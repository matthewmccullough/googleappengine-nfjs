<%@ page import="com.ambientideas.appengine.Venue" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Venue List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New Venue</g:link></span>
        </div>
        <div class="body">
            <h1>Venue List</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="seatingCapacity" title="Seating Capacity" />
                        
                   	        <g:sortableColumn property="venueName" title="Venue Name" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${venueInstanceList}" status="i" var="venueInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${venueInstance.id}">${fieldValue(bean:venueInstance, field:'id')}</g:link></td>
                        
                            <td>${fieldValue(bean:venueInstance, field:'seatingCapacity')}</td>
                        
                            <td>${fieldValue(bean:venueInstance, field:'venueName')}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${venueInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
