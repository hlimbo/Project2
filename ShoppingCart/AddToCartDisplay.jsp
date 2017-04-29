<%@ page import="java.util.*" %>

<HTML>
	<HEAD>
		<TITLE>Add To Cart</TITLE>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
	</HEAD>
	
	<BODY>	
		
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
		<% ArrayList<Integer> cart = (ArrayList<Integer>)session.getAttribute("cartList"); %>	
		<tbody>
			<tr>
				<% if ( cart != null && !cart.isEmpty() ) { %>
				<% for (Integer item : cart){ %>
					<td></td>
					<td></td>
					<td></td>
				<% } } else { %>
					<td>#</td>
					<td>Empty</td>
					<td>0.00</td>
					<td>0</td>	
				<% } %>
			</tr>
		</tbody>
		</table>
		
		<hr>
		
		<!-- TODO(Harvey): Might change back to GET request in order to retrieve the items that will be bought from cart -->
		<form action="CheckoutDisplay.jsp" method="GET">
			<button name="checkout">Continue To Checkout</button>
		</form>
	</BODY>
</HTML>