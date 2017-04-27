import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import ShoppingCartItem.java;

public class ShoppingCart extends HttpServlet
{
	public String getServletInfo()
	{
		return "Servlet displays/adds shopping cart contents";
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
		throws IOException, ServletException
	{
		
		ShoppingCartItem item = new ShoppingCartItem("broom", 54.95);
		
		String loginUser = "user";
		String loginPasswd = "password";
		String loginUrl = "jdbc:mysql://localhost:3306/gamedb";
		
		response.setContentType("text/html"); // Response mime type
		
		//Java writes html code
		PrintWriter out = response.getWriter();
		
		out.println()
		
		
	}
	
	
	/*
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	{
		
	}*/
}