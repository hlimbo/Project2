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
		<style>
			.error
			{
				color: red;
			}
		</style>
	
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
	
		<H1>Shopping Cart</H1>
		
		<% if ( session.getAttribute("errorString") != null ) { %>	
		<p class="error"> <%= session.getAttribute("errorString") %> </p>
		<% session.setAttribute("errorString", null); } %>
		
		<table class="table">
		<thead>
			<th>ID</th>
			<th>Game Name</th>
			<th>Price</th>
			<th>Quantity</th>
		</thead>
		
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
						<td> <input type="text" name="quantity" value="1"> </td>
						<td> 
							<form action="/ShoppingCart/delete-item" method="GET">
								<input type="hidden" name="itemID" value=<%= item %> >
								<button name="deleteItem"> Delete </button>
							</form>
						</td>
					</tr>
					<% } %>
				<% } } else { %>
				<tr>
					<p> Cart is Empty </p>
				</tr>
				<% } %>
		</tbody>
		</table>
		
		<hr>
		
		<!-- only display the checkout button if the cart is not empty -->
		<% if (cart != null && !cart.isEmpty() ) { %>
			<form action="/CustomerInformation/index.jsp" method="GET">
				<button name="checkout">Continue To Checkout</button>
			</form>
			
			<!-- clearing the cart contents -->
			<form action="/ShoppingCart/clear-cart" method="GET">
				<button name="clearCart">Clear Cart</button>
			</form>
		<% } %>
		
		<!-- back to home page -->
		<form action="/index.jsp" method="GET">
			<button name="backToHome">Back to Home</button>
		</form>
		
	</BODY>
</HTML>