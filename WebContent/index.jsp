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
	                                <div class="pull-right">Total Tweets <span class="badge badge-info">1,234</span></div>
	                            </div>
	                            <div class="block-content collapse in">
	                                <div class="span5">
	                                    <div class="easypiechart" data-percent="73">73%</div>
	                                    <div class="chart-bottom-heading"><span class="label label-info">Retweet</span>
	
	                                    </div>
	                                </div>
	                                <div class="span5">
	                                    <div class="easypiechart" data-percent="53">53%</div>
	                                    <div class="chart-bottom-heading"><span class="label label-info">Original</span>
	
	                                    </div>
	                                </div>
	                            </div>
							</div>
						</div>	
                        <div class="span6">
                            <!-- block -->
	                        <div class="block">
	                            <div class="navbar navbar-inner block-header">
	                                <div class="muted pull-left">From Date - To Date</div>
	                                <div class="pull-right">Total Tweets <span class="badge badge-info">1,234</span></div>
	                            </div>
                                <div class="block-content collapse in">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>Total Tweets</th>
                                                <th>Number</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Total Retweets</td>
                                                <td>Number</td>
                                            </tr>
                                        </tbody>
                                        <tbody>
                                            <tr>
                                                <td>Total Retweeters</td>
                                                <td>Number</td>
                                            </tr>
                                        </tbody>
                                        <tbody>
                                            <tr>
                                                <td>Tweeters Per day</td>
                                                <td>Number</td>
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
                                <div class="span10 chart">
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
                {date: '04/08/2013', numOfTweet: 500},
                {date: '04/09/2013', numOfTweet: 2000},
                {date: '04/10/2013', numOfTweet: 800},
                {date: '04/11/2013', numOfTweet: 400},
                {date: '04/12/2013', numOfTweet: 500},
                {date: '04/01/2014', numOfTweet: 1571}
            ],
            xkey: 'date',
            ykeys: ['numOfTweet'],
            labels: ['numOfTweet'],
            barRatio: 0.4,
            xLabelMargin: 10,
            hideHover: 'auto',
            barColors: ["#3d88ba"]
        });
        
        // Morris Bar Chart
        Morris.Bar({
            element: 'happy-bar',
            data: [
                {userId: 'userId1', numOfTweet: 2000},
                {userId: 'userId2', numOfTweet: 1800},
                {userId: 'userId3', numOfTweet: 800},
                {userId: 'userId4', numOfTweet: 400},
                {userId: 'userId5', numOfTweet: 200}
            ],
            xkey: 'userId',
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
                {label: 'Happy', value: 50 },
                {label: 'Unhappy', value: 40 },
                {label: 'So-so', value: 10 }
            ],
            colors: ["#30a1ec", "#76bdee", "#c4dafe"],
            formatter: function (y) { return y + "%" }
        });
        
        // Morris Bar Chart
        Morris.Bar({
            element: 'unhappy-bar',
            data: [
                {userId: 'userId1', numOfTweet: 2000},
                {userId: 'userId2', numOfTweet: 1800},
                {userId: 'userId3', numOfTweet: 800},
                {userId: 'userId4', numOfTweet: 400},
                {userId: 'userId5', numOfTweet: 200}
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
                {userId: 'userId1', numOfTweet: 2000},
                {userId: 'userId2', numOfTweet: 1800},
                {userId: 'userId3', numOfTweet: 800},
                {userId: 'userId4', numOfTweet: 400},
                {userId: 'userId5', numOfTweet: 200}
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
                {userId: 'userId1', numOfTweet: 2000},
                {userId: 'userId2', numOfTweet: 1800},
                {userId: 'userId3', numOfTweet: 800},
                {userId: 'userId4', numOfTweet: 400},
                {userId: 'userId5', numOfTweet: 200}
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