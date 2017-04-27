<HTML>
	<HEAD>
		<TITLE>AddToCartDisplay</TITLE>
	</HEAD>
	
	<BODY>
		<H1>AddToCart Display</H1>
		<p> You are buying: <%= request.getParameter("itemName") %> </p>
		<p> It costs: <%= request.getParameter("price") %> </p>
		<P> <%= request.getParameter("quantity") %> copy will be purhcased </p>
	</BODY>
</HTML>