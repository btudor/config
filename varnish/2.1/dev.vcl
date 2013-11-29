# Varnish Config

# default backend config
backend default {
	.host = "127.0.0.1";
	.port = "2280";
}


// Called at the beginning of a request, after the complete request has been received and parsed. 
// Its purpose is to decide whether or not to serve the request, how to do it, and, 
// if applicable, which backend to use.

sub vcl_recv {

	// cache multimedia
	if (req.request == "GET" && req.url ~ "\.(jpg|jpeg|gif|ico)$") {
		return(lookup);
	}

	// cache CSS and JS files
	if (req.request == "GET" && req.url ~ "\.(css|js)$") {
		return(lookup);
	}

	// cache static files
	if (req.request == "GET" && req.url ~ "\.(pdf|xls|vsd|doc|ppt|iso)$") {
		return(lookup);
	}

	// do NOT cache POST requests
	if (req.request == "POST") {
		return(pipe);
	}

	// We would only cache GET/HEAD requests
	if (req.request != "GET" && req.request != "HEAD") {
		return(pipe);
	}

	// If the request has a "Expect:" HTTP header it must be passed on to httpd itself
	if (req.http.Expect) {
		return(pipe);
	}

	// If the request has a "If-None-Match" HTTP header it must be passed on to httpd itself
	if (req.http.If-None-Match) {
		return(pass);
	}
	
	// pass to backend if we have HTTP authentication
	if (req.http.Authenticate || req.http.Authorization) {
		return(pass);
	}

	// Do a "lookup" in the cache.  This goes to "vcl_hit", or to "vcl_miss" and then "vcl_fetch"
	return(lookup);

}

// Called after a cache lookup if the requested document was found in the cache.
sub vcl_hit {
	// Nothing is cached with this config (we are only doing ESI processing)
	set obj.ttl = 0s; 
}

// Called after a cache lookup if the requested document was not found in the cache. 
sub vcl_miss {
	if (req.http.If-Modified-Since) {
		return(pass);
	}
}

// Called after a document has been successfully retrieved from the backend.
sub vcl_fetch {
	// do ESI processing only for HTML files
	if (req.http.Content-Type ~ "html") {
		esi;
	}

}
