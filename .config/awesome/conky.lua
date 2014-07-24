local awful = require("awful")
local button = require("awful.button")
local util = require("awful.util")
local wibox = require("wibox")
local naughty = require("naughty")
local cairo = require("lgi").cairo
local capi = { screen = screen,
               dbus = dbus}
               
local M_PI  = math.pi

local conky = wibox({ fg = '#ffffff88',
                               bg = '#354A7000',
                               type = "desktop" })
-- my screen size 1440x900
conky:geometry({ width = 1000, height = 300, x = 400, y = 500 })
conky.visible = true

local tb_task = wibox.widget.textbox()
local tb_task_margin = wibox.layout.margin()
tb_task:set_font('WenQuanYi Micro Hei Mono 11')
tb_task:set_text('......')
tb_task:set_align('right')
tb_task_margin:set_top(30)
tb_task_margin:set_left(50)
tb_task_margin:set_widget(tb_task)

local tb_kiss = wibox.widget.textbox()
local tb_kiss_margin = wibox.layout.margin()
tb_kiss:set_align('right')
tb_kiss:set_font('URW Chancery L 36')
tb_kiss:set_text('Keep It Simple, Stupid!')
tb_kiss_margin:set_widget(tb_kiss)


local layout = wibox.layout.fixed.vertical()

layout:add(tb_kiss_margin)
layout:add(tb_task_margin)

tb_task:buttons(util.table.join(button({ }, 1, function(c) 
  awful.util.spawn_with_shell( terminal .." -e myagtd.py ~/work/archiving/todo")  
end)))

conky:set_widget(layout)

capi.dbus.connect_signal("org.freedesktop.AwesomeWidget.Task", function (data, todolist) 
    if data.member == "Update" then
       tb_task:set_text(todolist)
       return "b", true
    end
  end)

capi.dbus.request_name("session", "org.freedesktop.AwesomeWidget")
