<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="SimpleCouchDB.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="org.lightcouch.CouchDbException" %>
<%@ page import="org.joda.time.DateTime" %>
<%@ page import="org.joda.time.Days" %>
<%@ page import="org.joda.time.MutableDateTime" %>

<%
	int over_the_past = 2;

	Date end_date = new Date();
	Date start_date = (new DateTime(end_date)).minusDays(over_the_past).toDate();
	
	int topK = 5;

	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat dateFormat2 = new SimpleDateFormat("dd/MM/yyyy");

	UserStatList list;
	List<UserStat> top_positive_users;
	List<UserStat> top_negative_users;
	List<UserStat> top_neutral_users;
	List<UserStat> top_frequent_users;
	
	List<TweetCount> tweetcount_list;
	
	TweetSentiment avg_sentiment;
	
	int countEnglishTweets = 0;
	int countNonEnglishTweets = 0;
	
	//Access DB and retrive the count for everyday
	CouchDB db = new CouchDB();
	String c_filename = getServletContext().getRealPath("classifier/classifier.txt");
			
	if(request.getParameter("over_the_past") != null){
		over_the_past = Integer.parseInt(request.getParameter("over_the_past"));
		start_date = (new DateTime(end_date)).minusDays(over_the_past).toDate();
	}
	/*if(request.getParameter("top_k") != null){
		topK = Integer.parseInt(request.getParameter("top_k"));
	}*/
	
	//Users Ranking
	list = db.getTopUser(c_filename, start_date, end_date);
	top_positive_users = list.getListSortedByPos(topK);
	top_negative_users = list.getListSortedByNeg(topK);
	top_neutral_users = list.getListSortedByNeu(topK);
	top_frequent_users = list.getListSortedByTotalTweet(topK);
	
	//Average Sentiment
	avg_sentiment = db.getSentiment(c_filename, start_date, end_date);
	
	//The number of total tweet per day
	tweetcount_list = db.countDailyTweet(start_date, end_date);
	countEnglishTweets = db.countEnTweet(start_date, end_date);
	countNonEnglishTweets = db.countNonEnTweet(start_date, end_date);
	int percentEnTweet = (int)Math.round((double)countEnglishTweets/(double)avg_sentiment.countTotalTweets()*(double)100);
	int percentNonEnTweet = (int)Math.round((double)countNonEnglishTweets/(double)avg_sentiment.countTotalTweets()*(double)100);
	
%>

<!DOCTYPE html>
<html class="no-js">
    
    <head>
        <title>Top Level Analysis</title>
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
                    <div class="row-fluid">
                        <div class="span6">
                            <!-- block -->
	                        <div class="block">
	                            <div class="navbar navbar-inner block-header">
	                                <div class="muted pull-left">Tweet vs Retweet Gauge</div>
	                                <span class="pull-right">
	                                	
	                                	<span class="btn-group">
											  <button data-toggle="dropdown" class="btn btn-primary dropdown-toggle">Past <%= over_the_past %> days<span class="caret"></span></button>
											  <ul class="dropdown-menu">
												<li><a href="index.jsp?over_the_past=2">Past 2 days</a></li>
												<li><a href="index.jsp?over_the_past=4">Past 4 days</a></li>
												<li><a href="index.jsp?over_the_past=7">Past 7 days</a></li>
											  </ul>
										</span><!-- /btn-group -->

									</span>
	                            </div>
	                            <div class="block-content collapse in">
	                                <div class="span5">
	                                    <div class="easypiechart" data-percent="<%= percentEnTweet %>"><%= percentEnTweet %>%</div>
	                                    <div class="chart-bottom-heading"><span class="label label-info">English</span>
	
	                                    </div>
	                                </div>
	                                <div class="span5">
	                                    <div class="easypiechart" data-percent="<%= percentNonEnTweet %>"><%= percentNonEnTweet %>%</div>
	                                    <div class="chart-bottom-heading"><span class="label label-info">Non-English</span>
	                                    </div>
	                                </div>
	                            </div>
							</div>
						</div>	
                        <div class="span6">
                            <!-- block -->
	                        <div class="block">
	                            <div class="navbar navbar-inner block-header">
	                                <div class="muted pull-left">From <%= dateFormat2.format(start_date) %> - To <%= dateFormat2.format(end_date) %></div>
	                                <div class="pull-right">Total Tweets <span class="badge badge-info"><%= avg_sentiment.countTotalTweets() %></span></div>
	                            </div>
                                <div class="block-content collapse in">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>Total Tweets</th>
                                                <th><%= avg_sentiment.countTotalTweets() %></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Total English Tweets</td>
                                                <td><%= countEnglishTweets %></td>
                                            </tr>
                                        </tbody>
                                        <tbody>
                                            <tr>
                                                <td>Total Non-English Tweeters</td>
                                                <td><%= countNonEnglishTweets %></td>
                                            </tr>
                                        </tbody>
                                        <tbody>
                                            <tr>
                                                <td>Tweeters Per day</td>
                                                <td><%= avg_sentiment.countTotalTweets()/over_the_past %></td>
                                            </tr>
                                        </tbody>                                        
                                    </table>
                                </div>
							</div>
						</div>						           
                    </div>
                    <div class="row-fluid">
                        <!-- block -->
                        <div class="block">
                            <div class="navbar navbar-inner block-header">
                                <div class="muted pull-left">Tweets by day</div>
                                <div class="pull-right"><span class="badge badge-warning">This is a graph</span>

                                </div>
                            </div>
                            <div class="block-content collapse in">
                                <div class="span6 chart">
                                    <h5>Tweet Stat</h5>
                                    <div id="hero-bar" style="height: 250px;"></div>
                                </div>
                                <div class="span5 chart">
                                    <h5>Average Sentiment</h5>
                                    <div id="hero-donut" style="height: 250px;"></div>    
                                </div>
                            </div>
                            
                        </div>    
                        <!-- block -->
                    </div>                    
                    <div class="row-fluid">
                        <div class="span6">
                            <!-- block -->
                            <div class="block">
                                <div class="navbar navbar-inner block-header">
                                    <div class="muted pull-left">Top 5 Frequent Users</div>
                                    <div class="pull-right"><span class="badge badge-info">1,234</span>

                                    </div>
                                </div>
                                <div class="block-content collapse in">
                                <div class="span12 chart">
                                    <h5>Top influencers</h5>
                                    <div id="topFreq-bar" style="height: 250px;"></div>
                                </div>
                                </div>
                            </div>
                            <!-- /block -->
                        </div>
                        <div class="span6">
                            <!-- block -->
                            <div class="block">
                                <div class="navbar navbar-inner block-header">
                                    <div class="muted pull-left">Top 5 so-so users</div>
                                    <div class="pull-right"><span class="badge badge-info">752</span>

                                    </div>
                                </div>
                                <div class="block-content collapse in">
                                <div class="span10 chart">
                                    <h5>People dont bother a lot</h5>
                                    <div id="neutral-bar" style="height: 250px;"></div>
                                </div>
                                </div>
                            </div>
                            <!-- /block -->
                        </div>
                    </div>
                    <div class="row-fluid">
                        <div class="span6">
                            <!-- block -->
                            <div class="block">
                                <div class="navbar navbar-inner block-header">
                                    <div class="muted pull-left">Top 5 Unhappy Users</div>
                                    <div class="pull-right"><span class="badge badge-warning">Trace Them In Map</span>

                                    </div>
                                </div>
                                <div class="block-content collapse in">
                                <div class="span10 chart">
                                    <h5>People takes life events as negetive</h5>
                                    <div id="unhappy-bar" style="height: 250px;"></div>
                                </div>
                                </div>
                            </div>
                            <!-- /block -->
                        </div>
                        <div class="span6">
                            <!-- block -->
                            <div class="block">
                                <div class="navbar navbar-inner block-header">
                                    <div class="muted pull-left">Top 5 Happy users</div>
                                    <div class="pull-right"><span class="badge badge-warning">Trace Them In Map</span>

                                    </div>
                                </div>
                                <div class="block-content collapse in">
                                <div class="span10 chart">
                                    <h5>People takes life events as positive</h5>
                                    <div id="happy-bar" style="height: 250px;"></div>
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
                <p>Big Data Analytic Project 2013</p>
            </footer>
        </div>
        <!--/.fluid-container-->
       
        <script src="vendors/jquery-1.9.1.min.js"></script>
        <script src="vendors/easypiechart/jquery.easy-pie-chart.js"></script>
        <script src="vendors/jquery.knob.js"></script>

        <link rel="stylesheet" href="vendors/morris/morris.css">
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
            
          // Easy pie charts
          $('.easypiechart').easyPieChart({animate: 1000});
          
       });      
     
           
        // Morris Bar Chart
        Morris.Bar({
            element: 'hero-bar',
            data: [
                   <%
                   		for(TweetCount tweetcount : tweetcount_list){
                   		 out.println("{date: '" + dateFormat2.format(tweetcount.getDate())
							   		+ "', numOfTweet: " + tweetcount.getCount() + "},");
                   		}
                   %>
                
            ],
            xkey: 'date',
            ykeys: ['numOfTweet'],
            labels: ['numOfTweet'],
            barRatio: 0.4,
            xLabelMargin: 10,
            hideHover: 'auto',
            barColors: ["#3d88ba"]
        });
        
        // Morris Donut Chart
        Morris.Donut({
            element: 'hero-donut',
            data: [
                {label: 'Happy', value: <%= avg_sentiment.getPositive() %> },
                {label: 'Unhappy', value: <%= avg_sentiment.getNegative() %> },
                {label: 'So-so', value: <%= avg_sentiment.getNeutral() %> }
            ],
            colors: ["#30a1ec", "#76bdee", "#c4dafe"],
            formatter: function (y) { return Math.round(y*100/<%= avg_sentiment.countTotalTweets() %>) + "%" }
        });
        
     	// Morris Bar Chart
        Morris.Bar({
            element: 'happy-bar',
            data: [
					<%	
					for(UserStat user : top_positive_users){
						   out.println("{userId: '" + user.getScreen_name() 
							   		+ "', numOfTweet: " + user.getPositive_tweet() + "},");
					}
					
					%>
            ],
            xkey: 'userId',
            ykeys: ['numOfTweet'],
            labels: ['numOfTweet'],
            barRatio: 0.4,
            xLabelMargin: 10,
            hideHover: 'auto',
            barColors: ["#3d88ba"]
        });  
        
        // Morris Bar Chart
        Morris.Bar({
            element: 'unhappy-bar',
            data: [
					<%	
					for(UserStat user : top_negative_users){
						   out.println("{userId: '" + user.getScreen_name() 
							   		+ "', numOfTweet: " + user.getNegative_tweet() + "},");
					}
					
					%>
            ],
            xkey: 'userId',
            ykeys: ['numOfTweet'],
            labels: ['numOfTweet'],
            barRatio: 0.4,
            xLabelMargin: 10,
            hideHover: 'auto',
            barColors: ["#3d88ba"]
        }); 
        
        // Morris Bar Chart
        Morris.Bar({
            element: 'neutral-bar',
            data: [
					<%	
					for(UserStat user : top_neutral_users){
						   out.println("{userId: '" + user.getScreen_name() 
							   		+ "', numOfTweet: " + user.getNeutral_tweet() + "},");
					}
					
					%>
            ],
            xkey: 'userId',
            ykeys: ['numOfTweet'],
            labels: ['numOfTweet'],
            barRatio: 0.4,
            xLabelMargin: 10,
            hideHover: 'auto',
            barColors: ["#3d88ba"]
        }); 
        
        // Morris Bar Chart
        Morris.Bar({
            element: 'topFreq-bar',
            data: [
                   <%	
                   for(UserStat user : top_frequent_users){
                	   out.println("{userId: '" + user.getScreen_name() 
                		   		+ "', numOfTweet: " + user.getAll_tweet() + "},");
                   }
                   
                   %>
            ],
            xkey: 'userId',
            ykeys: ['numOfTweet'],
            labels: ['numOfTweet'],
            barRatio: 0.4,
            xLabelMargin: 10,
            hideHover: 'auto',
            barColors: ["#3d88ba"]
        });
      
        </script>
    </body>

</html>