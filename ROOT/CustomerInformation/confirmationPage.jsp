<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>

<HTML>
	<HEAD>
		<TITLE>Confirmation Page</TITLE>
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
	
	
		<H1>Confirmation Page</H1>
		<p> <%= session.getAttribute("first_name") %>, You bought something special </p>
		<% if (session.getAttribute("cartList") == null) { %>
			<p> Shopping cart is empty!!!!!! </p>
		<% }  else { %>
		
		<table class="table">
		<thead>
			<th>ID</th>
			<th>Game Name</th>
			<th>Price</th>
			<th>Quantity</th>
		</thead>
		
		<tbody>
		<% ArrayList<String> cart = (ArrayList<String>)session.getAttribute("cartList"); %>	
		<% String itemQuery = "SELECT * FROM games WHERE id=?"; %>
		<% PreparedStatement statement = dbcon.prepareStatement(itemQuery); %>
		<% for(String itemID : cart) { %>
			<% statement.setInt(1, Integer.valueOf(itemID)); %>
			<% ResultSet set = statement.executeQuery(); %>
			<% if(set.next()) { %>
				<tr>
					<td><%= itemID %></td>
					<td><%= set.getString("name") %> </td>
					<td><%= set.getInt("price") %> </td>
				</tr>
			<% } } %>
		
		</tbody>
		</table>
		
			<!-- clear the cart after successful purchase -->
			<% cart.clear(); %>
			<% cart = null; %>
			<% session.setAttribute("cartList", null); %>
		
		<% } %>
		
	</BODY>
</HTML>