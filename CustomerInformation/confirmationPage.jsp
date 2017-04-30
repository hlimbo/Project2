<HTML>
	<HEAD>
		<TITLE>Confirmation Page</TITLE>
	</HEAD>
	
	<BODY>
		<H1>Confirmation Page</H1>
		<p> <%= session.getAttribute("first_name") %>, You bought something special </p>
		<% if (session.getAttribute("cartList") == null) { %>
			<p> Shopping cart is empty!!!!!! </p>
		<% } %>
	</BODY>
</HTML>