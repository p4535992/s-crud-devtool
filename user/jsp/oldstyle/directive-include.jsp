<%
 String WebApp=request.getParameter("WebApp") ;
 String BeanPackage=request.getParameter("BeanPackage") ;
 %><\%@ page errorPage = "/errorpage.jsp" %>
<\%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, javax.servlet.*, javax.servlet.http.* " %>
<\%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.* com.webapp.base64.*, <%=WebApp %>.*, <%=BeanPackage %>.* " %>
<\%@ taglib uri="mytag" prefix="dtag" %><\%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>