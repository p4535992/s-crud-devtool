<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="java.io.*, java.util.*, java.math.*,  java.sql.*, javax.servlet.*, javax.servlet.http.* " %>
<%@ page import="com.webapp.utils.*, com.webapp.db.*,  com.$WEBAPP.*, com.db.$WEBAPP.* " %>
<%@ taglib uri="mytag" prefix="dtag" %><%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<% 
String AppURL = request.getContextPath() ;
String thisFile = AppURL+request.getServletPath() ;
String ParamSQL = request.getParameter("SQL") ;
 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"  "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Excel Ouput From SQL Query</title>
<link rel="stylesheet" href="<%=AppURL %><%=ApplicationResource.stylesheet %>" type ="text/css" />
<style type="text/css">
.navtext 
{
width:300px;
font-size:10pt;
font-family:verdana;
border-width:2px;
border-style:outset;
border-color:#006BAE;
/* layer-background-color:#FFF6D9; */
background-color:#FFF6D9;
color:black;
}
</style>
<jsp:include page="/scripts/jquery/jquery.jsp" flush="true" />
<script type="text/javascript" src="<%=AppURL %>/scripts/alttxt/alttxt-div.js"></script>
<script type="text/javascript">
<!--
function NavigateTo(url)
{ 
  document.location.href = url ;
}

function InitPage()
{
  InitAltTxt();
}


$(document).ready(function(){
 // Init jQuery 
 // Access objects  $("#ID").$func()
 
 // End init
});

// -->
</script>

</head>
<body class="admin" onload="InitPage()">
<jsp:include page="/admin/banner.jsp" flush="true" />
<div class="block">
<table border="0" cellpadding="4" cellspacing="0" summary="" width="100%">
<tr>
  <td valign="top" align="left" width="70%" >
	<span class="title">Excel Output From Query</span>
	</td>
	<td valign="top" align="right" width="30%" >
	<a href="<%=AppURL %>/admin/index.jsp" onmouseover="writetxt('back_link')" onmouseout="writetxt(0)" ><b>&#x25C4; Go Back</b></a>&nbsp;&nbsp;
	</td>
</tr>
</table>
<div id="back_link" style="display:none;">Back to <b>admin main</b> page</div>
</div>
<div style="padding:1em;">
<form action="<%=AppURL %>/getexcelfromquery/" method="post">
<input type="hidden" name="SQL" value="<%=ParamSQL %>" />
<p>
 <button type="submit">Get Excel File</button><br/>
 Excel File Format: &nbsp;<input type="radio" name="xls" value="false" checked="checked" /> Newer (*.xlsx ) Excel 2007 / 2010&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<input type="radio" name="xls" value="true" /> Older (*.xls)  Excel 97, XP, 2003  
</p>
<jsp:include page="/getexcelfromquery/" flush="true">
   <jsp:param name="SQL" value="<%=ParamSQL %>" />
</jsp:include> 

</form>  
</div>

</div>

<!-- Div  for  AltTxt DHTML tooltip -->
<div id="navtxt" class="navtext" style="visibility:hidden; position:absolute; top:0px; left:-400px; z-index:10000; padding:10px"></div>

</body>
</html>
