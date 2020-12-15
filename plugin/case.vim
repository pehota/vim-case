" vim-case.vim - Switch between different cases
" Maintainer:  Dimitar Apostolov <d.apostolov@gmail.com>
" Last Change: 2020 Dec 14
" Version:     0.0.1

if exists('g:loaded_switch_case')
  finish
endif

let g:loaded_switch_case = 1

let s:cases = {
			\ 'camel': {'match': '\(\u\)',  'replace': '\u\1'},
			\ 'snake': {'match': '\%(\%(\k\+\)\)\@<=_\(\k\)', 'replace': '\_\l\1'},
			\ 'kebab': {'match': '\%(\%(\k\+\)\)\@<=-\(\k\)', 'replace': '\-\l\1'},
			\ }

function! s:switch_case(case, visualmode) abort
	if !has_key(s:cases, a:case)
		return
	endif

	let [_buf, line, column, __] = getpos('.')

	if !a:visualmode
		exe 'normal! viw'
		call s:switch_case(a:case, 1)
		exe 'normal! '
		call cursor(line, column)
		return
	endif

	let replace = s:cases[a:case].replace

	for case in keys(s:cases)
		if case !=# a:case
			exe  's#\%V' . s:cases[case].match . "#" . replace . "#ge"
		endif
	endfor
endfunction

command! -range -bar -nargs=1 CaseSwitch call s:switch_case(<f-args>, 0)
command! -range -bar -nargs=1 CaseSwitchSelection call s:switch_case(<f-args>, 1)

xnoremap <Plug>CaseSwitchCamel :CaseSwitchSelection camel<cr>
vnoremap <Plug>CaseSwitchCamel :CaseSwitchSelection camel<cr>
nnoremap <Plug>CaseSwitchCamel :CaseSwitch camel<cr>
xnoremap <Plug>CaseSwitchSnake :CaseSwitchSelection snake<cr>
vnoremap <Plug>CaseSwitchSnake :CaseSwitchSelection snake<cr>
nnoremap <Plug>CaseSwitchSnake :CaseSwitch snake<cr>
xnoremap <Plug>CaseSwitchKebab :CaseSwitchSelection kebab<cr>
vnoremap <Plug>CaseSwitchKebab :CaseSwitchSelection kebab<cr>
nnoremap <Plug>CaseSwitchKebab :CaseSwitch kebab<cr>

if !hasmapto('<Plug>CaseSwitchCamel')
	xmap <silent><localleader>c <Plug>CaseSwitchCamel
	vmap <silent><localleader>c <Plug>CaseSwitchCamel
	nmap <silent><localleader>c <Plug>CaseSwitchCamel

	xmap <silent><localleader>s <Plug>CaseSwitchSnake
	vmap <silent><localleader>s <Plug>CaseSwitchSnake
	nmap <silent><localleader>s <Plug>CaseSwitchSnake

	xmap <silent><localleader>k <Plug>CaseSwitchKebab
	vmap <silent><localleader>k <Plug>CaseSwitchKebab
	nmap <silent><localleader>k <Plug>CaseSwitchKebab
endif
