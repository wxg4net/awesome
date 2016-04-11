" =============================================================================
" Filename: autoload/calendar/view/ymd_year.vim
" Author: itchyny
" License: MIT License
" Last Change: 2013/12/09 22:40:43.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! calendar#view#ymd_year#new(source)
  return s:constructor.new(a:source)
endfunction

let s:self = {}

let s:self.ymd = [ 'year' ]

let s:constructor = calendar#constructor#view_ymd#new(s:self)

let &cpo = s:save_cpo
unlet s:save_cpo
