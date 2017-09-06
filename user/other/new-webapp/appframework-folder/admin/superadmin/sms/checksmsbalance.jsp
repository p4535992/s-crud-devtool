<%@ page errorPage = "/errorpage.jsp" %><%@ page import="com.$WEBAPP.*, com.$WEBAPP.appsms.*, com.db.$DATABASE.*"%><%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*,javax.servlet.*, javax.servlet.http.*" %><%@ page import="org.apache.commons.lang3.*, org.apache.commons.io.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.base64.*" %><%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%><jsp:useBean id="Sms_GtWysBn" scope="page" class="com.db.$DATABASE.Sms_gatewayaccountsBean" /><% 
  response.setDateHeader("Expires", 0 );
  response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
  response.setHeader("Pragma", "no-cache"); 
SMSService smsServ = (SMSService)application.getAttribute("WEBSMS-SERVICE") ; 
int nAccountID = 0 ;
try
{
    nAccountID = Integer.parseInt(request.getParameter("AccountID")) ;
}
catch(NumberFormatException ex)
{
    nAccountID = 0 ;
}
int nBal = 0;
nBal = smsServ.checkSMSBalance(nAccountID);
Sms_GtWysBn.locateRecord( nAccountID );
Sms_GtWysBn.LastSMSBalance = nBal;
Sms_GtWysBn.BalanceCheckTime = new java.sql.Timestamp(System.currentTimeMillis()); 
//Sms_GtWysBn.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis());
Sms_GtWysBn.updateRecord( nAccountID );
%><%=nBal %>