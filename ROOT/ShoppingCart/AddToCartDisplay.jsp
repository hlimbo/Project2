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
			
			.total
			{
				text-align: right;
				font-weight: bold;
				font-size: 24;
				padding-right: 12;
			}
			.qtextbox
			{
				width: 30px;
				text-align: center;
			}
			.qControlBox
			{
				display: inline;
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
		
		<% HashMap<String,Integer> cart = (HashMap<String,Integer>)session.getAttribute("cartList"); %>	
		<% int totalCost = 0; %>
		<tbody>
			
				<% if ( cart != null && !cart.isEmpty() ) { %>
				<% for (Map.Entry<String,Integer> item : cart.entrySet()){ %>
				<% String itemQuery = "SELECT * FROM games WHERE id=?"; %>
				<% PreparedStatement statement = dbcon.prepareStatement(itemQuery); %>
				<% statement.setInt(1,Integer.valueOf(item.getKey())); %>
				<% ResultSet set = statement.executeQuery(); %>
					<% if(set.next()) { %>
					<tr>
						<td><%= item.getKey() %></td>
						<td> <%= set.getString("name") %> </td>
						<td> <%= set.getInt("price") %> </td>
						<td> 
							<span>
								<input class="qtextbox" type="text" name="quantity" value=<%= item.getValue() %>>
								
								<form class="qControlBox" name="updateForm" action="/ShoppingCart/update-quantity" method="GET">
									<input type="hidden" name="itemID" value=<%= item.getKey() %> >
									<input type="hidden" name="updateFlag" value="increment" >
									<button name="quantity ">+</button>
								</form>
								<form class="qControlBox" name="updateForm" action="/ShoppingCart/update-quantity" method="GET">
									<input type="hidden" name="itemID" value=<%= item.getKey() %> >
									<input type="hidden" name="updateFlag" value="decrement" >
									<button id="q2" name="quantity ">-</button>
								</form>
							</span>
						</td>
						<td> 
							<form name="deleteForm" action="/ShoppingCart/delete-item" method="GET">
								<input type="hidden" name="itemID" value=<%= item.getKey() %> >
								<button name="deleteItem"> Delete </button>
							</form>
						</td>
					</tr>
					
					<!-- calculate total cost here -->
					<% totalCost += set.getInt("price") * item.getValue(); %>
					<% } %>
				<% } } else { %>
				<tr>
					<p> Cart is Empty </p>
				</tr>
				<% } %>
				
				<% dbcon.close(); %>
		</tbody>
		</table>
		
		<hr>
		
		<!-- only display the checkout button if the cart is not empty -->
		<% if (cart != null && !cart.isEmpty() ) { %>
			<span>
				<form action="/CustomerInformation/index.jsp" method="GET">
					<button name="checkout">Continue To Checkout</button>
				</form>
				<!-- display total cost -->
				<p class="total">Total Cost: $<%= totalCost %>.00</p>
			</span>
			
			<!-- clearing the cart contents -->
			<form action="/ShoppingCart/clear-cart" method="GET">
				<button name="clearCart">Clear Cart</button>
			</form>
		<% } %>
		
		<!-- back to previous page -->
		<% if( request.getParameter("previousPage") != null ){%>
			<form action=<%= request.getParameter("previousPage") %> method="GET">
				<button name="backToPrev">Back to Previous Page</button>
			</form>
		<% } %>
		
		<!-- back to home page -->
		<form action="/index.jsp" method="GET">
			<button name="backToHome">Back to Home</button>
		</form>
		
	</BODY>
</HTML>