<HTML>
	<HEAD>
		<TITLE>Login Success!</TITLE>
	</HEAD>
	
	<BODY>
		<H1>Login Successful</H1>
		<% if ( session.getAttribute("first_name") == null) { %>
			name is null
		<% } %>
		<p> Welcome, <%= (String)session.getAttribute("first_name") %>! </p>
	</BODY>
</HTML>