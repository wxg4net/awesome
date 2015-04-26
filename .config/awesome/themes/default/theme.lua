-------------------------------
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

-- Alternative icon sets and widget icons:
--  * http://awesome.naquadah.org/wiki/Nice_Icons http://awesome.naquadah.org/wiki/Nice_Icons


-- {{{ Main
theme = {}
theme.wallpaper = "/home/wxg/Pictures/default"
theme.icon_dir  = os.getenv("HOME") .. "/.config/awesome/themes/default"
-- }}}

-- {{{ Styles

theme.font      = "WenQuanYi Micro Hei 11"
-- {{{ Colors
theme.bg_color                      = {"#468966", "#46478a", "#8a4669", "#8a8946"}

theme.fg_normal                     = "#bbbbbb"
theme.fg_focus                      = "#cc6666"
theme.fg_urgent                     = "#cc6666"
theme.fg_minimize                   = "#bbbbbb"
theme.bg_normal                     = "#222222"
theme.bg_focus                      = "#222222"
theme.bg_urgent                     = "#222222"
theme.bg_systray                    = "#172E22"

theme.border_width                  = "0"
theme.border_normal                 = "#232424"
theme.border_focus                  = "#777777"
theme.border_marked                 = "#F44336"
--theme.taglist_fg_focus               = "#cc6666"
theme.taglist_bg_focus               = "#11111100"
theme.taglist_bg_urgent              = "#11111100"
theme.tasklist_bg_normal             = "#11111100"
theme.tasklist_bg_urgent             = "#11111100"
theme.tasklist_bf_focus              = "#cc7a7a"
theme.tasklist_bg_focus              = "#11111100"
theme.tasklist_bg_minimize           = "#11111100"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#222222"
theme.titlebar_bg_normal = "#222222"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

theme.tooltip_border_width = 10
theme.tooltip_border_color = "#060606"
theme.tooltip_bg_color = "#060606"
theme.tooltip_fg_color = "#D7D7D7"
theme.tooltip_font = "WenQuanYi Micro Hei Mono 12"


-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_bg_normal    = "#222222bb"
theme.menu_bg_focus     = "#222222bb"
theme.menu_border_width = "0"
theme.menu_height = "20"
theme.menu_width  = "150"
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = theme.icon_dir .. "/taglist/squarefz.png"
theme.taglist_squares_unsel = theme.icon_dir .. "/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = theme.icon_dir .. "/awesome-icon.png"
theme.menu_submenu_icon      = "/usr/share/awesome/themes/default/submenu.png"
theme.tasklist_floating_icon = "/usr/share/awesome/themes/default/tasklist/floatingw.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = theme.icon_dir .. "/layouts/tile.png"
theme.layout_tileleft   = theme.icon_dir .. "/layouts/tileleft.png"
theme.layout_tilebottom = theme.icon_dir .. "/layouts/tilebottom.png"
theme.layout_tiletop    = theme.icon_dir .. "/layouts/tiletop.png"
theme.layout_fairv      = theme.icon_dir .. "/layouts/fairv.png"
theme.layout_fairh      = theme.icon_dir .. "/layouts/fairh.png"
theme.layout_xtermv     = theme.icon_dir .. "/layouts/xtermv.png"
theme.layout_spiral     = theme.icon_dir .. "/layouts/spiral.png"
theme.layout_dwindle    = theme.icon_dir .. "/layouts/dwindle.png"
theme.layout_max        = theme.icon_dir .. "/layouts/max.png"
theme.layout_fullscreen = theme.icon_dir .. "/layouts/fullscreen.png"
theme.layout_magnifier  = theme.icon_dir .. "/layouts/magnifier.png"
theme.layout_floating   = theme.icon_dir .. "/layouts/floating.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = theme.icon_dir .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.icon_dir .. "/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = theme.icon_dir .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.icon_dir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = theme.icon_dir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.icon_dir .. "/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = theme.icon_dir .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.icon_dir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = theme.icon_dir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.icon_dir .. "/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = theme.icon_dir .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.icon_dir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = theme.icon_dir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.icon_dir .. "/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = theme.icon_dir .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.icon_dir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.icon_dir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.icon_dir .. "/titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme
