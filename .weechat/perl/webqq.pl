#!/usr/bin/perl
use IO::Socket::UNIX;
my $sock_path = "/tmp/webqq.sock";
unlink $sock_path if -e $sock_path;

sub buffer_input_cb {
    return weechat::WEECHAT_RC_OK;
}

sub qq_fd_cb {
    my $buffer = shift;
    $client->recv(my $msg, 600);
     if (length($msg) == 0) {
        weechat::buffer_close($buffer);
        weechat::unhook_all();
        return weechat::WEECHAT_RC_OK;
    }
    weechat::print($buffer, $msg);
    return weechat::WEECHAT_RC_OK;
}

weechat::register('webqq', "wxg4dev", '0.1',  "GPL3",  "QQ Console", "", "");

my $buffer = weechat::buffer_new("QQ-console", "buffer_input_cb", "", "buffer_close_cb", "");
my $server = IO::Socket::UNIX->new(
  Local  => $sock_path,
  Type   => SOCK_STREAM,
  Listen => 1,
);

weechat::hook_process("perl /home/wxg/.weechat/perl/webqq-daemon.pl > /dev/null", 0, '', '');

$client = $server->accept();
my $fileno = $client->fileno();
weechat::hook_fd($fileno, 1, 0, 0, "qq_fd_cb", $buffer);
