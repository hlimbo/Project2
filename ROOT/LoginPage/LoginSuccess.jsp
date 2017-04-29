<HTML>
	<HEAD>
		<TITLE>Games Station | Main</TITLE>
	</HEAD>
	
	<BODY>
		<h1>Games Station Main Page</h1>
		<% if ( session.getAttribute("first_name") == null) { %>
			name is null
		<% } %>
		<p> Welcome, <%= (String)session.getAttribute("first_name") %>! </p>
	<div>
		<a href="../search/search.jsp">Search Games</a>  | 
		<a href="BrowseGamesTemplate.html">Browse Games</a>
	</div>
		
	</BODY>
</HTML>