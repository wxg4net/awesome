local awful = require("awful")

function get_master_infos()
  local f=io.popen("amixer get Master")
  for line in f:lines() do
    if string.match(line, "%s%[%d+%%%]%s") ~= nil then
      volume=string.match(line, "%s%[%d+%%%]%s")
      volume=string.gsub(volume, "[%[%]%%%s]","")
      --helpers.dbg({volume})
    end
    if string.match(line, "%s%[[%l]+%]$") then
      state=string.match(line, "%s%[[%l]+%]$")
      state=string.gsub(state,"[%[%]%%%s]","")
    end
  end
  f:close()
  return state, volume
end


function get_calendar()
    local cal = awful.util.pread("cal -m ")
    cal = string.gsub(cal, "^%s*(.-)%s*$", "     %1")
    return cal
end

function todo()
    local total = 0
    local active = 0
    local todo = ""
    local tdfile = io.open('/home/wxg/work/archiving/todo', 'r')

    for line in tdfile:lines() do
        total = total + 1
        i, j = string.find(line, 'C:100')
        if i == nil then
            active = active + 1
            i, j =string.find(line, ' ')
            --todo = todo..string.sub(line, 0, j).."\n"
            todo = todo.."\n"..line
        end
    end
    if string.len(todo) < 4 then
        todo = todo.."\n无todo列表"
    end
    tdfile:close()
    return " <span>任务: "..active.."/"..total.."</span> ",todo
end

function mytimerboxinfo()
    local pdnsd = io.popen("pgrep pdnsd")
    --webdata = http.request('http://184.82.27.204/phstatus')
    if webdata ~= nil then
        for w in string.gmatch(webdata, "%d+") do
            websatus = 'Actived: '..w
            break
        end
    end
    pdnsdid = pdnsd:read()
    pdnsd:close()
    message = ''
    if pdnsdid == nil then
        message="<span color='red'>关</span>"
    else
        message="开"
    end
    return " DNS"..message.." "
end

function powerstatue()
    local powerstatue = io.open('/sys/class/power_supply/C1E9/status', 'r')
    local powersnow = io.open('/sys/class/power_supply/C1E9/charge_now', 'r')
    statue = powerstatue:read()
    cnow = powersnow:read()
    powerstatue:close()
    powersnow:close()
    rate = math.ceil(cnow*100/1790000)
    if statue == "Discharging" and rate < 10 then
        naughty.notify({title="电量警告", text="不好啦，电量低于10%，马上就要关机了"})
    end
    return " "..statue.." "..rate.."%"
end

function mytask()
    local tasks = io.open('/home/wxg/soft/data/task')
    naughty.notify({title="任务测试", text=tasks})
end

function copy_myinfo()
    awful.util.spawn_with_shell("echo -n -e '技术联系：2289688859\n项目查看：http://git.dev.work.cn' | xsel -ib") 
end
