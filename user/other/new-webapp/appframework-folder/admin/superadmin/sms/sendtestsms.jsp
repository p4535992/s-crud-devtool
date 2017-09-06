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

String Number=request.getParameter("Number") ;
String Text = request.getParameter("Text") ;
if(Number !=null && Number.length() >0 )
{
   if(smsServ.checkNumber(Number))
	 {
	   SMSServerResponse SrvRsp =  smsServ.sendSMS( nAccountID , Number ,  Text );
		 if(SrvRsp.ReturnVal< 0)
		 {
		    %><span class="label bg-red-800" style="font-size: 13px;">Error :</span> <%=SMSErrorCodes.getLabel(SrvRsp.ReturnVal) %><br/>
				<%=SrvRsp.Response  %><%
		 }
		 else
		 {
		  %><span class="blue-grey-700"><%=SrvRsp.Response  %></span><br/><span class="blue-grey-700">SMS Count : </span> <%=SrvRsp.MsgCount  %><br/><span class="label bg-green-800" style="font-size: 13px;"><%=SMSDispatchStatus.getLabel(SrvRsp.ReturnVal) %></span><%
		 }
	 }
	 else
	 { 
	     out.println("<span class=\"label bg-red-800\" style=\"font-size: 13px;\">Error :</span> Invalid Mobile Number");
	 }
}
else
{
  out.println("<span class=\"label bg-red-800\" style=\"font-size: 13px;\">Error :</span> Blank Number");
}

 %>