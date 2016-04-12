use Mojo::Webqq;
use IO::Socket::UNIX;
my $sock_path = "/tmp/webqq.sock";
my $socket = IO::Socket::UNIX->new(
        Type => SOCK_STREAM(),
        Peer => $sock_path,
    );

my $qq = 2289688859;
my $client=Mojo::Webqq->new(
    ua_debug    =>  0,         #是否打印详细的debug信息
    log_level   => "info",     #日志打印级别
    qq          =>  $qq,       #登录的qq帐号
    cookie_dir          =>  '/tmp/',
    keep_cookie          =>  1,
    login_type  =>  "qrlogin", #"qrlogin"表示二维码登录
);
$client->log->handle($socket);

$client->load("IRCShell",data=>{host=>"127.0.0.1",port=>6667,});

$client->on(input_qrcode=>sub{
    my($client,$filepath)=@_;
    $client->log->info("file://".$filepath);
});

$client->login();

#客户端开始运行
$client->run();
