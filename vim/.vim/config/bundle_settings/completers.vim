Plug 'wellle/tmux-complete.vim'

let g:tmuxcomplete#trigger = 'omnifunc'

" -----------------------
Plug 'Shougo/neco-vim', {'for': 'vim'}

if has('nvim')
    function! DoRemote(arg)
      UpdateRemotePlugins
    endfunction
    Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote'), 'for': 'vim' }
    let g:deoplete#enable_at_startup = 1
else
    Plug 'Shougo/neocomplete.vim', {'for': 'vim'}
    let g:acp_enableAtStartup = 0
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#sources#syntax#min_keyword_length = 3
endif

" ----------------------
Plug 'Valloric/YouCompleteMe'
let g:ycm_semantic_triggers =  {
      \ 'c' : ['->', '.'],
      \ 'objc' : ['->', '.'],
      \ 'ocaml' : ['.', '#'],
      \ 'cpp,objcpp' : ['->', '.', '::'],
      \ 'perl' : ['->'],
      \ 'php' : ['->', '::'],
      \ 'cs,javascript,d,python,perl6,scala,vb,elixir,go' : ['.'],
      \ 'java,jsp' : ['.', '::'],
      \ 'ruby' : ['.', '::'],
      \ 'lua' : ['.', ':'],
      \ 'erlang' : [':'],
      \ }

let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_autoclose_preview_window_after_completion = 1

" vim:set fdm=marker sw=2 nowrap:
