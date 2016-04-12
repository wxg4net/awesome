#!/usr/bin/perl
#	
#	Download all the images!!!
#		https://github.com/T00mm
require LWP::UserAgent;
my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;
@imageurl = ();
weechat::register("image_collector", "Tom", "1.0", "GPL3", "Collect all the images and put them in a folder!", "", "");
weechat::hook_print(NULL, "", "://", 1, "isimage", "");
weechat::print(NULL, "[ImageC] Image grabber, gogogogo");
sub isimage {	
	my ( $data, $buffer, $date, $tags, $displayed, $highlight, $prefix, $message ) = @_;
	%uris = ();
	if($message =~ /(http|https|file):\/\/(.*)(jpg|png|jpeg|gif)/i)
	{
		$url = "$1://$2$3";
		if ( grep $_ eq $url, @imageurl ) {
			$url = "";
		}		
    if ($url =~ /(gif|png|jpg|jpeg)/i) 
    {	
      $filename = "$date.$1";
      $buffern = weechat::buffer_get_string($buffer,"name");
      weechat::hook_process("/usr/bin/feh --image-bg white --geometry 1440x450 $url", 120 * 1000, "", "")
    }
		
	}
	return weechat::WEECHAT_RC_OK;
}
