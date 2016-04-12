# -*- coding: utf-8 -*-
import sys
import ast
import re
import os
import weechat
from twitter import *
import socket  
import socks
socket.setdefaulttimeout(5)
socks.setdefaultproxy(socks.PROXY_TYPE_SOCKS5, "127.0.0.01", 1081)
socket.socket = socks.socksocket

oauth_token = "418331824-Sj74Ou22mkKAN7wwef4eLBfh263ptLEEjFjOcqF8";
oauth_secret = "BOD3r1TyylRAd0ps3m5vganoQEquHWto58wDvq2knWJ5f";
CONSUMER_SECRET = 'ivx3oxxkSOAOofRuhmGXQK4nkLFNXD94wbJiRUBhN1g'
CONSUMER_KEY = 'NVkYe8DAeaw6YRcjw662ZQ'

twitter = None
buf = None
SCRIPT_NAME = 'weett'
script_options = {
    "last_id" : "0",
    "oauth_token" : "",
    "oauth_secret": "",
}

def tweibo_post(buffer, message):
  twitter.statuses.update(status=message)
  weechat.prnt(buffer, "<--\t"+message)

def setup_buffer(buffer):
  # set title
  weechat.buffer_set(buffer, "title", "Twitter buffer")
  # disable logging, by setting local variable "no_log" to "1"
  weechat.buffer_set(buffer, "localvar_set_no_log", "1")
  #show nicklist
  weechat.buffer_set(buffer, "nicklist", "0")
  weechat.buffer_set(buffer, "localvar_set_nick", 'wxg')
  

def buffer_input_cb(data, buffer, input_data):
  if input_data[0] == ':':
    input_args = input_data.split()
    command = input_args[0][1:]
    if True:
      message = []
      max_found = False
      twitter = Twitter(auth=OAuth(
                  oauth_token, oauth_secret, CONSUMER_KEY, CONSUMER_SECRET))
      twitter_data = twitter.statuses.home_timeline()
      index = 0
      for t in twitter_data:
        index += 1
        if (index%2) == 0:
          green = weechat.color('reset')
        else:
          green = weechat.color('lightgreen')
        message.append("%s%s\t%s%s" % (green, t['user']['screen_name'], green, t['text']))
      if message:
        message.reverse()
        message = "\n".join(message)
        weechat.prnt(buffer, message)
    return weechat.WEECHAT_RC_OK
  tweibo_post(buffer, input_data)
  return weechat.WEECHAT_RC_OK

def print_homeline_data(buffer, left_call=None):
  last_id= script_options['last_id']
  message = []
  max_found = False
  try:
    if last_id == '0':
      twitter_data = twitter.statuses.home_timeline()
    else:
      twitter_data = twitter.statuses.home_timeline(since_id=last_id)
  except:
    return weechat.WEECHAT_RC_ERROR 
  for t in twitter_data:
    if not max_found:
      max_found = True
      script_options['last_id'] = str(t['id'])
      weechat.config_set_plugin("last_id", script_options['last_id'])
    message.append("%s\t%s" % (t['user']['screen_name'], t['text']))
      
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
  weechat.register(SCRIPT_NAME , "wxg4dev", "1.2.1", "GPL3", "Weechat Twitter client", "", "")
  
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
  
  buf = weechat.buffer_new("twitter", "buffer_input_cb", "", "buffer_close_cb", "")
  setup_buffer(buf)
  twitter = Twitter(auth=OAuth(
              oauth_token, oauth_secret, CONSUMER_KEY, CONSUMER_SECRET))
# print_homeline_data(buf)
# weechat.hook_timer(60*30*1000, 60, 0, "print_homeline_data", buf)
  
