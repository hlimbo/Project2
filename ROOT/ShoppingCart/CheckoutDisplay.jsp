<!DOCTYPE html>
<html>
<head>
	<title>Customer Info</title>
	<!-- create Customer.css later -->
	<link rel="stylesheet" type="text/css" href="Customer.css">
	<link rel="stylesheet" type="text/css" href="bootstrap.css">
</head>
<body>
	<h1>Customer Info</h1>
	<!-- url pattern todo here! -->
	<form name="form1" action="confirmationPage.jsp" METHOD="POST">
		<div>
			<label>First Name:</label>
			<input name="first_name" type="text"  required>
		</div>
		<div>
			<label>Last Name:</label>
			<input name="last_name" type="text" required>
		</div>
		<div>
			<label>Credit Card Number:</label>
			<input name="cc_id" type="text" required>	
		</div>
		<div>
			<label>Expiration Date:</label>
			<input name="expiration" type="text" required>
		</div>
		<input type="submit" value="Confirm Purchase">
	</form>
	
	
</body>
</html>