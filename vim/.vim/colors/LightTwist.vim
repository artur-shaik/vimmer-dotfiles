" Colorscheme - Light-Twist !
"
" Fork me on GitHub !
"
" Author: Pychimp <pratheek.i@gmail.com>
"
let g:colors_name = "light-twist"

" First, The Normal 

hi Normal ctermfg=235  ctermbg=253  cterm=NONE

" Languages stuff !

hi Comment         ctermfg=110  ctermbg=NONE cterm=NONE 
hi Constant        ctermfg=20   ctermbg=NONE cterm=NONE   
hi String          ctermfg=28   ctermbg=NONE cterm=NONE   
hi Character       ctermfg=91   ctermbg=NONE cterm=NONE   
hi Number          ctermfg=57   ctermbg=NONE cterm=NONE  
hi Boolean         ctermfg=97   ctermbg=NONE cterm=NONE    
hi Float           ctermfg=57   ctermbg=NONE cterm=NONE   
hi Identifier      ctermfg=35   ctermbg=NONE cterm=NONE   
hi Function        ctermfg=125  ctermbg=NONE cterm=NONE    
hi Statement       ctermfg=26   ctermbg=NONE cterm=NONE    
hi Keyword         ctermfg=27   ctermbg=NONE cterm=NONE
hi Exception       ctermfg=130  ctermbg=NONE cterm=NONE
hi Conditional     ctermfg=136  ctermbg=NONE cterm=NONE    
hi PreProc         ctermfg=70   ctermbg=NONE cterm=NONE    
hi Include         ctermfg=29   ctermbg=NONE cterm=NONE    
hi Type            ctermfg=88   ctermbg=NONE cterm=NONE    
hi StorageClass    ctermfg=94   ctermbg=NONE cterm=NONE    
hi Special         ctermfg=167  ctermbg=NONE cterm=NONE    
hi Tag             ctermfg=212  ctermbg=NONE cterm=NONE    
hi Underlined      ctermfg=141  ctermbg=NONE cterm=underline    
hi Ignore          ctermfg=NONE ctermbg=NONE cterm=NONE
hi Error           ctermfg=88   ctermbg=172  cterm=bold 
hi TODO            ctermfg=232  ctermbg=214  cterm=bold   
 
" ------------------------------------------------------------
"
" Extended Highlighting
"
hi NonText       ctermfg=241  ctermbg=NONE  cterm=NONE
hi Visual        ctermfg=253  ctermbg=237   cterm=NONE 
hi ErrorMsg      ctermfg=88   ctermbg=172   cterm=bold
hi IncSearch     ctermfg=253  ctermbg=66    cterm=NONE
hi Search        ctermfg=253  ctermbg=66    cterm=NONE
hi MoreMsg       ctermfg=52   ctermbg=NONE  cterm=NONE
hi ModeMsg       ctermfg=52   ctermbg=NONE  cterm=NONE
hi LineNr        ctermfg=241  ctermbg=NONE  cterm=NONE
hi VertSplit     ctermfg=238  ctermbg=236   cterm=bold
hi VisualNOS     ctermfg=253  ctermbg=237   cterm=bold
hi Folded        ctermfg=235  ctermbg=249   cterm=NONE
hi DiffAdd       ctermfg=255  ctermbg=9     cterm=NONE
hi DiffChange    ctermfg=255  ctermbg=9     cterm=NONE
hi DiffDelete    ctermfg=255  ctermbg=9     cterm=NONE
hi DiffText      ctermfg=255  ctermbg=9     cterm=NONE
hi DiffAdd       ctermfg=255  ctermbg=9     cterm=NONE
hi DiffChange    ctermfg=255  ctermbg=9     cterm=NONE  
hi DiffDelete    ctermfg=255  ctermbg=9     cterm=NONE 
hi DiffText      ctermfg=255  ctermbg=9     cterm=NONE 
hi DiffAdd       ctermfg=255  ctermbg=9     cterm=NONE
hi DiffChange    ctermfg=255  ctermbg=9     cterm=NONE
hi DiffDelete    ctermfg=255  ctermbg=9     cterm=NONE
hi DiffText      ctermfg=255  ctermbg=9     cterm=NONE
hi DiffAdd       ctermfg=255  ctermbg=9     cterm=NONE
hi DiffChange    ctermfg=255  ctermbg=9     cterm=NONE
hi DiffDelete    ctermfg=255  ctermbg=9     cterm=NONE
hi DiffText      ctermfg=255  ctermbg=9     cterm=NONE
hi SpellBad      ctermfg=255  ctermbg=89    cterm=bold
hi SpellCap      ctermfg=255  ctermbg=89    cterm=bold
hi SpellRare     ctermfg=255  ctermbg=89    cterm=bold
hi SpellLocal    ctermfg=255  ctermbg=89    cterm=bold
hi Pmenu         ctermfg=81   ctermbg=246   cterm=NONE
hi PmenuSel      ctermfg=17   ctermbg=246   cterm=NONE
hi PmenuSbar     ctermfg=81   ctermbg=246   cterm=NONE
hi PmenuThumb    ctermfg=81   ctermbg=246   cterm=NONE
hi TabLine       ctermfg=3    ctermbg=NONE  cterm=NONE
hi TabLineFill   ctermfg=3    ctermbg=NONE  cterm=NONE
hi TabLineSel    ctermfg=1    ctermbg=NONE  cterm=bold
hi MatchParen    ctermfg=232  ctermbg=160   cterm=bold 
" in MatchParen --> use use Shift + 5 (the '%') locate the closing
" bracket by placing the cursor on the opening (or vice versa !)
