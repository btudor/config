<!---
	$Id: $
	$URL: $
	THIS IS NOT A VERSIONED FILE!
	Name:			system.cfm
  	Description:	Called by fws_SystemParser.cfm
					Sets Server & Application variables
--->


<!--- System configuration file --->

<cfscript>
// set the platform environment type variable
variables.platformEnv = 'dmcms';

if( attributes.scope eq "global" ) {

	//url of icnetwork page
	SERVER.CMS.icnetwork_url = "/icnetwork";
	SERVER.cms.jobsite_template = 'jobstemplate';
	SERVER.cms.datahub_shared_link = 'PCMS';
	SERVER.cms.proccachedir = "/src/webroot/cachedprocs";
	SERVER.cms.cacheprocs = 1;
	SERVER.cms.s_cfuser = "apache";
	
	// START OF SETTING GLOBAL SERVER VARIABLES
	SERVER.cms.intranet_home_url_link="/intranet/home";
	SERVER.cms.manage_messages = "/cms/manage_objects/messageboard/message_edit.cfm?type=0&object_id=";
	//For ads to show - set this env_type to "production": To hide them, set to "development".
	SERVER.cms.env_type = "production";	
	SERVER.cms.S_SERVER_TYPE = "cms";
        SERVER.cms.serverID = 1012;
	SERVER.cms.SHARED_DATASOURCE = "shared";
	
	SERVER.cms.NETWORK_IDJ = 5293;
	SERVER.cms.S_WEBROOT = "/cms";
	SERVER.cms.S_METHOD_DIR = "/methods";
	SERVER.cms.S_NETWORKROOT = "/src/webroot";
	SERVER.cms.s_image_fileroot = "/src/webroot/images";
	SERVER.cms.SESSIONLENGTHMINS = 360;	//6 hours
	SERVER.cms.application_release = "v2";
	SERVER.cms.cache_home = "/src/pagecache/";
	SERVER.cms.cache_tmp_dir = "/src/cachetmp/";
	SERVER.cms.s_mailserver = "lnproduction1cw";
	SERVER.cms.s_mailport = 25;
	SERVER.cms.s_faxdomain = "faxramp.com";
	SERVER.cms.s_vicinity_database = "ATRIUM";
	SERVER.cms.s_vicinity_url = "www.vicinity.com";
	SERVER.cms.s_log_file = "/log/portal_log";
	SERVER.cms.datahub_datasource="cfapp";//datahub datasource
	SERVER.cms.apglogdir = "/src/webroot/cms/apg/apglogs";
	SERVER.cms.apgconfigdir = "/src/webroot/cms/apg/config";
	SERVER.cms.apgimagedir = "/src/webroot/cms/apg/images";
	SERVER.cms.apgcssdir = "/src/webroot/cms/apg/stylesheets";
	SERVER.cms.apgmode = "750";
	SERVER.cms.apgimagemode = "640";
	SERVER.cms.icregion_db_schema = "icregion";
	SERVER.cms.intranet_datasource="intranet";
	SERVER.cms.intranet_home_url="/intranet";
	SERVER.cms.intranet_root="/src/webroot/intranet";
	SERVER.cms.public_imageserver = "/images";
	SERVER.cms.intranet_domain = ".tm-gnet.com";
	SERVER.cms.ldap_ipaddress = "10.134.6.32";
	SERVER.cms.widgetdeffiledir = "/src/webroot/images/widget_files";
	SERVER.cms.widgetuplfiledir = "/src/webroot/cms/manage_objects/widget/widget_file_uploads";
	SERVER.cms.widgetfilemode = "640";
	SERVER.cms.notes1_ipaddress = "10.134.9.130";

	//tile ad server setting
	SERVER.cms.tile_ad = StructNew();
	SERVER.cms.tile_ad.image_page="/images/upl";

	// SERVER.cms.s_error_handler_root = "/src/webroot/errors";

	//caching settings - IGNORED FOR CMS box
	SERVER.cms.st_cache = structNew();
        //number of sub-directories in each pagecfms4xxx cache directory
        SERVER.cms.st_cache.num_pagecfms_subdirs = 20;

        //Time span for which cache files are valid - (days,hours,minutes,seconds)
        SERVER.cms.st_cache.tempfile_expire = CreateTimeSpan(7,0,0,0);

        //do cache logging
        SERVER.cms.st_cache.b_log = 1;

        //cache flush method - 'contact' or 'direct'
        SERVER.cms.st_cache.flush_method = "contact";
        //location of file that contains list of pages that have caused errors
        SERVER.cms.s_error_file = "/src/webroot/cfcache_files/errorstatus";

	// SERVER.cms.st_cache.timeout_mins = 5;
	SERVER.cms.st_cache.b_use_caching = false;
	SERVER.cms.st_cache.cachedirectory = "/src/webroot/cfcache_files";
	SERVER.cms.st_cache.browser_timeout = 5; // minutes for browser to cache a page
	SERVER.cms.st_cache.b_debug =false;

	// initialise structure for storing pages to be re-cached
	SERVER.cms.st_reCachePages = structNew();

	SERVER.cms.st_cache.file2StoreCacheStatus = "/src/webroot/cfcache_files/cachestatus";
	SERVER.cms.st_cache.d_first_request = now();
	//initialize structure for sites that have been checked for re-cache
	SERVER.cms.st_cache.st_done_sites = structNew();

	//auto publishing setting
	SERVER.cms.n_autopub_userid = 11000600;


        //variable state settings - for loading of server & application vars
        SERVER.cms.variable_state_dir = "/src/webroot/variable_state"; //variable state directory

        SERVER.objcachedir = "/var/cache/objcache";
        SERVER.cacheobjects = 1;
        SERVER.cms.querycachedir = "/src/webroot/cachedqueries";
        SERVER.cms.cachequeries = 1;
        SERVER.cms.useMemcachedQuery = true;
        SERVER.cms.useMemcachedObject = false; //true;
        SERVER.cms.useMemcachedPage = true;
        SERVER.cms.querydefaultblockfactor = 1;
	SERVER.cms.icregion_db_schema = "icregion";

	// for document uploads
	SERVER.cms.s_document_fileroot = "/src/webroot/images/docs";

	// for classified images
	server.cms.s_classified_imageroot = "/src/webroot/images/classified/gc";

        // switch to allow msp for all, or a select group only
        SERVER.cms.msp = StructNew();
        SERVER.cms.msp.active = 1;
        SERVER.cms.msp.allowed_users = "11002200,11002201,11002202";
	server.cms.icme_domain = ".icnetwork.co.uk";
	server.cms.icme_site = "http://icme.icnetwork.co.uk";

	//CU settings
	SERVER.cms.cu_datasource = "clientupdate";
	SERVER.cms.cu_replication_url = "http://192.168.246.86/replication/cu_replication.cfm";
	SERVER.cms.b_clientupdate_allowed = 1;
	server.cms.resultsetcachedir = "/var/cache/resultset";
	SERVER.cms.username192 = "mgnrollout";
	SERVER.cms.password192 = "test";
	SERVER.cms.icnetworkmapurl = "http://www.icnetwork.co.uk/remote/maps_directions/requestMap.cfm";
	SERVER.cms.s_email_jsvalid = "http://www.icnetwork.co.uk/email_valid.js";
	server.cms.datahub_user_id = 90;
	// serve all of the css from below this URL
	server.css_url = "http://me/images/css/";


	// END OF SETTING GLOBAL SERVER VARIABLES

} else {

	// START OF SETTING GLOBAL APPLICATION VARIABLES
	application.S_IMAGESERVER = "http://me/images";
	application.GRAPHICS_PATH = "/images/design";

	//e-share settings
	application.st_eshare = structNew();
	application.st_eshare.host = "xxx";
	application.st_eshare.portnumber = "xxx";
	application.st_eshare.roomlist_url = "xxx";
	application.st_eshare.login_url = "xxx";
	application.st_eshare.timeout = "xxx";

 	//a&e variable
	application.s_ae_maxvicinityrecords = "50";

	// END OF SETTING GLOBAL APPLICATION VARIABLES

	switch(attributes.scope) {


	case "icshowbiz" : {

		// START OF SETTING ICSHOWBIZ APPLICATION VARIABLES
        application.moto = "You heard it here first";
		application.PerformanceCheck = "false";
		application.webCrossingRegPage = "http://icdiscussion.icshowbiz.com/cgi-bin/WebX.fcgi?20@@";
        application.webCrossingLoginPage = "http://icdiscussion.icshowbiz.com/cgi-bin/WebX.fcgi?getCertificate@@";
        application.webCrossingFolderPage = "http://icdiscussion.icshowbiz.com/cgi-bin/WebX.fcgi?14@@";
        application.webCrossingSubFolderPage = "http://icdiscussion.icshowbiz.com/cgi-bin/WebX.fcgi?14@@";
        application.webCrossingPortNumber = "80";
        application.webCrossingRLiveTest = "http://icdiscussion.icshowbiz.com/cgi-bin/WebX.fcgi?getDiscussion@@";

        application.eSharePortNumber = "80";
        application.chat.host = "192.168.246.180";
        application.eshare_internal_host = "icchat.icshowbiz.com";
        application.eShareDataPage = "http://192.168.246.180/eshare/server?action=4";
//      application.eShareDataPage = "http://#application.chat.internal_host#/eshare/server?action=4";
		application.eShareRegPage = "http://192.168.246.180/eshare/server?action=11";
        application.eShareLoginPage = "http://192.168.246.180/eshare/server?action=11";
        application.eShareBaseURL = "icchat.icshowbiz.com";

		/* flag for business directory and whatson.
		differentiate between regional & national site output */
		application.bd_ae_output_site_type = "national_site";

		// border colour for html list box for regional sites
		application.reg_htmllist_border = "0099cc";

		// hex value for htmllist box call
		application.ae_htmllistbox_hex = "000066";

		//files to include in database generated application variables
		application.st_toInclude = structNew();
		application.st_toInclude[1] = "setAEApplicationVars.cfm";
		application.st_toInclude[2] = "setBDApplicationVars.cfm";
		application.st_toInclude[3] = "seticshowbizApplicationVars.cfm";

		// END OF SETTING ICSHOWBIZ APPLICATION VARIABLES

	break;}


	case "icchoice" : {

		// START OF SETTING ICCHOICE APPLICATION VARIABLES

       //site moto
	   application.moto = "Independent guides for smart shoppers";

       //files to include in database generated application variables
	    application.st_toInclude = structNew();
		application.st_toInclude[1] = "seticchoiceApplicationVars.cfm";

       //Reuters information
	    application.reuters = structnew();
		application.reuters.primarycolour= "##ffffff";
		application.reuters.secondarycolour= "##ffccff";
		application.reuters.reuterslogo = "#application.s_imageserver#/design/money/reuters.gif";
		application.reuters.server_name = "http://ri2.rois.com";
		application.reuters.secure_server_name = "https://ri2.rois.com";
		application.reuters.xmlidstring = '<?xml version="1.0" encoding="ISO-8859-1" ?>';
		application.reuters.xmlfather = "ric";
		application.reuters.xmlchild = "fid";
		application.reuters.groupid = "vbqp1";
		application.reuters.user = "vbqp1";
		application.reuters.password = "2378asos";
		application.reuters.id = "id";
		application.reuters.seperator = "=";
		application.reuters.father_id = "name";
		//Session info will be kept in the database at all times.
		//End of Reuters information

     //Choice channel colour
	application.channel_colour = structnew();

	 //travel
	application.channel_colour[53257] = "33CC33";

    //motoring
    application.channel_colour[53258] = "3366FF";

    //Food and Drink
	application.channel_colour[53259] = "FFCC33";

    //Money
	application.channel_colour[53260] = "CC33FF";

	//Shopping
	application.channel_colour[53261] = "FF3399";

    //Discussion
	application.channel_colour[53262] = "";

	//Live Chat
	application.channel_colour[53263] = "";

	//Feedback
	application.channel_colour[53264] = "";

    //-----------------OAG Travel Application Settings Start---------------//

	//Records per page on the s_nat_cho_acco_list component
	application.s_nat_cho_acco_list_recs_per_page = 50;

	//Records per page on the s_nat_cho_acco_facility_searchresult component
	application.s_nat_cho_acco_facility_searchresult_recs_per_page = 20;

	//Records per page on the s_nat_cho_acco_facility_searchresult component
	application.s_nat_cho_acco_facility_searchresult_pages_per_block = 10;

	//Records per page on the s_nat_cho_res_search_result component
	application.s_nat_cho_res_searchresult_recs_per_page = 20;

	//Records per page on the s_nat_cho_res_search_result component
	application.s_nat_cho_res_searchresult_pages_per_block = 10;

	//sub path for truth about resorts
	application.s_oag_ttr_path="dtravel/aresorts";

	//sub path for truth about cities
	application.s_oag_ttc_path="dtravel/bcities";

	//Display length of descriptive fields in lists
	application.s_oag_dec_length = 250;

    //Default images for cities, resorts, accommodation,, maplink,, and weather map link
	application.default_eu_city_image1 = "generic_eu_city1.gif";
	application.default_eu_city_image2 = "generic_eu_city2.gif";
	application.default_int_city_image1 = "generic_int_city1.gif";
	application.default_int_city_image2 = "generic_int_city2.gif";
	application.default_resort_image1 = "generic_resort1.gif";
	application.default_resort_image2 = "generic_resort2.gif";
	application.default_resort_image3 = "generic_resort3.gif";
	application.default_budget_image = "generic_budget.gif";
	application.default_midrange_image = "generic_midrange.gif";
	application.default_topend_image = "generic_topend.gif";
	application.maplink_image = "map.gif";
	application.weathermaplink_image = "weather_map.jpg";
	application.breadcrumb_backarrow = "back_arrow.gif";

	//Default Vicinity Mapping Parameters
	application.resort_default_map_scale = "7";
	application.area_default_map_scale = "7";
	application.region_default_map_scale = "7";
	application.ctry_default_map_scale = "9";
	application.vicinity_pointer = "0";

	// -----------------OAG Travel Application settings End ----------------------//

		// END OF SETTING ICCHOICE APPLICATION VARIABLES

	break;}

        case "icsport" : {
                // START OF SETTING icsport APPLICATION VARIABLES
                //files to include in database generated application variables
                application.moto = "All the action, all the time";
                application.st_toInclude = structNew();
                application.st_toInclude[1] = "setAEApplicationVars.cfm";
                application.st_toInclude[2] = "setBDApplicationVars.cfm";
                application.st_toInclude[3] = "seticsportApplicationVars.cfm";
                // END OF SETTING icsport APPLICATION VARIABLES
       break;}


		case "ichuddersfield" : {

                // START OF SETTING ICHuddersfield APPLICATION VARIABLES

                //files to include in database generated application variables
                application.st_toInclude = structNew();
                application.st_toInclude[1] = "setAEApplicationVars.cfm";
                application.st_toInclude[2] = "setBDApplicationVars.cfm";

                application.st_toInclude[3] = "setRegionalApplicationVars.cfm";

                application.st_toInclude[4] = "setichuddersfieldApplicationVars.cfm";


                // END OF SETTING ICHuddersfield APPLICATION VARIABLES

       break;}
        case "icliverpool" : {

                // START OF SETTING ICLiverpool APPLICATION VARIABLES

                //files to include in database generated application variables
                application.st_toInclude = structNew();
                application.st_toInclude[1] = "setAEApplicationVars.cfm";
                application.st_toInclude[2] = "setBDApplicationVars.cfm";

                application.st_toInclude[3] = "setRegionalApplicationVars.cfm";

                application.st_toInclude[4] = "seticliverpoolApplicationVars.cfm";


                // END OF SETTING ICLiverpool APPLICATION VARIABLES

       break;}


        case "icwales" : {

                // START OF SETTING ICWales APPLICATION VARIABLES

                //files to include in database generated application variables
                application.st_toInclude = structNew();
                application.st_toInclude[1] = "setAEApplicationVars.cfm";
                application.st_toInclude[2] = "setBDApplicationVars.cfm";

                application.st_toInclude[3] = "setRegionalApplicationVars.cfm";

                application.st_toInclude[4] = "seticwalesApplicationVars.cfm";


                // END OF SETTING ICWales APPLICATION VARIABLES

       break;}

        case "icbirmingham" : {

                // START OF SETTING ICBirmingham APPLICATION VARIABLES

                //files to include in database generated application variables
                application.st_toInclude = structNew();
                application.st_toInclude[1] = "setAEApplicationVars.cfm";
                application.st_toInclude[2] = "setBDApplicationVars.cfm";

                application.st_toInclude[3] = "setRegionalApplicationVars.cfm";

                application.st_toInclude[4] = "seticbirminghamApplicationVars.cfm";


                // END OF SETTING ICBirmingham APPLICATION VARIABLES

       break;}

        case "iccoventry" : {

                // START OF SETTING ICCoventry APPLICATION VARIABLES

                //files to include in database generated application variables
                application.st_toInclude = structNew();
                application.st_toInclude[1] = "setAEApplicationVars.cfm";
                application.st_toInclude[2] = "setBDApplicationVars.cfm";

                application.st_toInclude[3] = "setRegionalApplicationVars.cfm";

                application.st_toInclude[4] = "seticcoventryApplicationVars.cfm";

                // END OF SETTING ICCoventry APPLICATION VARIABLES

        break;}

        case "icteesside" : {

                // START OF SETTING icTeesside APPLICATION VARIABLES

                //files to include in database generated application variables
                application.st_toInclude = structNew();
                application.st_toInclude[1] = "setAEApplicationVars.cfm";
                application.st_toInclude[2] = "setBDApplicationVars.cfm";

                application.st_toInclude[3] = "setRegionalApplicationVars.cfm";

                application.st_toInclude[4] = "seticteessideApplicationVars.cfm";

                // END OF SETTING icTeesside APPLICATION VARIABLES

        break;}


	case "icnewcastle" : {

	        // START OF SETTING icNewcastle APPLICATION VARIABLES

                //files to include in database generated application variables
                application.st_toInclude = structNew();
                application.st_toInclude[1] = "setAEApplicationVars.cfm";
                application.st_toInclude[2] = "setBDApplicationVars.cfm";

                application.st_toInclude[3] = "setRegionalApplicationVars.cfm";

                application.st_toInclude[4] = "seticnewcastleApplicationVars.cfm";


		// END OF SETTING ICNEWCASTLE APPLICATION VARIABLES

	break;}

       case "iccheshireonline" : {

                // START OF SETTING icCheshireonline APPLICATION VARIABLES

                //files to include in database generated application variables
                application.st_toInclude = structNew();
                application.st_toInclude[1] = "setAEApplicationVars.cfm";
                application.st_toInclude[2] = "setBDApplicationVars.cfm";

                application.st_toInclude[3] = "setRegionalApplicationVars.cfm";

                application.st_toInclude[4] = "seticcheshireonlineApplicationVars.cfm";

                // END OF SETTING icCheshireonline APPLICATION VARIABLES

        break;}

        case "icsurreyonline" : {

                // START OF SETTING icSurreyonline APPLICATION VARIABLES

                //files to include in database generated application variables
                application.st_toInclude = structNew();
                application.st_toInclude[1] = "setAEApplicationVars.cfm";
                application.st_toInclude[2] = "setBDApplicationVars.cfm";

                application.st_toInclude[3] = "setRegionalApplicationVars.cfm";

                application.st_toInclude[4] = "seticsurreyonlineApplicationVars.cfm";


                // END OF SETTING ICSURREYONLINE APPLICATION VARIABLES

        break;}


        case "icberkshire" : {

                // START OF SETTING icBerkshire APPLICATION VARIABLES

                //files to include in database generated application variables
                application.st_toInclude = structNew();
                application.st_toInclude[1] = "setAEApplicationVars.cfm";
                application.st_toInclude[2] = "setBDApplicationVars.cfm";

                application.st_toInclude[3] = "setRegionalApplicationVars.cfm";

                application.st_toInclude[4] = "seticberkshireApplicationVars.cfm";

                // END OF SETTING ICBERKSHIRE APPLICATION VARIABLES

        break;}


        case "icsouthlondon" : {

                // START OF SETTING icSouthlondon APPLICATION VARIABLES

                //files to include in database generated application variables
                application.st_toInclude = structNew();
                application.st_toInclude[1] = "setAEApplicationVars.cfm";
                application.st_toInclude[2] = "setBDApplicationVars.cfm";

                application.st_toInclude[3] = "setRegionalApplicationVars.cfm";

                application.st_toInclude[4] = "seticsouthlondonApplicationVars.cfm";


                // END OF SETTING ICSOUTHLONDON APPLICATION VARIABLES

        break;}

       case "icscotland" : {

        // START OF SETTING icscotland  APPLICATION VARIABLES

        application.st_toInclude = StructNew();
        application.st_toInclude[1] = "setAEApplicationVars.cfm";
        application.st_toInclude[2] = "setBDApplicationVars.cfm";
        application.st_toInclude[3] = "setRegionalApplicationVars.cfm";
        application.st_toInclude[4] = "seticscotlandApplicationVars.cfm";

        //END OF SETTING icscotland APPLICATION VARIABLES

        break;}

       case "icnorthwales" : {

        // START OF SETTING icnorthwales  APPLICATION VARIABLES

        application.st_toInclude = StructNew();
        application.st_toInclude[1] = "setAEApplicationVars.cfm";
        application.st_toInclude[2] = "setBDApplicationVars.cfm";
        application.st_toInclude[3] = "setRegionalApplicationVars.cfm";
        application.st_toInclude[4] = "seticnorthwalesApplicationVars.cfm";

        //END OF SETTING icnorthwales APPLICATION VARIABLES

        break;}

	case "mirror" : {

	// START OF SETTING mirror APPLICATION VARIABLES

	//files to include in database generated application variables
	application.st_toInclude = structNew();
	application.st_toInclude[1] = "setmirrorApplicationVars.cfm";
	application.st_toInclude[2] = "setRegionalApplicationVars.cfm";
	// END OF SETTING mirror APPLICATION VARIABLES

	break;}

        case "iclanarkshire" : {

        // START OF SETTING icregion APPLICATION VARIABLES

        //files to include in database generated application variables
        application.st_toInclude = structNew();
        application.st_toInclude[1] = "setAEApplicationVars.cfm";
        application.st_toInclude[2] = "setBDApplicationVars.cfm";
        application.st_toInclude[3] = "setRegionalApplicationVars.cfm";
        application.st_toInclude[4] = "seticlanarkshireApplicationVars.cfm";

        // END OF SETTING icregion APPLICATION VARIABLES

        break;}

	case "icregion" : {

        // START OF SETTING icregion APPLICATION VARIABLES
        //files to include in database generated application variables
        application.st_toInclude = structNew();
        application.st_toInclude[1] = "seticregionApplicationVars.cfm";
        application.st_toInclude[2] = "setRegionalApplicationVars.cfm";

	// END OF SETTING icregion APPLICATION VARIABLES

	break;}

	case "thepeople" : {

        // START OF SETTING The People APPLICATION VARIABLES

        //files to include in database generated application variables
        application.st_toInclude = structNew();
        application.st_toInclude[1] = "setAEApplicationVars.cfm";
        application.st_toInclude[2] = "setBDApplicationVars.cfm";
        application.st_toInclude[3] = "setRegionalApplicationVars.cfm";
        application.st_toInclude[4] = "setthepeopleApplicationVars.cfm";
        application.st_toInclude[5] = "setapgGenericApplicationVars.cfm";

        // END OF SETTING The People APPLICATION VARIABLES

       	break;}


	case "sundaymirror" : {

        // START OF SETTING Sunday Mirror APPLICATION VARIABLES

        //files to include in database generated application variables
       	application.st_toInclude = structNew();
        application.st_toInclude[1] = "setAEApplicationVars.cfm";
        application.st_toInclude[2] = "setBDApplicationVars.cfm";
        application.st_toInclude[3] = "setRegionalApplicationVars.cfm";
        application.st_toInclude[4] = "setsundaymirrorApplicationVars.cfm";
        application.st_toInclude[5] = "setapgGenericApplicationVars.cfm";

        // END OF SETTING Sunday Mirror APPLICATION VARIABLES

       	break;}

	default: {

	// START OF SETTING APG built generic APPLICATION VARIABLES
	application.st_toInclude = structNew();
	application.st_toInclude[1] = "setAEApplicationVars.cfm";
	application.st_toInclude[2] = "setBDApplicationVars.cfm";
	application.st_toInclude[3] = "setRegionalApplicationVars.cfm";
	application.st_toInclude[4] = "setapgGenericApplicationVars.cfm";

	// END OF SETTING APG built generic APPLICATION VARIABLES

	}

case "icnetwork" : {

                // START OF SETTING icNetwork APPLICATION VARIABLES
                //files to include in database generated application variables
                application.st_toInclude = structNew();
                application.st_toInclude[1] = "setAEApplicationVars.cfm";
                application.st_toInclude[2] = "setBDApplicationVars.cfm";
                application.st_toInclude[3] = "setRegionalApplicationVars.cfm";
                application.st_toInclude[4] = "setapgGenericApplicationVars.cfm";
                application.st_toInclude[5] = "ApplicationVars_no_container_spacing.cfm";
                // END OF SETTING icNetwork APPLICATION VARIABLES

break;}

/*
case "dailyrecord" :{
// START OF SETTING APG built Daily Record APPLICATION VARIABLES
   application.st_toInclude = structNew();
   application.st_toInclude[1] = "setAEApplicationVars.cfm";
   application.st_toInclude[2] = "setBDApplicationVars.cfm";
   application.st_toInclude[3] = "setRegionalApplicationVars.cfm";
   application.st_toInclude[4] = "setdailyrecordApplicationVars.cfm";
   application.st_toInclude[5] = "setapgGenericApplicationVars.cfm";

// END OF SETTING APG built Daily Record APPLICATION VARIABLES

break;}

case "sundaymail" :{
// START OF SETTING APG built Sunday Mail APPLICATION VARIABLES
  application.st_toInclude = structNew();
  application.st_toInclude[1] = "setAEApplicationVars.cfm";
  application.st_toInclude[2] = "setBDApplicationVars.cfm";
  application.st_toInclude[3] = "setRegionalApplicationVars.cfm";
  application.st_toInclude[4] = "setsundaymailApplicationVars.cfm";
  application.st_toInclude[5] = "setapgGenericApplicationVars.cfm";

// END OF SETTING APG built Sunday Mail APPLICATION VARIABLES

break;}

*/
	}
}
</cfscript>


<!--- ><cfscript>
//Some useful global functions
SERVER.robyn = StructNew();
server.robyn.dump = variables.dump;
//server.robyn.print = variables.print;
SERVER.robyn.timeLog = variables.timeLog;
SERVER.robyn.getLog = variables.getLog;
</cfscript> --->

<cffunction name="getLog" returnType="any" access="private">
	<cfif NOT StructKeyExists(SERVER.robyn, '_logger')>
		<cftry>
		<cfset SERVER.robyn._logger = createObject('component', 'com.tmglib.log.LogController').instanceOf()>
		<cfset SERVER.robyn._logger.info(SERVER.robyn._logger, 'SERVER.robyn._logger created')>
		<cfcatch type="any">
			<cfdump var="SERVER.robyn._logger creation ERROR">
		</cfcatch>
		</cftry>
	</cfif>
	<cfreturn SERVER.robyn._logger>
</cffunction>

<cffunction name="timeLog" returnType="any" output="no" access="private"
            hint="puts a logfile into /src/tmp/tmglog.info.log.
            This path is set in /src/java/config/tmglog.properties" >
	<cfargument name="startTime" required="true">
	<cfargument name="message" required="true">
	<cfargument name="component" default="">

	<cfscript>
		var tickCount = getTickCount();

		if(isObject(arguments.component)){
			SERVER.robyn.getLog().info(arguments.component, "t=#(tickCount-arguments.startTime)#ms: #arguments.message#");
		}else{
			SERVER.robyn.getLog().info(SERVER.robyn.getLog(), "t=#(tickCount-arguments.startTime)#ms: #arguments.message#");
		}
		return tickCount;
	</cfscript>

</cffunction>


<!--- put dump and trace in the server scope --->
<cffunction name="dump" access="private" returntype="void" hint="well it does a dump">
	<cfargument name="stuffToDump" type="any" required="true" hint="what you want to dump">
	<cfargument name="abort" type="any" default="false" hint="abort after dump">
	<cfargument name="label" type="string" default="Here" hint="what am I dumping">
	<cfargument name="expand" type="any" default="false" hint="expand output">

	<cfdump var="#arguments.stuffToDump#" expand="#arguments.expand#" label="#arguments.label#">
	<cfif #arguments.abort# EQ 1>
		<cfabort>
	</cfif>
</cffunction>

<cffunction name="print" access="private" returntype="void">
	<cfargument name="stuff" type="any" hint="what to print">
	<cfoutput>
		#arguments.stuff#
	</cfoutput>
</cffunction>

<!---  Andy's dump function:
<cffunction name="dump" returnType="void" access="public"
        hint="Dump out the given variable and nothing else">
        <cfargument name="variable" type="any" required="true" hint="The variable to dump">
        <cfargument name="top" type="string" default="1"
                hint="number of levels to display in structs">
        <cfargument name="asText" type="boolean" default="true"
                hint="Whether to format as text or html">

        <!--- Make sure nothing else is being output already --->
        <cfset getPageContext().getOut().clearBuffer()>
        <!--- in ColdFusion 8 format and limit the output --->
        <cfif left(server.coldfusion.productversion, 1) EQ '8' AND arguments.asText>
                <cfdump var="#arguments.variable#" format="text" top="#arguments.top#">
        <cfelse>
                <cfdump var="#arguments.variable#" expand="no">
        </cfif>
        <!--- Don't display anthing else after the dump --->
        <cfabort>
</cffunction>
--->
