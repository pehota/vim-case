" vim-case-switch.vim - Switch between different cases
" Maintainer:  Dimitar Apostolov <d.apostolov@gmail.com>
" Last Change: 2020 Dec 05
" Version:     0.0.1

if exists('g:loaded_switch_case')
  finish
endif

let g:loaded_switch_case = 1

let s:cases = { 'camel': 'camel', 'snake': 'snake', 'kebap': 'kebap' }

function! s:switch_case(case, start_line, end_line)
  let l:search_for = s:get_case_regex(a:case)
  let l:replace_with = s:get_case_replacement(a:case)

  exe a:start_line . ',' . a:end_line . 's#' . search_for . '#' . replace_with . '#ge'
endfunction
  
function! s:get_case_regex(case) abort
	if a:case ==# s:cases.camel
		return '\(\<\u\l\+\|\l\+\)\(\u\)'
	elseif a:case ==# s:cases.snake
		return '\%(\%(\k\+\)\)\@<=_\(\k\)'
	elseif a:case ==# s:cases.kebap
		return '\%(\%(\k\+\)\)\@<=_\(\k\)'
endfunction

function! s:get_case_replacement(case) abort
	if a:case ==# s:cases.camel
		return '\u\1'
	elseif a:case ==# s:cases.snake
		return '\_\1'
	elseif a:case ==# s:cases.kebap
		return '\-\1'
endfunction


command! -range -bar -nargs=1 SwitchCase call s:switch-case(<f-args>, <line1>, <line2>)

if !hasmapto('<Plug>SwitchCase') || maparg('gs','n') == ''
  xmap gsc  <Plug>SwitchCase s:cases.camel
  nmap gsc  <Plug>SwitchCase s:cases.camel

  xmap gss  <Plug>SwitchCase s:cases.snake
  nmap gss  <Plug>SwitchCase s:cases.snake

  xmap gsk  <Plug>SwitchCase s:cases.kebap
  nmap gsk  <Plug>SwitchCase s:cases.kebap
endif
