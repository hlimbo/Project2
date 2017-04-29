<HTML>
	<HEAD>
		<TITLE>AddToCartDisplay</TITLE>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
	</HEAD>
	
	<BODY>
	<script
  src="https://code.jquery.com/jquery-3.2.1.min.js"
  integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
  crossorigin="anonymous"></script>
		<script>
			$(document).ready(function(){

			var quantitiy=0;
			   $('.quantity-right-plus').click(function(e){
					
					// Stop acting like a button
					e.preventDefault();
					// Get the field name
					var quantity = parseInt($('#quantity').val());
					
					// If is not undefined
						
						$('#quantity').val(quantity + 1);

					  
						// Increment
					
				});

				 $('.quantity-left-minus').click(function(e){
					// Stop acting like a button
					e.preventDefault();
					// Get the field name
					var quantity = parseInt($('#quantity').val());
					
					// If is not undefined
				  
						// Increment
						if(quantity>0){
						$('#quantity').val(quantity - 1);
						}
				});
				
			});
		</script>
		
		<!-- increment/decrement buttons -->
		<div class="container">
		<div class="row">
		<h2>Simple Quantity increment buttons with Javascript </h2>

		<div class="col-lg-2">
		<div class="input-group">
		<span class="input-group-btn">
		<button type="button" class="quantity-left-minus btn btn-danger btn-number"  data-type="minus" data-field="">
		  <span class="glyphicon glyphicon-minus"></span>
		</button>
		</span>
		<input type="text" id="quantity" name="quantity" class="form-control input-number" value="10" min="1" max="100">
		<span class="input-group-btn">
		<button type="button" class="quantity-right-plus btn btn-success btn-number" data-type="plus" data-field="">
			<span class="glyphicon glyphicon-plus"></span>
		</button>
		</span>
		</div>
		</div>
		</div>
		</div>
		
		
		
		<!--TODO(HARVEY): turn this into a list instead -->
		<% session.setAttribute("game_name", request.getParameter("game_name")); %> 
		<% session.setAttribute("price", request.getParameter("name")); %> 
		<% session.setAttribute("quantity", request.getParameter("quantity")); %>
	
		<H1>AddToCart Display</H1>
		<p> You are buying: <%= session.getAttribute("game_name") %> </p>
		<p> It costs: <%= session.getAttribute("price") %> </p>
		<P> <%= session.getAttribute("quantity") %> copy will be purhcased </p>
		
		<!-- TODO(Harvey): Might change back to GET request in order to retrieve the items that will be bought from cart -->
		<form action="CheckoutDisplay.jsp" method="GET">
		<button name="checkout">Continue To Checkout</button>
		</form>
	</BODY>
</HTML>