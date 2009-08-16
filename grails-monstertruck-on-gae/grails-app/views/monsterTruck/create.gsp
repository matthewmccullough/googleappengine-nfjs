<%@ page import="com.ambientideas.appengine.MonsterTruck" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Create MonsterTruck</title>         
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${resource(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">MonsterTruck List</g:link></span>
        </div>
        <div class="body">
            <h1>Create MonsterTruck</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${monsterTruckInstance}">
            <div class="errors">
                <g:renderErrors bean="${monsterTruckInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" method="post" >
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="driverName">Driver Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:monsterTruckInstance,field:'driverName','errors')}">
                                    <input type="text" id="driverName" name="driverName" value="${fieldValue(bean:monsterTruckInstance,field:'driverName')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="horsePower">Horse Power:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:monsterTruckInstance,field:'horsePower','errors')}">
                                    <input type="text" id="horsePower" name="horsePower" value="${fieldValue(bean:monsterTruckInstance,field:'horsePower')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="truckName">Truck Name:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:monsterTruckInstance,field:'truckName','errors')}">
                                    <input type="text" id="truckName" name="truckName" value="${fieldValue(bean:monsterTruckInstance,field:'truckName')}"/>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><input class="save" type="submit" value="Create" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
