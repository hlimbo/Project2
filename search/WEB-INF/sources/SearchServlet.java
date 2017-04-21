
/* A servlet to display the contents of the MySQL movieDB database */

import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class SearchServlet extends HttpServlet
{
    public String getServletInfo()
    {
        return "Servlet connects to MySQL database and displays result of a SELECT";
    }

    // Use http GET

    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
        String loginUser = "user";
        String loginPasswd = "password";
        String loginUrl = "jdbc:mysql://localhost:3306/gamedb";

        response.setContentType("text/html");    // Response mime type

        try
        {
            //Class.forName("org.gjt.mm.mysql.Driver");
            Class.forName("com.mysql.jdbc.Driver").newInstance();

            Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
            // Declare our statement
            Statement statement = dbcon.createStatement();

            String name = request.getParameter("name");
            String query = "SELECT * from games where name = '" + name + "'";

            // Perform the query
            ResultSet rs = statement.executeQuery(query);

            String results = "";
            results+="<TABLE border>";

            // Iterate through each row of rs
            results+="<tr>" +
                "<td>" + "ID" + "</td>" +
                "<td>" + "Name " + "</td>" +
                "</tr>";
            while (rs.next())
            {
                /*Hashtable<String,String> row = new Hashtable<String,String>();
                row.put("id",rs.getString("id"));
                row.put("name",rs.getString("name"));*/
                String m_ID = rs.getString("id");
                String m_TI = rs.getString("name");
                results+="<tr>" +
                    "<td>" + m_ID + "</td>" +
                    "<td>" + m_TI + "</td>" +
                    "</tr>";
            }
            results+="</TABLE>";

            rs.close();
            statement.close();
            dbcon.close();
            String nextJSP = request.getParameter("nextPage");
            if (nextJSP == null) {
                nextJSP = "/";
            }
            request.setAttribute("searchResults",results);
            RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(nextJSP); 
            dispatcher.forward(request,response);
        }
        catch (SQLException ex) {
            while (ex != null) {
                System.out.println ("SQL Exception:  " + ex.getMessage ());
                ex = ex.getNextException ();
            }  // end while
        }  // end catch SQLException

        catch(java.lang.Exception ex)
        {
            PrintWriter out = response.getWriter();
            out.println("<HTML>" +
                    "<HEAD><TITLE>" +
                    "gamedb: Error" +
                    "</TITLE></HEAD>\n<BODY>" +
                    "<P>Error in doGet: " +
                    ex.getMessage() + "</P></BODY></HTML>");
            out.close();
            return;
        }
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
        doGet(request, response);
    }
}
