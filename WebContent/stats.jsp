<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="SimpleCouchDB.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="org.lightcouch.CouchDbException" %>

<%
	Date start_date = new SimpleDateFormat("dd/MM/yyyy").parse("20/09/2013");
	Date end_date = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss").parse("25/09/2013 23:59:59");

	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat dateFormat2 = new SimpleDateFormat("dd/MM/yyyy");

	List<TweetCount> counts;
	//Access DB and retrive the count for everyday
	CouchDB db = new CouchDB();
			
	if(request.getParameter("start_date") != null && request.getParameter("end_date") != null){
		start_date = new SimpleDateFormat("dd/MM/yyyy").parse( request.getParameter("start_date") );
		end_date = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss").parse( request.getParameter("end_date") + " 23:59:59");
		counts = db.countDailyTweet(start_date, end_date);
	}
	else{
		counts = db.countDailyTweet(start_date, end_date);
		
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
		                                            <button type="submit" class="btn btn-primary">Submit</button>
		                                          </div>
		                                    </div>
		                                </fieldset>
		                            </form>
		                        </div>
                            
                                <div class="span12">
                                    <div id="hero-graph" style="height: 300px;"></div>
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
        // Morris Line Chart
        var tax_data = [
                        <%
                        for(int i=0;i<counts.size();i++){
                        	TweetCount count = counts.get(i);
                        	if(i!=counts.size()-1){
                        		out.println(" {\"period\": \"" + dateFormat.format(count.getDate()) + "\", "  
                						+ "\"tweets\": "+ count.getCount() +"},");
                        	}
                        	else{
                        		out.println(" {\"period\": \"" + dateFormat.format(count.getDate()) + "\", "  
                						+ "\"tweets\": "+ count.getCount() +"}");
                        	}
                        }
                       //for(TweetCount count : counts){
                        %>
            
        ];
        Morris.Line({
            element: 'hero-graph',
            data: tax_data,
            xkey: 'period',
            xLabels: "day",
            ykeys: ['tweets'],
            labels: ['Tweets', 'User signups']
        });

        
        </script>
    </body>

</html>