<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>



<HTML>
	<HEAD>
		<TITLE>Add To Cart</TITLE>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
	</HEAD>
	
	<BODY>	
		
		<!-- HARDCODING... -->
		<% String loginUser = "user"; %>
		<% String loginPasswd = "password"; %>
		<% String loginUrl = "jdbc:mysql://localhost:3306/gamedb"; %>
		<% Connection dbcon = null; %>
		<% try { %>
		<% Class.forName("com.mysql.jdbc.Driver").newInstance(); %>
		<% dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd); %>
		<% } catch (SQLException e) { %>
		<% e.printStackTrace(); } %>
		
		<!--TODO(HARVEY): turn this into a list instead -->
		<% session.setAttribute("game_name", request.getParameter("game_name")); %> 
		<% session.setAttribute("price", request.getParameter("name")); %> 
		<% session.setAttribute("quantity", request.getParameter("quantity")); %>
	
		<H1>Shopping Cart</H1>
		
		<table class="table">
		<thead>
			<th>ID</th>
			<th>Game Name</th>
			<th>Price</th>
			<th>Quantity</th>
		</thead>
		
		<!-- TODO(HARVEY): get from session a list of items via id registered user added to his/her cart. -->
		<% ArrayList<String> cart = (ArrayList<String>)session.getAttribute("cartList"); %>	
		<tbody>
			
				<% if ( cart != null && !cart.isEmpty() ) { %>
				<% for (String item : cart){ %>
				<% String itemQuery = "SELECT * FROM games WHERE id=?"; %>
				<% PreparedStatement statement = dbcon.prepareStatement(itemQuery); %>
				<% statement.setInt(1,Integer.valueOf(item)); %>
				<% ResultSet set = statement.executeQuery(); %>
					<% if(set.next()) { %>
					<tr>
						<td><%= item %></td>
						<td> <%= set.getString("name") %> </td>
						<td> <%= set.getInt("price") %> </td>
						<td> 1 </td>
					</tr>
					<% } %>
				<% } } else { %>
				<tr>
					<td>#</td>
					<td>Empty</td>
					<td>0.00</td>
					<td>0</td>	
				</tr>
				<% } %>
		</tbody>
		</table>
		
		<hr>
		
		<!-- TODO(Harvey): Might change back to GET request in order to retrieve the items that will be bought from cart -->
		<form action="/CustomerInformation/index.jsp" method="GET">
			<button name="checkout">Continue To Checkout</button>
		</form>
	</BODY>
</HTML>
