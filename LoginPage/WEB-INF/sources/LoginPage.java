
/* A servlet to display the contents of the MySQL movieDB database */

import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class LoginPage extends HttpServlet
{
    public String getServletInfo()
    {
       return "Servlet connects to database to verify login credentials user entered in";
    }

    // Use http GET

    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
        String loginUser = "user";
        String loginPasswd = "password";
        String loginUrl = "jdbc:mysql://localhost:3306/gamedb";

        response.setContentType("text/html");    // Response mime type

        // Output stream to STDOUT
        PrintWriter out = response.getWriter();

        out.println("<HTML><HEAD><TITLE>GameDB: Found Records</TITLE></HEAD>");
        out.println("<BODY><H1>GameDB: Found Records</H1>");


        try
           {
              //Class.forName("org.gjt.mm.mysql.Driver");
              Class.forName("com.mysql.jdbc.Driver").newInstance();

              Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
              // Declare our statement
              Statement statement = dbcon.createStatement();

			  String email = request.getParameter("email");
              String query = "SELECT * from customers where email = '" + email + "'";
			  Statement emailStatement = dbcon.createStatement();
			  
			 
			String password = request.getParameter("password");
			String passwordQuery = "Select * from customers where password = '" + password + "'"; 
			Statement statement2 = dbcon.createStatement();
			
			ResultSet es = emailStatement.executeQuery(query);
			ResultSet ps = statement2.executeQuery(passwordQuery);
			
			//use a session key for the client.
			
			
			if(es.next() && ps.next())
			{
				out.println("Login successful!");
			}
			else
			{
				try
				{
					//client side
					response.sendRedirect("http://localhost:8080/LoginPage/");
					HttpSession session = request.getSession();
					session.setAttribute("loginKey", session.getId());
				}
				catch (IOException e)
				{
				}
				//out.println("Login failure... Wrong password!");
			}
			
			 
              // Perform the query
              ResultSet rs = statement.executeQuery(query);
			
              out.println("<TABLE border>");

              // Iterate through each row of rs
	      out.println("<tr>" +
			  "<td>" + "ID" + "</td>" +
			  "<td>" + "First Name" + "</td>" +
			  "<td>" + "Last Name" + "</td>" +
			  "<td>" + "Password" + "</td>" +
			  "</tr>");
              while (rs.next())
              {
                  String m_ID = rs.getString("cc_id");
                  String m_FN = rs.getString("first_name");
                  String m_LN = rs.getString("last_name");
				  String m_pass = rs.getString("password");
                  out.println("<tr>" +
                              "<td>" + m_ID + "</td>" +
                              "<td>" + m_FN + "</td>" +
                              "<td>" + m_LN + "</td>" +
							  "<td>" + m_pass + "</td>" +
                              "</tr>");
              }
              out.println("</TABLE>");

              rs.close();
              statement.close();
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
                out.println("<HTML>" +
                            "<HEAD><TITLE>" +
                            "MovieDB: Error" +
                            "</TITLE></HEAD>\n<BODY>" +
                            "<P>SQL error in doGet: " +
                            ex.getMessage() + "</P></BODY></HTML>");
                return;
            }
         out.close();
    }
    
    public void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
		doGet(request, response);
	}
}
