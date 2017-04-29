
/* A servlet to display the contents of the MySQL movieDB database */

import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class CustomerInformation extends HttpServlet
{
    public String getServletInfo()
    {
       return "Servlet verifies customer information is in the creditcards table database";
    }

    // Use http GET

    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
        String loginUser = "user";
        String loginPasswd = "password";
        String loginUrl = "jdbc:mysql://localhost:3306/gamedb";

		
		System.out.println("CustomerInformation class is active");
		
        response.setContentType("text/html");    // Response mime type
		
        try
        {
              //Class.forName("org.gjt.mm.mysql.Driver");
              Class.forName("com.mysql.jdbc.Driver").newInstance();
              Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);	

			  HttpSession session = request.getSession();
			  String first_name = (String)request.getParameter("first_name");
  			  String last_name = (String)request.getParameter("last_name");
			  String cc_id = (String)request.getParameter("cc_id");
			  String expiration = (String)request.getParameter("expiration");
			  java.sql.Date expDate = java.sql.Date.valueOf(expiration);
			
			Statement statement = dbcon.createStatement();	
             String query = "SELECT * FROM creditcards WHERE id='" + cc_id 
			 + "' and first_name='" + first_name + "' and last_name='" + last_name + "' and expiration='" + expDate + "';";
			  
			ResultSet result = statement.executeQuery(query);
			//get the number of rows in the set executed by query
			result.last();
			int rowCount = result.getRow();
			System.out.println(query);
			System.out.println(rowCount);
						
			if(rowCount == 1)
			{
				System.out.println(first_name + " " + last_name + " was found in the creditcards table");
				session.setAttribute("first_name",first_name);				
				response.sendRedirect("http://localhost:8080/CustomerInformation/confirmationPage.jsp");
			}
			else if(rowCount > 1)
			{
				System.out.println("There are multiple records in the database with the same information");
				session.setAttribute("invalidFlag","There are multiple records in the database with the same information");
				response.sendRedirect("http://localhost:8080/CustomerInformation/confirmationPage.jsp");
			}
			else//if rowCount == 0
			{
				try
				{
					System.out.println("Supplied information not found or does not match in creditcards table");
					session.setAttribute("invalidFlag", "Supplied information not found or does not match in creditcards table");
					response.sendRedirect("http://localhost:8080/CustomerInformation/index.jsp");
				}
				catch (IOException e)
				{
					e.printStackTrace();
				}
			}
			
			  result.close();
              dbcon.close();
            }
        catch (SQLException ex) {
              while (ex != null) {
                    System.out.println ("SQL Exception:  " + ex.getMessage ());
                    ex = ex.getNextException ();
                }  // end while
            }  // end catch SQLException

        catch(java.lang.Exception ex)
            {
                System.out.println("<HTML>" +
                            "<HEAD><TITLE>" +
                            "MovieDB: Error" +
                            "</TITLE></HEAD>\n<BODY>" +
                            "<P>SQL error in doGet: " +
                            ex.getMessage() + "</P></BODY></HTML>");
                return;
            }
    }
    
    public void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
		doGet(request, response);
	}
}
