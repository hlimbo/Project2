<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
  <TITLE>Customer Information</TITLE>

  <style>
	input:invalid
	{
		border: 3px solid red;
	}
	input,
	input:validity
	{
		border: 1px solid #ccc;
	}
	.error
	{
		color: red;
	}
  </style>
  
  <script type="text/javascript">
  
	window.onload = function()
	{
		var input = document.getElementById('first_name');
		
		input.oninvalid = function(event)
		{
			event.target.setCustomValidity("First Name should only contain lowercase or uppercase letters. e.g. John");
		}
		
		//clears the custom validity
		input.oninput = function(event)
		{
			event.target.setCustomValidity("");
		}
	}
	
  </script>
  
</HEAD>

<BODY BGCOLOR="#FDF5E6">

<H1 ALIGN="CENTER">Customer Information</H1>



<% String errorMsg = (String)session.getAttribute("invalidFlag"); %>
<%	if (errorMsg != null) { %>
		<p class="error"> <%= errorMsg %> </p>
		<% session.setAttribute("invalidFlag", null); %>
<% } %>


<FORM ACTION="/CustomerInformation/customer-info-confirmation" METHOD="POST">
	
	<div>
		<label>First Name:</label>
		<input type="text" id="first_name" name="first_name" pattern="[A-Za-z]*">
	</div>
	<div>
		<label>Last Name:</label>
		<input type="text" id="last_name" name="last_name" pattern="[A-Za-z]*">
	</div>
	<div>
		<label>Credit Card Number:</label>
		<input name="cc_id" type="text">	
	</div>
	<div>
		<label>Expiration Date:</label>
		<input name="expiration" type="text">
	</div>
	<input type="submit" value="Confirm Purchase">
</FORM>


</BODY>
</HTML>
