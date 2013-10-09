<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="SimpleCouchDB.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="org.lightcouch.CouchDbException" %>
<%@ page import="twitter4j.GeoLocation" %>

<%
	RectArea adelaid_city = new RectArea(new GeoLocation(-34.8130075199158, 138.70000000000005), 
		new GeoLocation(-34.97030508204433, 138.4835205078125));
	RectArea rural = new RectArea(new GeoLocation(-34.59172168044161, 139.11198730468755), 
		new GeoLocation(-35.27582555470527, 138.412109375));

	Date start_date = new SimpleDateFormat("dd/MM/yyyy").parse("23/09/2013");
	Date end_date = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss").parse("25/09/2013 23:59:59");

	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat dateFormat2 = new SimpleDateFormat("dd/MM/yyyy");
	String c_filename = getServletContext().getRealPath("classifier/classifier.txt");

	//Access DB and retrive the count for everyday
	CouchDB db = new CouchDB();
	

	if(request.getParameter("start_date") != null && request.getParameter("end_date") != null){
		start_date = new SimpleDateFormat("dd/MM/yyyy").parse( request.getParameter("start_date") );
		end_date = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss").parse( request.getParameter("end_date") + " 23:59:59");
	}
	
	List<TweetSentiment> sentiment_list_rural = db.getDailySentimentExclude(c_filename, rural,adelaid_city, start_date, end_date);
	List<TweetSentiment> sentiment_list_city = db.getDailySentiment(c_filename, adelaid_city, start_date, end_date);
	List<TweetCount> tweetcount_list_city = db.getTopKHashTag(5, adelaid_city, start_date, end_date);
	List<TweetCount> tweetcount_list_rural = db.getTopKHashTag(5, rural, adelaid_city, start_date, end_date);
	
%>


<!DOCTYPE html>
<html class="no-js">
    
    <head>
        <title>Statistic (City and Rural area)</title>
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
        <script>
// This example adds a user-editable rectangle to the map.
// When the user changes the bounds of the rectangle,
// an info window pops up displaying the new bounds.
var adelaid = new google.maps.LatLng(-34.8033, 138.6);
var center_point = new google.maps.LatLng( <%= adelaid_city.getMiddlePoint().getLatitude()-0.1 %>, <%= adelaid_city.getMiddlePoint().getLongitude()+0.4 %>);

var rectangle;
var map;
var infoWindow;

function initialize() {
  var mapOptions = {
    center: center_point,
    zoom: 8,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById('map-canvas-small'),
      mapOptions);

  var bounds_city = new google.maps.LatLngBounds(
	  new google.maps.LatLng(<%= adelaid_city.getSouth_west().getLatitude() %>, <%= adelaid_city.getSouth_west().getLongitude() %>),
      new google.maps.LatLng(<%= adelaid_city.getNorth_east().getLatitude() %>, <%= adelaid_city.getNorth_east().getLongitude() %>)
  );
  
  var bounds_rural = new google.maps.LatLngBounds(
		  new google.maps.LatLng(<%= rural.getSouth_west().getLatitude() %>, <%= rural.getSouth_west().getLongitude() %>),
	      new google.maps.LatLng(<%= rural.getNorth_east().getLatitude() %>, <%= rural.getNorth_east().getLongitude() %>)
	  );

  // Define the rectangle and set its editable property to true.
  rectangle_city = new google.maps.Rectangle({
    bounds: bounds_city,
    strokeColor: '#FF0000',
    strokeWeight: 0.5,
    fillColor: '#FF0000',
    fillOpacity: 0.5,
    editable: false,
    draggable: false
  });
  
  rectangle_rural = new google.maps.Rectangle({
	    bounds: bounds_rural,
	    strokeColor: '#0000FF',
	    strokeWeight: 0.5,
	    fillColor: '#0000FF',
	    fillOpacity: 0.2,
	    editable: false,
	    draggable: false
	  });
  rectangle_city.setMap(map);
  rectangle_rural.setMap(map);
  

  // Add an event listener on the rectangle.
  google.maps.event.addListener(rectangle1, 'bounds_changed', showNewRect);

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
                	<div class="row-fluid section">
                         <!-- block -->
                        <div class="block">
                            <div class="navbar navbar-inner block-header">
                                <div class="muted pull-left">The number of tweets <small>(over the time)</small></div>
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
		                                          <div class="controls">
		                                            <div id="map-canvas-small"></div>
		                                            <span class="label label-info">Blue</span> = Rural and <span class="label label-important">Red</span> = City
		                                          </div>
		                                    </div>
		                                    <div class="control-group">
		                                          <div class="controls">
		                                            <button type="submit" class="btn btn-primary">Show Trends</button>
		                                          </div>
		                                    </div>
		                                </fieldset>
		                            </form>
		                        </div>
                            </div>
                        </div>
                        <!-- /block -->
                    </div>
                
                    <!-- morris graph chart -->
                    <div class="row-fluid section">
                         <!-- block -->
                        <div class="block">
                            <div class="navbar navbar-inner block-header">
                                <div class="muted pull-left"> Adelaide City vs <small>Rural Tweets</small></div>
                                <div class="pull-right"><span class="badge badge-warning">View More</span>

                                </div>
                            </div>
                            <div class="block-content collapse in">
                                <div class="span12">
                                    <div id="citywisecompare-graph" style="height: 230px;"></div>
                                </div>
                            </div>
                        </div>
                        <!-- /block -->
                    </div>

                    <!-- morris bar & donut charts -->
                    <div class="row-fluid section">
                         <!-- block -->
                        <div class="block">
                            <div class="navbar navbar-inner block-header">
                                <div class="muted pull-left">Location Wise Peoples' Interest</div>
                                <div class="pull-right"><span class="badge badge-warning">View More</span>

                                </div>
                            </div>
                            <div class="block-content collapse in">
                                <div class="span6 chart">
                                    <h5>Top Trends in Adelaide City</h5>
                                    <div id="city-bar" style="height: 250px;"></div>
                                </div>
                                <div class="span6 chart">
                                    <h5>Top Trends in Adelaide Rural</h5>
                                    <div id="rural-bar" style="height: 250px;"></div>
                                </div>
                            </div>
                        </div>
                        <!-- /block -->
                    </div>

                    


                </div>
            </div>
            <hr>
            <%@ include file="footer.jsp" %>
        </div>
        <!--/.fluid-container-->
        <link rel="stylesheet" href="vendors/morris/morris.css">


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
        
        <link href="vendors/datepicker.css" rel="stylesheet" media="screen">
        <script src="vendors/bootstrap-datepicker.js"></script>

        <script src="assets/scripts.js"></script>
        <script>
        $(function() {
        	$(".datepicker").datepicker();         
            // Morris Bar Chart
            Morris.Bar({
                element: 'city-bar',
                data: [
                       <% 
                       for(TweetCount count : tweetcount_list_city){
                       		out.println("{topic: '" + count.getKeyword() + "', percentage: " + count.getCount() + "},");
                       }
                       %>
                   ],
                   xkey: 'topic',
                   ykeys: ['percentage'],
                   labels: ['percentage'],
                   barRatio: 0.4,
                   xLabelMargin: 10,
                   hideHover: 'auto',
                   barColors: ["#3d88ba"]
               });

        });
        
        // Morris Bar Chart
        Morris.Bar({
            element: 'rural-bar',
            data: [
					<% 
					for(TweetCount count : tweetcount_list_rural){
							out.println("{topic: '" + count.getKeyword() + "', percentage: " + count.getCount() + "},");
					}
					%>
               ],
               xkey: 'topic',
               ykeys: ['percentage'],
               labels: ['percentage'],
               barRatio: 0.4,
               xLabelMargin: 10,
               hideHover: 'auto',
               barColors: ["#3d88ba"]
           });
    

        // Morris Line Chart
        var line_chart = [
                          <%
                          		for(TweetSentiment sentiment_city  : sentiment_list_city){
                          			Date temp_date = sentiment_city.getDate();
                          			out.print("{\"period\": \""+ dateFormat.format(temp_date) +"\", " +
                          					"\"tweetsCity\": " + sentiment_city.countTotalTweets() + ", ");
                          			for(TweetSentiment sentiment_rural  : sentiment_list_rural){
                          				if(temp_date.equals(sentiment_rural.getDate())){
                          					out.println("\"tweetsRural\": " + sentiment_rural.countTotalTweets() + "}, ");
                          				}
                          			}
                          		}
                          
                          %>
            
        ];
        Morris.Line({
            element: 'citywisecompare-graph',
            data: line_chart,
            xkey: 'period',
            xLabels: "day",
            ykeys: ['tweetsCity', 'tweetsRural'],
            labels: ['Adelaide City', 'Rural']
        });
        




        </script>
    </body>

</html>