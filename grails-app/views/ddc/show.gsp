<%@ page import="grails.persistence.Event" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: '${domainClass.propertyName}.label', default: '${domainClass.name}')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list" params="[dc:params.dc]"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create" params="[dc:params.dc]"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>
                    <%  excludedProps = Event.allEvents.toList() << 'version'
                        allowedNames = domainClass.persistentProperties*.name << 'id' << 'dateCreated' << 'lastUpdated'
                        props = domainClass.properties.findAll { allowedNames.contains(it.name) && !excludedProps.contains(it.name) }
                        // Collections.sort(props, comparator.constructors[0].newInstance([domainClass] as Object[]))
                        props.each { p -> %>
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="${domainClass.propertyName}.${p.name}.label" default="${p.naturalName}" /></td>
                            <%  if (p.isEnum()) { %>
                            <td valign="top" class="value">${fieldValue(bean: domainInstance, field: p.name)}</td>
                            <%  } else if (p.oneToMany || p.manyToMany) { %>
                            <td valign="top" style="text-align: left;" class="value">
                                <ul>
                                <g:each in="domainInstance.'${p.name}'" var="item">
                                    <li><g:link controller="${p.referencedDomainClass?.propertyName}" action="show" id="${item.id}">${item?.encodeAsHTML()}</g:link></li>
                                </g:each>
                                </ul>
                            </td>
                            <%  } else if (p.manyToOne || p.oneToOne) { %>
                            <%-- td valign="top" class="value"><g:link controller="${p.referencedDomainClass?.propertyName}" action="show" id="${domainInstance?."${p.name}".id}">${domainInstance?."${p.name}".encodeAsHTML()}</g:link></td --%>
                            <%  } else if (p.type == Boolean.class || p.type == boolean.class) { %>
                            <td valign="top" class="value"><g:formatBoolean boolean="${domainInstance?.${p.name}}" /></td>
                            <%  } else if (p.type == Date.class || p.type == java.sql.Date.class || p.type == java.sql.Time.class || p.type == Calendar.class) { %>
                            <td valign="top" class="value"><g:formatDate date="${domainInstance?.${p.name}}" /></td>
                            <%  } else if(!p.type.isArray()) { %>
                            <td valign="top" class="value">${fieldValue(bean: domainInstance, field: p.name)}</td>
                            <%  } %>
                        </tr>
                    <%  } %>
                    </tbody>
                </table>
            </div>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${domainInstance?.id}" />
                    <g:hiddenField name="dc" value="${params.dc}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
        </div>
    </body>
</html>