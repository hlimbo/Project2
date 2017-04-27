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
			<input type="hidden" name="first_name">
			<input id="first_name" name="first_name" type="text" required>
		</div>
		<div>
			<label>Last Name:</label>
			<input type="hidden" name="last_name">
			<input id="last_name" name="last_name" type="text" required>
		</div>
		<div>
			<label>Address:</label>
			<input type="hidden" name="address">
			<input id="address" name="address" type="text" required>
		</div>
		<div>
			<label>City:</label>
			<input type="hidden" name="city">
			<input id="city" name="city" type="text" required>
		</div>
		<div>
			<label>Zip Code:</label>
			<input type="hidden" name="zip">
			<input id="zip" name="zip" type="text" required>
		</div>
		<div>
			<label>Credit Card Number:</label>
			<input type="hidden" name="cc_id">
			<input id="cc_id" name="cc_id" type="text" required>	
		</div>
		<input type="button" value="Confirm Purchase" onclick="OnConfirmPurchase()">
	</form>
	
	<script language="JavaScript">
		function OnConfirmPurchase()
		{
			document.form1.first_name.value = document.getElementById("first_name").value;
			document.form1.last_name.value = document.getElementById("last_name").value;
			document.form1.address.value = document.getElementById("address").value;
			document.form1.city.value = document.getElementById("city").value;
			document.form1.cc_id.value = document.getElementById("cc_id").value;
			
			//get value from 
			form1.submit();
		}
	</script>	
	
	
</body>
</html>