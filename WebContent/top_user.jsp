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
	int topK = 10;

	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat dateFormat2 = new SimpleDateFormat("dd/MM/yyyy");

	UserStatList list;
	List<UserStat> top_positive_users;
	List<UserStat> top_negative_users;
	List<UserStat> top_neutral_users;
	List<UserStat> top_frequent_users;
	
	//Access DB and retrive the count for everyday
	CouchDB db = new CouchDB();
	String c_filename = getServletContext().getRealPath("classifier/classifier.txt");
			
	if(request.getParameter("start_date") != null && request.getParameter("end_date") != null){
		start_date = new SimpleDateFormat("dd/MM/yyyy").parse( request.getParameter("start_date") );
		end_date = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss").parse( request.getParameter("end_date") + " 23:59:59");
	}
	if(request.getParameter("top_k") != null){
		topK = Integer.parseInt(request.getParameter("top_k"));
	}
	
	list = db.getTopUser(c_filename, start_date, end_date);
	top_positive_users = list.getListSortedByPos(topK);
	top_negative_users = list.getListSortedByNeg(topK);
	top_neutral_users = list.getListSortedByNeu(topK);
	top_frequent_users = list.getListSortedByTotalTweet(topK);
	
%>

<!DOCTYPE html>
<html>
    
    <head>
        <title>Tables</title>
        <!-- Bootstrap -->
        <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen">
        <link href="bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet" media="screen">
        <link href="assets/styles.css" rel="stylesheet" media="screen">
        <link href="assets/DT_bootstrap.css" rel="stylesheet" media="screen">
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
		                                          <label class="control-label" for="typeahead">Top K </label>
		                                          <div class="controls">
		                                            <input type="text" id="date02" name="top_k" value="<%= topK %>">
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
                            </div>
                        </div>
                        <!-- /block -->
                    </div>

                    
                    <div class="row-fluid">
                    <div class="span6">
                        <!-- block -->
                        <div class="block">
                            <div class="navbar navbar-inner block-header">
                                <div class="muted pull-left">Top frequent users</div>
                            </div>
                            <div class="block-content collapse in">
                                <div class="span12">
  									<table class="table">
						              <thead>
						                <tr>
						                  <th>Ranking</th>
						                  <th>Screen Name</th>
						                  <th>Total Tweets</th>
						                </tr>
						              </thead>
						              <tbody>
						              	<% 
						              	
						              	for(int i=1;i<=top_frequent_users.size();i++){ 
						              	%>
						                <tr>
						                  <td><%= i %></td>
						                  <td><a href="trackuser.jsp?user=<%= top_frequent_users.get(i-1).getScreen_name() %>&start_date=<%= dateFormat2.format(start_date) %>&end_date=<%= dateFormat2.format(end_date) %>&limit=100"><%= top_frequent_users.get(i-1).getScreen_name() %></a></td>
						                  <td><%= top_frequent_users.get(i-1).getAll_tweet() %></td>
						                </tr>
						                <%} %>
						                
						              </tbody>
						            </table>
                                </div>
                            </div>
                        </div>
                        <!-- /block -->
                        </div>
                    
                    
                    
                    <div class="span6">
                        <!-- block -->
                        <div class="block">
                            <div class="navbar navbar-inner block-header">
                                <div class="muted pull-left">Top so-so users</div>
                            </div>
                            <div class="block-content collapse in">
                                <div class="span12">
  									<table class="table">
						              <thead>
						                <tr>
						                  <th>Ranking</th>
						                  <th>Screen Name</th>
						                  <th>Neutral Tweets</th>
						                </tr>
						              </thead>
						              <tbody>
						              	<% 
						              	
						              	for(int i=1;i<=top_neutral_users.size();i++){ 
						              	%>
						                <tr>
						                  <td><%= i %></td>
						                  <td><a href="trackuser.jsp?user=<%= top_frequent_users.get(i-1).getScreen_name() %>&start_date=<%= dateFormat2.format(start_date) %>&end_date=<%= dateFormat2.format(end_date) %>&limit=100"><%= top_neutral_users.get(i-1).getScreen_name() %></a></td>
						                  <td><%= top_neutral_users.get(i-1).getNeutral_tweet() %></td>
						                </tr>
						                <%} %>
						                
						              </tbody>
						            </table>
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
                                <div class="muted pull-left">Top unhappy users</div>
                            </div>
                            <div class="block-content collapse in">
                                <div class="span12">
  									<table class="table">
						              <thead>
						                <tr>
						                  <th>Ranking</th>
						                  <th>Screen Name</th>
						                  <th>Negative Tweets</th>
						                </tr>
						              </thead>
						              <tbody>
						              	<% 
						              	
						              	for(int i=1;i<=top_negative_users.size();i++){ 
						              	%>
						                <tr>
						                  <td><%= i %></td>
						                  <td><a href="trackuser.jsp?user=<%= top_frequent_users.get(i-1).getScreen_name() %>&start_date=<%= dateFormat2.format(start_date) %>&end_date=<%= dateFormat2.format(end_date) %>&limit=100"><%= top_negative_users.get(i-1).getScreen_name() %></a></td>
						                  <td><%= top_negative_users.get(i-1).getNegative_tweet() %></td>
						                </tr>
						                <%} %>
						                
						              </tbody>
						            </table>
                                </div>
                            </div>
                        </div>
                        <!-- /block -->
                        </div>
                    
                    
                    
                    <div class="span6">
                        <!-- block -->
                        <div class="block">
                            <div class="navbar navbar-inner block-header">
                                <div class="muted pull-left">Top happy users</div>
                            </div>
                            <div class="block-content collapse in">
                                <div class="span12">
  									<table class="table">
						              <thead>
						                <tr>
						                  <th>Ranking</th>
						                  <th>Screen Name</th>
						                  <th>Positive Tweets</th>
						                </tr>
						              </thead>
						              <tbody>
						              	<% 
						              	
						              	for(int i=1;i<=top_positive_users.size();i++){ 
						              	%>
						                <tr>
						                  <td><%= i %></td>
						                  <td><a href="trackuser.jsp?user=<%= top_frequent_users.get(i-1).getScreen_name() %>&start_date=<%= dateFormat2.format(start_date) %>&end_date=<%= dateFormat2.format(end_date) %>&limit=100"><%= top_positive_users.get(i-1).getScreen_name() %></a></td>
						                  <td><%= top_positive_users.get(i-1).getPositive_tweet() %></td>
						                </tr>
						                <%} %>
						                
						              </tbody>
						            </table>
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

        <script src="vendors/jquery-1.9.1.js"></script>
        <script src="bootstrap/js/bootstrap.min.js"></script>
        <script src="vendors/datatables/js/jquery.dataTables.min.js"></script>
        <script src="assets/DT_bootstrap.js"></script>
        <!--/.fluid-container-->
        <link rel="stylesheet" href="vendors/morris/morris.css">
		<link href="vendors/datepicker.css" rel="stylesheet" media="screen">
        <link href="vendors/uniform.default.css" rel="stylesheet" media="screen">
        <link href="vendors/chosen.min.css" rel="stylesheet" media="screen">
        
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
        
    </body>

</html>