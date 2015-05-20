local awful = require("awful")
local button = require("awful.button")
local util = require("awful.util")
local wibox = require("wibox")
local capi = { screen = screen,
               dbus = dbus}
local beautiful = require("beautiful")
local driver = require("luasql.sqlite3")
local sqlite3 = driver.sqlite3()
local db = sqlite3:connect('./Work/data/awesome.sqlite')
local timer = require("gears.timer")

conky = wibox({ fg = '#ffffffaa',bg = '#ffffff00',type = "desktop" })
-- my screen size 1440x900
conky:geometry({ width = 600, height = 100, x = 60, y = 750 })
conky.visible = true
conky.ontop = false

--[[

local tb_todo = wibox.widget.textbox()
local  cpu = awful.widget.graph()
cpu:set_height(200)
cpu:set_width(700)
cpu:set_background_color('#494B4F00')
cpu:set_color('#B5D0C2')
cpu:set_max_value(100)
cpu:set_scale(3)

]]--

local tb_kiss = wibox.widget.textbox()
local tb_pbar = awful.widget.progressbar()
-- local tb_todo_margin = wibox.layout.constraint(tb_todo, 'exact', 700, 600)
local tb_kiss_margin = wibox.layout.margin(tb_kiss, 0, 0, 10, 10)
local tb_pbar_margin = wibox.layout.margin(tb_pbar, 0, 0, 10, 0)

tb_pbar:set_height(5)
tb_pbar:set_value(0)

tb_pbar:set_color('#cc6666')
tb_pbar:set_background_color('#B5D0C2')

tb_kiss:set_font('WenQuanYi Micro Hei Mono 13')
tb_kiss:set_align('left')
tb_kiss:set_markup("  Keep It Simple, Stupid. Just Do It ")

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
-- layout:add(cpu)
layout:add(tb_kiss_margin)
layout:add(tb_pbar_margin)
conky:set_widget(layout)

--[[

local t = timer { timeout = 1 }
t:connect_signal("timeout", function()
    cpu:add_value(math.random(0,100))
end)
t:start()
t:emit_signal("timeout")

]]--

client.connect_signal("focus", function(c) 
    if c.class == nil then return end
    
    db:execute('INSERT INTO log (app, type) VALUES ("'..string.gsub(c.class, " ", "_") ..'", "1")')
    c.border_color = beautiful.border_focus 
  end)

client.connect_signal("unfocus", function(c) 
    if c.class == nil then return end

    db:execute('INSERT INTO log (app, type) VALUES ("'..string.gsub(c.class, " ", "_") ..'", "0")')
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

