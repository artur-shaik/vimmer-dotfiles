" auto commands

augroup initialautocommands
  autocmd!

  " smartident after keywords in python
  autocmd BufRead *.py setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

  autocmd FileType java,jsp setlocal omnifunc=javacomplete#Complete
  autocmd Filetype java,jsp,pom compiler mvn
  autocmd Filetype java,jsp nmap <F5> <Plug>(JavaComplete-Imports-Add)
  autocmd Filetype java,jsp imap <F5> <Plug>(JavaComplete-Imports-Add)
  autocmd Filetype java,jsp nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
  autocmd Filetype java,jsp imap <F4> <Plug>(JavaComplete-Imports-AddSmart)
  autocmd Filetype java,jsp imap <F7> <Plug>(JavaComplete-Generate-AbstractMethods)
  autocmd Filetype java,jsp no <F9> :make clean<CR>
  autocmd Filetype java,jsp no <F10> :wa<CR> :make compile<CR>
  autocmd Filetype java,jsp no <F11> :make exec:exec<CR>

  autocmd VimResized * execute "normal! \<c-w>="
  autocmd InsertLeave * set nopaste
augroup END

" vim:set fdm=marker sw=2 nowrap:
