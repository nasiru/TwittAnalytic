<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="SimpleCouchDB.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="org.lightcouch.CouchDbException" %>
<%@ page import="twitter4j.GeoLocation" %>

<%
	Date start_date = new SimpleDateFormat("dd/MM/yyyy").parse("24/09/2013");
	Date end_date = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss").parse("25/09/2013 23:59:59");

	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat dateFormat2 = new SimpleDateFormat("dd/MM/yyyy");

	RectArea rectangle = new RectArea(new GeoLocation(-34.8333,138.7),
										new GeoLocation(-35.0333,138.5));
	TweetSentiment sentiment;
	//Access DB and retrive the count for everyday
	CouchDB db = new CouchDB();
	String c_filename = getServletContext().getRealPath("classifier/classifier.txt");
	
	//Get area of interest from parameter attached in the URL
	if(request.getParameter("ne_lat") != null && request.getParameter("ne_lng") != null &&
		request.getParameter("sw_lat") != null && request.getParameter("sw_lng") != null){
		rectangle = new RectArea(new GeoLocation(
										Double.parseDouble(request.getParameter("ne_lat")), 
										Double.parseDouble(request.getParameter("ne_lng"))),
								 new GeoLocation(
										Double.parseDouble(request.getParameter("sw_lat")),
										Double.parseDouble(request.getParameter("sw_lng")))
								);
	}
			
	if(request.getParameter("start_date") != null && request.getParameter("end_date") != null){
		start_date = new SimpleDateFormat("dd/MM/yyyy").parse( request.getParameter("start_date") );
		end_date = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss").parse( request.getParameter("end_date") + " 23:59:59");
		sentiment = db.getSentiment(c_filename,rectangle,start_date, end_date);
	}
	else{
		sentiment = db.getSentiment(c_filename,rectangle,start_date, end_date);
		
	}
	
%>



<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    
    <head>
        <title>Statistics</title>
        <!-- Bootstrap -->
        <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen">
        <link href="bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet" media="screen">
        <link href="assets/styles.css" rel="stylesheet" media="screen">
        <!--[if lte IE 8]><script language="javascript" type="text/javascript" src="vendors/flot/excanvas.min.js"></script><![endif]-->
        <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
        <!--[if lt IE 9]>
            <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->
        <script src="vendors/modernizr-2.6.2-respond-1.1.0.min.js"></script>
        <script type="text/javascript"
      		src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAe8RpD7yqP4R_68vC94uPNXWYgxiWVm_o&sensor=false">
    	</script>
        <script>
// This example adds a user-editable rectangle to the map.
// When the user changes the bounds of the rectangle,
// an info window pops up displaying the new bounds.
var adelaid = new google.maps.LatLng(-34.9333, 138.6);
var center_point = new google.maps.LatLng( <%= rectangle.getMiddlePoint().getLatitude() %>, <%= rectangle.getMiddlePoint().getLongitude() %>);

var rectangle;
var map;
var infoWindow;

function initialize() {
  var mapOptions = {
    center: center_point,
    zoom: 9,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById('map-canvas-small'),
      mapOptions);

  var bounds = new google.maps.LatLngBounds(
	  new google.maps.LatLng(<%= rectangle.getSouth_west().getLatitude() %>, <%= rectangle.getSouth_west().getLongitude() %>),
      new google.maps.LatLng(<%= rectangle.getNorth_east().getLatitude() %>, <%= rectangle.getNorth_east().getLongitude() %>)
  );

  // Define the rectangle and set its editable property to true.
  rectangle = new google.maps.Rectangle({
    bounds: bounds,
    strokeColor: '#FF0000',
    strokeWeight: 0.5,
    fillColor: '#FF0000',
    fillOpacity: 0.2,
    editable: true,
    draggable: true
  });

  rectangle.setMap(map);

  // Add an event listener on the rectangle.
  google.maps.event.addListener(rectangle, 'bounds_changed', showNewRect);

  // Define an info window on the map.
  infoWindow = new google.maps.InfoWindow();
}
// Show the new coordinates for the rectangle in an info window.

/** @this {google.maps.Rectangle} */
function showNewRect(event) {
  var ne = rectangle.getBounds().getNorthEast();
  var sw = rectangle.getBounds().getSouthWest();
  
  document.getElementById("ne_lat").value = ne.lat();
  document.getElementById("ne_lng").value = ne.lng();
  document.getElementById("sw_lat").value = sw.lat();
  document.getElementById("sw_lng").value = sw.lng();

  /*var contentString = '<b>Rectangle moved.</b><br>' +
      'New north-east corner: ' + ne.lat() + ', ' + ne.lng() + '<br>' +
      'New south-west corner: ' + sw.lat() + ', ' + sw.lng();*/

  // Set the info window's content and position.
  //infoWindow.setContent(contentString);
  //infoWindow.setPosition(ne);

  //infoWindow.open(map);
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

                    <!-- morris graph chart -->
                    <div class="row-fluid section">
                         <!-- block -->
                        <div class="block">
                            <div class="navbar navbar-inner block-header">
                                <div class="muted pull-left">Sentiment of tweets <small>(over the time)</small></div>
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
		                                            <input type="text" class="datepicker" id="date01" name="start_date" value="<%= dateFormat2.format(start_date) %>">
		                                          </div>
		                                    </div>
		                                    <div class="control-group">
		                                          <label class="control-label" for="typeahead">End Date </label>
		                                          <div class="controls">
		                                            <input type="text" class="datepicker" id="date02" name="end_date" value="<%= dateFormat2.format(end_date) %>">
		                                          </div>
		                                    </div>                           
		                                    <div class="control-group">
		                                          <label class="control-label" for="typeahead">Select Area </label>
		                                          <div class="controls">
		                                            <div id="map-canvas-small"></div>
		                                          </div>
		                                    </div>
		                                    <div class="control-group">
		                                          <label class="control-label" for="typeahead">NE Position </label>
		                                          <div class="controls">
		                                             <input class="input disabled" name="ne_lat" id="ne_lat" type="text" value="<%= rectangle.getNorth_east().getLatitude() %>" readonly>
		                                          	 <input class="input disabled" name="ne_lng" id="ne_lng" type="text" value="<%= rectangle.getNorth_east().getLongitude() %>" readonly>
		                                          </div>
		                                    </div>
		                                    <div class="control-group">
		                                          <label class="control-label" for="typeahead">SW Position </label>
		                                          <div class="controls">
		                                             <input class="input disabled" name="sw_lat" id="sw_lat" type="text" value="<%= rectangle.getSouth_west().getLatitude() %>" readonly>
		                                          	 <input class="input disabled" name="sw_lng" id="sw_lng" type="text" value="<%= rectangle.getSouth_west().getLongitude() %>" readonly></div>
		                                    </div>
		                                   
		                                    
		                                    <div class="control-group">
		                                          <div class="controls">
		                                            <button type="submit" class="btn btn-primary">Submit</button>
		                                          </div>
		                                    </div>
		                                </fieldset>
		                            </form>
		                        </div>
		                        <div class="span6 chart">
                                    <h5>Sentiment(Pie Chart)</h5>
                                    <div id="piechart1" style="width:100%;height:200px"></div>
                                </div>
                                <div class="span5 chart">
                                    <h5>Sentiment(Bar)</h5>
                                    <div id="hero-bar" style="width:100%;height:200px"></div>
                                </div>
                                
                            

                            </div>
                        </div>
                        <!-- /block -->
                    </div>

                    

                </div>
            </div>
            <hr>
            <footer>
                <p>&copy; Vincent Gabriel 2013</p>
            </footer>
        </div>
        <!--/.fluid-container-->
        <link rel="stylesheet" href="vendors/morris/morris.css">
		<link href="vendors/datepicker.css" rel="stylesheet" media="screen">
        <link href="vendors/uniform.default.css" rel="stylesheet" media="screen">
        <link href="vendors/chosen.min.css" rel="stylesheet" media="screen">

        <script src="vendors/jquery-1.9.1.min.js"></script>
        <script src="vendors/jquery.knob.js"></script>
        <script src="vendors/raphael-min.js"></script>
        <script src="vendors/morris/morris.min.js"></script>

        <script src="bootstrap/js/bootstrap.min.js"></script>
        <script src="vendors/flot/jquery.flot.js"></script>
        <script src="vendors/flot/jquery.flot.categories.js"></script>
        <script src="vendors/flot/jquery.flot.pie.js"></script>
        <script src="vendors/flot/jquery.flot.time.js"></script>
        <script src="vendors/flot/jquery.flot.stack.js"></script>
        <script src="vendors/flot/jquery.flot.resize.js"></script>
        
        <script src="vendors/bootstrap-datepicker.js"></script>
        <script src="vendors/jquery.uniform.min.js"></script>
        <script src="vendors/chosen.jquery.min.js"></script>
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
        <script>
        var data1 = [{label: "Positive", data: <%= sentiment.getPositive() %>},
                     {label: "Negative", data: <%= sentiment.getNegative() %>},
                     {label: "Neutral", data: <%= sentiment.getNeutral() %>}]

        $.plot('#piechart1', data1, {
            series: {
                pie: { 
                    show: true,
                    radius: 1,
                    label: {
                        show: true,
                        radius: 3/4,
                        formatter: labelFormatter,
                        background: { 
                            opacity: 0.5,
                            color: '#000'
                        }
                    }
                }
            },
            legend: {
                show: false
            }
        });

        function labelFormatter(label, series) {
            return "<div style='font-size:8pt; text-align:center; padding:2px; color:white;'>" + label + "<br/>" + Math.round(series.percent) + "%</div>";
        }
        
        
     // Morris Bar Chart
        Morris.Bar({
            element: 'hero-bar',
            data: [
                {feedback: 'Pos+', counts: <%= sentiment.getPositive()  %>},
                {feedback: 'Neg-', counts: <%= sentiment.getNegative()  %>},
                {feedback: 'Neutral', counts: <%= sentiment.getNeutral()  %>},
            ],
            xkey: 'feedback',
            ykeys: ['counts'],
            labels: ['Sentiment'],
            barRatio: 0.4,
            xLabelMargin: 10,
            hideHover: 'auto',
            barColors: ["#3d88ba"]
        });
        
        var tax_data = [

            
        ];
        
        
        </script>
    </body>

</html>