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

<%
    PersistenceManager pm = PMF.get().getPersistenceManager();
    String query = "select from " + TimeTracked.class.getName() + " order by date desc range 0,5";
    List<TimeTracked> timetracked = (List<TimeTracked>) pm.newQuery(query).execute();
    if (timetracked.isEmpty()) {
%>
<p>The Time Logbook has no entries.</p>
<%
    } else {
        for (TimeTracked g : timetracked) {
            if (g.getWorkComments() == null) {
%>
<p>Time Tracked Comments:</p>
<%
            }
%>
<blockquote>Hours: <%= g.getHoursWorked() %></blockquote>
<%
        }
    }
    pm.close();
%>

    <form action="/sign" method="post">
      <div><textarea name="workComments" rows="3" cols="60"></textarea></div>
      <div><input type="submit" value="New Time" /></div>
    </form>

  </body>
</html>
