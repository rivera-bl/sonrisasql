let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +1 dev/python/proj/sonrisasql/todo.md
badd +13 dev/python/proj/sonrisasql/core/urls.py
badd +49 dev/python/proj/sonrisasql/core/models.py
badd +2 dev/python/proj/sonrisasql/core/views.py
badd +34 dev/python/proj/sonrisasql/core/templates/core/base.html
badd +1 dev/python/proj/sonrisasql/core/templates/core/upload_ficha.html
badd +27 dev/python/proj/sonrisasql/core/forms.py
badd +14 dev/python/proj/sonrisasql/core/templates/core/upload.html
badd +373 dev/python/proj/sonrisasql/script.sql
badd +1 man://BEGIN(7)
badd +0 term://~/dev/python/proj/sonrisasql//97942:/usr/bin/zsh
badd +73 dev/python/proj/sonrisasql/core/templates/core/agenda.html
argglobal
%argdel
edit dev/python/proj/sonrisasql/core/models.py
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 118 + 118) / 237)
exe 'vert 2resize ' . ((&columns * 118 + 118) / 237)
argglobal
balt dev/python/proj/sonrisasql/core/templates/core/agenda.html
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 28) / 56)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
lcd ~/dev/python/proj/sonrisasql
wincmd w
argglobal
if bufexists("~/dev/python/proj/sonrisasql/script.sql") | buffer ~/dev/python/proj/sonrisasql/script.sql | else | edit ~/dev/python/proj/sonrisasql/script.sql | endif
if &buftype ==# 'terminal'
  silent file ~/dev/python/proj/sonrisasql/script.sql
endif
balt ~/dev/python/proj/sonrisasql/core/forms.py
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 497 - ((27 * winheight(0) + 28) / 56)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 497
normal! 030|
lcd ~/dev/python/proj/sonrisasql
wincmd w
exe 'vert 1resize ' . ((&columns * 118 + 118) / 237)
exe 'vert 2resize ' . ((&columns * 118 + 118) / 237)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0&& getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToOFI
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
let g:this_session = v:this_session
let g:this_obsession = v:this_session
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
