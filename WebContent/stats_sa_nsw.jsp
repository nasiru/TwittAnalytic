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
	RectArea south_aus = new RectArea(new GeoLocation(-26.349168096832464, 140.11174316406255), 
		new GeoLocation(-37.57825653978668, 129.2330322265625));
	RectArea nsw = new RectArea(new GeoLocation(-28.918378800890405, 153.38322753906255), 
		new GeoLocation(-35.45948188107027, 141.0982666015625));
	RectArea vic = new RectArea(new GeoLocation(-35.62302661921946, 151.18046875000005), 
			new GeoLocation(-39.37139812888573, 140.85107421875));
	RectArea qld = new RectArea(new GeoLocation(-15.815105788358228, 153.28984375000005), 
			new GeoLocation(-28.925162591143017, 141.37841796875));
	RectArea tas = new RectArea(new GeoLocation(-40.46501851083061, 148.89531250000005), 
			new GeoLocation(-44.09048288187994, 143.83935546875));
	RectArea wa = new RectArea(new GeoLocation(-14.11699104096049, 128.68046875000005), 
			new GeoLocation(-35.320658303188715, 113.07763671875));
	RectArea nt = new RectArea(new GeoLocation(-11.890592250949286, 137.46953125000005), 
			new GeoLocation(-25.645163541460366, 128.89794921875));

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
	
	List<TweetSentiment> sentiment_list_sa = db.getDailySentiment(c_filename, south_aus, start_date, end_date);
	List<TweetSentiment> sentiment_list_nsw = db.getDailySentiment(c_filename, nsw, start_date, end_date);
	List<TweetSentiment> sentiment_list_vic = db.getDailySentiment(c_filename, vic, start_date, end_date);
	List<TweetSentiment> sentiment_list_qld = db.getDailySentiment(c_filename, qld, start_date, end_date);
	List<TweetSentiment> sentiment_list_tas = db.getDailySentiment(c_filename, tas, start_date, end_date);
	List<TweetSentiment> sentiment_list_wa = db.getDailySentiment(c_filename, wa, start_date, end_date);
	List<TweetSentiment> sentiment_list_nt = db.getDailySentiment(c_filename, nt, start_date, end_date);
	
	List<TweetCount> tweetcount_list_sa = db.getTopKHashTag(5, south_aus, start_date, end_date);
	List<TweetCount> tweetcount_list_nsw = db.getTopKHashTag(5, nsw, start_date, end_date);
%>


<!DOCTYPE html>
<html class="no-js">
    
    <head>
        <title>Traveling Pattern</title>
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
var center_point = new google.maps.LatLng( <%= south_aus.getMiddlePoint().getLatitude()-0.1 %>, <%= south_aus.getMiddlePoint().getLongitude()+0.4 %>);

var rectangle;
var map;
var infoWindow;

function initialize() {
  var mapOptions = {
    center: center_point,
    zoom: 2,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById('map-canvas-small'),
      mapOptions);

  var bounds_sa = new google.maps.LatLngBounds(
	  new google.maps.LatLng(<%= south_aus.getSouth_west().getLatitude() %>, <%= south_aus.getSouth_west().getLongitude() %>),
      new google.maps.LatLng(<%= south_aus.getNorth_east().getLatitude() %>, <%= south_aus.getNorth_east().getLongitude() %>)
  );
  
  var bounds_nsw = new google.maps.LatLngBounds(
		  new google.maps.LatLng(<%= nsw.getSouth_west().getLatitude() %>, <%= nsw.getSouth_west().getLongitude() %>),
	      new google.maps.LatLng(<%= nsw.getNorth_east().getLatitude() %>, <%= nsw.getNorth_east().getLongitude() %>)
	  );
  
  	var bounds_vic = new google.maps.LatLngBounds(
		new google.maps.LatLng(<%= vic.getSouth_west().getLatitude() %>, <%= vic.getSouth_west().getLongitude() %>),
	    new google.maps.LatLng(<%= vic.getNorth_east().getLatitude() %>, <%= vic.getNorth_east().getLongitude() %>)
	);
	  
	var bounds_qld = new google.maps.LatLngBounds(
		new google.maps.LatLng(<%= qld.getSouth_west().getLatitude() %>, <%= qld.getSouth_west().getLongitude() %>),
		new google.maps.LatLng(<%= qld.getNorth_east().getLatitude() %>, <%= qld.getNorth_east().getLongitude() %>)
	);
	
	var bounds_tas = new google.maps.LatLngBounds(
		new google.maps.LatLng(<%= tas.getSouth_west().getLatitude() %>, <%= tas.getSouth_west().getLongitude() %>),
		new google.maps.LatLng(<%= tas.getNorth_east().getLatitude() %>, <%= tas.getNorth_east().getLongitude() %>)
	);
		  
  	var bounds_wa = new google.maps.LatLngBounds(
		new google.maps.LatLng(<%= wa.getSouth_west().getLatitude() %>, <%= wa.getSouth_west().getLongitude() %>),
		new google.maps.LatLng(<%= wa.getNorth_east().getLatitude() %>, <%= wa.getNorth_east().getLongitude() %>)
	);
  	
  	var bounds_nt = new google.maps.LatLngBounds(
  			new google.maps.LatLng(<%= nt.getSouth_west().getLatitude() %>, <%= nt.getSouth_west().getLongitude() %>),
  			new google.maps.LatLng(<%= nt.getNorth_east().getLatitude() %>, <%= nt.getNorth_east().getLongitude() %>)
  		);

  // Define the rectangle and set its editable property to true.
  rectangle_sa = new google.maps.Rectangle({
    bounds: bounds_sa,
    strokeColor: '#FF0000',
    strokeWeight: 0.5,
    fillColor: '#FF0000',
    fillOpacity: 0.5,
    editable: false,
    draggable: false
  });
  
  rectangle_nsw = new google.maps.Rectangle({
	    bounds: bounds_nsw,
	    strokeColor: '#0000FF',
	    strokeWeight: 0.5,
	    fillColor: '#0000FF',
	    fillOpacity: 0.2,
	    editable: false,
	    draggable: false
	  });
  
  rectangle_vic = new google.maps.Rectangle({
	    bounds: bounds_vic,
	    strokeColor: '#0000FF',
	    strokeWeight: 0.5,
	    fillColor: '#0000FF',
	    fillOpacity: 0.2,
	    editable: false,
	    draggable: false
	  });
  
  rectangle_qld = new google.maps.Rectangle({
	    bounds: bounds_qld,
	    strokeColor: '#0000FF',
	    strokeWeight: 0.5,
	    fillColor: '#0000FF',
	    fillOpacity: 0.2,
	    editable: false,
	    draggable: false
	  });
  
  rectangle_tas = new google.maps.Rectangle({
	    bounds: bounds_tas,
	    strokeColor: '#0000FF',
	    strokeWeight: 0.5,
	    fillColor: '#0000FF',
	    fillOpacity: 0.2,
	    editable: false,
	    draggable: false
	  });
  
  rectangle_wa = new google.maps.Rectangle({
	    bounds: bounds_wa,
	    strokeColor: '#0000FF',
	    strokeWeight: 0.5,
	    fillColor: '#0000FF',
	    fillOpacity: 0.2,
	    editable: false,
	    draggable: false
	  });
  
  rectangle_nt = new google.maps.Rectangle({
	    bounds: bounds_nt,
	    strokeColor: '#0000FF',
	    strokeWeight: 0.5,
	    fillColor: '#0000FF',
	    fillOpacity: 0.2,
	    editable: false,
	    draggable: false
	  });
  
  
  rectangle_sa.setMap(map);
  rectangle_nsw.setMap(map);
  rectangle_vic.setMap(map);
  rectangle_qld.setMap(map);
  rectangle_tas.setMap(map);
  rectangle_wa.setMap(map);
  rectangle_nt.setMap(map);
  

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
                                <div class="muted pull-left">Traveling Pattern <small>(over the time)</small></div>
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
		                                            <span class="label label-info">Blue</span> = Outside SA, <span class="label label-important">Red</span> = SA
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
                                <div class="muted pull-left">South Australia Residences traveling outside the state</div>
                                <div class="pull-right"><span class="badge badge-warning">View More</span>

                                </div>
                            </div>
                            <div class="block-content collapse in">
                                <div class="span12">
                                    <div id="statewisecompare-graph" style="height: 230px;"></div>
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
                                <div class="muted pull-left">South Australia Residences traveling outside the state</div>
                                <div class="pull-right"><span class="badge badge-warning">View More</span>

                                </div>
                            </div>
                            <div class="block-content collapse in">
                                <div class="span12">
                                    <div id="statewisecompare-graph2" style="height: 230px;"></div>
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
                                    <h5>Top  5 Trends in SA</h5>
                                    <div id="SA-bar" style="height: 250px;"></div>
                                </div>
                                <div class="span6 chart">
                                    <h5>Top 5 Trends in NSW</h5>
                                    <div id="NSW-bar" style="height: 250px;"></div>
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
            element: 'SA-bar',
            data: [
					<% 
					for(TweetCount count : tweetcount_list_sa){
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
    
    // Morris Bar Chart
    Morris.Bar({
        element: 'NSW-bar',
        data: [
				<% 
				for(TweetCount count : tweetcount_list_nsw){
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
        var line_chart2 = [
            <%
                          		for(TweetSentiment sentiment_nsw  : sentiment_list_nsw){
                          			Date temp_date = sentiment_nsw.getDate();
                          			out.print("{\"period\": \""+ dateFormat.format(temp_date) +"\", " +
                          					"\"tweetsNSW\": " + sentiment_nsw.countTotalTweets() + ", ");
                          			for(TweetSentiment sentiment_vic  : sentiment_list_vic){
                          				if(temp_date.equals(sentiment_vic.getDate())){
                          					out.print("\"tweetsVIC\": " + sentiment_vic.countTotalTweets() + ", ");
                          				}
                          			}
                          			for(TweetSentiment sentiment_qld  : sentiment_list_qld){
                          				if(temp_date.equals(sentiment_qld.getDate())){
                          					out.print("\"tweetsQLD\": " + sentiment_qld.countTotalTweets() + ", ");
                          				}
                          			}
                          			for(TweetSentiment sentiment_tas  : sentiment_list_tas){
                          				if(temp_date.equals(sentiment_tas.getDate())){
                          					out.print("\"tweetsTAS\": " + sentiment_tas.countTotalTweets() + ", ");
                          				}
                          			}
                          			for(TweetSentiment sentiment_wa  : sentiment_list_wa){
                          				if(temp_date.equals(sentiment_wa.getDate())){
                          					out.print("\"tweetsWA\": " + sentiment_wa.countTotalTweets() + ", ");
                          				}
                          			}
                          			for(TweetSentiment sentiment_nt  : sentiment_list_nt){
                          				if(temp_date.equals(sentiment_nt.getDate())){
                          					out.println("\"tweetsNT\": " + sentiment_nt.countTotalTweets() + "}, ");
                          				}
                          			}
                          		}
                          
            %>
        ];
        Morris.Area({
            element: 'statewisecompare-graph',
            data: line_chart2,
            xkey: 'period',
            xLabels: "day",
            ykeys: ['tweetsNSW','tweetsVIC','tweetsQLD','tweetsTAS','tweetsWA','tweetsNT'],
            labels: ['NSW','VIC','QLD','TAS','WA','NT']
        });
        
        var line_chart3 = [
                           <%
                                         		for(TweetSentiment sentiment_sa  : sentiment_list_sa){
                                         			Date temp_date = sentiment_sa.getDate();
                                         			out.print("{\"period\": \""+ dateFormat.format(temp_date) +"\", " +
                                         					"\"tweetsSA\": " + sentiment_sa.countTotalTweets() + ", ");
                                         			int outside_SA = 0;
                                         			for(TweetSentiment sentiment_vic  : sentiment_list_vic){
                                         				if(temp_date.equals(sentiment_vic.getDate())){
                                         					outside_SA += sentiment_vic.countTotalTweets();
                                         				}
                                         			}
                                         			for(TweetSentiment sentiment_qld  : sentiment_list_qld){
                                         				if(temp_date.equals(sentiment_qld.getDate())){
                                         					outside_SA += sentiment_qld.countTotalTweets();
                                         				}
                                         			}
                                         			for(TweetSentiment sentiment_tas  : sentiment_list_tas){
                                         				if(temp_date.equals(sentiment_tas.getDate())){
                                         					outside_SA += sentiment_tas.countTotalTweets();
                                         				}
                                         			}
                                         			for(TweetSentiment sentiment_wa  : sentiment_list_wa){
                                         				if(temp_date.equals(sentiment_wa.getDate())){
                                         					outside_SA += sentiment_wa.countTotalTweets();
                                         				}
                                         			}
                                         			for(TweetSentiment sentiment_nt  : sentiment_list_nt){
                                         				if(temp_date.equals(sentiment_nt.getDate())){
                                         					outside_SA += sentiment_nt.countTotalTweets();
                                         				}
                                         			}
                                         			out.println("\"tweetsOutsideSA\": " + outside_SA + "}, ");
                                         		}
                                         
                           %>
                       ];
        
        
        
        Morris.Line({
            element: 'statewisecompare-graph2',
            data: line_chart3,
            xkey: 'period',
            xLabels: "day",
            ykeys: ['tweetsSA','tweetsOutsideSA'],
            labels: ['SA','OUTSIDE']
        });
        });

        </script>
    </body>

</html>