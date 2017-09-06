<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.*"%>
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, javax.servlet.*, javax.servlet.http.* " %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.* com.webapp.base64.* " %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="StBn" scope="page" class="com.db.$DATABASE.State_cityBean" />
<% 
String State =request.getParameter("state");
//out.println(State);
%>
<select name="City" id="City" class="form-control show-tick selectpicker">
      <option value="">-- NONE --</option>
 	<% 
    StBn.openTable("WHERE `State`='"+State+"' ", " ");
    while(StBn.nextRow())
    { 
  %>
      <option value="<%=StBn.City %>"><%=StBn.City %></option>
  <% 
    }
    StBn.closeTable();
  %>
</select>

