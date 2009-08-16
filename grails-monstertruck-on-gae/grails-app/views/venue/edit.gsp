<%@ page import="com.ambientideas.appengine.Venue" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Edit Venue</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">Venue List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New Venue</g:link></span>
        </div>
        <div class="body">
            <h1>Edit Venue</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${venueInstance}">
            <div class="errors">
                <g:renderErrors bean="${venueInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${venueInstance?.id}" />
                <input type="hidden" name="version" value="${venueInstance?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="seatingCapacity">Seating Capacity:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:venueInstance,field:'seatingCapacity','errors')}">
                                    <input type="text" id="seatingCapacity" name="seatingCapacity" value="${fieldValue(bean:venueInstance,field:'seatingCapacity')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="venueName">Venue Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:venueInstance,field:'venueName','errors')}">
                                    <input type="text" id="venueName" name="venueName" value="${fieldValue(bean:venueInstance,field:'venueName')}"/>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" value="Update" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
