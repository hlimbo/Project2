import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;


//The servlet's job should be to:
// 1. redirect the user to the proper jsp webpage.
// 2. authenticate user credentials
// 3. query for certain items to be found in the database. i.e. game id, genre id.

public class ClearCart extends HttpServlet
{	
	public String getServletInfo()
	{
		return "Servlet clears shopping cart contents";
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
		throws IOException, ServletException
	{	
		System.out.println("Clearcart.java");
		HttpSession session = request.getSession(false);	
		ArrayList<String> cartList = (ArrayList<String>)session.getAttribute("cartList");
		if(cartList == null)
		{
			System.out.println("Cart is already empty");
			session.setAttribute("errorString", "Cart is already empty");
		}
		else
		{
			session.setAttribute("cartList", null);
			cartList = null;
		}
		
		response.sendRedirect("http://localhost:8080/ShoppingCart/AddToCartDisplay.jsp");
		
	}
	
	/* public void doPost(HttpServletRequest request, HttpServletResponse response)
	{
		
	} */
}
