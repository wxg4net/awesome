local awful = require("awful")
local button = require("awful.button")
local util = require("awful.util")
local wibox = require("wibox")
local capi = { screen = screen,
               dbus = dbus}
local beautiful = require("beautiful")
local sqlite3 = require("lsqlite3")
local db = sqlite3.open('./work/data/awesome.sqlite')

conky = wibox({ fg = '#ffffff66',bg = '#ffffff00',type = "desktop" })
-- my screen size 1440x900
conky:geometry({ width = 700, height = 300, x = 720, y = 600 })
conky.visible = true
conky.ontop = false

tb_task = wibox.widget.textbox()
local tb_task_margin = wibox.layout.margin()

tb_task:set_font('WenQuanYi Micro Hei Mono 12')
tb_task:set_text('')
tb_task:set_align('right')
tb_task_margin:set_margins(10)
tb_task_margin:set_widget(tb_task)

conky:buttons(util.table.join(
  button({ }, 1, function(c) 
    if conky.ontop then
      return true
    end
    awful.util.spawn("./work/soft/python/myagtd-cli.py  updateWidgetTask", false)  
    return true
  end),
  button({ }, 4, function(c) 
    tb_task:set_text('')
    conky.ontop = false
    return true
  end),
  button({ }, 5, function(c) 
    tb_task:set_text('')
    conky.ontop = false
    return true
  end),
  button({ }, 3, function(c) 
    if conky.ontop then
      return true
    end
    awful.util.spawn(awful.util.getdir("config").."/vlog.py", false)  
    return false
  end)
))


local layout = wibox.layout.fixed.vertical()
layout:add(tb_task_margin)
conky:set_widget(layout)

client.connect_signal("focus", function(c) 
    if c.class == nil then return end
    db:exec('INSERT INTO log (app, type) VALUES ("'..c.class..'", "1")')
    c.border_color = beautiful.border_focus 
  end)

client.connect_signal("unfocus", function(c) 
    if c.class == nil then return end
    db:exec('INSERT INTO log (app, type) VALUES ("'..c.class..'", "0")')
    c.border_color = beautiful.border_normal 
  end)
  
capi.dbus.connect_signal("org.freedesktop.AwesomeWidget.Task", function (data, message) 
  if data.member == "Update" then
     tb_task:set_text(message)
     return "b", true
  end
end)

capi.dbus.request_name("session", "org.freedesktop.AwesomeWidget")
