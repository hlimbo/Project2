<!DOCTYPE html>
<html>
<head>
	<title>Shopping Cart</title>
	<link rel="stylesheet" type="text/css" href="ShoppingCart.css">
	<link rel="stylesheet" type="text/css" href="bootstrap.css">
</head>
<body>
	<h1>Shopping Cart</h1>
	
	<!-- +/- quantity button needs to be added -->
	<table border="5">
		<thead>
			<tr>
				<th>Quantity</th>
				<th>Item Name</th>
				<th>Price</th>
			</tr>
		</thead>
		
		<!-- keep track of shopping cart contents cached with using session key  -->
		<!--- session key holds values to shopping cart and login info -->
		<tbody>
			<!-- TODO: create shopping cart button functionality -->
			<% List<ShoppingCartItems> shopCartItems = session.getAttribute("ShoppingCartItems");
				for(ShoppingCartItems item : shopCartItems){
			%>
			<tr>
				<td><%= item.quantity %></td>
				<td><%= item.name %></td>
				<td><%= item.getTotalPrice %></td>
			</tr>
			<%}%>
		</tbody>
	</table>
	
	<br><br>
	
	<!-- todo: make xml page for this transition -->
	<form action="/servlet/customer-info" METHOD="GET">
	<button name="submit">Go to Checkout</button>
	</form>
	
	
</body>
</html>