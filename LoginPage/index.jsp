<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
  <TITLE>GameDB Login</TITLE>
</HEAD>

<BODY BGCOLOR="#FDF5E6">

<H1 ALIGN="CENTER">GameDB Login Page</H1>


<!-- can only obtain values from httprequest and httpresponse -->
<% if ( session.getAttribute("loginKey") != null ){ %>
	<p id="invalid_flag">email or password is invalid</p>
	<p> Session Key <%= session.getAttribute("loginKey") %> </p>
<% } %>

<FORM ACTION="/LoginPage/servlet/loginSuccess"
      METHOD="POST">
  Email: <INPUT type="email" name="email" required><BR>

  Password: <INPUT type="password" name="password" required><BR>
  <CENTER>
    <INPUT TYPE="SUBMIT" VALUE="Login">
  </CENTER>
</FORM>

</BODY>
</HTML>