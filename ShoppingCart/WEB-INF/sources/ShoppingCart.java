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
		
		//obtain session key
		try
		{
			HttpSession session = request.getSession();
			
			//critical section ~ find pre-existing shopping cart if within same session.
			synchronized(session)
			{
				ArrayList previousItems = (ArrayList)session.getAttribute("ShoppingCartItems");
				if(previousItems == null)
				{
					previousItems = new ArrayList();
					session.setAttribute("ShoppingCartItems", previousItems);
				}
			}
			
			
			if(session.getAttribute("loginKey") != null)
			{
				//if shopping cart does not exist, create one for the session.
				if(session.getAttribute("ShoppingCartItems") == null)
				{
					session.setAttribute("ShoppingCartItems") = new ArrayList<ShoppingCartItem>();			
				}
				
				//add item to shopping cart.
				
				
			}
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}
		
	}
	
	
	/*
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	{
		
	}*/
}