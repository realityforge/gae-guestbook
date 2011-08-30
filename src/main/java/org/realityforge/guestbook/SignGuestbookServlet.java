package org.realityforge.guestbook;

import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import java.io.IOException;
import java.util.Date;
import java.util.logging.Logger;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SignGuestBookServlet
    extends HttpServlet
{
  private static final Logger log = Logger.getLogger( SignGuestBookServlet.class.getName() );

  public void doPost( final HttpServletRequest request, final HttpServletResponse response )
      throws IOException
  {
    final UserService userService = UserServiceFactory.getUserService();
    final User user = userService.getCurrentUser();

    String content = request.getParameter( "content" );
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

    // We have one entity group per GuestBook with all Greetings residing
    // in the same entity group as the GuestBook to which they belong.
    // This lets us run an ancestor query to retrieve all Greetings for a
    // given GuestBook. However, the write rate to each GuestBook should be
    // limited to ~1/second.
    final String guestBookName = request.getParameter( "GuestBookName" );
    final Key guestBookKey = KeyFactory.createKey( "GuestBook", guestBookName );

    final Entity greeting = new Entity( "Greeting", guestBookKey );
    greeting.setProperty( "user", user );
    greeting.setProperty( "date", new Date() );
    greeting.setProperty( "content", content );

    DatastoreServiceFactory.getDatastoreService().put( greeting );

    response.sendRedirect( "/guestbook.jsp" );
  }
}
