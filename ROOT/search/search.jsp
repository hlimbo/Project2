<%-- Show results--%>
<% if (request.getAttribute("searchResults") != null) { %>
<%= (String) request.getAttribute("searchResults") %>
<%-- default is to ask for the search--%>
<% } else { %>
<form action="/search/query" method="GET">
    title: <input type="TEXT" name="name" /> <BR />
    genre: <input type="TEXT" name="genre" /> <BR />
    platform: <input type="TEXT" name="platform" /> <BR />
    publisher: <input type="TEXT" name="publisher" /> <BR />
    <input type="HIDDEN" name="nextPage" <%= "value="+request.getRequestURI() %> />
    <center>
        <input type="SUBMIT" value="search" />
    </center>
</form>
<% } %>
