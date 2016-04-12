# Copyright (c) 2013 Bit Shift <bitshift@bigmacintosh.net>
# Licensed under the MIT license:
# http://www.opensource.org/licenses/mit-license.php
import weechat

weechat.register(
        "weecat",
        "Bit Shift <bitshift@bigmacintosh.net>",
        "0.1.0",
        "MIT",
        "read a file into a buffer",
        "",
        "UTF-8"
        )


weecat_buffers = set()
files_by_buffer = {}
listen_hooks = {}


def weecat_input_cb(data, buffer, input_data):
    return weechat.WEECHAT_RC_OK


def weecat_close_cb(data, buffer):
    global weecat_buffers, listen_hooks, files_by_buffer

    weecat_buffers.remove(buffer)
    if files_by_buffer[buffer].name in listen_hooks:
        weechat.unhook(listen_hooks[files_by_buffer[buffer].name])
        del listen_hooks[files_by_buffer[buffer].name]
    files_by_buffer[buffer].close()
    del files_by_buffer[buffer]

    return weechat.WEECHAT_RC_OK


def weecat_command_cb(data, buffer, args):
    global weecat_buffers, cmds_by_buffer, listen_hooks

    try:
        this_file = open(args)
    except IOError as e:
        weechat.prnt("", weechat.prefix("error") + "weecat: " + e.strerror)
        return weechat.WEECHAT_RC_ERROR

    filename = this_file.name

    if not args in listen_hooks:
        new_buffer = weechat.buffer_new(
                "wc: " + filename,
                "weecat_input_cb", "",
                "weecat_close_cb", ""
                )

        weechat.buffer_set(new_buffer, "title",
                "weecat: " + filename)

        weechat.hook_signal_send("logger_backlog",
                weechat.WEECHAT_HOOK_SIGNAL_POINTER, new_buffer)

        listen_hooks[filename] = weechat.hook_fd(this_file.fileno(), 1, 0, 0, "weecat_update_cb", new_buffer)

        weechat.buffer_set(new_buffer, "display", "1") # switch to it

        weecat_buffers.add(new_buffer)
        files_by_buffer[new_buffer] = this_file

    return weechat.WEECHAT_RC_OK


def weecat_update_cb(buffer, fd):
    this_file = files_by_buffer[buffer]

    try:
        for line in this_file.read().splitlines():
            weechat.prnt(buffer, line)
    except IOError as e:
        weechat.prnt(buffer, weechat.prefix("error") + "weecat: File closed unexpectedly: " + e.strerror)
        return weechat.WEECHAT_RC_ERROR

    return weechat.WEECHAT_RC_OK


def init_script():
    weechat.hook_command(
        "weecat",
        "open a new buffer reading a given file",
        "",
        "",
        "",
        "weecat_command_cb", ""
        )


init_script()
