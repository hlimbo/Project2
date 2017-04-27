<HTML>
	<HEAD>
		<TITLE>AddToCartDisplay</TITLE>
	</HEAD>
	
	<BODY>
		<H1>AddToCart Display</H1>
		<p> You are buying: <%= request.getParameter("itemName") %> </p>
		<p> It costs: <%= request.getParameter("price") %> </p>
		<P> <%= request.getParameter("quantity") %> copy will be purhcased </p>
		
		<!-- TODO(Harvey): Might change back to GET request in order to retrieve the items that will be bought from cart -->
		<form action="CheckoutDisplay.jsp" method="POST">
		<button name="checkout">Continue To Checkout</button>
		</form>
	</BODY>
</HTML>