#!/usr/bin/python
# -*- coding: utf-8 -*-

import os,sys
import time
import sqlite3
import dbus
from operator import itemgetter

conn = sqlite3.connect( os.path.expanduser('~') + '/work/data/awesome.sqlite')
conn.text_factory = str
cur  = conn.cursor()

def log(today):
  cur.execute("select app, count(app) as force  from log where type=1 and date(time)='%s' group by app" % (today, ))
  lists = cur.fetchall()
  res = {}
  for r in lists:
    res[r[0]] = [r[0], r[1], 0, 0]

  cur.execute("select app, type, strftime('%%s',time)  from log where date(time)='%s'  order by id ASC" % (today, ))
  lists = cur.fetchall()

  for r in lists:
    end = res[r[0]][3]
    if r[1] == 1:
      res[r[0]][3] = int(r[2])
    elif r[1] == 0 and end != 0:
      m = int(r[2]) - end
      res[r[0]][2] += m
    else:
      pass
  return res


yestoday = time.strftime('%Y-%m-%d', time.localtime(time.time()-86400))
today = time.strftime('%Y-%m-%d')

yres = log(yestoday)
res = log(today)

message = []
total_time = 0
total_focus = 0
keys = list(res.keys())
keys.sort()
for r in keys:
  if res[r][0] != 'Firefox' and res[r][0] != 'Google-chrome' and res[r][0] != 'urbanterror':
    total_time += res[r][2]
  app = res[r][0]
  force = int(res[r][1])
  total_focus += force
  time = int(res[r][2]/60)
  if app in yres:
    force = '%d/%d' % (force, yres[r][1])
    time = '%d/%d' % (time, yres[r][2]/60)
 
  message.append('%10s %10s %12s' % (app, force, time))
  
message.append('非浏览器使用时间 (%.2f/%d) 小时' % (total_time/3600, total_focus))

strm = '\n'.join(message)
sessionBus = dbus.SessionBus()
awesomeWidgetObject = sessionBus.get_object('org.freedesktop.AwesomeWidget', '/')
awesomeWidgetTaskUpdate = awesomeWidgetObject.get_dbus_method('Update', 'org.freedesktop.AwesomeWidget.Task')
awesomeWidgetTaskUpdate(strm)

exit(0)
