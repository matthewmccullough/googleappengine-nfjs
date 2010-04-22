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

<table>
  <tr>
    <td>Date</td>
    <td>Employee</td>
    <td>Comments</td>
    <td>Hours</td>
  </tr>
<%
    PersistenceManager pm = PMF.get().getPersistenceManager();
    String query = "select from " + TimeTracked.class.getName() + " order by date desc range 0,5";
    List<TimeTracked> timetracked = (List<TimeTracked>) pm.newQuery(query).execute();
    if (timetracked.isEmpty()) {
%>
<tr><td>The Time Logbook has no entries.</td></tr>
<%
    }
    else {
        for (TimeTracked g : timetracked) {
%>

  <tr>
    <td><%= g.getDate() %></td>
    <td><%= g.getEmployeeName() %></td>
    <td><%= g.getWorkComments() %></td>
    <td><%= g.getHoursWorked() %></td>
  </tr>
<%
        }
    }
    pm.close();
%>
</table>
  </body>
</html>
