<HTML>
	<HEAD>
		<TITLE>Using Buttons</TITLE>
	</HEAD>
	
	<BODY>
		<H1>Using Buttons</H1>
		
		<!--
			Note: JSP is dynamic! No need to recompile the file and reload the web page via tomcat manager.
		
			Form tag attributes
			1. name is required to identify which form is being processed in javascript
			2. action is required to identify which file (in our case basic.jsp) will be used as a page to redirect to.
				- can also provide a pathName for this attribute.
			3. method = "GET" or "POST"
				- "GET" reveals arguments passed into a form via URL to the next page user is directed to.
				- "POST" hides arguments from the user to the next page user is directed to.
				
			input tag attributes
			1. type="hidden" A control that is not displayed but whose value is submitted to the server.
							<input type="hidden" name="buttonName"> is used to send over data from the associated script file (in our case the javascript wrapped around <script> tag)
				-the attribute "hidden" is useful for sending its value over to the server!
				-without this attribute field specified, the next page will not know what button was pressed in the previous page.
		-->
		<form name="form1" action="basic.jsp" method="POST">
		
			<div><input type="hidden" name="buttonName">
			<div><input type="button" value="button 1" onclick="button1()">
			<div><input type="button" value="button 2" onclick="button2()">
			<div><input type="button" value="button 3" onclick="button3()">
		</form>
		
		
		<!-- TODO(HARVEY): have future javascript code included in another file -->
		<script language="JavaScript">
			function button1()
			{
				document.form1.buttonName.value = "button 1";
				form1.submit();//sends the request to the server and redirects the user to the appropriate page supplied by the action attribute in the <form> tag
			}
			
			function button2()
			{
				document.form1.buttonName.value = "button 2";
				form1.submit();
			}
			
			function button3()
			{
				document.form1.buttonName.value = "button 3";
				form1.submit();
			}
		</script>	
	</BODY>
</HTML>