Plug 'junegunn/goyo.vim'

function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  silent !bspc node focused -t fullscreen
  let g:bg_opacity = system("setbgopacity")
  silent !setbgopacity 100 2> /dev/null &

  set nofoldenable
  set scrolloff=999
  Limelight

  let g:goyo_enabled = 1
  set laststatus=0
  hi StatusLine ctermfg=16
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  silent !bspc node focused -t tiled
  execute "silent! !setbgopacity ". g:bg_opacity[:-2]. " 2> /dev/null &"

  set foldenable
  set scrolloff=0
  Limelight!

  let g:goyo_enabled = 0
  set laststatus=2

  execute ':CustomHighlights'
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" F6 toggle Goyo
nnoremap <leader>f :Goyo<cr>

Plug 'junegunn/limelight.vim' " {{{2
let g:limelight_conceal_ctermfg = 14
let g:limelight_paragraph_span = 1

" vim:set fdm=marker sw=2 nowrap:
