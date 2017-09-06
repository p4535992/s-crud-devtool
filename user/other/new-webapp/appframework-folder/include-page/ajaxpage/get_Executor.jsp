<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.*"%>
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, javax.servlet.*, javax.servlet.http.* " %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.* com.webapp.base64.* " %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<%
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 
 
String ExecuteBy = request.getParameter("ExecuteBy");
%>
<% if(ExecuteBy.equalsIgnoreCase("Administrator")){ %>
<select name="ExecutorID" id="ExecutorID" class="form-control show-tick selectpicker">
 <option value="">-- All --</option>
 <% 
    SiBn.openTable("WHERE `AdminID` NOT IN ('1') " , " ");
    while(SiBn.nextRow())
    { 
 %>
        <option value="<%=SiBn.AdminID %>"><%=ShowItem.showAdminNameWithGender(SiBn.AdminID, 1) %></option>
 <% 
    }
    SiBn.closeTable(); 
 %>
</select>
<% } %>