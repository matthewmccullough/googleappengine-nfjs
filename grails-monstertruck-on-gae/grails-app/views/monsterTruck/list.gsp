<%@ page import="com.ambientideas.appengine.MonsterTruck" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>MonsterTruck List</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="create" action="create">New MonsterTruck</g:link></span>
        </div>
        <div class="body">
            <h1>MonsterTruck List</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                   	        <g:sortableColumn property="id" title="Id" />
                        
                   	        <g:sortableColumn property="driverName" title="Driver Name" />
                        
                   	        <g:sortableColumn property="horsePower" title="Horse Power" />
                        
                   	        <g:sortableColumn property="truckName" title="Truck Name" />
                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${monsterTruckInstanceList}" status="i" var="monsterTruckInstance">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                        
                            <td><g:link action="show" id="${monsterTruckInstance.id}">${fieldValue(bean:monsterTruckInstance, field:'id')}</g:link></td>
                        
                            <td>${fieldValue(bean:monsterTruckInstance, field:'driverName')}</td>
                        
                            <td>${fieldValue(bean:monsterTruckInstance, field:'horsePower')}</td>
                        
                            <td>${fieldValue(bean:monsterTruckInstance, field:'truckName')}</td>
                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${monsterTruckInstanceTotal}" />
            </div>
        </div>
    </body>
</html>
