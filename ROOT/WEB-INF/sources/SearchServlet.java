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

    private String addSearchTerm (HttpServletRequest request, String term, boolean useSubMatch) {
            String value = (String) request.getParameter(term);
            String searchTerm = "";
            if (value != null && value.trim() != "") {
                if (!useSubMatch) {
                    for (String subvalue : value.split(" ")) {
                        searchTerm+=" AND ";
                        searchTerm+=term+" LIKE ?";
                    }
                } else {
                    searchTerm+=" AND ";
                    searchTerm+=term+" LIKE ?";
                }
            }
            return searchTerm;
    }

    private int setSearchTerm (HttpServletRequest request, String term, PreparedStatement statement, 
            int offset, boolean useSubMatch) throws SQLException {
            String value = (String) request.getParameter(term);
            String searchTerm = "";
            if (value != null && value.trim() != "") {
                if (!useSubMatch) {
                    for (String subvalue : value.split(" ")) {
                        statement.setString(offset,"%"+subvalue+"%");
                        offset+=1;
                    }
                } else {
                    statement.setString(offset,value);
                    offset+=1;
                }
            }
            return offset;
    }

    private String cartButton (String id, String quantity) {
        String button = "<tr><td><form action=\"/ShoppingCart/AddToCartDisplay.jsp\" method=\"GET\">";
        button+="<input type=\"HIDDEN\" name=id value=\""+id+"\" \\>";
        button+="<input type=\"HIDDEN\" name=\"quantity\" value=\""+quantity+"\" \\>";
        button+="<input type=\"SUBMIT\" value=\"Checkout\" \\>";
        button+="</form></td></tr>";
        return button;
    }

	private static String tableRow (ResultSet result,String table, Hashtable<String,Boolean> link,
            Hashtable<String,Boolean> images) throws SQLException {
		ResultSetMetaData meta = result.getMetaData();
	    String resString = "";
		resString+="<tr>";
		for (int i=1;i<=meta.getColumnCount();++i) {
			int type = meta.getColumnType(i);
			String typeName = meta.getColumnTypeName(i);
            boolean handled = false;
            String value="";
			switch(typeName.toUpperCase()) {
			case "YEAR":
				value+=result.getString(i).substring(0,4);
                handled=true;
				break;
			}
			if (!handled) {
				switch(type) {
				case Types.INTEGER:
					value+=result.getInt(i);
					break;
				default:
					value+=result.getString(i);
					break;
				}
			}
            if (value==null) {
                continue;
            }
			String colName = meta.getColumnName(i);
            if  (link.containsKey(colName) && link.get(colName)) {
                try {
			        resString+="<td><a href=\"/display/query?table="+table+"&columnName="+colName+
                        "&"+colName+"="+URLEncoder.encode(value,"UTF-8")+"\">";
                } catch (UnsupportedEncodingException error) {
			        resString+="<td><a href=\"/display/query?table="+table+"&columnName="+colName+
                        "&"+colName+"="+value.replaceAll("[^\\w]","_")+"\">";
                }
                resString+=value;
                resString+="</a></td>";
            } else if (images.containsKey(colName) && images.get(colName)){
                resString+="<td><img src=\"http://"+value+"\" /></td>";
            } else {
			    resString+="<td>";
                resString+=value;
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

        String query = "";
        String returnLink = "<a href=\"/\"> Return to home </a>";
        try
        {
            //Class.forName("org.gjt.mm.mysql.Driver");
            Class.forName("com.mysql.jdbc.Driver").newInstance();

            Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
            // Declare our statement
            //Statement statement = dbcon.createStatement();
            PreparedStatement statement; 

            String table = (String) request.getParameter("table");
            if (table==null) {
                table="games";
            } else {
                table = table.replaceAll("[^\\w]","_");
            }
            String limit = (String) request.getParameter("limit");
            if (limit==null) {
                limit="20";
            } else {
                limit = limit.replaceAll("[\\D]","");
            }

            String offset = (String) request.getParameter("offset");
            if (offset==null) {
                offset="0";
            } else {
                offset = offset.replaceAll("[\\D]","");
            }

            String order = (String) request.getParameter("order");
            if (order==null) {
                order="id";
            } else {
                order = order.replaceAll("[^\\w]","_");
            }

            String matchParameter = (String) request.getParameter("match");
            boolean useSubMatch = false;
            if (matchParameter != null && matchParameter.compareToIgnoreCase("true") == 0) {
                useSubMatch = true;
            }

            String masterTable = "((SELECT id AS game_id FROM games) AS g_id NATURAL JOIN "
                +"publishers_of_games NATURAL JOIN genres_of_games NATURAL JOIN (SELECT id AS publisher_id FROM publishers) AS p_id "
                +"NATURAL JOIN (SELECT id AS genre_id FROM genres) AS n_id NATURAL JOIN (SELECT id AS platform_id FROM platforms) AS l_id"
                +" NATURAL JOIN platforms_of_games)";
            //duplicates due to games on multiple platforms, with multiple genres, or etc...
            query = "SELECT DISTINCT "+table+".* FROM games, publishers, platforms, genres, "+masterTable+" WHERE "
                +"games.id=game_id AND publishers.id=publisher_id AND platforms.id=platform_id";
            query+=addSearchTerm(request,"name",useSubMatch);
            query+=addSearchTerm(request,"publisher",useSubMatch);
            query+=addSearchTerm(request,"genre",useSubMatch);
            query+=addSearchTerm(request,"platform",useSubMatch);
            query+="ORDER BY "+order+" LIMIT "+limit+" OFFSET "+offset;

            // Perform the query
            statement = dbcon.prepareStatement(query);
            int statementOffset = 1;
            statementOffset = setSearchTerm(request,"name",statement,statementOffset,useSubMatch);
            statementOffset = setSearchTerm(request,"publisher",statement,statementOffset,useSubMatch);
            statementOffset = setSearchTerm(request,"genre",statement,statementOffset,useSubMatch);
            statementOffset = setSearchTerm(request,"platform",statement,statementOffset,useSubMatch);
            ResultSet rs = statement.executeQuery();

            String results = "";
            results+="<TABLE border>";

            // Iterate through each row of rs
            Hashtable<String,Boolean> links = new Hashtable<String,Boolean>();
            links.put("name",true);
            links.put("publisher",true);
            links.put("genre",true);
            links.put("platform",true);
            links.put("url",true);
            links.put("trailer",true);
            Hashtable<String,Boolean> images = new Hashtable<String,Boolean>();
            images.put("logo",true);

            ResultSetMetaData meta = rs.getMetaData();
            results+="<tr>";
            for (int i=1;i<=meta.getColumnCount();++i) {
                String column = meta.getColumnName(i);
                results+="<td>"+column+"</td>";
            }
            results+="</tr>";
            while (rs.next())
            {
                results+=tableRow(rs,table,links,images);
                results+=cartButton(Integer.toString(rs.getInt(1)),"1");
            }
            results+="</TABLE>";

            rs.close();
            statement.close();
            dbcon.close();
            String nextJSP = request.getParameter("nextPage");
            if (nextJSP == null) {
                nextJSP = "/search/index.jsp";
            } else {
                nextJSP="/"+nextJSP;
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
            out.println(" in sql expression "+query+"<br />\n"+returnLink);
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
                    ex.getMessage() +"<br />\n"+returnLink+"</P></BODY></HTML>");
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
