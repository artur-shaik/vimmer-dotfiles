Plug 'lervag/vimtex'

let g:vimtex_view_method = 'zathura'

if !exists('g:ycm_semantic_triggers')
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = [
      \ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*, ?)*'
      \ ]

" vim:set fdm=marker sw=2 nowrap:
