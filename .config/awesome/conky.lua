
local button = require("awful.button")
local util = require("awful.util")
local wibox = require("wibox")
local cairo = require("lgi").cairo

require("vfunction")

local conky = wibox({  border_width = 0,  type = "desktop" })
local pat = cairo.Pattern.create_rgba(0, 0, 0, 0)
conky:set_bg(pat)                                            
conky.ontop = false
-- my screen size 1440x900
conky:geometry({ width = 660, height = 300, x = 660, y = 500 })
conky.opacity = 1
conky.visible = true

local tasktextbox = wibox.widget.textbox()
t_title, t_message = todo()
tasktextbox:set_valign('top')
tasktextbox:set_align('left')
tasktextbox:set_font('WenQuanYi Micro Hei Mono 12')
tasktextbox:set_markup(t_message)

local tasktextmarginbox = wibox.layout.margin()
tasktextmarginbox:set_widget(tasktextbox)

local layout = wibox.layout.fixed.horizontal()
layout:add(tasktextmarginbox)

layout:buttons(util.table.join(button({ }, 1, function(c) 
  t_title, t_message = todo()
  tasktextbox:set_markup(t_message)
end)))

conky:set_widget(layout)
