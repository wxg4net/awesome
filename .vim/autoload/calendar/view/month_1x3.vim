" =============================================================================
" Filename: autoload/calendar/view/month_1x3.vim
" Author: itchyny
" License: MIT License
" Last Change: 2013/11/23 12:08:09.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! calendar#view#month_1x3#new(source)
  return s:constructor.new(a:source)
endfunction

let s:self = {}
let s:self.x_months = 1
let s:self.y_months = 3

let s:constructor = calendar#constructor#view_months#new(s:self)

let &cpo = s:save_cpo
unlet s:save_cpo
