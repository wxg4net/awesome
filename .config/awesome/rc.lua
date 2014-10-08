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
        -- gears.wallpaper.set('#354A70')
        -- gears.wallpaper.maximized(beautiful.wallpaper, s, true)
        gears.wallpaper.centered(beautiful.wallpaper, s, '#242424')
    end
end
-- }}}

local vars = {
   -- names  = {" ➊ ", " ➋ ", " ➌ ", " ➍ ", " ➎ ", " ➏ ", " ➐ "},
   names = { "  ", "  ","  ", "  ", "  ", " ", "  " },
   -- names  = { ' 1 ', ' 2 ', ' 3 ', ' 4 ', ' 5 ', ' 6 ', ' 7 '},
   -- names  = { '网络', '聊天', '终端', '编辑','文件', '阅读', '其它'},
   layout = { 
      awful.layout.layouts[3], 
      awful.layout.layouts[5], 
      awful.layout.layouts[1], 
      awful.layout.layouts[2], 
      awful.layout.layouts[1],
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
                                    { "文件浏览器p", "pcmanfm" },
                                    { "文件浏览器r", "rox" },
                                    { "Firefox浏览器", "firefox" },
                                    { "(&G)Google-Chrome", "google-chrome" },
                                    { "TM2009", "work/soft/wine-tm2009.sh" },
                                    { "网络电视", "gsopcast" },
                                    { "账单管理", "homebank" },
                                    { "矢量设计", "inkscape" },
                                    { "音乐启动", "mocp -S" },
                                    { "音乐播放", "mocp --play -o shuffle" },
                                    { "换个听听", "mocp --next" },
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
mytextclock = awful.widget.textclock("%e号 %A %I:%M ")
mytextclock:buttons( 
    awful.util.table.join(
        awful.button({ }, 1, 
          function() 
            date = awful.util.pread('cdate');  
            naughty.notify({ 
                             title = "农历日期",
                             timeout = 2,
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
vicious.register(netwidget, vicious.widgets.net, ' ${eth0 up_kb}  ${eth0 down_kb}')
-- vicious.register(netwidget, vicious.widgets.net, '↑${wlan0 up_kb} ↓${wlan0 down_kb}')
vicious.register(cpuwidget, vicious.widgets.cpu, "$1%")

local netlayout = wibox.layout.constraint()
netlayout:set_widget(netwidget)
netlayout:set_strategy('exact')
netlayout:set_width(100)

local cpulayout = wibox.layout.constraint()
cpulayout:set_widget(cpuwidget)
cpulayout:set_strategy('exact')
cpulayout:set_width(25)

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
    awful.button({ }, 2, function () awful.util.spawn_with_shell("/home/wxg/work/soft/bash/clock.sh")   end),
    awful.button({ }, 3, function () awful.util.spawn_with_shell("/home/wxg/work/soft/bash/weather.sh")   end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
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
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey }, "t", 
              function ()  
                awful.util.spawn_with_shell(terminal .." -e myagtd.py ~/work/archiving/todo") 
              end),
    awful.key({ modkey }, "q", 
              function ()  
                awful.util.spawn_with_shell(terminal .." -e ~/work/soft/bash/post-qqweibo.sh") 
              end),
    awful.key({ modkey }, "p", 
              function ()  
                awful.util.spawn_with_shell("planner ~/work/archiving/todo.planner") 
              end),
    awful.key({ modkey }, "v", 
              function ()  
                awful.util.spawn_with_shell(terminal .." -t weechat -e weechat") 
              end),
    awful.key({ modkey }, "s", 
              function ()  
                awful.util.spawn_with_shell(terminal .." -e offlineimap -o -q ") 
              end),

    awful.key({ modkey }, "x",
              function ()
                awful.util.spawn_with_shell(terminal .." -t newsbeuter -e newsbeuter") 
              end),
    -- Menubar
    awful.key({ "" }, "Print", false, function () awful.util.spawn_with_shell("cd /tmp/; scrot -e 'weibo4pic.py -f /tmp/$f | xsel -ib'") end),
    awful.key({ modkey }, "Print", false, function () awful.util.spawn_with_shell("cd /tmp/; scrot -s -e 'weibo4pic.py -f /tmp/$f | xsel -ib'") end),
    awful.key({ "Control", "Shift" }, "space", function () awful.util.spawn("dmenu_run -b") end),
    -- awful.key({ modkey, "Shift" }, "m", function() menubar.show() end),
    awful.key({ modkey,           }, "Up", function() awful.util.spawn_with_shell('amixer -q set Master 2%+')  end),
    awful.key({ modkey,           }, "Down", function() awful.util.spawn_with_shell('amixer -q set Master 2%-')  end),
    awful.key({ modkey,  'Control'}, "Down", function() awful.util.spawn_with_shell('amixer -q set Master toggle')  end),
    awful.key({ modkey,           }, "m", function (c) awful.util.spawn_with_shell(terminal .." -e mutt -y") end)
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
    { rule_any = { class = {"Xephyr", "Lightsoff", "Firefox", "Pidgin", "Opera", "Xulrunner", "rdesktop", "Inkscape"}}, except_any = { role={"smiley_dialog"}, name={"表情"} } , 
        properties = { floating=false } },
    { rule_any = { class = {"Gcolor2", 'doubanfm-qt', "MPlayer","Gnome-mplayer", "Plugin-container", "Exe", "operapluginwrapper-native", "Gmchess", "Main.py"},  skip_taskbar={true}, above={true}, name={"TXMenuWindow"}, type={"splash", "dialog", "dropdown_menu", "popup_menu"}}, 
        callback = awful.placement.centered,
        properties = { floating = true, border_width = 0 } },
    { rule_any = { class = {"Geany", "Scribus", "Gvim", "Dia", "Inkscape", "Gimp", "Xulrunner-bin", "Pencil", "Pgadmin3"} , name = { "LibreOffice", "XMind"} },
       properties = { tag = tags[1][4], switchtotag=true } },
    { rule_any = { class = {"XTerm", 'Sakura', "URxvt"} },
       properties = { tag = tags[1][3], switchtotag=true , border_width = 0 } },
    { rule_any = { class = {"Pidgin", "Skype", "Openfetion", "AliWangWang", "Xchat", "Wine"} },
       properties = { tag = tags[1][2], switchtotag=true } },
    { rule_any = { class = {"Chromium", "Firefox", "Opera", "Google-chrome-unstable", "Google-chrome-beta", "Google-chrome"} },
       properties = { tag = tags[1][1], switchtotag=true } },
    { rule_any = { class = {"Pcmanfm", "Nautilus", "File-roller", "Thunar", "ROX-Filer", "JavaEmbeddedFrame"}},
       properties = { tag = tags[1][5], switchtotag=true, sticky=false} },
    { rule_any = { class = {"Evince", "Liferea", "Genymotion", "rdesktop"}, name = { "newsbeuter" } },
       properties = { tag = tags[1][6], switchtotag=true } },
    { rule_any = { class = {"Transmission", "Planner", "VirtualBox", "Gsopcast", "Homebank"} },
       properties = { tag = tags[1][7], switchtotag=true } },
    { rule_any = { class = {"ROX-Filer", "ROX-Panel"}},
       properties = { border_width = 0 } },
       -- properties = { border_width = 0, border_color = "#EDEDED", sticky = false } },
    { rule_any = { class = {"feh", 'Sxiv', 'XTerm'} },
       properties = { maximized_vertical = true, maximized_horizontal = true  } },
    { rule_any = { class = { "Pidgin", "Skype", "MPlayer" } },
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
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
          -- client.focus = c
        end
    end)

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
    local titlebars_clients = {"Pidgin", "Gcolor2", "MPlayer", "Gnome-mplayer", "Xmradio", "Skype"}

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

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- require("conky")

autorun = true
autorunApps =
{
    "ps -e | grep fcitx || fcitx",
    "ps -e | grep gnote || gnote"
--  "python2 /home/wxg/work/soft/python/myagtd-cli.py updateWidgetTask"
}
if autorun then
    for app = 1, #autorunApps do
        awful.util.spawn_with_shell(autorunApps[app])
    end
end

naughty.config.defaults.timeout = 5
naughty.config.defaults.icon_size = 900
naughty.config.defaults.position = "top_right"
