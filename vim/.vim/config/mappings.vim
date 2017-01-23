" custom mappings

" F3 to toggle paste and nopaste
nnoremap <F3> :set paste!<CR>

" F4 to toggle header and source files
nnoremap <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>  

" F5 list buffers
nnoremap <F5> :buffers<CR>:buffer<Space>

nnoremap <leader>w :wa<cr>
nnoremap <leader>q :q<cr>
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P
nnoremap <Leader><Leader> <C-^>
map q: :q

" change window size with arrow keys
noremap <up>    <C-W>+
noremap <down>  <C-W>-
noremap <left>  3<C-W><
noremap <right> 3<C-W>>

" remove spaces both sides of selection
vmap gs :s/ \(<C-r>*\) /\1/g<cr>

nnoremap ; :
nnoremap : ;
nnoremap ! :!

" shortcuts for Esc
imap <C-l> <esc>
imap jk <esc>
imap kk <esc>
imap лл <esc>
imap <F1> <Esc>
map <F1> <Esc>
imap <C-h> <backspace>

imap <C-b> <Left>
imap <C-a> <esc>^i
imap <C-f> <Right>
imap <C-e> <End>
imap <C-d> <Del>
imap <C-h> <BS>
imap <C-n> <Down>
imap <C-p> <Up>

cmap <Esc>k <Up>
cmap <Esc>j <Down>
cmap <Esc>l <Enter>

" replace word under cursor with entered 
" in all document
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>

" easy split navigation
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h

nnoremap E :Explore<CR>
nnoremap <Leader>b :EditVifm<CR>

" Tab/Shift+Tab for switching between buffers
" nnoremap  <silent>   <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
" nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>
" nnoremap <tab> za

" delete current buffer and keep split
nnoremap <leader>d :bp\|bd #<CR>

nnoremap gs :Gstatus<cr>
nnoremap gC :Gcommit<cr>

nnoremap g= gg=Gg``

" disable search highlighting
nnoremap <silent> <M-t> :<C-u>nohlsearch<CR>

function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction

function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction

let s:putSwap = 1
function! TogglePutSwap()
  if s:putSwap
    vnoremap <silent> <expr> p <sid>Repl()
    let s:putSwap = 0
    echo 'noreplace put'
  else
    vnoremap <silent> <expr> p p
    let s:putSwap = 1
    echo 'replace put'
  endif
  return
endfunction
noremap <leader>P :call TogglePutSwap()<cr>

let g:quickfix_is_open = 0
function! ToggleQuickfix()
  if g:quickfix_is_open
    cclose
    let g:quickfix_is_open = 0
    execute g:quickfix_return_to_window . "wincmd w"
  else
    let g:quickfix_return_to_window = winnr()
    copen
    let g:quickfix_is_open = 1
  endif
endfunction

nnoremap Q :call ToggleQuickfix()<cr>

" vim:set fdm=marker sw=2 nowrap:
