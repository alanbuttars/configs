set nocompatible

colorscheme vibrantink

au FileType diff colorscheme desert
au FileType git colorscheme desert
au BufWinLeave * colorscheme vibrantink

augroup markdown
  au!
  au BufNewFile,BufRead *.md set local filetype=ghmarkdown
augroup END

autocmd BufNewFile,BufRead *.txt setlocal spell spellang=en-us
autocmd FileType tex setlocal spell spellang=en_us
autocmd BufRead,BufNewFile *.conf* setfiletype apache

set laststatus=2
set statusline=
set statusline+=%<\
set statusline+=%2*[%n%H%M%R%W]%*\
set statusline+=%-40f\
set statusline+=%=
set statusline+=%1*%y%*%*\
set statusline+=%10(L(%l/%L)%)\
set statusline+=%2(C(%v/125)%)\
set statusline+=%P

let html_use_css=1
let html_number_lines=0
let html_no_pre=1

map <silent> <leader>f :CommandT<CR>
map <silent> <leader>fb :CommandTBuffer<CR>
map <silent> <leader>fr :CommandTFlush<CR>
