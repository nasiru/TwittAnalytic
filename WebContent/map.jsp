<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="SimpleCouchDB.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="org.lightcouch.CouchDbException" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    
    <head>
        <title>Admin Home Page</title>
        <!-- Bootstrap -->
        <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen">
        <link href="bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet" media="screen">
        <link href="vendors/easypiechart/jquery.easy-pie-chart.css" rel="stylesheet" media="screen">
        <link href="assets/styles.css" rel="stylesheet" media="screen">
        
        
        <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
        <!--[if lt IE 9]>
            <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->
        <script src="vendors/modernizr-2.6.2-respond-1.1.0.min.js"></script>
        
        <script type="text/javascript"
      		src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAe8RpD7yqP4R_68vC94uPNXWYgxiWVm_o&sensor=false">
    	</script>
        
        <script type="text/javascript">
	        var adelaid = new google.maps.LatLng(-34.9333, 138.6);
	
	        var neighborhoods = [
<%
	int limit = 10;
	Date start_date = null;
	Date end_date = null;
	
	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

	List<TweetLocation> locations;
	
	if(request.getParameter("limit") != null){
		limit = Integer.parseInt( request.getParameter("limit") );
	}

	CouchDB db = new CouchDB();

	if(request.getParameter("start_date") != null || request.getParameter("end_date") != null){
		start_date = new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("start_date"));
		end_date = new SimpleDateFormat("dd/MM/yyyy").parse(request.getParameter("end_date"));
		try{
			locations = db.getTweetLocations(limit,start_date,end_date);
		}
		catch(CouchDbException e){
			locations = null;
		}
	}
	else{
		locations = db.getTweetLocations(limit);
	}

	for(TweetLocation location : locations){
		out.println("new google.maps.LatLng(" + location.getLat() + "," + location.getLng() +"),");
	}

%>
	        ];
	
	        var markers = [];
	        var iterator = 0;
	
	        var map;
	
	        function initialize() {
	          var mapOptions = {
	            zoom: 10,
	            mapTypeId: google.maps.MapTypeId.ROADMAP,
	            center: adelaid
	          };
	          
	          for (var i = 0; i < neighborhoods.length; i++) {
	        	    setTimeout(function() {
	        	      addMarker();
	        	    }, i * 10);
	        	  }
	
	          map = new google.maps.Map(document.getElementById('map-canvas'),
	                  mapOptions);
	        }
	
	
	        function addMarker() {
	          markers.push(new google.maps.Marker({
	            position: neighborhoods[iterator],
	            map: map,
	            draggable: false,
	            icon: 'http://maps.google.com/mapfiles/ms/icons/green-dot.png',
	            animation: google.maps.Animation.DROP
	          }));
	          iterator++;
	        }
	
	        google.maps.event.addDomListener(window, 'load', initialize);
    	</script>
        
    </head>
    
    <body>
        <%@ include file="header.jsp" %>
        <div class="container-fluid">
            <div class="row-fluid">
                <%@ include file="nav.jsp" %>
                
                <!--/span-->
                <div class="span9" id="content">
                    
                    <div class="row-fluid">
                        <!-- block -->
                        <div class="block">
                            <div class="navbar navbar-inner block-header">
                                <div class="muted pull-left">Google Map</div>
                                <div class="pull-right"><span class="badge badge-warning">View More</span>

                                </div>
                            </div>
                            <div class="block-content collapse in">
                            	<div class="span12">
                            		<form class="form-horizontal">
                                    	<fieldset>
		                            		<div class="control-group">
		                                          <label class="control-label" for="typeahead">Start Date </label>
		                                          <div class="controls">
		                                            <input type="text" class="datepicker" id="date01" name="start_date" <% if(start_date == null) {out.print("placeholder=\"dd/mm/yyyy\"");} else { out.print("value=\"" + dateFormat.format(start_date) + "\"");} %>>
		                                          </div>
		                                    </div>
		                                    <div class="control-group">
		                                          <label class="control-label" for="typeahead">End Date </label>
		                                          <div class="controls">
		                                            <input type="text" class="datepicker" id="date02" name="end_date" <% if(end_date == null) {out.print("placeholder=\"dd/mm/yyyy\"");} else { out.print("value=\"" + dateFormat.format(end_date) + "\"");} %>>
		                                          </div>
		                                    </div>
		                                    <div class="control-group">
		                                          <label class="control-label" for="typeahead">Limit </label>
		                                          <div class="controls">
		                                            <input type="text" id="date02" name="limit" value="<%= limit %>">
		                                          </div>
		                                    </div>
		                                    <div class="control-group">
		                                          <div class="controls">
		                                            <button type="submit" class="btn btn-primary">Submit</button>
		                                          </div>
		                                    </div>
		                                </fieldset>
		                            </form>
									<div class="well" style="margin-top:30px;">
										<div id="map-canvas"></div>
									</div>
                                </div>
                            </div>
                        </div>
                        <!-- /block -->
                    </div>
                    
                    </div>
                </div>
            </div>
            <hr>
            <footer>
                <p>&copy; Vincent Gabriel 2013</p>
            </footer>
        </div>
        
        <!--/.fluid-container-->
        <link href="vendors/datepicker.css" rel="stylesheet" media="screen">
        <link href="vendors/uniform.default.css" rel="stylesheet" media="screen">
        <link href="vendors/chosen.min.css" rel="stylesheet" media="screen">

        <link href="vendors/wysiwyg/bootstrap-wysihtml5.css" rel="stylesheet" media="screen">

        <script src="vendors/jquery-1.9.1.js"></script>
        <script src="bootstrap/js/bootstrap.min.js"></script>
        <script src="vendors/jquery.uniform.min.js"></script>
        <script src="vendors/chosen.jquery.min.js"></script>
        <script src="vendors/bootstrap-datepicker.js"></script>

        <script src="vendors/wysiwyg/wysihtml5-0.3.0.js"></script>
        <script src="vendors/wysiwyg/bootstrap-wysihtml5.js"></script>

        <script src="vendors/wizard/jquery.bootstrap.wizard.min.js"></script>


        <script src="assets/scripts.js"></script>
        <script>
        $(function() {
            $(".datepicker").datepicker();
            $(".uniform_on").uniform();
            $(".chzn-select").chosen();
            $('.textarea').wysihtml5();

            $('#rootwizard').bootstrapWizard({onTabShow: function(tab, navigation, index) {
                var $total = navigation.find('li').length;
                var $current = index+1;
                var $percent = ($current/$total) * 100;
                $('#rootwizard').find('.bar').css({width:$percent+'%'});
                // If it's the last tab then hide the last button and show the finish instead
                if($current >= $total) {
                    $('#rootwizard').find('.pager .next').hide();
                    $('#rootwizard').find('.pager .finish').show();
                    $('#rootwizard').find('.pager .finish').removeClass('disabled');
                } else {
                    $('#rootwizard').find('.pager .next').show();
                    $('#rootwizard').find('.pager .finish').hide();
                }
            }});
            $('#rootwizard .finish').click(function() {
                alert('Finished!, Starting over!');
                $('#rootwizard').find("a[href*='tab1']").trigger('click');
            });
        });
        </script>
        
    </body>

</html>