<%--
Licensed to the Apache Software Foundation (ASF) under one or more
contributor license agreements.  See the NOTICE file distributed with
this work for additional information regarding copyright ownership.
The ASF licenses this file to You under the Apache License, Version 2.0
(the "License"); you may not use this file except in compliance with
the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" 
    import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Welcome</title>
        <link href="/tomcat.css" rel="stylesheet" type="text/css" />
    </head>

    <body>
        <% if (session.getAttribute("first_name") != null) { %>
            Browse by 
        <ul>
            <%  ArrayList<String> tables = new ArrayList<String>();
                tables.add("genres");
                tables.add("publishers");
                tables.add("platforms");
                tables.add("games");
                for (String table : tables) { %>
                <li><a href="/search/query?table="<%= table %>><%= table %></a>
                    <ul>
                        <% for (char firstLetter = 'a';firstLetter<='z';++firstLetter) { 
                            String column;
                            if (table.compareToIgnoreCase("games")!=0) { 
                                column = table.substring(0,table.length()-1);
                            } else { 
                                column = "name";
                            } %>
                            <%= "<li><a href=\"search/query?table="+table+"&columnName="+column
                                +"&"+column+"="+firstLetter+"%25&match=true\" >"+(""+firstLetter).toUpperCase()
                                +"</a></li>" %>
                        <% } %>
                    </ul>
                </li>
            <% } %>
        </ul>
            Search
            <jsp:include page="search/search.jsp" />
        <% } else { %>
            <a href="/LoginPage">Login</a> 
        <% } %>
    </body>
</html>
