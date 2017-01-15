Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}

noremap <silent> <F2> :NERDTreeFind<CR> :wincmd p<cr> <C-w>=
noremap <silent> <C-n> :NERDTreeToggle<CR>
let g:NERDTreeWinPos='right'
let g:NERDTreeWinSize=31
let g:NERDTreeChDirMode=1
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
