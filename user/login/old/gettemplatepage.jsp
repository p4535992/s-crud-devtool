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
String ContentDisp = "attachment; filename="+TableName+"-template.jsp" ;
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
<\%@ page import="java.util.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, <%=WebApp %>.*"%>
<\%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<\% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
/* Logged user reference if relevent
   <%=WebApp %>.<%=LoginClass %> LogUsr =  (<%=WebApp %>.<%=LoginClass %>)session.getAttribute("<%=LoginObjectID %>") ;
*/

%>
<!DOCTYPE html>
<html>
<head>
<title>Page Title</title>
<link rel="stylesheet" href="<\%=appPath %><\%=ApplicationResource.stylesheet %>" type ="text/css" />
<style type="text/css">
.navtext 
{
    width:300px;
    font-size:10pt;
    font-family:verdana;
    border-width:2px;
    border-style:outset;
    border-color:#006BAE;
    background-color:#FFF6D9;
    color:black;
}

.datalist th {  font-size:10pt; }
.datalist td {  font-size:10pt; }

</style>
<script type="text/javascript" src="<\%=appPath %>/scripts/alttxt/alttxt-div.js"></script>

 
<% 
out.println("<jsp:include page=\""+ScriptFolder+"/jquery/jquery.jsp\" flush=\"true\" />");
out.println("<jsp:include page=\""+ScriptFolder+"/jvalidate/jvalidate.jsp\" flush=\"true\" />");
 %>
 

<script type="text/javascript">
 
function NavigateTo(url)
{ 
  document.location.href = url ;
}

function InitPage()
{
   // Do something on page init
   InitAltTxt();
}
 
$(document).ready(function(){
 // Init jQuery 
 // Access objects  $("#ID").$func()
  

 // End init
});

 
 
</script>
</head>
<body  class="main" onload="InitPage()">
<% out.print("<jsp:include page=\""+usrpath+"banner.jsp\" flush=\"true\" />"); %>
<div class="block"><!-- Header block begin -->
<table width="100%">
<tr>
	<td valign="top" align="left" width="70%" ><span class="title">Page Title </span></td>
	<!-- <td valign="top" align="center" width="30%" >?? </td> -->
	<td valign="top"  align="right" width="30%" > <a href="<\%=appPath %><%=usrpath %>index.jsp"> &#x25C4; Go Back</a>&nbsp;&nbsp;( Parent Page )</td>
</tr>
</table>
</div><!-- Header block end -->
<div id="maindiv" style="margin: 1em"><!-- main div begin -->
<ul>
 <li><p><b><a href="<\%=appPath %><%=usrpath %>#">Link To Other Pages</a></b></p></li>
</ul>
</div><!-- main div end -->

<!-- Div  for  AltTxt DHTML tooltip -->
<div id="navtxt" class="navtext" style="visibility:hidden; position:absolute; top:0px; left:-400px; z-index:10000; padding:10px"></div>
</body>
</html>

