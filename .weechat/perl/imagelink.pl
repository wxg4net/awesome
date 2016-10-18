
weechat::register("image_collector", "wxg4dev", "0.01", "GPL3", "Collect all the images and show them with feh!", "", "");
weechat::hook_print(NULL, "", "://", 1, "isimage", "");
weechat::print(NULL, "[ImageC] Image Shower, gogogogo");
sub isimage {	
    my ( $data, $buffer, $date, $tags, $displayed, $highlight, $prefix, $message ) = @_;
    %uris = ();
    if($message =~ /(http|https|file):\/\/(.*)(jpg|png|jpeg|gif)/i)
    {
      $url = "$1://$2$3";
      if ($url =~ /(gif|png|jpg|jpeg)/i and not $url =~ /qbox.me/i) 
      {	
	$filename = "$date.$1";
	$buffern = weechat::buffer_get_string($buffer,"name");
	weechat::hook_process("/usr/bin/feh --image-bg white --geometry 1440x450 $url", 120 * 1000, "", "")
      }
    }
    return weechat::WEECHAT_RC_OK;
}
