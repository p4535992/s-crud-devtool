<%
 String WebApp=request.getParameter("WebApp") ;
 String BeanPackage=request.getParameter("BeanPackage") ;
 String bConfigSMS = request.getParameter("ConfigSMS") ; 
%><\%@ page errorPage = "/errorpage.jsp" %><\%@ page import="<%=WebApp %>.*, <%=WebApp %>.apputil.*,<%if(bConfigSMS.equalsIgnoreCase("true")){%> <%=WebApp %>.appsms.*, <%=WebApp %>.appmail.*,<% } %> <%=BeanPackage %>.*"%> 
<\%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*,javax.servlet.*, javax.servlet.http.*" %>
<\%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.base64.*" %>
<\%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>