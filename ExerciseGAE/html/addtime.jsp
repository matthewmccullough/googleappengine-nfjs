<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.jdo.PersistenceManager" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.ambientideas.invoicetimetracking.TimeTracked" %>
<%@ page import="com.ambientideas.invoicetimetracking.PMF" %>

<html>

  <body>
<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
%>
<p>Hello, <%= user.getNickname() %>! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
<%
    } else {
%>
<p>Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to include your name with greetings you post.</p>
<%
    }
%>

    <form action="/addtime" method="post">
      <div>Hours:<textarea name="hoursWorked" rows="1" cols="4"></textarea></div>
      <div>Comments:<textarea name="workComments" rows="3" cols="60"></textarea></div>
      <div><input type="submit" value="New Time" /></div>
    </form>

  </body>
</html>
