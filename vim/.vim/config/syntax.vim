" syntax and highlights settings

filetype on
filetype plugin on
filetype plugin indent on

set background=light
colorscheme default

syntax on 

set cursorline

function! s:CustomHighlights()
  hi Visual term=none cterm=none ctermbg=1 gui=none ctermfg=15
  hi CursorLine term=none cterm=bold ctermfg=8 ctermbg=15
  hi Pmenu ctermbg=2 ctermfg=15
  hi PmenuSel ctermfg=2 ctermbg=15
  hi LineNr ctermfg=5 cterm=none
  hi SpellBad term=underline cterm=underline ctermbg=none ctermfg=1
  hi Error term=none cterm=none ctermbg=none ctermfg=1
  hi TabLine ctermfg=14 ctermbg=1 cterm=none
  hi TabLineSel ctermbg=15
  hi Folded term=standout ctermfg=14 ctermbg=none
  hi Search ctermbg=14 cterm=none
  hi StatusLine ctermfg=6
endfunction

command! CustomHighlights :call <SID>CustomHighlights()
augroup customhi
  autocmd!
  autocmd VimEnter * :CustomHighlights
augroup END

call s:CustomHighlights()

" vim:set fdm=marker sw=2 nowrap:
