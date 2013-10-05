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
                element: 'city-bar',
                data: [
                       {topic: 'AFL', percentage: 67},
                       {topic: 'Chick', percentage: 35},
                       {topic: 'Uni', percentage: 20},
                       {topic: 'Job', percentage: 10},
                       {topic: 'Sexy', percentage: 5}
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
                   {topic: 'AFL', percentage: 67},
                   {topic: 'Chick', percentage: 35},
                   {topic: 'Uni', percentage: 20},
                   {topic: 'Job', percentage: 10},
                   {topic: 'Sexy', percentage: 5}
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
            element: 'SA-bar',
            data: [
                   {topic: 'AFL', percentage: 67},
                   {topic: 'Chick', percentage: 35},
                   {topic: 'Uni', percentage: 20},
                   {topic: 'Job', percentage: 10},
                   {topic: 'Sexy', percentage: 5}
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
               {topic: 'AFL', percentage: 67},
               {topic: 'Chick', percentage: 35},
               {topic: 'Uni', percentage: 20},
               {topic: 'Job', percentage: 10},
               {topic: 'Sexy', percentage: 5}
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
            {"period": "2013-04", "tweetsCity": 2407, "tweetsRural": 660},
            {"period": "2013-03", "tweetsCity": 3351, "tweetsRural": 729},
            {"period": "2013-02", "tweetsCity": 2469, "tweetsRural": 1318},
            {"period": "2013-01", "tweetsCity": 2246, "tweetsRural": 461},
            {"period": "2012-12", "tweetsCity": 3171, "tweetsRural": 1676},
            {"period": "2012-11", "tweetsCity": 2155, "tweetsRural": 681},
            {"period": "2012-10", "tweetsCity": 1226, "tweetsRural": 620},
            {"period": "2012-09", "tweetsCity": 2245, "tweetsRural": 500}
        ];
        Morris.Line({
            element: 'citywisecompare-graph',
            data: line_chart,
            xkey: 'period',
            xLabels: "month",
            ykeys: ['tweetsCity', 'tweetsRural'],
            labels: ['Adelaide City', 'Rural']
        });
        
        // Morris Line Chart
        var line_chart2 = [
            {"period": "2013-04", "tweetsSA": 2407, "tweetsNSW": 660},
            {"period": "2013-03", "tweetsSA": 3351, "tweetsNSW": 729},
            {"period": "2013-02", "tweetsSA": 2469, "tweetsNSW": 1318},
            {"period": "2013-01", "tweetsSA": 2246, "tweetsNSW": 461},
            {"period": "2012-12", "tweetsSA": 3171, "tweetsNSW": 1676},
            {"period": "2012-11", "tweetsSA": 2155, "tweetsNSW": 681},
            {"period": "2012-10", "tweetsSA": 1226, "tweetsNSW": 620},
            {"period": "2012-09", "tweetsSA": 2245, "tweetsNSW": 500}
        ];
        Morris.Line({
            element: 'statewisecompare-graph',
            data: line_chart2,
            xkey: 'period',
            xLabels: "month",
            ykeys: ['tweetsSA', 'tweetsNSW'],
            labels: ['SA', 'NSW']
        });



        </script>
    </body>

</html>