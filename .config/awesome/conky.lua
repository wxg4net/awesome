
local button = require("awful.button")
local util = require("awful.util")
local wibox = require("wibox")
local naughty = require("naughty")
local cairo = require("lgi").cairo
local capi = { screen = screen,
               dbus = dbus}
               

local task_theme_color = '#96AEDA'

local conky = wibox({  border_width = 0,  type = "desktop" })
local pat = cairo.Pattern.create_rgba(0, 0, 0, 0)
conky:set_bg(pat)                                            
conky.ontop = false
-- my screen size 1440x900
conky:geometry({ width = 800, height = 360, x = 600, y = 500 })
conky.opacity = 0.3
conky.visible = true

local tasktextbox = wibox.widget.textbox()

tasktextbox:set_valign('top')
tasktextbox:set_align('right')
tasktextbox:set_wrap('world_char')
tasktextbox:set_font('WenQuanYi Micro Hei Mono 11')
tasktextbox:set_markup('<span color="'..task_theme_color..'">loading...</span>')

local tasktextmarginbox = wibox.layout.margin()
tasktextmarginbox:set_margins(1)
tasktextmarginbox:set_widget(tasktextbox)

local layout = wibox.layout.fixed.horizontal()
layout:add(tasktextmarginbox)

layout:buttons(util.table.join(button({ }, 1, function(c) 
  --~ conky.ontop = not conky.ontop
  naughty.notify({ preset = naughty.config.presets.critical,
                   title = "Oops",
                   timeout = 2,
                   text = '此处无法点击' })
end)))

conky:set_widget(layout)

capi.dbus.connect_signal("org.freedesktop.AwesomeWidget.Task", function (data, todolist) 
    if data.member == "Update" then
       tasktextbox:set_markup('<span color="'..task_theme_color..'">'..todolist..'</span>')
       return "s", "True"
    end
  end)

capi.dbus.request_name("session", "org.freedesktop.AwesomeWidget")
