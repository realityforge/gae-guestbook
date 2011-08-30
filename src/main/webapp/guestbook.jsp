<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>

<html>
<body>

<%
  String guestBookName = request.getParameter( "GuestBookName" );
  if( guestBookName == null )
  {
    guestBookName = "default";
  }

  final UserService userService = UserServiceFactory.getUserService();
  final User user = userService.getCurrentUser();
  if( user != null )
  {
%>
<p>Hello, <%= user.getNickname() %>! (You can
  <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
<%
}
else
{
%>
<p>Hello!
  <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
  to include your name with greetings you post.</p>
<%
  }
%>
<%
  final DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
  final Key guestbookKey = KeyFactory.createKey( "GuestBook", guestBookName );
  // Run an ancestor query to ensure we see the most up-to-date
  // view of the Greetings belonging to the selected Guestbook.
  final Query query = new Query( "Greeting", guestbookKey ).addSort( "date", Query.SortDirection.DESCENDING );
  final List<Entity> greetings = datastore.prepare( query ).asList( FetchOptions.Builder.withLimit( 15 ) );
  if( greetings.isEmpty() )
  {
%>
<p>Guestbook '<%= guestBookName %>' has no messages.</p>
<%
}
else
{
%>
<p>Messages in Guestbook '<%= guestBookName %>'.</p>
<%
  for( Entity greeting : greetings )
  {
    if( greeting.getProperty( "user" ) == null )
    {
%>
<p>An anonymous person wrote:</p>
<%
}
else
{
%>
<p><b><%= ( (User) greeting.getProperty( "user" ) ).getNickname() %>
</b> wrote:</p>
<%
  }
%>
<blockquote><%= greeting.getProperty( "content" ) %>
</blockquote>
<%
    }
  }
%>
<form action="/sign" method="post">
  <div><textarea name="content" rows="3" cols="60"></textarea></div>
  <div><input type="hidden" name="GuestBookName" value="<%= guestBookName %>"/></div>
  <div><input type="submit" value="Post Greeting"/></div>
</form>

</body>
</html>