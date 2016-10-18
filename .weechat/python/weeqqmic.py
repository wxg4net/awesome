#! /usr/bin/env python
# -*- coding:utf-8 -*- #

import sys,re,os,time
import weechat
from tweibo import *

APP_KEY = "801068466"
APP_SECRET = "2ca7cb35d44d9de896ad0a07cabe47b7"
CALLBACK_URL = "http://127.0.0.1:8090/do/"
ACCESS_TOKEN = "5b70a1a531f0f6ff80a39f54a97868bb"
OPENID = "7414551EF0BDB5C42C2BC03B1E54E88E"



api = None
buf = None
SCRIPT_NAME = 'weeqqmic'
script_options = {
    "last_id" : "0",
    "OPENID" : "",
    "ACCESS_TOKEN" : "",
}

#获取access_token openid 参数
def access_token_test():
  oauth = OAuth2Handler()
  oauth.set_app_key_secret(APP_KEY, APP_SECRET, CALLBACK_URL)
  return oauth.get_access_token_url()
    
def tweibo_init():
  oauth = OAuth2Handler()
  oauth.set_app_key_secret(APP_KEY, APP_SECRET, CALLBACK_URL)
  oauth.set_access_token(ACCESS_TOKEN)
  oauth.set_openid(OPENID)
  api = API(oauth)
  return api
  
def tweibo_post(buffer, message):
  try:
    tweet2 = api.post.t__add(format="json", content=message, clientip="127.0.0.1")
    msg = ">> time=%s, http://t.qq.com/p/t/%s" % (tweet2.data.time, tweet2.data.id)
    weechat.prnt(buffer, "<--\t"+message)
    weechat.prnt(buffer, "-->\t"+msg)
  except:
    _url = access_token_test()
    weechat.prnt(buffer, "<--\t"+_url)

def setup_buffer(buffer):
  # set title
  weechat.buffer_set(buffer, "title", "QQmicblog buffer")
  # disable logging, by setting local variable "no_log" to "1"
  weechat.buffer_set(buffer, "localvar_set_no_log", "1")
  #show nicklist
  weechat.buffer_set(buffer, "nicklist", "0")
  weechat.buffer_set(buffer, "localvar_set_nick", 'wxg')
  

def buffer_input_cb(data, buffer, input_data):
  global api
  if input_data[0] == ':':
    input_args = input_data.split()
    command = input_args[0][1:]
    if True:
      user_timeline = api.get.statuses__mentions_timeline(format="json", name="qqfarm", reqnum=5, pageflag=0, lastid=0, pagetime=0, type=0, contenttype=0)
      message = []
      for idx, tweet in enumerate(user_timeline.data.info):
        message.append("%s\t(%s) %s" % (tweet.name, tweet.nick, tweet.text))
      message.reverse()
      message = "\n".join(message).encode("utf-8")
      weechat.prnt(buffer, message)

    return weechat.WEECHAT_RC_OK
  tweibo_post(buffer, input_data)
  return weechat.WEECHAT_RC_OK

def print_aboutme_data(buffer, left_call=None):
  global api
  last_id= script_options['last_id']
  user_timeline = api.get.statuses__mentions_timeline(format="json", name="qqfarm", reqnum=5, pageflag=0, lastid=0, pagetime=0, type=0, contenttype=0)
  message = []
  max_found = False
  for idx, tweet in enumerate(user_timeline.data.info):
    if tweet.id > last_id:
      if not max_found:
        max_found = True
        script_options['last_id'] = tweet.id
        weechat.config_set_plugin("last_id", tweet.id)
      message.append("%s\t(%s) %s" % (tweet.name, tweet.nick, tweet.text))
      
  if message:
    message.reverse()
    message = "\n".join(message).encode("utf-8")
    weechat.prnt(buffer, message)

  return weechat.WEECHAT_RC_OK
  
  
def buffer_close_cb(data, buffer):
  weechat.unhook_all()
  return weechat.WEECHAT_RC_OK
    
def read_config():
  for item in script_options:
      script_options[item] = weechat.config_string(weechat.config_get("plugins.var.python."+SCRIPT_NAME+"." + item))

def config_cb(data, option, value):
    """Callback called when a script option is changed."""
    # for example, read all script options to script variables...
    # ...
    read_config()
    return weechat.WEECHAT_RC_OK
    
if __name__ == "__main__":
  weechat.register(SCRIPT_NAME , "wxg4dev", "1.2.1", "GPL3", "Weechat QQ client", "", "")
  
  for option, default_value in script_options.items():
    if not weechat.config_is_set_plugin(option):
      if isinstance(default_value,bool):
        if default_value:
          default_value = "on"
        else:
          default_value = "off"
      weechat.config_set_plugin(option, default_value) 

  read_config()
  weechat.hook_config("plugins.var.python." + SCRIPT_NAME + ".*", "config_cb", "")
  
  buf = weechat.buffer_new("腾讯微博", "buffer_input_cb", "", "buffer_close_cb", "")
  setup_buffer(buf)
  api = tweibo_init()
  print_aboutme_data(buf)
  weechat.hook_timer(60*30*1000, 60, 0, "print_aboutme_data", buf)
  
