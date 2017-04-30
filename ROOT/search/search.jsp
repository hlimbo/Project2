<%-- Show results--%>
<% if (request.getAttribute("searchResults") != null) { %>
<%= (String) request.getAttribute("searchResults") %>
    <% 
        Integer count = (int) request.getAttribute("searchCount");
        Integer offset = (int)request.getAttribute("searchOffset");
        Integer limit = (int)request.getAttribute("searchLimit");
        if (offset == null || limit==null) {
        } else if (offset > -1 && limit > -1) {
            int pages = count/limit;
            if (count % limit != 0) {
                ++pages;
            }
            String params = "?"+request.getQueryString();
            String paramsEnd = "";
            int offsetStart =  params.indexOf("offset=");
            if  (offsetStart > -1) {
                int offsetEnd = params.substring(offsetStart).indexOf("&");
                if (offsetEnd == -1) {
                    params=params.substring(0,offsetStart);
                } else {
                    paramsEnd=params.substring(offsetStart+offsetEnd);
                    params=params.substring(0,offsetStart);
                }
            } else {
                params=params+"&";
            }
            boolean limitPages = false;
            if (pages > 20) {
                limitPages = true;
                pages = 20;
            }
            if (offset > 0) { %>
                <%= " <a href=\"/search/query"
                    +params+"offset=0"
                    +"\"> First </a>"+
                    "<a href=\"/search/query"
                    +params+"offset="+Integer.toString(Math.max(0,offset-limit))
                    +"\"> Previous </a> " %>
                <% 
            }
            int pageStart=Math.max(0,Math.min(offset/limit-10,
                count/limit-20+(count%limit==0 ? 0 : 1)));
            for (int i=pageStart;i<pages+pageStart;++i) {
            %>
            <%= " <a href=\"/search/query"
                +params+"offset="+Integer.toString(i*limit)+paramsEnd
                +"\">"+Integer.toString(i+1)+"</a> " %>
         <% }
            if (offset+limit<count) { %>
            <%= " <a href=\"/search/query"
                +params+"offset="+Integer.toString(offset+limit)
                +"\">Next</a> "+
                "<a href=\"/search/query"
                +params+"offset="+Integer.toString(count-limit)
                +"\">Last</a> "
            %>
            <% }
        } else { %>
    <% } %>
<%-- default is to ask for the search--%>
<% } else { %>
Search
<form action="/search/query" method="GET">
    title: <input type="TEXT" name="name" /> <BR />
    year: <input type="TEXT" name="year" /> <BR />
    genre: <input type="TEXT" name="genre" /> <BR />
    platform: <input type="TEXT" name="platform" /> <BR />
    publisher: <input type="TEXT" name="publisher" /> <BR />
    results per page (max 50): <input type="text" name="limit" /> <BR />
    exact search?: <input type="checkbox" name="match" value="true" /> <BR />
    <input type="HIDDEN" name="forward" <%= "value="+request.getRequestURI() %> />
    <center>
        <input type="SUBMIT" value="Search" />
    </center>
</form>
<% } %>
