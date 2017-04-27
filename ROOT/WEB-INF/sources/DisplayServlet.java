import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class DisplayServlet extends HttpServlet
{
    public String getServletInfo()
    {
        return "Servlet connects to MySQL database and displays a single record within the database";
    }

    private String cartButton (String value) {
        String button = "<tr><td><form action=\"TODO\" method=\"GET\">";
        button+="<input type=\"HIDDEN\" id=\""+value+"\" \\>";
        button+="<input type=\"SUBMIT\" value=\"Checkout\" \\>";
        button+="</form></td></tr>";
        return button;
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
            DatabaseMetaData dbmeta = dbcon.getMetaData();
            ResultSet tableMeta = dbmeta.getTables(dbcon.getCatalog(),null,"%",null);
            ArrayList<String> tables = new ArrayList<String>();
            while (tableMeta.next()) {
                tables.add(tableMeta.getString("TABLE_NAME"));
            }
            tableMeta.close();
            PreparedStatement statement;

            String table = (String) request.getParameter("table");
            table=table.replaceAll("[^\\w]","_");
            String column = (String) request.getParameter("columnName");
            column=column.replaceAll("[^\\w]","_");
            String columnValue= (String) request.getParameter(column);
            if (table==null) {
                table="games";
            }

            String masterTable = "((SELECT id AS game_ID FROM games) AS g_id NATURAL JOIN "
                +"publishers_of_games NATURAL JOIN genres_of_games NATURAL JOIN (SELECT id AS publisher_id FROM publishers) AS p_id "
                +"NATURAL JOIN (SELECT id AS genre_id FROM genres) AS n_id NATURAL JOIN (SELECT id AS platform_id FROM platforms) AS l_id"
                +" NATURAL JOIN platforms_of_games)";
            //duplicates due to games on multiple platforms, with multiple genres, or etc...
            String query = "SELECT DISTINCT "+table+".id FROM games, publishers, platforms, genres, "+masterTable+" WHERE "
                +"games.id=game_id AND publishers.id=publisher_id AND platforms.id=platform_id AND "+table+"."+column+"=?";
            statement = dbcon.prepareStatement(query);
            statement.setString(1,columnValue);

            // Perform the query
            ResultSet rs = statement.executeQuery();

            String id;
            if (rs.next()) {
                id = rs.getString(1);
            } else {
                rs.close();
                statement.close();
                return;
            }
            //Convert to column name of a relation table by naming convention of database. 
            //For example, publishers.id -> publisher_id
            String tableIDField = table.substring(0,table.length()-1)+"_id";
            String tableIDCond = tableIDField+"="+id;
            String gameID = "";
            if (table.trim().compareToIgnoreCase("games") == 0) {
                gameID=id;
            }

            statement.close();
            rs.close();
            String results = "<TABLE border>";
            //Sets which fields to not display to client. Configuration option
            Hashtable<String,Boolean> fieldIgnores = new Hashtable<String,Boolean>();
            //fieldIgnores.put("id",true);
            fieldIgnores.put("platform_id",true);
            fieldIgnores.put("game_id",true);
            fieldIgnores.put("genre_id",true);
            fieldIgnores.put("publisher_id",true);
            fieldIgnores.put("globalsales",true);
            fieldIgnores.put("rank",true);
            //Sets which fields to hyperlink. Configuration option
            Hashtable<String,Boolean> links = new Hashtable<String,Boolean>();
            links.put("name",true);
            links.put("publisher",true);
            links.put("genre",true);
            links.put("platform",true);

            results+="<tr><td>"+columnValue+"</td</tr>";
            for (String tbl : tables) {
                //by convention of SQL schema, relation tables contains name
                //of entity tables. For example, publishers_of_games contains both
                //publishers and games within its name
                if (tbl.indexOf(table) != -1 && tbl.trim().compareToIgnoreCase(table.trim()) != 0) {
                    results+="<tr>";
                    results+="<td>"+tbl.trim().replace("_of_","").replace(table,"")+":</td>";
                    query="SELECT DISTINCT * FROM "+tbl+" WHERE "+tableIDCond;
                    statement=dbcon.prepareStatement(query);
                    rs = statement.executeQuery();
                    results += "<td><TABLE border>";
                    //boolean parentAdded = false;
                    ArrayList<String> fields = new ArrayList<String>();

                    int k = 0;
                    while (rs.next()) {
                        ResultSetMetaData meta = rs.getMetaData();
                        for (int i=1;i<=meta.getColumnCount();++i) {
                            String columnName = meta.getColumnName(i);
                            if (columnName.compareToIgnoreCase(tableIDField) != 0) {
                                //By naming convention of database
                                String parentTable = columnName.substring(0,columnName.length()-3)+"s";
                                query= "SELECT DISTINCT * FROM "+parentTable+" WHERE id=?";
                                PreparedStatement parentStatement=dbcon.prepareStatement(query);
                                parentStatement.setString(1,rs.getString(i));
                                ResultSet parentResult = parentStatement.executeQuery();
                                ResultSetMetaData parentMeta = parentResult.getMetaData();
                                /*if (!parentAdded) {
                                    results+="<tr>";
                                    for (int j=1;j<=parentMeta.getColumnCount();++j) {
                                        String parentColumn = parentMeta.getColumnName(j);
                                        if (fieldIgnores.containsKey(parentColumn) && fieldIgnores.get(parentColumn)
                                                && (parentTable.compareToIgnoreCase("games") != 0 || parentColumn.compareToIgnoreCase("id") != 0)) {
                                            continue;
                                        }
                                        results+="<td>"+parentColumn+"</td>";
                                    }
                                    parentAdded=true;
                                    results+="</tr>";
                                }*/
                                //results+="<tr>";
                                while (parentResult.next()) {
                                    for (int j=1;j<=parentMeta.getColumnCount();++j) {
                                        String parentColumn = parentMeta.getColumnName(j);
                                        if (parentColumn.compareToIgnoreCase("id")==0 && parentTable.compareToIgnoreCase("games")==0) {
                                            gameID=Integer.toString(parentResult.getInt(1));
                                        }
                                        String fieldValue = parentResult.getString(j);
                                        if (fieldIgnores.containsKey(parentColumn) && fieldIgnores.get(parentColumn)
                                                && (parentTable.compareToIgnoreCase("games") != 0 || parentColumn.compareToIgnoreCase("id") != 0)) {
                                            continue;
                                        } else if (links.containsKey(parentColumn) && links.get(parentColumn)) {
                                            String fieldUrl = "/display/query?table="+parentTable+
                                                "&columnName="+parentColumn+"&"+parentColumn+"="+
                                                URLEncoder.encode(fieldValue,"UTF-8");
                                            fieldValue="<td>"+parentColumn+": <a href=\""+fieldUrl+"\">"+fieldValue+"</a></td>";
                                        } else {
                                            fieldValue="<td>"+parentColumn+": "+fieldValue+"</td>";
                                        }
                                        if (fields.size() > k) {
                                            fields.set(k,fields.get(k)+fieldValue);
                                        } else {
                                            fields.add(k,fieldValue);
                                        }
                                    }
                                    if (parentTable.trim().compareToIgnoreCase("games")==0) {
                                        fields.set(k,fields.get(k)+cartButton(gameID));
                                    }
                                }
                                parentResult.close();
                                parentStatement.close();
                            }
                        }
                        ++k;
                    }
                    for (String fld : fields) {
                        results+="<tr>"+fld+"</tr>";
                    }
                    results += "</td></TABLE>";
                    results+="</tr>\n";
                }
            }
            if (table.compareToIgnoreCase("games") == 0) {
                results+=cartButton(gameID);
            }
            results+="</TABLE>";

            statement.close();
            rs.close();
            dbcon.close();
            String nextJSP = request.getParameter("nextPage");
            if (nextJSP == null) {
                nextJSP = "/display/index.jsp";
            } else {
                nextJSP="/"+nextJSP;
            }
            request.setAttribute("displayResults",results);
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
