<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.appsms.*, com.db.$DATABASE.*"%> 
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
SMSService.resetService(application);
String MessageText = "Web SMS Service Restarted" ;
response.sendRedirect(response.encodeRedirectURL(appPath+"/admin/superadmin/sms/smsappSetting.jsp?Message="+MessageText));
%>

