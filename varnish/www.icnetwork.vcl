## $Id: www.icnetwork.vcl 62448 2010-09-15 13:28:17Z teropikala $
## $URL: http://10.134.130.125/svn/CodeDB/trunk/config/varnish/www.icnetwork.vcl $
## varnish regionals www configs


### define backends:

# www.icnetwork.co.uk VIP cluster
# we need two for error 500 vcl restarts

backend b1 {
    .host = "172.27.11.102";
    .port = "80";
}
backend b2 {
    .host = "172.27.11.102";
    .port = "80"; 
}

#backend yahoo {
#    .host = "172.27.11.85";
#    .port = "80";
#}

acl purge {
     "localhost";
     "172.27.14.0"/24;
}


### Called when a client request is received
# pipe = just a pipe through varnish. No checks whatsoever
# pass = Go through all checks -> everything, just dont lookup in the cache

sub vcl_recv {
 
# Add a unique header containing the client address
remove req.http.X-Forwarded-For;
set    req.http.X-Forwarded-For = req.http.rlnclientipaddr;

# grace settings, note this is also set in vcl_fetch,
set req.grace = 600s; 

### mobile redirects site:

if ( req.http.host ~ "^org\.www.*$" ) {
	set req.http.newhost = regsub(req.http.host, "(org)?\.(www)?\.(.*)", "\2.\3");
	remove req.http.host;
	set req.http.host = req.http.newhost;
}


if ( req.http.user-agent ~ "(.*Blackberry.*|.*BlackBerry.*|.*Blazer.*|.*Ericsson.*|.*htc.*|.*Huawei.*|.*iPhone.*|.*iPod.*|.*MobilePhone.*|.*Motorola.*|.*nokia.*|.*Novarra.*|.*O2.*|.*Palm.*|.*Samsung.*|.*Sanyo.*|.*Smartphone.*|.*SonyEricsson.*|.*Symbian.*|.*Toshiba.*|.*Treo.*|.*vodafone.*|.*Xda.*|^Alcatel.*|^Amoi.*|^ASUS.*|^Audiovox.*|^AU-MIC.*|^BenQ.*|^Bird.*|^CDM.*|^DoCoMo.*|^dopod.*|^Fly.*|^Haier.*|^HP.*iPAQ.*|^i-mobile.*|^KDDI.*|^KONKA.*|^KWC.*|^Lenovo.*|^LG.*|^NEWGEN.*|^Panasonic.*|^PANTECH.*|^PG.*|^Philips.*|^portalmmm.*|^PPC.*|^PT.*|^Qtek.*|^Sagem.*|^SCH.*|^SEC.*|^Sendo.*|^SGH.*|^Sharp.*|^SIE.*|^SoftBank.*|^SPH.*|^UTS.*|^Vertu.*|.*Opera.Mobi.*|.*Windows.CE.*|^ZTE.*)"

	&& req.http.host ~ "(www.birminghampost.net|www.journallive.co.uk|www.gazettelive.co.uk|www.chroniclelive.co.uk|www.liverpooldailypost.co.uk|www.examiner.co.uk|www.dailypost.co.uk|www.liverpoolecho.co.uk|www.walesonline.co.uk|www.dailyrecord.co.uk|www.coventrytelegraph.net|www.birminghammail.net|org.www.walesonline.co.uk)"

	&& req.url == "/") {

	set req.http.newhost = regsub(req.http.host, "(www)?\.(.*)", "http://m.\2");
   	error 750 req.http.newhost;
}

### restart logic, this will restart the vcl if the backend returns an error - check vcl_fetch...
                if (req.restarts == 0) {
                        set req.backend = b1;
		} else if (req.restarts == 1) {
                        set req.backend = b2;
                } else if (req.restarts == 2) {
			set req.backend = b1;
                } else {
                        set req.backend = b1;
                }

	if ( req.http.user-agent ~ "(.*slurp.*|.*yahoo.*)" ) {
		error 745 "OK";
	}






### do not cache these files:
	
	if (req.request == "GET" && req.url ~ "\.(cfm)") {
                pass;
        }

### always cache these items:

  
     if (req.request == "GET" && req.url ~ "\.(js)") {
                lookup;
        }
    
	## images
        if (req.request == "GET" && req.url ~ "\.(gif|jpg|jpeg|bmp|png|tiff|tif|ico|img|tga|wmf)$") {
        lookup;
        }
	
	## various other content pages	
	if (req.request == "GET" && req.url ~ "\.(css|html)$") {	
        lookup;
        }		

   	## multimedia 
    	if (req.request == "GET" && req.url ~ "\.(svg|swf|ico|mp3|mp4|m4a|ogg|mov|avi|wmv)$") {
        lookup;
        }	

	## xml

        if (req.request == "GET" && req.url ~ "\.(xml)$") {
        lookup;
        }

### do not cache these rules:

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

### don't cache authenticated sessions
        if (req.http.Cookie && req.http.Cookie ~ "authtoken=") {
                pipe;
        }
### Varnish doesn't do INM requests so pass it through if no If-Modified-Since was sent
        if (req.http.If-None-Match && !req.http.If-Modified-Since) {
                pass;
        }
        if (req.http.Authenticate) {
		pass;
	}       
     
### if there is a purge make sure its coming from $localhost

	if (req.request == "PURGE") {
	    if (!client.ip ~ purge) {
                error 405 "Not allowed.";
                }
                lookup;
        }

### parse accept encoding rulesets to make it look nice, ***might not actually be needed***
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

### if it passes all these tests, do a lookup anyway;
        lookup;

### end of vcl_recv
}









### when the mobile feeds reach here, we just "error" it and it dishes out the 302
sub vcl_error {
    if (obj.status == 750) {
        set obj.http.Location = obj.response;
     	set obj.status = 302;
        deliver;
	}

	if (obj.status == 745) {
	set obj.status = 200;
	deliver;	
	}	


set obj.http.Content-Type = "text/html; charset=utf-8";
      synthetic {"
        <?xml version="1.0" encoding="utf-8"?>
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
         <html>
         <head>
         <title>"} obj.status " " obj.response {"</title>
         </head>
         <body>
<h1>Sorry we are experiencing technical difficulties.</h1>
<p class='sansserif'>"} req.http.host {" is temporarily unavailable.</p>

<p class='serif'>Go to the <a href='"} req.http.host {"'>"} req.http.host {" </a> homepage. </p>
<p>Browse the <a href='"} req.http.host {"/sitemap/'>"} req.http.host {"</a>  sitemap. </p>
<p>If you have any queries about this error, please email <a href='mailto:support@ichelp.co.uk'>Helpdesk </a> and we'll see what we can do to help you.</p>
         </body>
         </html>
         "};
deliver;





}


### Called when an object is in the cache, its a hit.
sub vcl_hit {
  if (req.request == "PURGE") {
      set obj.ttl = 0s;
      error 200 "Purged.";
  }
  if (!obj.cacheable) {
      pass;
  }

deliver;
}


### Called when the requested object was not found in the cache

sub vcl_miss {
  if (req.request == "PURGE") {
                 error 404 "Not in cache.";
  }
}


### Called when the requested object has been retrieved from the backend, or the request to the backend has failed

sub vcl_fetch {  

 ## If the request to the backend returns a code other than 200, restart the loop
 ## If the number of restarts reaches the value of the parameter max_restarts,
 ## the request will be error'ed.  max_restarts defaults to 4.  This prevents
 ## an eternal loop in the event that, e.g., the object does not exist at all.
 ## this rule also allows for 301's and 302's redirects... 	
	
	#for http status code 5xx  serve the page after a single restart	 
	if (obj.status >= 500 && req.restarts > 0) {
		set obj.ttl = 30s;		 
		pass;
	}
	
	if (obj.status != 200 && obj.status != 403 && obj.status != 404 && obj.status != 301 && obj.status != 302 && obj.status != 401) {
           restart;
        }

	# if i cant connect to the backend, ill set the grace period to be 600 seconds to hold onto content
        set obj.ttl = 600s;
	set obj.grace = 600s; 

        if (obj.status == 404) { 
        set obj.ttl = 0s; 
        }
        
        if (req.request == "GET" && req.url ~ "\.(gif|jpg|jpeg|bmp|png|tiff|tif|ico|img|tga|wmf)$") {
        set obj.ttl = 600s;     
        }

        ## various other content pages
        if (req.request == "GET" && req.url ~ "\.(css|html)$") {
        set obj.ttl = 600s;
        }
	
        if (req.request == "GET" && req.url ~ "\.(js)$") {
        set obj.ttl = 600s;
        }

	## xml
        if (req.request == "GET" && req.url ~ "\.(xml)$") {
        set obj.ttl = 600s;
        }

        ## multimedia
        if (req.request == "GET" && req.url ~ "\.(svg|swf|ico|mp3|mp4|m4a|ogg|mov|avi|wmv)$") {
        set obj.ttl = 600s;
        }

        if (!obj.cacheable) {
        set obj.http.X-Cacheable = "NO:Not-Cacheable"; 
        pass;
        }
   
        if (obj.http.Set-Cookie) {
        pass;
        }   

	if (req.request == "HEAD") {
		set obj.http.head = "yes";
	}	


	if (req.http.host ~ "(www.birminghampost.net|www.journallive.co.uk|www.gazettelive.co.uk|www.chroniclelive.co.uk|www.liverpooldailypost.co.uk|www.examiner.co.uk|www.dailypost.co.uk|www.liverpoolecho.co.uk|www.walesonline.co.uk|www.dailyrecord.co.uk|www.coventrytelegraph.net|www.birminghammail.net|org.www.walesonline.co.uk)"
	&& req.url == "/") {
	
	remove req.http.Cache-Control;
        set obj.http.Cache-Control = "private, must-revalidate";
	remove obj.http.Vary;
	set obj.http.Vary = "Accept-Encoding, User-agent";
        }


	

        set obj.http.X-Cacheable = "YES";
        deliver;
}

#
#
## Called before a cached object is delivered to the client
#
sub vcl_deliver {

  set resp.http.X-Served-By = server.hostname;
  if (obj.hits > 0) {
    set resp.http.X-Cache = "HIT";	
    set resp.http.X-Cache-Hits = obj.hits;
  } else {
    set resp.http.X-Cache = "MISS";	
  }

#  set resp.http.Cache-Control = "private, s-maxage=0, max-age=0, must-revalidate";
#  set resp.http.Expires = "Thu, 01 Jan 1970 00:00:00 GMT";
#  if(!resp.http.Vary) {
#   set resp.http.Vary = "Accept-Encoding,Cookie";
#  }

  deliver;
}

