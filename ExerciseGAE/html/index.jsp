<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!-- The HTML 4.01 Transitional DOCTYPE declaration-->
<!-- above set at the top of the file will set     -->
<!-- the browser's rendering engine into           -->
<!-- "Quirks Mode". Replacing this declaration     -->
<!-- with a "Standards Mode" doctype is supported, -->
<!-- but may lead to some differences in layout.   -->


<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    
    <title>App Engine Consulting Time Tracker</title>
  </head>

  <body>
    <h1>Welcome to the Time Tracker!</h1>

    <table>
      <tr>
        <td colspan="2" style="font-weight:bold;">Available Features:</td>        
      </tr>
      <tr>
        <td><a href="addtime.jsp">Add time worked</a></td>
      </tr>
      <tr>
        <td><a href="listtime.jsp">View time worked</a></td>
      </tr>
      <tr>
        <td><a href="<%= UserServiceFactory.getUserService().createLoginURL(request.getRequestURI()) %>">Log In</a></td>
      </tr>
      <tr>
        <td><a href="<%= UserServiceFactory.getUserService().createLogoutURL(request.getRequestURI()) %>">Log Out</a></td>
      </tr>
      <tr>
        <td><a href="/appstats/">App Stats</a></td>
      </tr>
      <tr>
        <td><a href="_ah/admin">Admin Console</a></td>
      </tr>
      <tr>
        <td><a href="/sendmailalert">Send Mail Alert</a></td>
      </tr>
      
    </table>
  </body>
</html>
