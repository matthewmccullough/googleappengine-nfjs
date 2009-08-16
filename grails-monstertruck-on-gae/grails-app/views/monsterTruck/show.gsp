<%@ page import="com.ambientideas.appengine.MonsterTruck" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Show MonsterTruck</title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">MonsterTruck List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New MonsterTruck</g:link></span>
        </div>
        <div class="body">
            <h1>Show MonsterTruck</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>

                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:monsterTruckInstance, field:'id')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Driver Name:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:monsterTruckInstance, field:'driverName')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Horse Power:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:monsterTruckInstance, field:'horsePower')}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Truck Name:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:monsterTruckInstance, field:'truckName')}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <input type="hidden" name="id" value="${monsterTruckInstance?.id}" />
                    <span class="button"><g:actionSubmit class="edit" value="Edit" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>
