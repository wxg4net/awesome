-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- local menubar = require("menubar")
local vicious = require("vicious")
local revelation = require("revelation")

local ldbus = require("ldbus")
local conn = ldbus.bus.get ( "session" )
  
require("menu")
require("vfunction")
os.setlocale("zh_CN.UTF-8")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config").."/themes/default/theme.lua")
revelation.init()

-- This is used later as the default terminal and editor to run.
terminal = "sakura"
editor = os.getenv("EDITOR") or "leafpad"
editor_cmd = terminal .. " -x " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts =
{
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.right,
    awful.layout.suit.max,
    awful.layout.suit.fair,
    awful.layout.suit.floating
--[[    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
--]]
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        -- gears.wallpaper.set('#444444')
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
        --gears.wallpaper.centered(beautiful.wallpaper, s, '#242424')
    end
end
-- }}}

local vars = {
   -- names  = {" ➊ ", " ➋ ", " ➌ ", " ➍ ", " ➎ ", " ➏ ", " ➐ "},
   names = { "  ", "  ","  ", "  ", "  ", " ", "  " },
   -- names  = { ' 1 ', ' 2 ', ' 3 ', ' 4 ', ' 5 ', ' 6 ', ' 7 '},
   -- names  = { '网络', '聊天', '终端', '编辑','文件', '阅读', '其它'},
   layout = { 
      awful.layout.layouts[1], 
      awful.layout.layouts[1], 
      awful.layout.layouts[1], 
      awful.layout.layouts[1], 
      awful.layout.layouts[4],
      awful.layout.layouts[3], 
      awful.layout.layouts[1]
    }
}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(vars.names, s, vars.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

-- { "awesome", myawesomemenu },
mymainmenu = awful.menu({ items = { 
                                    { "选择软件", xdgmenu },
                                    { "文件浏览器r", "rox" },
                                    { "文件浏览器p", "pcmanfm" },
                                    { "Firefox", "firefox" },
                                    { "Chrome", "google-chrome" },
                                    { "TM2009", "work/soft/wine-tm2009.sh" },
                                    { "Weechat", "sakura -e weechat" },
                                    { "网络电视", "gsopcast" },
                                    { "Skype", "skype" },
                                    { "账单管理", "homebank" },
                                    { "矢量设计", "inkscape" },
                                    { "便笺", "gnote" },
                                    { "百度云", "bcloud-gui" },
                                    { "任务", "work/soft/python/zbj_net.py" },
                                    { "音乐播放", "work/soft/bash/mocp" },
                                    { "音乐恢复", "mocp --unpause" },
                                    { "音乐暂停", "mocp --pause" },
                                    { "启动Window Xp", "VBoxManage startvm winxp"},
                                    { "注销", awesome.quit },
                                    { "挂起", 'systemctl suspend'},
                                    { "休眠", 'systemctl hibernate'},
                                    { "关机", 'systemctl poweroff'}

                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
-- menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock(" %eD %VW %a %I:%M")
mytextclock:buttons( 
    awful.util.table.join(
        awful.button({ }, 1, 
          function() 
            date = awful.util.pread('cdate');  
            naughty.notify({ 
                             icon =  os.getenv("HOME")..'/Pictures/cdate',
                             title = "农历日期",
                             timeout = 9,
                             text = date })
          end)
    ))
--
-- Initialize widget
volumewidget = wibox.widget.textbox()
netwidget = wibox.widget.textbox()
cpuwidget = wibox.widget.textbox()

-- -- Register widget
vicious.register(volumewidget, vicious.widgets.volume, "  $1% ", 2, "Master")
vicious.register(netwidget, vicious.widgets.net, ' ${eth0 down_kb}  ${eth0 up_kb} Kb')
-- vicious.register(netwidget, vicious.widgets.net, '↑${wlan0 up_kb} ↓${wlan0 down_kb}')
vicious.register(cpuwidget, vicious.widgets.cpu, "$1%")

local netlayout = wibox.layout.constraint()
netlayout:set_widget(netwidget)
netlayout:set_strategy('exact')
netlayout:set_width(100)

local cpulayout = wibox.layout.constraint()
cpulayout:set_widget(cpuwidget)
cpulayout:set_strategy('exact')
cpulayout:set_width(35)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag) 
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function (c)
                                              c:kill()
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(volumewidget)
    right_layout:add(netlayout)
    right_layout:add(cpulayout)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 1, function () mymainmenu:toggle() end),
    awful.button({ }, 2, function () awful.util.spawn_with_shell("~/work/soft/bash/clock.sh")   end),
    awful.button({ }, 3, function () awful.util.spawn_with_shell("~/work/soft/bash/weather.sh")   end)
    -- awful.button({ }, 4, awful.tag.viewnext),
    -- awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "x",     function () 
      -- awful.util.spawn("work/soft/bash/contact-for-me.sh") 
      -- awful.util.spawn("google-chrome file:///home/wxg/work/data/task/task.html") 
      -- awful.tag.viewonly(awful.tag.gettags(mouse.screen)[1])
      mypromptbox[mouse.screen]:run() 
    end),
    awful.key({ modkey },            "z",     function () 
      awful.util.spawn("work/soft/bash/contact-for-me.sh") 
      awful.util.spawn("firefox file:///home/wxg/work/data/task/task.html") 
      awful.tag.viewonly(awful.tag.gettags(mouse.screen)[1])
      -- mypromptbox[mouse.screen]:run() 
    end),
    awful.key({ modkey },            "a",   revelation ),
    awful.key({ modkey }, "t", 
              function ()  
                awful.util.spawn(terminal .." -e /usr/bin/myagtd.py -c work/archiving/todo") 
              end),
    awful.key({ modkey }, "q", 
              function ()  
                awful.util.spawn(terminal .." -e work/soft/bash/post-qqweibo.sh") 
              end),
    awful.key({ modkey }, "p", 
              function ()  
                awful.util.spawn("planner") 
              end),
    awful.key({ modkey }, "v", 
              function ()  
                awful.util.spawn(terminal .." -t Weechat -e weechat") 
              end),
    awful.key({ modkey }, "s", 
              function ()  
                awful.util.spawn(terminal .." -e offlineimap -o -q ") 
              end),

    awful.key({ modkey }, "r",
              function ()
                awful.util.spawn(terminal .." -t newsbeuter -e newsbeuter") 
              end),
    -- Menubar
    awful.key({ modkey }, "Print", false, function () 
        awful.util.spawn_with_shell("cd /tmp/; scrot -e 'weibo4pic.py -f /tmp/$f | xsel -ib'") 
      end),
    awful.key({ "" }, "Print", false, function () 
        awful.util.spawn_with_shell("cd /tmp/; scrot -s -e 'weibo4pic.py -f /tmp/$f | xsel -ib'") 
        -- awful.util.spawn_with_shell("cd /tmp/; scrot -s -e 'curl -F \"name=@/tmp/$f\" https://img.vim-cn.com/ | xsel -ib'") 
      end),
    awful.key({ "Control", "Shift" }, "space", function () awful.util.spawn("dmenu_run -b") end),
    -- awful.key({ modkey, "Shift" }, "m", function() menubar.show() end),
    awful.key({ modkey,           }, "Up", function() awful.util.spawn_with_shell('amixer -q set Master 2%+')  end),
    awful.key({ modkey,           }, "Down", function() awful.util.spawn_with_shell('amixer -q set Master 2%-')  end),
    awful.key({ modkey,  'Control'}, "Down", function() awful.util.spawn_with_shell('amixer -q set Master toggle')  end),
    awful.key({ modkey,           }, "o", function () awful.util.spawn(terminal .. " -e \"sh -c 'sleep 0.5;mutt -y'\"") end) 
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m", 
      function (c) 
          c.maximized_horizontal = not c.maximized_horizontal
          c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

local titlebars_clients = {"Gcolor2", "MPlayer", "Gnome-mplayer", "Xmradio", "Gmchess"}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     size_hints_honor = false,
                     buttons = clientbuttons } },
    { rule_any = { class = {"Xephyr", "Lightsoff", "Firefox", "Xulrunner", "rdesktop", "Inkscape"} } , 
        properties = { floating=false } },
    { rule_any = { class = {"Gcolor2", 'doubanfm-qt', "MPlayer","Gnome-mplayer", "Plugin-container", "Exe", "operapluginwrapper-native", "Gmchess", "Main.py"},  skip_taskbar={true}, above={true}, type={"splash", "dialog", "dropdown_menu", "popup_menu"}}, 
        callback = awful.placement.centered,
        properties = { floating = true } },
    { rule_any = { name={"TM2009", "TM2013"} }, except_any = { role={"smiley_dialog"}, name={"表情"} } , 
        properties = { floating=false } },
    { rule_any = { class = {"Geany", "Scribus", "Gvim", "Dia", "Inkscape", "Gimp", "Xulrunner-bin", "Blender"} , name = { "LibreOffice", "XMind", "Pencil"} },
       properties = { tag = tags[1][4], switchtotag=true } },
    { rule_any = { class = {"XTerm", 'Sakura', "URxvt"} },
       properties = { tag = tags[1][3], switchtotag=true , border_width = 0 } },
    { rule_any = { class = {"Pidgin", "Skype", "Openfetion", "AliWangWang", "Gmchess", "Wine"} },
       properties = { tag = tags[1][2], switchtotag=true } },
    { rule_any = { class = {"Chromium", "Firefox", "Opera", "Google-chrome-unstable", "Google-chrome-beta", "Google-chrome"} },
       properties = { tag = tags[1][1], switchtotag=true } },
    { rule_any = { class = {"Pcmanfm", "Nautilus", "File-roller", "Thunar", "ROX-Filer", "Pgadmin3", "Bcloud-gui"}},
       properties = { tag = tags[1][5], switchtotag=true, sticky=false} },
    { rule_any = { class = {"Evince", "Liferea", "Genymotion", "rdesktop", "Xchm"}, name = { "newsbeuter" } },
       properties = { tag = tags[1][6], switchtotag=true } },
    { rule_any = { class = {"Transmission", "Planner", "VirtualBox", "Gsopcast", "Homebank"} },
       properties = { tag = tags[1][7], switchtotag=true } },
    { rule_any = { class = {"Unkown"} },
       properties = { maximized_vertical = true, maximized_horizontal = true  } },
    { rule_any = { class = titlebars_clients },
       properties = { border_width = 1 } },

    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    --[[
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)
    ]]--
    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false

    for _, tc in pairs(titlebars_clients) do
      if c.class == tc then
        titlebars_enabled = true
        break
      end
    end

    if titlebars_enabled then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

require("vconky")

client.connect_signal("focus", function(c) 
    if c.class == nil then return end
    local msg = ldbus.message.new_method_call ( "org.freedesktop.AwesomeWidget" , "/org/freedesktop/AwesomeWidget/Log" , "org.freedesktop.AwesomeWidget.Log" , "focus" ) 
    local iter = ldbus.message.iter.new ( )
    msg:iter_init_append ( iter )
    iter:append_basic ( c.class )
    conn:send ( msg )
    
    c.border_color = beautiful.border_focus 
  end)
  
client.connect_signal("unfocus", function(c) 
    if c.class == nil then return end
    local msg = ldbus.message.new_method_call ( "org.freedesktop.AwesomeWidget" , "/org/freedesktop/AwesomeWidget/Log" , "org.freedesktop.AwesomeWidget.Log" , "unfocus" ) 
    local iter = ldbus.message.iter.new ( )
    msg:iter_init_append ( iter )
    iter:append_basic ( c.class )
    conn:send ( msg )
    
    c.border_color = beautiful.border_normal 
  end)
  
-- }}}

autorun = true
autorunApps =
{
    "ps -e | grep fcitx || fcitx",
    "/usr/bin/start-pulseaudio-x11",
    "ps -e | grep compton || /usr/bin/compton  --config ~/.compton.conf -b"
--  "ps -e | grep gnote || gnote" 
--  "python2 /home/wxg/work/soft/python/myagtd-cli.py updateWidgetTask"
}
if autorun then
    for app = 1, #autorunApps do
        awful.util.spawn_with_shell(autorunApps[app])
    end
end

naughty.config.defaults.timeout = 10
naughty.config.defaults.icon_size = 900
-- naughty.config.defaults.font = "WenQuanYi Micro Hei 14"
naughty.config.defaults.position = "top_right"
