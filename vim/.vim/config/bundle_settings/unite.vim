function! PostLoad(info)
  call unite#filters#matcher_default#use(['matcher_fuzzy'])
endfunction

Plug 'Shougo/unite.vim', {'do': function('PostLoad')}

let g:unite_source_history_yank_enable = 1

" Use ag in unite grep source.
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts =
  \ '--vimgrep --hidden --ignore ' .
  \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
let g:unite_source_grep_recursive_opt = ''

nnoremap <space>/ :Unite grep:.<cr>
nnoremap <silent> <C-p> :Unite -no-split -buffer-name=files -start-insert file_rec/async:!<cr>
nnoremap <leader>f :Unite -no-split -buffer-name=files -start-insert file<cr>
nnoremap <leader>m :Unite -no-split -buffer-name=mru -start-insert file_mru<cr>
nnoremap <leader>y :Unite -no-split -buffer-name=yank history/yank<cr>
nnoremap <silent> <C-b> :Unite -start-insert -buffer-name=buffer buffer<cr>
nnoremap <silent> <C-t> :Unite -start-insert -buffer-name=buffer_tab buffer_tab<cr>

nnoremap <leader>ev :Unite -no-split -start-insert -path=$HOME/.vim/ file_rec/async:<cr>

" Interface for Git
let g:unite_source_menu_menus = {}
let g:unite_source_menu_menus.git = {
  \ 'description' : 'Fugitive interface',
  \}
let g:unite_source_menu_menus.git.command_candidates = [
  \[' git status', 'Gstatus'],
  \[' git diff', 'Gvdiff'],
  \[' git commit', 'Gcommit'],
  \[' git stage/add', 'Gwrite'],
  \[' git checkout', 'Gread'],
  \[' git rm', 'Gremove'],
  \[' git cd', 'Gcd'],
  \[' git push', 'exe "Git! push -u origin " input("branch: ")'],
  \[' git pull', 'exe "Git! pull " input("branch: ")'],
  \[' git fetch', 'Gfetch'],
  \[' git merge', 'Gmerge'],
  \[' git browse', 'Gbrowse'],
  \[' git head', 'Gedit HEAD^'],
  \[' git parent', 'edit %:h'],
  \[' git log commit buffers', 'Glog --'],
  \[' git log current file', 'Glog -- %'],
  \[' git log last n commits', 'exe "Glog -" input("num: ")'],
  \[' git log first n commits', 'exe "Glog --reverse -" input("num: ")'],
  \[' git log until date', 'exe "Glog --until=" input("day: ")'],
  \[' git log grep commits',  'exe "Glog --grep= " input("string: ")'],
  \[' git log pickaxe',  'exe "Glog -S" input("string: ")'],
  \[' git index', 'exe "Gedit " input("branchname\:filename: ")'],
  \[' git mv', 'exe "Gmove " input("destination: ")'],
  \[' git grep',  'exe "Ggrep " input("string: ")'],
  \[' git prompt', 'exe "Git! " input("command: ")'],
  \] " Append ' --' after log to get commit info commit buffers
nnoremap <silent> <space>g :Unite -direction=botright -silent -buffer-name=git menu:git<CR>

" vim:set fdm=marker sw=2 nowrap:
