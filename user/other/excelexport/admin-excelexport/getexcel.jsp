<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.webapp.utils.*, com.webapp.db.* com.webapp.jsp.*,  com.$WEBAPP.*, com.db.$WEBAPP.* " %>
<%@ taglib uri="mytag" prefix="dtag" %><%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<% 
String appPath = request.getContextPath() ;
String thisFile =appPath+request.getServletPath() ;
String ParamSQL = request.getParameter("SQL") ;


String ParamReturnPath = request.getParameter("ReturnPath") ;
String ReturnPath = RequestHelper.getBase64param(request, "ReturnPath");
if(ReturnPath ==null || ReturnPath.length()==0) ReturnPath= appPath+"/admin/index.jsp" ;


 %>
<!DOCTYPE HTML >
<html>
<head>
<title>Excel Ouput From SQL Query</title>
<link rel="stylesheet" href="<%=appPath %><%=ApplicationResource.stylesheet %>" type ="text/css" />
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
<script type="text/javascript" src="<%=appPath %>/scripts/alttxt/alttxt-div.js"></script>
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
	<a href="<%=ReturnPath %>" onmouseover="writetxt('back_link')" onmouseout="writetxt(0)" ><b>&#x25C4; Done, Go Back</b></a>&nbsp;&nbsp;
	</td>
</tr>
</table>
<div id="back_link" style="display:none;">Back to <b>admin main</b> page</div>
</div>
<div style="padding:1em;">
<form action="<%=appPath %>/getexcelfromquery/" method="post">
<input type="hidden" name="SQL" value="<%=ParamSQL %>" />
<input type="hidden" name="xls" value="false" />
<% 
if(ParamReturnPath !=null && ParamReturnPath.length()>0)
{ 
%>
<input type="hidden" name="ReturnPath" value="<%=ParamReturnPath %>" />
<% 
} 
%>

<button type="submit">Get Excel File</button>

<p>[&nbsp;&nbsp;<a href="javascript:void(0)" onclick="{ $('.chkbx').prop('checked', true); }">Check All</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:void(0)" onclick="{ $('.chkbx').prop('checked', false); }">Un-Check All</a>&nbsp;&nbsp;]</p>
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
