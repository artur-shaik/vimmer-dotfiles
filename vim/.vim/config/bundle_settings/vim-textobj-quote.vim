Plug 'kana/vim-textobj-user'
Plug 'reedes/vim-textobj-quote'

augroup textobj_quote
  autocmd!
  autocmd FileType * call textobj#quote#init({'double':'«»', 'single':'‚‘'})
augroup END
