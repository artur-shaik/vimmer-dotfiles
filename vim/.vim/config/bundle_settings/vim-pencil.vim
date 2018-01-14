Plug 'reedes/vim-pencil'

"augroup pencil
"    autocmd!
"    autocmd FileType * call pencil#init()
"augroup END

iabbrev <buffer> -- –
iabbrev <buffer> --- —
iabbrev <buffer> << «
iabbrev <buffer> >> »
iabbrev <buffer> ___ …

nnoremap <buffer> <silent> gq gqap
xnoremap <buffer> <silent> gq gq
nnoremap <buffer> <silent> <leader>gQ vapJgqap

" replace typographical quotes (reedes/vim-textobj-quote)
map <silent> <buffer> <leader>qc <Plug>ReplaceWithCurly
map <silent> <buffer> <leader>qs <Plug>ReplaceWithStraight

let g:pencil#textwidth = 74
