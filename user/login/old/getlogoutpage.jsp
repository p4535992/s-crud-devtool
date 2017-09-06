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
String ContentDisp = "attachment; filename="+LogoutPage.substring(1);	
response.setContentType(ContentType);
response.setHeader("Content-Disposition", ContentDisp);

//response.setContentType("text/plain");

%><\%@ page errorPage = "/errorpage.jsp" %>
<\%@ page import="<%=WebApp %>.*"%>
<\%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<% 
 // out.print("<jsp:useBean id=\"AppRes\" scope=\"application\" class=\""+WebApp+".ApplicationResource\" />\r\n");
%>
<\% 
String appPath = request.getContextPath();
<%=WebApp %>.<%=LoginClass %> LogUsr =  (<%=WebApp %>.<%=LoginClass %>)session.getAttribute("<%=LoginObjectID %>") ;
String LogUsrName = "" ;
if(LogUsr != null)
{
  LogUsrName= LogUsr.getUserName();
  LogUsr.invalidate();
  session.removeAttribute("<%=LoginObjectID %>") ;
	session.invalidate() ;
}

%>
<!DOCTYPE html>
<html>
<head>
<title><\%=ApplicationResource.pagetitle %></title>
<link rel="stylesheet" href="<\%=appPath %><\%=ApplicationResource.stylesheet %>" type ="text/css" />

<script type="text/javascript">
<!--
function NavigateTo(url)
{ 
document.location.href = url ;
}
// --> 
</script>
</head>
<body  class="main">
<\%-- Page Banner if relevent 
<% out.print("<jsp:include page=\"/banner.jsp\" flush=\"true\" />"); %>
 --%>
<hr size="1" /> 
  <span class="title" align="center"><\%=LogUsrName %> ( <%=Title %> )</span> <b>is logged out  from current browser session.</b>
<hr size="1" />
<p>&nbsp;</p>
<div style="margin: 1em">
<ul>
 <li><p><b><a href="<\%=appPath %><%=LoginForm %>">Click here</a> to login once again.</b></p></li>
 <li><p><b><a href="<\%=appPath %>/index.jsp">Click here</a> to go main page.</b></p></li> 
</ul></div>
</body>
</html>

