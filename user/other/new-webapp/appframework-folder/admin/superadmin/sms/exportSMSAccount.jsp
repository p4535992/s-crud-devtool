<%@ page errorPage = "/errorpage.jsp" %><%@ page import="com.$WEBAPP.*, com.$WEBAPP.appsms.*, com.db.$DATABASE.*"%><%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*,javax.servlet.*, javax.servlet.http.*" %><%@ page import="org.apache.commons.lang3.*, org.apache.commons.io.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.base64.*" %><%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%><jsp:useBean id="Sms_GtWysBn" scope="page" class="com.db.$DATABASE.Sms_gatewayaccountsBean" /><%
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
	 
	 String xml = SMSAccountHelper.exportToXml( Sms_GtWysBn );
	 String filename = "Export_ActID_"+ Sms_GtWysBn.AccountID+".xml";
	 response.setHeader("Cache-control", "no-cache"); 
   response.setDateHeader("Expires", 0); 
   response.setHeader("Pragma", "No-cache"); 
	 response.setContentType("application/x-download");
	 String ContentDisp = "attachment; filename=\""+filename+"\"" ;	
	 response.setHeader("Content-Disposition", ContentDisp);
	 out.print(xml);
%>
