<html>
	<head>
		<title>Determining Which Button Was Clicked</title>
	</head>
	
	<body>
		<h1> Determining which button was clicked</h1>
		You clicked  <%= request.getParameter("buttonName") %>
		
		<p>Retrieve request.getParameter("buttonName") value from buttons.jsp</p>
	</body>
</html>