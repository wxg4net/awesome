-- Standard awesome library
local capi = { screen = screen,
               awesome = awesome,
               client = client }
local gears = require("gears")
local awful = require("awful")
local tag = require("awful.tag")
local util = require("awful.util")
local ascreen = require("awful.screen")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
beautiful.init(awful.util.getdir("config").."/themes/default/theme.lua")
-- Notification library
local naughty = require("naughty")
local revelation = require("revelation")
local scratch = require("scratch")
local hotkeys_popup = require("awful.hotkeys_popup").widget

require("menu")
os.setlocale("zh_CN.UTF-8")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

local function scratch_pad_client (c) scratch.pad.set(c, 0.5, 0.5, true) end

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
-- Themes define colours, icons, font and wallpapers.

revelation.init()

-- This is used later as the default terminal and editor to run.
terminal = "termite"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.right,
    awful.layout.suit.max,
    awful.layout.suit.fair,
    awful.layout.suit.floating,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.spiral
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
        -- gears.wallpaper.set(beautiful.Wallpaper_color)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}

myscreen = {
   name  = {' reborn ', ' 2 ', ' 3 ', ' 4 ', ' 5 ', ' 6 ', ' 7 ', ' 8 ', ' 9 '},
   layout = { 
      awful.layout.layouts[7], 
      awful.layout.layouts[1], 
      awful.layout.layouts[1], 
      awful.layout.layouts[1], 
      awful.layout.layouts[4],
      awful.layout.layouts[3], 
      awful.layout.layouts[3], 
      awful.layout.layouts[4], 
      awful.layout.layouts[1]
    }
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(myscreen.name, s, myscreen.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
mymainmenu = awful.menu({ 
  items = { 
      { "选择软件", xdgmenu },
      { "文件浏览器r", "rox" },
      { "文件浏览器p", "pcmanfm" },
      { "Firefox", "firefox" },
      { "Chrome", "google-chrome" },
      { "Weechat", terminal.." -e weechat -t Weechat" },
      { "Skype", "skype" },
      { "账单管理", "homebank" },
      { "矢量设计", "inkscape" },
      { "便笺", "gnote" },
      { "hotkeys", function() return false, hotkeys_popup.show_help end},
      { "百度云", "bcloud-gui" },
      { "TM2009", "Work/soft/wine-tm2009.sh" },
      { "音乐播放", "Work/soft/bash/mocp" },
      { "音乐恢复", "mocp --unpause" },
      { "音乐暂停", "mocp --pause" },
      { "启动Window Xp", "VBoxManage startvm 'win7'"},
      { "注销", awesome.quit },
      { "挂起", 'systemctl suspend'},
      { "关机", 'systemctl poweroff'}
  }
})
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
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
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
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
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.noempty, mytaglist.buttons)

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
    right_layout:add(mykeyboardlayout)

    if s == 1 then right_layout:add(wibox.widget.systray()) end
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

local function noemptytag_viewidx(i, screen) 
    local screen = screen or ascreen.focused()
    local tags = tag.gettags(screen)
    local showntags = {}
    for k, t in ipairs(tags) do
        if not tag.getproperty(t, "hide") and (#t:clients() > 0 or t.selected) then
            table.insert(showntags, t)
        end
    end
    local sel = tag.selected(screen)
    tag.viewnone(screen)
    for k, t in ipairs(showntags) do
        if t == sel then
            showntags[util.cycle(#showntags, k + i)].selected = true
        end
    end
    capi.screen[screen]:emit_signal("tag::history::update")
end

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 1, function () mymainmenu:toggle() end),
    awful.button({ }, 2, revelation),
    awful.button({ }, 3, function () awful.util.spawn_with_shell("~/Work/soft/bash/weather.sh")   end) 
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey }, "F12", function () scratch.drop(terminal..' --title=dropshell') end),
    awful.key({ modkey }, "F11", function () scratch.pad.toggle() end),
    awful.key({ modkey }, "a",      revelation               ),
    awful.key({ modkey }, "t",   
              function ()  
                awful.util.spawn(terminal .." -e '/usr/bin/myagtd.py -c Work/archiving/todo'") 
              end),
    awful.key({ modkey }, "y", 
              function ()  
                awful.client.urgent.jumpto()
              end),
    awful.key({ modkey }, "v", 
              function ()  
                awful.util.spawn(terminal .." -t Weechat -e weechat") 
              end),
    awful.key({ modkey }, "s", 
              function ()  
                awful.util.spawn(terminal .." -e offlineimap -o ") 
              end),
    awful.key({ modkey }, "r",
              function ()
                awful.util.spawn(terminal .." -t newsbeuter -e newsbeuter") 
              end),
    awful.key({ modkey }, "Print", false, 
              function () 
                awful.util.spawn_with_shell("cd /tmp/; scrot -e 'weibo4pic.py -f /tmp/$f | xsel -ib'") 
              end),
    awful.key({        }, "Print", false, 
              function () 
                awful.util.spawn_with_shell("cd /tmp/; scrot -s -e 'weibo4pic.py -f /tmp/$f | xsel -ib'") 
              end),
    awful.key({ modkey }, "Up",   
              function () 
                awful.util.spawn_with_shell('amixer -q set Master 2%+')  
              end),
    awful.key({ modkey }, "Down", 
              function () 
                awful.util.spawn_with_shell('amixer -q set Master 2%-')  
              end),
    awful.key({ modkey }, "o",    
              function () 
                awful.util.spawn(terminal .. " -e \"sh -c 'sleep 0.5;mutt -y'\"") 
              end),
    awful.key({ modkey }, "d", 
              function () 
                awful.util.spawn("dmenu_run -b") 
              end),
    awful.key({ modkey, "Control" }, "Down",   
              function () 
                awful.util.spawn_with_shell('amixer -q set Master toggle')  
              end),
  --awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Left",   function() noemptytag_viewidx(-1)  end),
  --awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Right",  function() noemptytag_viewidx(1)   end),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
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
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn_with_shell(terminal..' -e ranger') end),
    awful.key({ modkey, "Control" }, "Return", function () awful.util.spawn('dmenu_run -b') end),
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

    awful.key({ modkey, "Control" }, "n",
              function ()
                  c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end),

    -- Prompt
    -- awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() 
       awful.util.spawn("planner Work/now.planner") 
    end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end),
    awful.key({ modkey,           }, "F10",    scratch_pad_client),
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
            c.maximized = not c.maximized
            c:raise()
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
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

local np_map = { 87, 88, 89, 83, 84, 85, 79, 80, 81 }
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. np_map[i],
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. np_map[i],
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. np_map[i],
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. np_map[i],
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
    -- awful.button({ }, 2, revelation),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

titlebar_clients = {"Gcolor2", "MPlayer", "Gnome-mplayer", "Xmradio", "Gnote"}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     size_hints_honor = false,
                     buttons = clientbuttons } },
    { rule_any = { class = {"Xephyr", "Lightsoff", "Firefox", "Xulrunner", "rdesktop", "Inkscape"} } , 
        properties = { floating=false } },
    { rule_any = { class = {"Gcolor2", 'doubanfm-qt', "MPlayer","Gnome-mplayer", "Plugin-container", "Exe", "Gnote", "Gmchess", "Main.py"},  skip_taskbar={true}, above={true}, type={"splash", "dialog", "dropdown_menu", "popup_menu"}}, 
        callback = awful.placement.centered,
        properties = { floating = true } },
    { rule_any = { name={"TM2009", "TM2013"}, class={"QQ.exe"} }, except_any = { role={"smiley_dialog"}, name={"表情"} } , 
        properties = { floating=false } },
    { rule_any = { name={}, class={"Gnote"} }, except_any = { role={}, name={} } , 
        callback = scratch_pad_client },
    { rule_any = { class = {"Geany", "Scribus", "Gvim", "Dia"} , name = { "LibreOffice", "XMind", "Pencil","jetbrains-idea-ce"} },
       properties = { tag = tags[1][2], switchtotag=true } },
    { rule_any = { class = {"XTerm", 'Sakura', "URxvt", "Termite"} }, except_any = { name={"dropshell"} },
       properties = { tag = tags[1][3], switchtotag=true } },
    { rule_any = { class = {"Pidgin", "Skype", "Openfetion", "AliWangWang", "Gmchess", "Wine"}, name = {"Weechat"} },
       properties = { tag = tags[1][8], switchtotag=true } },
    { rule_any = { class = {"Chromium", "google-chrome-unstable", "Google-chrome-beta", "google-chrome", "Firefox"} },
       properties = { tag = tags[1][1], switchtotag=true } },
    { rule_any = { class = {"Pcmanfm", "Nautilus", "File-roller", "Thunar", "ROX-Filer", "Pgadmin3", "Bcloud-gui"}},
       properties = { tag = tags[1][5], switchtotag=true, sticky=false} },
    { rule_any = { class = {"Evince", "Liferea", "Genymotion", "rdesktop", "Xchm"} },
       properties = { tag = tags[1][6], switchtotag=true } },
    { rule_any = { class = {"Transmission", "Planner", "VirtualBox", "Gsopcast", "Homebank"} },
       properties = { tag = tags[1][7], switchtotag=true } },
    { rule_any = { class = {"Inkscape", "Gimp", "Blender"} , name = { "LibreOffice", "XMind", "Pencil","jetbrains-idea-ce"} },
       properties = { tag = tags[1][6], switchtotag=true } },
    { rule_any = { class = {"Unkown"} },
       properties = { maximized_vertical = true, maximized_horizontal = true  } },
    { rule_any = { class = titlebars_clients },
       properties = { border_width = 1 } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    if not awesome.startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    elseif not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count change
        awful.placement.no_offscreen(c)
    end

    local titlebars_enabled = false

    for _, tc in pairs(titlebar_clients) do
      if c.class == tc then
        titlebars_enabled = true
        break
      end
    end
    
    if titlebars_enabled  then
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

-- Enable sloppy focus
--[[
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)
]]--

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

autorunapps = {
    "xset s 0",
    "xset dpms 0 0 0",
    "/usr/bin/fcitx",
    "/usr/bin/start-pulseaudio-x11"
--  "/usr/bin/compton  --config ~/.compton.conf -b"
--  "ps -e | grep gnote || gnote" 
}

for app = 1, #autorunapps do
    awful.util.spawn_with_shell(autorunapps[app])
end

naughty.config.defaults.timeout = 10
naughty.config.defaults.font = "WenQuanYi Micro Hei Mono 11"
naughty.config.defaults.position = "top_right"
