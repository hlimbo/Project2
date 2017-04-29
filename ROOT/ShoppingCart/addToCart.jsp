<HTML>
	<HEAD>
		<TITLE>AddToCart</TITLE>
	</HEAD>
	
	<BODY>
		<H1>AddToCart Widget</H1>
		
		<form name="form1" action="AddToCartDisplay.jsp" method="POST">
			<input type="hidden" name="cartItem">
			<!-- temporary code -->
			<input type="hidden" name="itemName">
			<input type="hidden" name="price">
			<input type="hidden" name="quantity">
			<!-- end -->
			<input type="button" value="Add To Cart" onclick="OnAddToCart()">
		</form>
		
		<script language="JavaScript">
			function OnAddToCart()
			{
				//temporary code
				document.form1.itemName.value = "Jak & Daxter";
				document.form1.price.value = 19.99;
				document.form1.quantity.value = 1;	
				//TODO(Harvey): find a way to retrieve the item's name from another script.
				document.form1.cartItem.value = " the item associated with this widget";
				form1.submit();
			}
		</script>	
	</BODY>
</HTML>