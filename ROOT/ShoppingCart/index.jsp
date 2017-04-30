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
				<th>Game Name</th>
				<th>Price</th>
				<th>Quantity</th>
			</tr>
		</thead>
		
		<!-- temp code -->
		<% session.setAttribute("game_name", "Doom 3"); %>
		<% session.setAttribute("price", 29.99f); %>
		<% session.setAttribute("quantity", 1); %>
		
		<!-- keep track of shopping cart contents cached with using session key  -->
		<!--- session key holds values to shopping cart and login info -->
		<tbody>
			<!-- TODO: create shopping cart button functionality -->
			<tr>
				<td> <%= session.getAttribute("game_name") %></td>
				<td> <%= session.getAttribute("price") %></td>
				<td> <%= session.getAttribute("quantity") %></td>
			</tr>
		</tbody>
	</table>
	
	<br><br>
	
	<!-- todo: make xml page for this transition -->
	<form action="/ShoppingCart/servlet/ShoppingCart" METHOD="GET">
	<button name="submit">Go to Checkout</button>
	</form>
	
	
</body>
</html>