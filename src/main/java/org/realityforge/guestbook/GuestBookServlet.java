package org.realityforge.guestbook;

import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class GuestBookServlet extends HttpServlet
{
  public void doGet( final HttpServletRequest req,
                     final HttpServletResponse resp )
      throws IOException
  {
    resp.setContentType( "text/plain" );
    resp.getWriter().println( "Hello, world" );
  }
}