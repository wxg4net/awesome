local naughty = require("naughty")
local button = require("awful.button")
local util = require("awful.util")
local wibox = require("wibox")
local cairo = require("lgi").cairo
-- local pl = require('pl.pretty')
local capi = { timer = timer }
-- local surface = require("gears.surface")

local M_PI  = math.pi
local imagewh = 200
local imagehwh = imagewh/2
local cr
local surface

function getcrc()
  surface = cairo.ImageSurface('ARGB32', imagewh, imagewh)
  cr = cairo.Context(_surface)
  cr:set_source_rgba (0, 0, 0, 1)
  cr:set_line_width (1);
  cr:arc(imagehwh, imagehwh, imagewh/2, 0, 2*M_PI);
  cr:fill();
  cr:set_source_rgba (1, 0.2, 0.2, 1)
  cr:set_line_width (imagehwh);
  return cr, surface
end
--~ local geom = screen[1].geometry

local conky = wibox({  border_width = 0,  type = "desktop" })
local pat = cairo.Pattern.create_rgba(0, 0, 0, 0)
conky:set_bg(pat)                                            
conky.ontop = false
conky:geometry({ width = imagewh, height = imagewh, x = 150, y = 600 })
conky.opacity = 1
conky.visible = true

--~ local textbox = wibox.widget.textbox()
--~ textbox:set_valign("middle")
--~ textbox:set_markup('ss')
--~ 
--~ local textmarginbox = wibox.layout.margin()
--~ textmarginbox:set_margins(5)
--~ textmarginbox:set_widget(textbox)

local imagebox = wibox.widget.imagebox()
local surface = cairo.ImageSurface('ARGB32', imagewh, imagewh)

cr, surface = getcrc()

imagebox:set_image(surface)
imagemarginbox = wibox.layout.margin(imagebox, 0, 0, 0, 0)

local layout = wibox.layout.fixed.horizontal()
--~ layout:add(textmarginbox)
layout:add(imagemarginbox)

layout:buttons(util.table.join(button({ }, 1, function(c) 
  end)))
  
conky:set_widget(layout)

local an = false
conkytimer = capi.timer { timeout = 1 }
conkytimer:connect_signal("timeout", function() 
    second=math.abs(os.date("%S"))
    now = an
    if second == 0 then 
      second= 60 
      an = not an
    end
    
    tstart = 0
    tend  = M_PI*second/30
    
    if now then 
      tstart, tend = tend, tstart
      cr, surface = getcrc()
    end
    
    cr:arc(imagehwh, imagehwh, imagewh/4, tstart, tend);
    cr:stroke ();
    imagebox:set_image(surface)
    
  end)
conkytimer:start()
conkytimer:emit_signal("timeout")
