#!/usr/bin/python2
# -*- coding: utf-8 -*-

import os,sys
import time
import sqlite3
import dbus

conn = sqlite3.connect('work/data/awesome.sqlite')
conn.text_factory = str
cur  = conn.cursor()

today = time.strftime('%Y-%m-%d')

cur.execute("select app, count(app)  from log where type=1 and date(time)='%s' group by app" % (today, ))

lists = cur.fetchall()
res = {}
for r in lists:
  res[r[0]] = [r[0], r[1], 0, 0]

cur.execute("select app, type, strftime('%%s',time)  from log where date(time)='%s' " % (today, ))
lists = cur.fetchall()

for r in lists:
  end = res[r[0]][3]
  if r[1] == 1:
    res[r[0]][3] = int(r[2])
  elif r[1] == 0 and end != 0:
    m = int(r[2]) - end
    res[r[0]][2] += m
    
message = []
total_time = 0
for r in res:
  
  if res[r][0] != 'Firefox' and res[r][0] != 'Google-chrome':
    total_time += res[r][2]
  message.append('%10s %5s %5s' % (res[r][0], res[r][1], res[r][2]/60))
  
message.append('非浏览器使用时间 (%s) 分钟' % (total_time/60, ))

sessionBus = dbus.SessionBus()
awesomeWidgetObject = sessionBus.get_object('org.freedesktop.AwesomeWidget', '/')
awesomeWidgetTaskUpdate = awesomeWidgetObject.get_dbus_method('Update', 'org.freedesktop.AwesomeWidget.Task')
awesomeWidgetTaskUpdate('\n'.join(message))

exit(0)