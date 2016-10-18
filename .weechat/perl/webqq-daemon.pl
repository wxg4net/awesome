
use Mojo::Webqq;
use IO::Socket::UNIX;

my $webqq_num = shift @ARGV;
my $webqq_irc = shift @ARGV;;

my $sock_fullpath =  sprintf '/tmp/webqq-%d.sock', $webqq_irc;
my $socket = IO::Socket::UNIX->new(
        Type => SOCK_STREAM(),
        Peer => $sock_fullpath,
    );

my $client=Mojo::Webqq->new(
    ua_debug    =>  0,         #是否打印详细的debug信息
    log_level   => "info",     #日志打印级别
    qq          =>  $webqq_num,#登录的qq帐号
    cookie_dir  =>  '/tmp/',
    keep_cookie =>  1,
    login_type  =>  "qrlogin", #"qrlogin"表示二维码登录
);

$client->log->handle($socket);
$client->load("IRCShell", data=>{
        listen=>[ {host=>"127.0.0.1",port=>$webqq_irc} ], 
        load_friend=>1, 
        master_irc_user=>$webqq_num}
    );
    
$client->on(input_qrcode=>sub{
    my($client,$filepath)=@_;
    $client->log->info("file://".$filepath);
});


$client->run();
