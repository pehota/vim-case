" vim-case-switch.vim - Switch between different cases
" Maintainer:  Dimitar Apostolov <d.apostolov@gmail.com>
" Last Change: 2020 Dec 05
" Version:     0.0.1

if exists('g:loaded_switch_case')
  finish
endif

let g:loaded_switch_case = 1

let s:cases = {
			\ 'camel': {'match': '\(\<\u\l\+\|\l\+\)\(\u\)',  'replace': '\u\1'},
			\ 'snake': {'match': '\%(\%(\k\+\)\)\@<=_\(\k\)', 'replace': '\_\1'},
			\ 'kebap': {'match': '\%(\%(\k\+\)\)\@<=-\(\k\)', 'replace': '\-\1'},
			\ }

function! s:switch_case(case, start_line, end_line)
	if !has_key(s:cases, a:case)
		return
	endif

	let l:replace = s:cases[a:case].replace

	for l:case in keys(s:cases)
		if l:case !=# a:case
			exe a:start_line . ',' . a:end_line . 's#' . s:cases[l:case].match . '#' . l:replace . '#ge'
		endif
	endfor

endfunction

command! -range -bar -nargs=1 CaseSwitch call s:switch_case(<f-args>, <line1>, <line2>)

if !hasmapto('<Plug>CaseSwitch') || maparg('gs','n') == ''
  xmap gsc  <Plug>CaseSwitch camel
  nmap gsc  <Plug>CaseSwitch camel

  xmap gss  <Plug>CaseSwitch snake
  nmap gss  <Plug>CaseSwitch snake

  xmap gsk  <Plug>CaseSwitch kebap
  nmap gsk  <Plug>CaseSwitch kebap
endif
