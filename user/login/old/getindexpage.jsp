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
String  ScriptFolder = request.getParameter("ScriptFolder") ;


boolean   bIntegerIDField=true;
String	 Quotes="";


String ContentType =  "application/x-download" ;
String ContentDisp = "attachment; filename=index.jsp" ;
response.setContentType(ContentType);
response.setHeader("Content-Disposition", ContentDisp);

//response.setContentType("text/plain");

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
<!DOCTYPE html>
<html>
<head>
<title><\%=ApplicationResource.pagetitle %></title>
<link rel="stylesheet" href="<\%=appPath %><\%=ApplicationResource.stylesheet %>" type ="text/css" />
<\%--JQuery include mostly needed
<% 
out.println("<jsp:include page=\""+ScriptFolder+"/jquery/jquery.jsp\" flush=\"true\" />");
out.println("<jsp:include page=\""+ScriptFolder+"/jvalidate/jvalidate.jsp\" flush=\"true\" />");
 %>
 --%>
<script type="text/javascript">
<!--
function NavigateTo(url)
{ 
document.location.href = url ;
}

<\%--JQuery Init  mostly needed
$(document).ready(function(){
 // Init jQuery 
 // Access objects  $("#ID").$func()
 
 // End init
});

--%> 


// --> 
</script>
</head>
<body  class="main">
<div id="page_banner">
<table width="100%" align="center" border="0">
<tr>
	<td valign="top" align="left" width="20%">
	<img src="<\%=appPath %><\%=ApplicationResource.logo %>" border="0" alt="Web application logo">
	</td>
	<td valign="top" align="center" width="60%">
	<img src="<\%=appPath %><\%=ApplicationResource.banner %>" border="0" alt="Web application banner">
	
	</td>
	<td valign="top" align="right" width="20%">&nbsp;</td>
</tr>
</table>

</div>
<hr size="1" /> 
<div align="center" >  
   <big>Welcome </big><span class="label" align="center"><\%=LogUsrName %> </span><span class="dataitem">( <%=Title %> )</span> 
</div>
<hr size="1" />
<br clear="all">

<div style="margin: 1em">
<ul>
 <li><p><b><a href="<\%=appPath %><%=usrpath %>#">Link To Other Pages</a></b></p></li>
</ul>
 
<ul> 
 <li><p><b><a href="<\%=appPath %><%=usrpath %>changepassword.jsp" >Change Login Password</a></b></p></li> 
 <li><p><b><a href="<\%=appPath %><%=usrpath %><%=LogoutPage.replace("/","") %>">Logout From Session</a></b></p></li> 
</ul>
</div>
</body>
</html>

