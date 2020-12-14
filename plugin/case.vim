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
			\ 'kebap': {'match': '\%(\%(\k\+\)\)\@<=-\(\k\)', 'replace': '\-\l\1'},
			\ }

function! s:switch_case(case, visualmode) abort
	if !has_key(s:cases, a:case)
		return
	endif

	let [_buf, line, column, __] = getpos('.')
	let replace = s:cases[a:case].replace

	if a:visualmode
		let selection_mode = '\%V'
	else
		let selection_mode = ''
	endif

	for case in keys(s:cases)
		if case !=# a:case
			exe  's#' . selection_mode . s:cases[case].match . "#" . replace . "#ge"
		endif
	endfor

	call cursor(line, column)
endfunction

command! -range -bar -nargs=1 CaseSwitch call s:switch_case(<f-args>, 0)
command! -range -bar -nargs=1 CaseSwitchSelection call s:switch_case(<f-args>, 1)

if !hasmapto('<Plug>CaseSwitch') || maparg('gs','n') == ''
  xmap gsc  <Plug>CaseSwitch camel
  nmap gsc  <Plug>CaseSwitch camel

  xmap gss  <Plug>CaseSwitch snake
  nmap gss  <Plug>CaseSwitch snake

  xmap gsk  <Plug>CaseSwitch kebap
  nmap gsk  <Plug>CaseSwitch kebap
endif
