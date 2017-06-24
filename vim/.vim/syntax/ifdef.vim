" Description: C Preprocessor Highlighting
" Language: Preprocessor on top of c, cpp, idl syntax
" Author: Michael Geddes <vimmer@frog.wheelycreek.net>
" Modified: July 2011
" Version: 3.2
"
" Copyright 2002-2011 Michael Geddes
" Please feel free to use, modify & distribute all or part of this script,
" providing this copyright message remains.
" I would appreciate being acknowledged in any derived scripts, and would
" appreciate and welcome any updates, modifications or suggestions.

" Usage:
" Use as a syntax plugin (source ifdef.vim from ~/vimfiles/after/syntax/cpp.vim -
" also c.vim and idl.vim )
"
" #ifdef defintions are considered to be in 1 of 3 states, defined, not-defined
" or don't know (the default).
"
" To specify which defines are valid/invalid, the scripts searches two places.
"   * Firstly, the current directory, and all higher directories are search for
"     the file specified in g:ifdef_filename - which defaults to '.defines'
"     (first one found gets used)
"   * Secondly, modelines prefixed by 'vim_ifdef:' are searched for within the
"     current file being loaded.  You can either use the vim default settings
"     for modeline/modelines, or these can be overridden by using
"     ifdef_modeline and ifdef_modelines.
" The defines/undefines are addeded in order.  Lines must be prefixed with
" 'defined=' or 'undefined=' and contain a ';' or ',' separated list of keywords.
" Keywords may be regular expressions, though use of '\k' rather than '.' is
" highly recommended.
"
" Specifying '*' by itself equates to '\k\+' and allows
" setting of the default to be defined/undefined.
" Caveat:
" Don't expect an #else/#endif inside an open bracket '(' to match the #ifdef
" correctly.  This is almost impossible to do without messing up the error-in
" bracket code.
" Currently #else/#endif that are inside brackets where the #ifdef is outside
" will be highlighted as 'Special', you may wish to hilight it as an error. >
"   hi link ifdefElseEndifInBracketError Error
"
" NB: On 16bit and win32s windows builds, the default for ifdef_filename is
" '_defines'.  I've assumed that win32 apps can handle '.defines'.
"
" Examples:
" ----.defines-------
" undefined=*
" defined=WIN32;__MT
" ----.defines----------
" undefined=DEBUG,DBG
" ----(modelines) samples.cpp-------
" /* vim_ifdef: defined=WIN32 */
" // vim_ifdef: undefine=DBG
"
" Settings:
" g:ifdef_modeline overrides &modeline for whether to use the ifdef modelines.
" g:ifdef_modelines overrides &modelines for how many lines to look at.
"
" Hilighting:
" ifdefIfZero (default Comment)                     - Inside #if 0 highlighting
" ifdefUndefined (default Debug)                    - The #ifdef/#else/#endif/#elseif
" ifdefNeutralDefine (default PreCondit)            - Other defines where the defines are valid
" ifdefInBadPreCondit (default PreCondit)           - The #ifdef/#else/#endif/#elseif in an invalid section.
" ifdefInUndefinedComment (default ifdefUndefined)  - A C/C++ comment inside a an invalid section
" ifdefPreCondit1 (defualt PreCondit)               - The #ifdef/#else/#endif/#elseif in a valid section
" ifdefElseEndifInBracketError (default Special)    - Usupported #else/#endif inside a bracket '('.
" ------------------------------
" Alternate (old) usage.
" Call CIfDef() after sourcing the c/cpp syntax file.
" Use :Define <keyword> or function Define(keyword) to mark a preprocessor symbol as being defined.
" Use  :Undefine <keyword> or function Undefine(keyword) to mark a preprocessor symbol as not being defined.
" call Undefine('\k\+') will mark all words that aren't explicitly 'defined' as undefined.
"
" History:
" 3.2
"  - Fix by Dr. Chip for C comment at endof ifdef continuing over line.
" 3.1
"  - Wu Hong fixed bug in Undefine()
"  - Stop errors in script due to undefined hl being cleared.
"  - Added :Define, :Undefine with completion
" 3.0
"   - Renamed everything to be more clear, and reversed some of the include
"   groups from exclude groups - make use of ALL in groups. This seems to have
"   fixed most bugs, but may have reintroduced some as well, however doing it
"   this way round should prevent most interaction with other scripts.
"   KNOWN issues: Comments at the end of #ifndef, #else don't always highlight.
"   - Actually clear the cPreCondit highlight group as we are taking it over.
"     Ditto cCppOut (#if 0) handling
" 2.4
"   - Prevent interaction with c brackets (Picked up by Dany St-Amant)
" 2.3
"   - Clean up some of the comments
"   - Ignore whitespace in .defines files. (TODO: Credit person who suggested this!)
"   - Add comments for highlighting groups.
" 2.2
"   - Add support for idl files.
"   - Suggestions from
"     - Check for 'shell' type and 'shellslash'
"     - Don't use has("windows"), which is different.
" 2.1
"   - Fixes from Erik Remmelzwaal
"     - Need to use %:p:h instead of %:h to get directory
"     - Documentation fixes/updates
"     - Added ability to parse ',' or ';' separated lists instead of fixing
"       the documentation ;)
" 2.0:
"   - Added loading of ifdefs
"     - via ifdef modelines
"     - via .defines files
"   - Added missing highlight link.. relinked ifdefed out comments to special
"   - Conditional loading of functions
" 1.3:
"   - Fix some group names
" 1.2:
"   - Fix some errors in the tidy-up with group names
"   - Make it a propper syntax file - to be added onto c.vim / cpp.vim
"   - Use standard highlight groups - PreProc, Comment and Debug
"   - Use 'default' highlight syntax.
" 1.1:
"   - Tidy-up
"   - Make sure CIfDef gets called.
"   - Turn of #if 0 properly - this script handles it!
"   - prefix 'ifdef' to all groups
"   - Use some c 'clusters' to get rid of some inhouse code
"
"   TODO: (Feel free to contact me with suggestions)
"     - Allow defined= and undefined= on the same line in modelines.
"

"
if exists('b:current_syntax') && b:current_syntax =~ 'ifdef'
  finish
endif

if !exists('b:current_syntax')
  let b:current_syntax = "ifdef"
else
  let b:current_syntax = b:current_syntax.'+ifdef'
endif


" Settings for the c.vim highlighting .. disable the default preprocessor handling.
let c_no_if0=1
if hlexists('cPreCondit')
  syn clear cPreCondit
endif
if hlexists('cCppOut')
  syn clear cCppOut
endif

if hlexists('cCppOut2')
  syn clear cCppOut2
endif
if hlexists('cCppSkip')
  syn clear cCppSkip
endif

" Reload protection
if !exists('ifdef_loaded') || exists('ifdef_debug')
  let ifdef_loaded=1
else
  call s:CIfDef(1)
  call IfdefLoad()
  finish
endif

if !exists('ifdef_filename')
  if has('dos16') || has('gui_win32s') || has('win16')
    let ifdef_filename='_defines'
  else
    let ifdef_filename='.defines'
  endif
endif

" Reload CIfDef - backwards compatible
function! CIfDef()
  call s:CIfDef(0)
endfun

" Load the C ifdef highlighting.
function! s:CIfDef(force)
  if ! a:force &&  exists('b:ifdef_syntax')
      return
  endif
  let b:ifdef_syntax=1

  " Some useful groups.
  syn cluster ifdefClusterCommon contains=TOP,cPreCondit
  syn cluster ifdefClusterNeutral contains=@ifdefClusterCommon,ifdefDefined,ifdefUndefined,ifdefNeutral.*,ifdefInNeutralIf
  syn cluster ifdefClusterDefined contains=@ifdefClusterCommon,ifdefDefined,ifdefUndefined,ifdefNeutral.*,ifdefInNeutralIf
  syn cluster ifdefClusterUndefined contains=ifdefInUndefinedComment,ifdefInUndefinedIf

  syn region ifdefCommentAtEnd contained start=+//+ end='$' skip='\\$' contains=cSpaceError
  syn region ifdefCommentAtEnd contained extend start=+/\*+ end='\*/' contains=cSpaceError nextgroup=ifdefCommentAtEnd


  " #if .. #endif  nesting
  syn region ifdefOutsideNeutral matchgroup=ifdefPreCondit1 start="^\s*#\s*\(if\>\|ifdef\>\|ifndef\>\)\(/[/*]\@!\|[^/]\)*" matchgroup=ifdefPreCondit1 end="^\s*#\s*endif\>.*$" contains=@ifdefClusterNeutral,ifdefElseInDefinedNeutral,cComment,cCommentL
  " #if .. #endif  nesting
  syn region ifdefInNeutralIf matchgroup=ifdefPreCondit1 start="^\s*#\s*\(if\>\|ifdef\>\|ifndef\>\).*$" matchgroup=ifdefPreCondit1 end="^\s*#\s*endif\>.*$" contained contains=@ifdefClusterNeutral,ifdefElseInDefinedNeutral,cComment,cCommentL
  syn region ifdefInUndefinedIf matchgroup=ifdefPreConditBad start="^\s*#\s*\(if\>\|ifdef\>\|ifndef\>\).*$" matchgroup=ifdefPreConditBad end="^\s*#\s*endif\>" contained contains=@ifdefClusterUndefined,ifdefElseInUndefinedNeutral,cCommentL,cComment skipwhite nextgroup=ifdefCommentAtEnd

  " #else highlighting for nesting
  syn match ifdefElseInDefinedNeutral "^\s*#\s*\(elif\>\|else\>\)" contained skipwhite
  syn match ifdefElseInUndefinedNeutral "^\s*#\s*\(elif\>\|else\>\)" contained skipwhite nextgroup=ifdefCommentAtEnd

  " #if 0 matching
  syn region ifdefUndefined  matchgroup=ifdefPreCondit4 start="^\s*#\s*if\s\+0\>" matchgroup=ifdefPreCondit4 end="^\s*#\s*endif" contains=@ifdefClusterUndefined,ifdefElseInUndefinedToDefined

  " #else handling .. switching to out group
  syn region ifdefElseInDefinedToUndefined matchgroup=ifdefPreCondit3 start="^\s*#\s*else\>" end="^\s*#\s*endif\>"me=s-1 contained contains=@ifdefClusterUndefined
  " #else handling .. switching to in group
  syn region ifdefElseInUndefinedToDefined matchgroup=ifdefPreCondit6 start="^\s*#\s*else\>" end="^\s*#\s*endif\>"me=s-1 contained contains=@ifdefClusterDefined

  " Handle #else, #endif inside a bracket. Not really an error, but impossible
  " to work out.
  syn match ifdefElseEndifInBracketError "^\s*#\s*\(elif\>\|else\>\|endif\>\)" contained containedin=cParen

  " comment highlighting
  syntax region ifdefInUndefinedComment start="/\*" end="\*/" contained contains=cCharacter,cNumber,cFloat,cSpaceError
  syntax match  ifdefInUndefinedComment "//.*" contained contains=cCharacter,cNumber,cSpaceError

  " Now add to all the c/rc/idl clusters
  syn cluster cParenGroup add=ifdefInUndefined.*,ifdefElse.*,ifdefInNeutralIf
  syn cluster cPreProcGroup add=ifdefInUndefined.*,ifdefElse.*,ifdefInNeutralIf
  syn cluster cMultiGroup add=ifdefInUndefined.*,ifdefElse.*,ifdefInNeutralIf
  syn cluster rcParenGroup add=ifdefInUndefined.*,ifdefElse.*,ifdefInNeutralIf
  syn cluster rcGroup add=ifdefInUndefined.*,ifdefElse.*,ifdefInNeutralIf

  " Include group - so reverse
  syn cluster idlCommentable add=ifdefUndefined,ifdefDefined

  " Start sync from scratch
  syn sync fromstart

endfunction

" Mark a (regexp) definition as defined.
" Note that the regular expression is use with \< \> arround it.
fun! Define(define)
  call CIfDef()
  exe 'syn region ifdefUndefined  matchgroup=ifdefPreCondit4 start="^\s*#\s*ifndef\s\+'.a:define.'\>" matchgroup=ifdefPreCondit4 end="^\s*#\s*endif" contains=@ifdefClusterUndefined,ifdefElseInUndefinedToDefined'
  exe 'syn region ifdefDefined matchgroup=ifdefPreCondit5 start="^\s*#\s*ifdef\s\+'.a:define.'\>" matchgroup=ifdefPreCondit5 end="^\s*#\s*endif" contains=@ifdefClusterDefined,ifdefElseInDefinedToUndefined'
endfun

" Mark a (regexp) definition as not defined.
" Note that the regular expression is use with \< \> arround it.
fun! Undefine(define)
  call CIfDef()
  exe 'syn region ifdefUndefined  matchgroup=ifdefPreCondit4 start="^\s*#\s*ifdef\s\+'.a:define.'\>" matchgroup=ifdefPreCondit4 end="^\s*#\s*endif" contains=@ifdefClusterUndefined,ifdefElseInUndefinedToDefined'
  exe 'syn region ifdefDefined matchgroup=ifdefPreCondit5 start="^\s*#\s*ifndef\s\+'.a:define.'\>" matchgroup=ifdefPreCondit5 end="^\s*#\s*endif" contains=@ifdefClusterDefined,ifdefElseInDefinedToUndefined'

endfun

" Find the modelines for vim_ifdef between l1 and l2.
fun! s:GetModelines( l1, l2)
  if a:l1==0 | return ''| endif
  let c=a:l1
  let lines=''
  let reA='\<vim_ifdef:'
  let reB='\<vim_ifdef:\s*\zs\(.\{-}\)\ze\s*\(\*/\s*\)\=$'
  while c <= a:l2
    let l=getline(c)
    if l =~reA
      let lines=lines.matchstr(l,reB)."\n"
    endif
    let c=c+1
  endwhile
  return lines
endfun

" Return the modelines based on the settings.
fun! s:ReadDefineModeline()
  " Check for modeline=enable/disable
  if (exists('g:ifdef_modeline') ? (g:ifdef_modeline==0):(!&modeline)) | return | endif
  let defmodelines= (exists('g:ifdef_modelines')?(g:ifdef_modelines):(&modelines))
  if ((2*defmodelines)>=line('$'))
    " Check whole file
    return s:GetModelines( 1,line('$'))
  else
    " Check top & bottom
    return s:GetModelines( 1,defmodelines).s:GetModelines(line('$')-defmodelines,line('$'))
  endif
endfun

" Check a directory for the specified file
function! s:CheckDirForFile(directory,file)
  let aborted=0
  let cur=a:directory
  let slsh= ((cur=~'[/\\]$') ? '' : '/')
  while !filereadable(cur.slsh.a:file)
    let nxt=fnamemodify(cur,':h')
    let aborted=(nxt==cur)
    if aborted!=0 | break |endif
    let cur=nxt
    let slsh=((cur=~'[/\\]$') ? '' : '/')
  endwhile
  " Check the two cases we haven't tried
  if aborted | let aborted=!filereadable(cur.slsh.a:file) | endif

  return ((aborted==0) ? cur.slsh : '')
endfun

" Read a .defines file in the specified (or higher) directory
fun! s:ReadFile( dir, filename)
  let realdir= s:CheckDirForFile( a:dir, a:filename )
  if realdir=='' | return '' | endif
  " if has('dos16') || has('gui_win32s') || has('win16') || ha
  if !has('unix') && !&shellslash && &shell !~ 'sh[a-z.]*$'
    return system('type "'.fnamemodify(realdir,':gs?/?\\?.').a:filename.'"')
  else
    return system( 'cat "'.escape(realdir.a:filename,'\$*').'"' )
  endif
endfun

" Define/undefine a ';' or ',' separated list
fun! s:DoDefines( define, defines)
  let reBreak='[^;,]*'
  let here=0
  let back=strlen(a:defines)
  while here<back
    let idx=matchend(a:defines,reBreak,here)+1
    if idx<0 | let idx=back|endif
    let part=strpart(a:defines,here,(idx-here)-1)
    let part=substitute(substitute(part,'^\s*','',''),'\s*$','','')
    if part != ''
      if part=='*' | let part='\k\+' | endif
      if a:define
        call Define(part)
      else
        call Undefine(part)
      endif
    endif
    let here=idx
  endwhile
endfun

" Load ifdefs for a file
fun! IfdefLoad()
  let txt=s:ReadFile(expand('%:p:h'),g:ifdef_filename)
  if txt!='' && txt !~"[\r\n]$" | let txt=txt."\n" | endif
  let txt=txt.s:ReadDefineModeline()
  let reCr="[^\n\r]*[\r\n]*"
  let reDef='^\s*\(un\)\=defined\=\s*=\s*'
  let back=strlen(txt)
  let here=0
  while here < back
    let idx=matchend(txt,reCr,here)
    if idx < 0 | let idx=back|endif
    let part=strpart(txt,here,(idx-here))
    if part=~reDef
      let un=(part[0]=='u')
      let rest=substitute(strpart(part,matchend(part,reDef)),"[\r\n]*$",'','')
      call s:DoDefines(!un , rest)
    endif
    let here=idx
  endwhile
endfun

"  hi default ifdefIfZero term=bold ctermfg=1 gui=italic guifg=DarkSeaGreen
hi default link ifdefIfZero Comment
hi default link ifdefCommentAtEnd Comment
hi default link ifdefUndefined Debug
hi default link ifdefInUndefinedIf ifdefUndefined
hi default link ifdefElseInDefinedToUndefined ifdefUndefined
hi default link ifdefNeutralDefine PreCondit
hi default link ifdefNeutralPreProc PreProc
hi default link ifdefElseInDefinedNeutral PreCondit
hi default link ifdefElseInUndefinedNeutral PreCondit
hi default link ifdefInBadPreCondit PreCondit
hi default link ifdefInUndefinedComment ifdefUndefined
hi default link ifdefOutPreCondit ifdefInBadPreCondit
hi default link ifdefPreCondit1 PreCondit
hi default link ifdefPreConditBad ifdefInBadPreCondit
hi default link ifdefPreCondit3 ifdefPreCondit1
hi default link ifdefPreCondit4 ifdefPreCondit1
hi default link ifdefPreCondit5 ifdefPreCondit1
hi default link ifdefPreCondit6 ifdefPreCondit1
hi default link ifdefElseEndifInBracketError Special

call s:CIfDef(1)
call IfdefLoad()

fun! Find_defines(A, L, P)
  " Use dictionary to fix uniqueness
  let l:ret={}
  let cur=1
  while cur <= line('$')
    let line=getline(cur)
    if line =~ '^\s*#\s*ifn\=def\>\s\+'.a:A
      let l:find=matchstr(line,'^\s*#\s*ifn\=def\s*\zs\k\+')
      let ret[l:find]=1
    endif
    let cur+=1
  endwhile
  " Return the sorted keys of the dictionary
  return sort(keys(ret))
endfun

com! -complete=customlist,Find_defines -nargs=1 Define call Define(<q-args>)
com! -complete=customlist,Find_defines -nargs=1 Undefine call Undefine(<q-args>)

" vim:ts=2 sw=2 et
