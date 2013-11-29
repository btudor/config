#age for details on VCL syntax and semantics.
#
# $Id: ttl300.www.icnetwork.vcl 48722 2009-04-07 11:29:06Z jknowlin $
# $URL: http://10.134.130.125/svn/CodeDB/trunk/config/varnish/ttl300.www.icnetwork.vcl $
#

# Default backend definition.  Set this to point to your content
# server.

#www.icnetwork.co.uk
backend b1 {
    .host = "172.27.11.102";
    .port = "80";
}

#images.icnetwork.co.uk
#backend b1 {
#    .host = "172.27.11.103";
#    .port = "80";
#}

acl purge {
                 "localhost";
                 "172.27.14.0"/24;
         }


## Called when a client request is received
#
#pipe = just a pipe through varnish. No checks whatsoever
#pass = Go through all checks -> everything, just dont lookup in the cache

sub vcl_recv {

# Add a unique header containing the client address

remove req.http.X-Forwarded-For;
set    req.http.X-Forwarded-For = req.http.rlnclientipaddr;

############### mobile sites:

if ( req.http.user-agent ~ "(^SonyEricsson.*|^Nokia.*|^MOT.*|^Motorola.*|^SEC.*|^BenQ.*|^BlackBerry.*|^HTC.*|^LG.*|.*Novarra-Vision.*|.*Symbian.*|^SAGEM.*|^SAMSUNG.*|^SEC.*|^SIE.*|^Samsung.*|^Vodafone.*|^portalmmm.*|.*iPod.*|.*iPhone.*)"

#	&& req.http.host ~ "(www.journallive.co.uk|www.liverpoolecho.co.uk|www.liverpooldailypost.co.uk|www.birminghampost.net)"
#	&& req.http.host ~ "(www.journallive.co.uk|www.liverpoolecho.co.uk|www.liverpooldailypost.co.uk|www.birminghampost.net)"
#&& req.http.host ~ "(www.birminghampost.net|www.journallive.co.uk|www.gazettelive.co.uk|www.chroniclelive.co.uk|www.liverpooldailypost.co.uk|www.examiner.co.uk|www.dailypost.co.uk|www.liverpoolecho.co.uk|www.walesonline.co.uk|www.dailyrecord.co.uk|www.coventrytelegraph.net|www.birminghammail.net)"

&& req.http.host ~ "(www.birminghampost.net|www.liverpooldailypost.co.uk|www.examiner.co.uk|www.dailypost.co.uk|www.liverpoolecho.co.uk|www.walesonline.co.uk|www.dailyrecord.co.uk|www.coventrytelegraph.net|www.birminghammail.net)"
	
	&& req.url == "/") {

	set req.http.newhost = regsub(req.http.host, "(www)?\.(.*)", "http://m.\2");
   	error 750 req.http.newhost;
   }



#### do not cache these files
	
if (req.request == "GET" && req.url ~ "\.(cfm)") {
	pass;
}
if (req.request == "GET" && req.url ~ "/registration/") {
	pass;
}

##### always cache these items:

  
     if (req.request == "GET" && req.url ~ "\.(js)") {
                lookup;
        }
    
	## images
        if (req.request == "GET" && req.url ~ "\.(gif|jpg|jpeg|bmp|png|tiff|tif|ico|img|tga|wmf)$") {
        set req.backend = b1; 
        lookup;
        }
	
	## various other content pages	
	if (req.request == "GET" && req.url ~ "\.(css|html)$") {	
        set req.backend = b1;	           	
        lookup;
        }		

   	## multimedia 
    	if (req.request == "GET" && req.url ~ "\.(svg|swf|ico|mp3|mp4|m4a|ogg|mov|avi|wmv)$") {
        set req.backend = b1;                
        lookup;
        }	

	## xml

        if (req.request == "GET" && req.url ~ "\.(xml)$") {
        set req.backend = b1;
        lookup;
        }

#### do not cache these rules:

        # pass mode can't handle POST (yet)
        if (req.request == "POST") {
                pipe;
        }
 
        if (req.request != "GET" && req.request != "HEAD") {
                pipe;
        }
        if (req.http.Expect) {
                pipe;
        }
        if (req.http.Authenticate || req.http.Authorization) {
                pass;
        }
     

#### if there is a purge make sure its coming from $localhost

if (req.request == "PURGE") {
                 if (!client.ip ~ purge) {
                     error 405 "Not allowed.";
                 }
                 lookup;
             }




#### 

        if (req.http.Accept-Encoding) {
                if (req.http.Accept-Encoding ~ "gzip") {
                        set req.http.Accept-Encoding = "gzip";
                } elsif (req.http.Accept-Encoding ~ "deflate") {
                        set req.http.Accept-Encoding = "deflate";
                } else {
                        # unkown algorithm
                        remove req.http.Accept-Encoding;
                }
        }

####  don't cache authenticated sessions
        if (req.http.Cookie && req.http.Cookie ~ "authtoken=") {
                pipe;
        }
        //  Varnish doesn't do INM requests so pass it through if no If-Modified-Since was sent
        if (req.http.If-None-Match && !req.http.If-Modified-Since) {
                pass;
        }
        if (req.http.Authenticate) {
		pass;
	}       

#### if it passes all these tests, do a lookup anyway;
        lookup;

}

sub vcl_error {
    if (obj.status == 750) {
        set obj.http.Location = obj.response;
     	set obj.status = 302;
        deliver;
	}
}




#
## Called when entering pipe mode
#
#sub vcl_pipe {
#        pipe;
#}
#
## Called when entering pass mode
#
#sub vcl_pass {
#pass;
#}
#
## Called when entering an object into the cache
#
#sub vcl_hash {
#        set req.hash += req.url;
#        hash;
#}
#
## Called when the requested object was found in the cache
#

sub vcl_hit {

#  if (obj.http.X-Cache == "MISS") {
#                set obj.http.X-Cache = "HIT";
#        }

  if (req.request == "PURGE") {
                 set obj.ttl = 0s;
                 error 200 "Purged.";
             }


  if (!obj.cacheable) {
                pass;
        }

        deliver;
}
#
## Called when the requested object was not found in the cache
#
sub vcl_miss {
  if (req.request == "PURGE") {
                 error 404 "Not in cache.";
             }

}

#
## Called when the requested object has been retrieved from the
## backend, or the request to the backend has failed
#
sub vcl_fetch {  

        if (obj.status == 404) { 
        set obj.ttl = 0s; 
	deliver;
        }
   
        if (req.request == "GET" && req.url ~ "\.(gif|jpg|jpeg|bmp|png|tiff|tif|ico|img|tga|wmf)$") {
           set obj.ttl = 600s;     
	deliver;
        }

        ## various other content pages
        if (req.request == "GET" && req.url ~ "\.(css|html)$") {
           set obj.ttl = 300s;
	deliver;
        }
	
       if (req.request == "GET" && req.url ~ "\.(js)$") {
           set obj.ttl = 120s;
        deliver;
        }


	## xml
        if (req.request == "GET" && req.url ~ "\.(xml)$") {
           set obj.ttl = 300s;
        deliver;
        }

        ## multimedia
        if (req.request == "GET" && req.url ~ "\.(svg|swf|ico|mp3|mp4|m4a|ogg|mov|avi|wmv)$") {
            set obj.ttl = 300s;
	deliver;
        }

        if (!obj.cacheable) {
        set obj.http.X-Cacheable = "NO:Not-Cacheable"; 
        pass;
        }
   
        if (obj.http.Set-Cookie) {
         pass;
        }   

        set obj.http.X-Cacheable = "YES";
#        set obj.grace = 30s;
	
	set obj.ttl = 300s;
        deliver;
}

#
#
## Called before a cached object is delivered to the client
#
sub vcl_deliver {

  set resp.http.X-Served-By = "varnish-pxy-1";
  if (obj.hits > 0) {
    set resp.http.X-Cache = "HIT";	
    set resp.http.X-Cache-Hits = obj.hits;
  } else {
    set resp.http.X-Cache = "MISS";	
  }

#  set resp.http.Cache-Control = "private, s-maxage=0, max-age=0, must-revalidate";
#  set resp.http.Expires = "Thu, 01 Jan 1970 00:00:00 GMT";
 # if(!resp.http.Vary) {
 #   set resp.http.Vary = "Accept-Encoding,Cookie";
 # }

    deliver;


}

#
## Called when an object nears its expiry time
#
#sub vcl_timeout {
#    fetch;
#}
#
## Called when an object is about to be discarded
#
#sub vcl_discard {
#    discard;
#}
