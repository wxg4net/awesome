local awful = require("awful")
local button = require("awful.button")
local util = require("awful.util")
local wibox = require("wibox")
local capi = { screen = screen,
               dbus = dbus}
local beautiful = require("beautiful")
local sqlite3 = require("lsqlite3")
local db = sqlite3.open('./Work/data/awesome.sqlite')
-- local timer = require("gears.timer")

conky = wibox({ fg = '#ffffff99',bg = '#ffffff00',type = "desktop" })
-- my screen size 1440x900
conky:geometry({ width = 700, height = 100, x = 100, y = 700 })
conky.visible = true
conky.ontop = false


-- local tb_todo = wibox.widget.textbox()
local tb_kiss = wibox.widget.textbox()
local tb_pbar = awful.widget.progressbar()

-- local tb_todo_margin = wibox.layout.constraint(tb_todo, 'exact', 700, 600)
local tb_kiss_margin = wibox.layout.margin(tb_kiss, 0, 0, 10, 10)
local tb_pbar_margin = wibox.layout.margin(tb_pbar, 0, 0, 10, 0)

tb_pbar:set_height(8)
tb_pbar:set_value(0)

tb_pbar:set_color('#cc6666')
tb_pbar:set_background_color('#B5D0C2')

tb_kiss:set_font('WenQuanYi Micro Hei Mono 18')
tb_kiss:set_align('left')
tb_kiss:set_text("  Keep It Simple, Stupid ")


conky:buttons(util.table.join(
  button({ }, 1, function(c) 
    mymainmenu:toggle()
    return true
  end),
  button({ }, 3, function(c) 
    mymainmenu:toggle()
    return false
  end)
))

local layout = wibox.layout.fixed.vertical()
-- layout:add(tb_todo_margin)
layout:add(tb_kiss_margin)
layout:add(tb_pbar_margin)
conky:set_widget(layout)

client.connect_signal("focus", function(c) 
    if c.class == nil then return end
    db:exec('INSERT INTO log (app, type) VALUES ("'..string.gsub(c.class, " ", "_") ..'", "1")')
    c.border_color = beautiful.border_focus 
  end)

client.connect_signal("unfocus", function(c) 
    if c.class == nil then return end
    db:exec('INSERT INTO log (app, type) VALUES ("'..string.gsub(c.class, " ", "_") ..'", "0")')
    c.border_color = beautiful.border_normal 
  end)

--[[

capi.dbus.add_match("session", "interface='org.freedesktop.AwesomeWidget', member='Value'" )
capi.dbus.connect_signal("org.freedesktop.AwesomeWidget",
    function (...)
        local data = {...}
        naughty.notify({ text = "data table size " .. #data .. "; value " .. tostring(data[2]) })
    end
)

]]--

capi.dbus.connect_signal("org.freedesktop.AwesomeWidget.Api", function (data, message) 
  if data.member == "WorkMode" then
     return "i", working_mode
  elseif data.member == "pBarUpdate" then
     tb_pbar:set_value(message)
  end
end)

capi.dbus.request_name("session", "org.freedesktop.AwesomeWidget")

