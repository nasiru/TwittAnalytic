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
	List<TweetCount> tweetcount_list_sa = db.getTopKHashTag(5, south_aus, start_date, end_date);
	List<TweetCount> tweetcount_list_nsw = db.getTopKHashTag(5, nsw, start_date, end_date);
%>


<!DOCTYPE html>
<html class="no-js">
    
    <head>
        <title>Stats Sample</title>
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
                                <div class="muted pull-left"> South Australia vs <small>NSW Tweets</small></div>
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
            <footer>
                <p>Big Data Cracker Team 2013</p>
            </footer>
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

        <script src="assets/scripts.js"></script>
        <script>
        $(function() {
        
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
                          		for(TweetSentiment sentiment_sa  : sentiment_list_sa){
                          			Date temp_date = sentiment_sa.getDate();
                          			out.print("{\"period\": \""+ dateFormat.format(temp_date) +"\", " +
                          					"\"tweetsSA\": " + sentiment_sa.countTotalTweets() + ", ");
                          			for(TweetSentiment sentiment_nsw  : sentiment_list_nsw){
                          				if(temp_date.equals(sentiment_nsw.getDate())){
                          					out.println("\"tweetsNSW\": " + sentiment_nsw.countTotalTweets() + "}, ");
                          				}
                          			}
                          		}
                          
            %>
        ];
        Morris.Line({
            element: 'statewisecompare-graph',
            data: line_chart2,
            xkey: 'period',
            xLabels: "month",
            ykeys: ['tweetsSA', 'tweetsNSW'],
            labels: ['SA', 'NSW']
        });
        });

        </script>
    </body>

</html>