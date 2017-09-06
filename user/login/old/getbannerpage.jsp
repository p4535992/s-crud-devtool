<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.TableColumn" %>
<%
String  DriverName= request.getParameter("DriverName");
String  BeanName = request.getParameter("BeanName");
String  BeanClass = request.getParameter("BeanClass");
String  BeanPackage = request.getParameter("BeanPackage");
String  JNDIDSN   = request.getParameter("JNDIDSN");
String  TableName = request.getParameter("TableName");
String  IDField = request.getParameter("IDField");
String  IDFieldType = request.getParameter("IDFieldType") ;
String  WebApp = request.getParameter("WebApp") ;
String  Title = request.getParameter("Title") ;
String  LoginClass = request.getParameter("LoginClass") ;
String  LoginObjectID = request.getParameter("LoginObjectID") ;
String  LoginIDField =  request.getParameter("LoginIDField") ;
String  LoginIDFieldType = request.getParameter("LoginIDFieldType") ;
String  PasswordField = request.getParameter("PasswordField") ;
String  DisplayFields = request.getParameter("DisplayFields") ;
String  LoginForm  = request.getParameter("LoginForm")  ;
String  LogoutPage = request.getParameter("LogoutPage") ;
String  LoginServlet = request.getParameter("LoginServlet") ;
String  LoginServletPath = request.getParameter("LoginServletPath");
String  LoginFilter = request.getParameter("LoginFilter") ;
String  AccessPath = request.getParameter("AccessPath") ;
String  LoginSuccesPath = request.getParameter("LoginSuccesPath") ;
String  LoginFailurePath = request.getParameter("LoginFailurePath") ;

boolean   bIntegerIDField=true;
String	 Quotes="";


String ContentType =  "application/x-download" ;
String ContentDisp = "attachment; filename=banner.jsp" ;
response.setContentType(ContentType);
response.setHeader("Content-Disposition", ContentDisp);

//response.setContentType("text/plain");
if("INT".equalsIgnoreCase(LoginIDFieldType))
{
   // ID field is Integer quotes not needed in SQL expression.
   bIntegerIDField=true;
	 Quotes="";
}
else
{
   // ID field is Character type, quotes needed in SQL expression
 		bIntegerIDField=false;
	  Quotes="'";
}
String usrpath = null;
if( AccessPath!=null && AccessPath.length() > 0 ) usrpath = AccessPath.replace("*", "");
else usrpath="" ;

%><\%@ page errorPage = "/errorpage.jsp" %>
<\%@ page import="<%=WebApp %>.*"%>
<\%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>

<% 
//out.print("<jsp:useBean id=\"AppRes\" scope=\"application\" class=\""+WebApp+".ApplicationResource\" />\r\n");
%>
<\% 
String appPath = request.getContextPath();
<%=WebApp %>.<%=LoginClass %> LogUsr =  (<%=WebApp %>.<%=LoginClass %>)session.getAttribute("<%=LoginObjectID %>") ;
String LogUsrName = "" ;
if(LogUsr != null)
{
  LogUsrName= LogUsr.getUserName();
}

%>
<div id="page_banner">
<table width="100%" align="center" border="0">
<tr>
	<td valign="top" align="left" width="20%">
	<img src="<\%=appPath %><\%=ApplicationResource.logo %>" border="0" alt="Web application logo">
	</td>
	<td valign="top" align="center" width="60%">
	<img src="<\%=appPath %><\%=ApplicationResource.banner %>" border="0" alt="Web application banner">
	<br clear="all">
     <span class="label">Logged user:</span>&nbsp;<span class="dataitem"><\%=LogUsrName %></span>[<a href="<\%=appPath %><%=usrpath %><%=LogoutPage.replace("/","") %>" title="Click here to logout from session" > Logout</a> ]	
	</td>
	<td valign="top" align="right" width="20%">
	 <a href="<\%=appPath %><%=usrpath %>index.jsp"><img src="<\%=appPath %><\%=ApplicationResource.homelink_image %>" border="0" alt="Back to user home page."></a></td>
</tr>
</table>
</div>