call plug#begin()
Plug 'laktak/tome'
call plug#end()

syntax on

" -- legacy config (pathogen era) ---------------------------------------------
"execute pathogen#infect()
"
"set encoding=utf8
"set tabstop=4
"set shiftwidth=4
"set et
"set showcmd
"set ai
"set bg=light
"set backspace=indent,eol,start
"map <leader>jt  <Esc>:%!json_xs -f json -t json-pretty<CR>
"au BufRead,BufNewFile *.json set filetype=json
"
"nnoremap <silent> <F5> :NERDTree<CR>
"
"" Highlight all instances of word under cursor, when idle.
"" Type z/ to toggle highlighting on/off.
"nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
"function! AutoHighlightToggle()
"  let @/ = ''
"  if exists('#auto_highlight')
"    au! auto_highlight
"    augroup! auto_highlight
"    setl updatetime=4000
"    echo 'Highlight current word: off'
"    return 0
"  else
"    augroup auto_highlight
"      au!
"      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
"    augroup end
"    setl updatetime=500
"    echo 'Highlight current word: ON'
"    return 1
"  endif
"endfunction
"
"colorscheme distinguished-yoyo
"
"set cursorline
"set cursorcolumn
"
"nnoremap <M-,> k:call search('^'. matchstr(getline(line('.')+1), '\(\s*\)') .'\S', 'b')<CR>^
"nnoremap <M-.> :call search('^'. matchstr(getline(line('.')), '\(\s*\)') .'\S')<CR>^
"function! NextIndent(exclusive, fwd, lowerlevel, skipblanks)
"  let line = line('.')
"  let column = col('.')
"  let lastline = line('$')
"  let indent = indent(line)
"  let stepvalue = a:fwd ? 1 : -1
"  while (line > 0 && line <= lastline)
"    let line = line + stepvalue
"    if ( ! a:lowerlevel && indent(line) == indent ||
"          \ a:lowerlevel && indent(line) < indent)
"      if (! a:skipblanks || strlen(getline(line)) > 0)
"        if (a:exclusive)
"          let line = line - stepvalue
"        endif
"        exe line
"        exe "normal " column . "|"
"        return
"      endif
"    endif
"  endwhile
"endfunction
"
"nnoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
"nnoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
"nnoremap <silent> [L :call NextIndent(0, 0, 1, 1)<CR>
"nnoremap <silent> ]L :call NextIndent(0, 1, 1, 1)<CR>
"vnoremap <silent> [l <Esc>:call NextIndent(0, 0, 0, 1)<CR>m'gv''
"vnoremap <silent> ]l <Esc>:call NextIndent(0, 1, 0, 1)<CR>m'gv''
"vnoremap <silent> [L <Esc>:call NextIndent(0, 0, 1, 1)<CR>m'gv''
"vnoremap <silent> ]L <Esc>:call NextIndent(0, 1, 1, 1)<CR>m'gv''
"onoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
"onoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
"onoremap <silent> [L :call NextIndent(1, 0, 1, 1)<CR>
"onoremap <silent> ]L :call NextIndent(1, 1, 1, 1)<CR>
"
"nmap <F8> :TagbarToggle<CR>
"
"highlight ExtraWhitespace ctermbg=red guibg=red
"match ExtraWhitespace /\s\+$/
"let g:airline_powerline_fonts = 1
"
"set laststatus=2
"
"let g:tagbar_sort = 0
"
"autocmd FileType php nested :call tagbar#autoopen(0)
"autocmd FileType php set omnifunc=phpcomplete#CompletePHP
"autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType python set omnifunc=pythoncomplete#Complete
"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
"autocmd FileType css set omnifunc=csscomplete#CompleteCSS
"autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
"autocmd FileType c set omnifunc=ccomplete#Complete
