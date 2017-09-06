<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.db.$DATABASE.*"%> 
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*, javax.servlet.*, javax.servlet.http.* " %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.* com.webapp.base64.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<jsp:useBean id="Sms_GtWysBn" scope="page" class="com.db.$DATABASE.Sms_gatewayaccountsBean" />
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);
com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiBn.locateRecord(LogUsr.AdminID);

int nAccountID = 0;
try
{
   nAccountID = Integer.parseInt(request.getParameter("AccountID"));
}
catch(NumberFormatException ex)
{ 
   nAccountID = 0;
}
Sms_GtWysBn.locateRecord(nAccountID);

String UserID = request.getParameter("UserID_"+nAccountID);
String Password = request.getParameter("Password_"+nAccountID);
String SenderIDValue = request.getParameter("SenderIDValue_"+nAccountID);

java.sql.Timestamp dt = new java.sql.Timestamp(System.currentTimeMillis()); 

Sms_GtWysBn.executeUpdate("UPDATE `sms_gatewayaccounts` SET `UserID`='"+UserID+"', `Password`='"+Password+"', `SenderIDValue`='"+SenderIDValue+"', `UpdateDateTime`='"+dt+"' WHERE `AccountID`="+nAccountID+" ");
%>