<div class="span3" id="sidebar">
                    <ul class="nav nav-list bs-docs-sidenav nav-collapse collapse">
                        <li <% if(request.getRequestURI().contains("index.jsp")) {out.print("class=\"active\"");}  %>>
                            <a href="index.jsp"><i class="icon-chevron-right"></i> Top Tweets</a>
                        </li>
                        <li <% if(request.getRequestURI().contains("map.jsp")) {out.print("class=\"active\"");}  %>>
                            <a href="map.jsp"><i class="icon-chevron-right"></i> Google Map</a>
                        </li>
                        <li <% if(request.getRequestURI().contains("trackuser.jsp")) {out.print("class=\"active\"");}  %>>
                            <a href="trackuser.jsp"><i class="icon-chevron-right"></i> User Tracking</a>
                        </li>
                        <li <% if(request.getRequestURI().contains("stats.jsp")) {out.print("class=\"active\"");}  %>>
                            <a href="stats.jsp"><i class="icon-chevron-right"></i> Statistics (Tweets)</a>
                        </li>
                        <li <% if(request.getRequestURI().contains("sentiment.jsp")) {out.print("class=\"active\"");}  %>>
                            <a href="sentiment.jsp"><i class="icon-chevron-right"></i> Sentiment Analysis</a>
                        </li>
                        <li <% if(request.getRequestURI().contains("top_user.jsp")) {out.print("class=\"active\"");}  %>>
                            <a href="top_user.jsp"><i class="icon-chevron-right"></i> Top Users</a>
                        </li>
                        <li <% if(request.getRequestURI().contains("statsSample.jsp")) {out.print("class=\"active\"");}  %>>
                            <a href="statsSample.jsp"><i class="icon-chevron-right"></i> Statistics (Amendment)</a>
                        </li>                        
                    </ul>
                </div>