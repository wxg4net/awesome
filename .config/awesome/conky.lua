local awful = require("awful")
local button = require("awful.button")
local util = require("awful.util")
local wibox = require("wibox")
local naughty = require("naughty")
local cairo = require("lgi").cairo
local capi = { screen = screen,
               dbus = dbus}
               
local M_PI  = math.pi

local conky = wibox({ fg = '#ffffff55',
                               bg = '#354A70ff',
                               type = "desktop" })
conky.ontop = false
-- my screen size 1440x900
conky:geometry({ width = 1440, height = 300, x = 0, y = 600 })
conky.visible = true

local pat = cairo.Pattern.create_rgba(0, 0, 0, 0)
local surface = cairo.ImageSurface.create(cairo.FORMAT_ARGB32, 1440, 200)
local cr = cairo.Context(surface)
cr:set_source_rgba(0, 0, 0, 0)
cr:paint()
cr:set_line_width(6);
cr:set_source_rgba (0.96, 0.47, 0.31, 0.5)
cr:arc (100, 48, 40, 0, M_PI*5/3);
cr:stroke()
cr:set_source_rgba (1, 1, 1, 0.3)
cr:arc (100, 48, 40, M_PI*5/3, M_PI*2);
cr:stroke()

cr:set_line_width(2);
cr:set_source_rgba (1, 1, 1, 0.3)
cr:move_to(0, 100)
cr:curve_to (480, 60, 960, 140, 1440, 100);
cr:stroke()
local pat = cairo.Pattern.create_for_surface( surface ) 
conky:set_bg(pat)   

local tb_task = wibox.widget.textbox()
local tb_task_margin = wibox.layout.margin()
tb_task:set_font('WenQuanYi Micro Hei Mono 12')
tb_task:set_text('Keep It Simple, Stupid!')
tb_task:set_align('left')
tb_task_margin:set_margins(30)
tb_task_margin:set_widget(tb_task)

local tb_kiss = wibox.widget.textbox()
local tb_kiss_margin = wibox.layout.margin()
tb_kiss:set_valign('center')
tb_kiss:set_align('right')
tb_kiss:set_font('URW Chancery L 36')
tb_kiss:set_text('Keep It Simple, Stupid!     ')
tb_kiss_margin:set_margins(20)
tb_kiss_margin:set_widget(tb_kiss)


local layout = wibox.layout.fixed.vertical()

layout:add(tb_kiss_margin)
layout:add(tb_task_margin)

layout:buttons(util.table.join(button({ }, 1, function(c) 
--  conky.ontop = not conky.ontop
  date = awful.util.pread('cdate');  
  naughty.notify({ 
                   title = "农历日期",
                   timeout = 2,
                   text = date })
end)))

conky:set_widget(layout)

capi.dbus.connect_signal("org.freedesktop.AwesomeWidget.Task", function (data, todolist) 
    if data.member == "Update" then
       tb_task:set_text(todolist)
       return "b", true
    end
  end)

capi.dbus.request_name("session", "org.freedesktop.AwesomeWidget")
