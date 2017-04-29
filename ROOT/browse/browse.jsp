<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" 
    import="java.util.*" %>
<ul>
    <%  ArrayList<String> tables = new ArrayList<String>();
        tables.add("genres");
        tables.add("publishers");
        tables.add("platforms");
        tables.add("games");
        for (String table : tables) { %>
        <li class="browseList" ><a href="/search/query?table="<%= table %>><%= table %></a>
            <ul class="letterList" >
                <% for (char firstLetter = 'a';firstLetter<='z';++firstLetter) { 
                    String column;
                    if (table.compareToIgnoreCase("games")!=0) { 
                        column = table.substring(0,table.length()-1);
                    } else { 
                        column = "name";
                    } %>
                    <%= "<li class=\"letterList\"><a href=\"search/query?table="+table+"&columnName="+column
                        +"&"+column+"="+firstLetter+"%25&match=true\" >"+(""+firstLetter).toUpperCase()
                        +"</a></li>" %>
                <% } %>
            </ul>
        </li>
    <% } %>
</ul>
