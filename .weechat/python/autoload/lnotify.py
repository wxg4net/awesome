#  Project: lnotify2
#  Description: forked from lnotify. A libnotify script for weechat. Uses
#  dbus org.freedesktop.Notifications:Notify
#  Author: wxg4dev <wxg4dev@gmail.com>
#  License: GPL3
#
# Note: If you want pynotify, refer to the 'notify.py' weechat script
import weechat as weechat
import dbus

lnotify_name = "lnotify"
lnotify_version = "0.2.1"
lnotify_license = "GPL3"

# convenient table checking for bools
true = { "on": True, "off": False }

# declare this here, will be global config() object
# but is initialized in __main__
cfg = None

sessionBus = dbus.SessionBus()
awesomeObject = sessionBus.get_object('org.freedesktop.Notifications', '/')
awesomeNotify = awesomeObject.get_dbus_method('Notify', 'org.freedesktop.Notifications')

class config(object):
    def __init__(self):
        # default options for lnotify
        self.opts = {
            "highlight": "on",
            "query": "on",
            "notify_away": "off",
            "icon": "/usr/share/icons/hicolor/32x32/apps/weechat.png",
            "timeout": '5000',
            "public": 'on',
            "ignore": 'wxg4irc wxg4net wph xg wxg wxg4ph weechat',
            "instance": '2',
        }

        self.init_config()
        self.check_config()

    def init_config(self):
        for opt, value in self.opts.items():
            temp = weechat.config_get_plugin(opt)
            if not len(temp):
                weechat.config_set_plugin(opt, value)

    def check_config(self):
        for opt in self.opts:
            self.opts[opt] = weechat.config_get_plugin(opt)

    def __getitem__(self, key):
        return self.opts[key]

def printc(msg):
    weechat.prnt("", msg)

def handle_msg(data, pbuffer, date, tags, displayed, highlight, prefix, message):
    highlight = bool(highlight) and cfg["highlight"]
    query = true[cfg["query"]]
    notify_away = true[cfg["notify_away"]]
    public = true[cfg["public"]]
    buffer_type = weechat.buffer_get_string(pbuffer, "localvar_type")
    away = weechat.buffer_get_string(pbuffer, "localvar_away")
    
    prefix_join = weechat.config_string(weechat.config_get("weechat.look.prefix_join"))
    prefix_network = weechat.config_string(weechat.config_get("weechat.look.prefix_network"))
    prefix_quit = weechat.config_string(weechat.config_get("weechat.look.prefix_quit"))
    
    if away and not notify_away:
        return weechat.WEECHAT_RC_OK

    
    
    ignore = cfg["ignore"].split(' ')
    if prefix in ignore:
        return weechat.WEECHAT_RC_OK
        
    buffer_name = weechat.buffer_get_string(pbuffer, "short_name")
    
    if buffer_type == "private" and query:
        notify_user(buffer_name, message)
    elif buffer_type == "channel" and highlight:
        notify_user("{} @ {}".format(prefix, buffer_name), message)
    elif public and prefix != prefix_quit and prefix != prefix_join and prefix != prefix_network:
        notify_user("{} @ {}".format(prefix, buffer_name), message)

    return weechat.WEECHAT_RC_OK

def notify_user(origin, message):
    awesomeNotify("weechat", dbus.UInt32(cfg['instance']), cfg['icon'], origin, message, [], {}, dbus.UInt32(cfg['timeout']))
    return weechat.WEECHAT_RC_OK

# execute initializations in order
if __name__ == "__main__":
    weechat.register(lnotify_name, "wxg", lnotify_version, lnotify_license,
        "{} - A libnotify script for weechat".format(lnotify_name), "", "")

    cfg = config()
    print_hook = weechat.hook_print("", "", "", 1, "handle_msg", "")

