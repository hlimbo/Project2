<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
  <TITLE>GameDB Login</TITLE>
</HEAD>

<BODY BGCOLOR="#FDF5E6">


<% if ( session.getAttribute("sessionKey") != null ){
		

	if ( (int)session.getAttribute("sessionKey") == 0 ) {

%>


<H1 ALIGN="CENTER">GameDB Login Page</H1>

<p id="invalid_flag"></p>

email or password is invalid

<% }} %>

<FORM ACTION="/LoginPage/servlet/login"
      METHOD="POST">
  Email: <INPUT type="email" name="email" required><BR>

  Password: <INPUT type="password" name="password" required><BR>
  <CENTER>
    <INPUT TYPE="SUBMIT" VALUE="Login">
  </CENTER>
</FORM>

</BODY>
</HTML>
