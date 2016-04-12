#! /usr/bin/env python
# -*- coding:utf-8 -*- #

import sys,re,os,time
import weechat
import sqlite3
import re

conn = sqlite3.connect('/home/wxg/.local/share/newsbeuter/cache.db')
conn.text_factory = str
cur  = conn.cursor()

TAG_RE = re.compile(r'<[^>]+>')
BREAK_RE = re.compile(r'\n+')
buf = None
SCRIPT_NAME = 'weefeed'

def setup_buffer(buffer):
  # set title
  weechat.buffer_set(buffer, "title", "Feed buffer")
  # disable logging, by setting local variable "no_log" to "1"
  weechat.buffer_set(buffer, "localvar_set_no_log", "1")
  #show nicklist
  weechat.buffer_set(buffer, "nicklist", "0")
  #weechat.buffer_set(buffer, "localvar_set_nick", 'rss')
  

def buffer_input_cb(data, buffer, input_data):
  global cur, TAG_RE
  cmd = input_data.split(' ')
  if cmd[0] == 'n':
    cur.execute("select id, title, url, author  from rss_item where unread=1 order by id asc")
    lists = cur.fetchall()
    res = {}
    index = 0
    if lists:
      for r in lists:
        weechat.prnt(buffer, '%s%s\t%2d)%s - %d' % (weechat.color("lightgreen"), r[3][:12], index, r[1], r[0], ))
        index += 1
      return weechat.WEECHAT_RC_OK
    weechat.prnt(buffer, 'nothing here')
    return weechat.WEECHAT_RC_OK
  if cmd[0] == 'a':
    cur.execute("update rss_item set unread=0 where unread=1")
    conn.commit()
    weechat.prnt(buffer, 'Done')
    return weechat.WEECHAT_RC_OK
  if cmd[0] == 'u':
    weechat.hook_process("/usr/bin/newsbeuter -x reload", 30 * 1000, "my_process_cb", "")
    weechat.prnt(buffer, 'Running...')
    return weechat.WEECHAT_RC_OK
  if cmd[0].isdigit():
    cur.execute("select content, url  from rss_item where unread = 1 order by id asc  limit %s,1" % (cmd[0],))
    lists = cur.fetchall()
    res = {}
    if lists:
      for r in lists:
        message = TAG_RE.sub("\n", r[0])
        message = BREAK_RE.sub("\n", message)
        weechat.prnt(buffer, 'url\t%s%s' % (weechat.color("red"), r[1],))
        weechat.prnt(buffer, '\t%s' % (message,))
    conn.commit()
    return weechat.WEECHAT_RC_OK
  weechat.prnt(buffer, 'unknow command')
  return weechat.WEECHAT_RC_OK

def my_process_cb(data, command, rc, out, err):
  weechat.prnt(buf, 'Done')
  return weechat.WEECHAT_RC_OK
  
def buffer_close_cb(data, buffer):
  weechat.unhook_all()
  return weechat.WEECHAT_RC_OK

if __name__ == "__main__":
  weechat.register(SCRIPT_NAME , "wxg4dev", "1.2.1", "GPL3", "Weechat feed client", "", "")
  
  buf = weechat.buffer_new("feed", "buffer_input_cb", "", "buffer_close_cb", "")
  setup_buffer(buf)

  
