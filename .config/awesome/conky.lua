local awful = require("awful")
local button = require("awful.button")
local util = require("awful.util")
local wibox = require("wibox")
local capi = { screen = screen,
               dbus = dbus}
               
local sqlite3 = require("lsqlite3")
local db = sqlite3.open('./work/data/awesome.sqlite')

local conky = wibox({ fg = '#ffffff77',
                               bg = '#00000000',
                               type = "desktop" })
-- my screen size 1440x900
conky:geometry({ width = 900, height = 400, x = 500, y = 500 })
conky.visible = true

local tb_task = wibox.widget.textbox()
local tb_task_margin = wibox.layout.margin()

tb_task:set_font('WenQuanYi Micro Hei Mono 12')
tb_task:set_text('......')
tb_task:set_align('right')
tb_task_margin:set_margins(10)
tb_task_margin:set_widget(tb_task)

tb_task:buttons(util.table.join(
  button({ }, 1, function(c) 
    awful.util.spawn_with_shell(terminal .. " -e myagtd.py ~/work/archiving/todo")  
    return false
  end),
  button({ }, 3, function(c) 
    awful.util.spawn("./work/soft/python/awesome-log.py")  
    return false
  end)
))

local layout = wibox.layout.fixed.vertical()
layout:add(tb_task_margin)
conky:set_widget(layout)

capi.dbus.connect_signal("org.freedesktop.AwesomeWidget.Log", function (data, app) 
    local force = 0
    if data.member == "focus" then
      force = 1
    end
    db:exec('INSERT INTO log (app, type) VALUES ("'..app..'", "'..force..'")')
    return "b", true
  end)

capi.dbus.connect_signal("org.freedesktop.AwesomeWidget.Task", function (data, message) 
    if data.member == "Update" then
       tb_task:set_text(message)
       return "b", true
    end
  end)

capi.dbus.request_name("session", "org.freedesktop.AwesomeWidget")
