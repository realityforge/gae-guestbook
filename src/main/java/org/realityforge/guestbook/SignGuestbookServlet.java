package org.realityforge.guestbook;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import java.io.IOException;
import java.util.logging.Logger;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SignGuestBookServlet
    extends HttpServlet
{
  private static final Logger log = Logger.getLogger( SignGuestBookServlet.class.getName() );

  public void doPost( final HttpServletRequest req, final HttpServletResponse resp )
      throws IOException
  {
    final UserService userService = UserServiceFactory.getUserService();
    final User user = userService.getCurrentUser();

    String content = req.getParameter( "content" );
    if( null == content )
    {
      content = "(No greeting)";
    }
    if( user != null )
    {
      log.info( "Greeting posted by user " + user.getNickname() + ": " + content );
    }
    else
    {
      log.info( "Greeting posted anonymously: " + content );
    }
    resp.sendRedirect( "/guestbook.jsp" );
  }
}
