package org.realityforge.guestbook;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
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
    final UserService userService = UserServiceFactory.getUserService();
    final User user = userService.getCurrentUser();
    if( null != user )
    {
      resp.setContentType( "text/html" );
      final StringBuilder page = new StringBuilder();
      page.append( "<html><body>Hello, " );
      page.append( user.getNickname() );
      page.append( ". Maybe you should <a href=\"" );
      page.append( userService.createLogoutURL( req.getRequestURI() ) );
      page.append( "\">logout</a>.</body></html>" );
      resp.getWriter().println( page.toString() );
    }
    else
    {
      resp.sendRedirect( userService.createLoginURL( req.getRequestURI() ) );
    }
  }
}