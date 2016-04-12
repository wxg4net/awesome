import weechat as weechat

def handle_autojointwitter(data, buf, date, tags, displayed, highlight, prefix, message):
    buf_name = weechat.buffer_get_string(buf, "short_name")
    if buf_name == '&bitlbee':
        weechat.command(buf, "/msg * identify wxg4ircwxg4irc")
    return weechat.WEECHAT_RC_OK
if __name__ == "__main__":
    weechat.register('autojointwitter', "wxg", '1.0', 'gpl', "A little script for weechat", "", "")
    hook = weechat.hook_print("", "", "identify", 1, "handle_autojointwitter", "")
