Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'blindFS/vim-taskwarrior'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'tbabej/taskwiki'

let g:vimwiki_list = [{'path': '~/vimwiki/', 
                   \ 'syntax': 'markdown', 'ext': '.md'}]
                   
nnoremap <Leader>vv :!vimwiki_to_html.py -o<cr>
nnoremap <Leader>VV :!vimwiki_to_html.py -o -b defaultbrowser<cr>
