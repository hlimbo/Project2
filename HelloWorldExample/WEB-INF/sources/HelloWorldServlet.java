
/* http://stackoverflow.com/questions/2370960/generate-an-html-response-in-a-java-servlet */

import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import javax.servlet.annotation.WebServlet;


@WebServlet("/hello")
public class HelloWorldServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String message = "Hello World";
        request.setAttribute("message", message); // This will be available as ${message}
        request.getRequestDispatcher("/WEB-INF/hello.jsp").forward(request, response);
    }

}
