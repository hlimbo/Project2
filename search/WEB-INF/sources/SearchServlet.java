
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

    private String addSearchTerm (HttpServletRequest request, String term) {
            String value = (String) request.getParameter(term);
            String searchTerm = "";
            if (value != null && value.trim() != "") {
                searchTerm+=" AND ";
                searchTerm+=term+"= '" + value + "' ";
            }
            return searchTerm;
    }

	private static String tableRow (ResultSet result,Hashtable<String,Boolean> link) throws SQLException {
		ResultSetMetaData meta = result.getMetaData();
	    String resString = "";
		resString+="<tr>";
		for (int i=1;i<=meta.getColumnCount();++i) {
			int type = meta.getColumnType(i);
			String typeName = meta.getColumnTypeName(i);
			String colName = meta.getColumnName(i);
            boolean makeLink = false;
            if  (link.containsKey(colName) && link.get(colName)) {
                makeLink=true;
                //TODO set links to display a single entity.
			    resString+="<td><a href='display_"+colName+"'>";
            } else {
			    resString+="<td>";
            }
            boolean handled = false;
			switch(typeName.toUpperCase()) {
			case "YEAR":
				resString+=result.getString(i).substring(0,4);
                handled=true;
				break;
			}
			if (!handled) {
				switch(type) {
				case Types.INTEGER:
					resString+=result.getInt(i);
					break;
				default:
					resString+=result.getString(i);
					break;
				}
			}
            if (makeLink) {
                resString+="</a></td>";
            } else {
			    resString+="</td>";
            }
		}
		resString+="</tr>";
        return resString;
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

            String table = (String) request.getParameter("table");
            if (table==null) {
                table="games";
            }

            String masterTable = "((SELECT id AS game_ID FROM games) AS g_id NATURAL JOIN "
                +"publishers_of_games NATURAL JOIN genres_of_games NATURAL JOIN (SELECT id AS publisher_id FROM publishers) AS p_id "
                +"NATURAL JOIN (SELECT id AS genre_id FROM genres) AS n_id NATURAL JOIN platforms_of_games)";
            //duplicates due to games on multiple platforms, with multiple genres, or etc...
            String query = "SELECT DISTINCT "+table+".* FROM games, publishers, platforms, genres, "+masterTable+" WHERE "
                +"games.id=game_id AND publishers.id=publisher_id AND platform_id=platform_id";
            query+=addSearchTerm(request,"name");
            query+=addSearchTerm(request,"publisher");
            query+=addSearchTerm(request,"genre");
            query+=addSearchTerm(request,"platform");

            // Perform the query
            ResultSet rs = statement.executeQuery(query);

            String results = "";
            results+="<TABLE border>";

            // Iterate through each row of rs
            Hashtable<String,Boolean> links = new Hashtable<String,Boolean>();
            links.put("name",true);
            links.put("publisher",true);
            links.put("genre",true);
            links.put("platform",true);
            while (rs.next())
            {
                results+=tableRow(rs,links);
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
            PrintWriter out = response.getWriter();
            out.println("<HTML>" +
                    "<HEAD><TITLE>" +
                    "gamedb: Error" +
                    "</TITLE></HEAD>\n<BODY>" +
                    "<P>Error in SQL: ");
            while (ex != null) {
                out.println ("SQL Exception:  " + ex.getMessage ());
                ex = ex.getNextException ();
            }  // end while
                    out.println("</P></BODY></HTML>");
            out.close();
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
