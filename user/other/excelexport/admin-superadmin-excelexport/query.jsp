<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="java.io.*, java.util.*, java.math.*,  java.sql.*, javax.servlet.*, javax.servlet.http.* " %>
<%@ page import="com.webapp.utils.*, com.webapp.db.*,  com.webapp.base64.*,  com.$WEBAPP.*, com.db.$WEBAPP.* " %>
<%@ taglib uri="mytag" prefix="dtag" %><%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<% 
String AppURL = request.getContextPath() ;
String thisFile = AppURL+request.getServletPath() ;

if("POST".equalsIgnoreCase(request.getMethod()))
{ 
// redirect getexcel.jsp
String query = request.getParameter("query") ;
String SQL =  new String(UrlBase64.encode(query.getBytes() ) );
String redirect = "getexcel.jsp?SQL="+SQL ;

response.sendRedirect(response.encodeRedirectURL(redirect));

}

 %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"  "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Page Title</title>
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

function InsertSQL(tbl)
{

    var content = " SELECT * FROM "+tbl;
    var txtarea = document.getElementById("querybox");
	  var sel ;
    //IE support
    if (document.selection) 
    {
       txtarea.focus();
       sel = document.selection.createRange();
       sel.text = content;
    }
    else if (txtarea.selectionStart ||txtarea.selectionStart == '0')
    {
       var startPos = txtarea.selectionStart;
       var endPos = txtarea.selectionEnd;
       txtarea.value = txtarea.value.substring(0, startPos)+ content+ txtarea.value.substring(endPos, txtarea.value.length);
    } 
    else 
    {
       txtarea.value +=  content;
    }
 
} // End function InsertComment(BLK)
 


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
	<span class="title">S.Q.L. Query</span>
	</td>
	<td valign="top" align="right" width="30%" >
	<a href="<%=AppURL %>/admin/index.jsp" onmouseover="writetxt('back_link')" onmouseout="writetxt(0)" ><b>&#x25C4; Go Back</b></a>&nbsp;&nbsp;
	</td>
</tr>
</table>
<div id="back_link" style="display:none;">Back to <b>admin main</b> page</div>
</div>
<table border="0" cellpadding="6" cellspacing="0" summary="" width="100%">
<tr>
<td width="50%" valign="top" >

<form action="<%=thisFile %>" method="post">


<p>Enter SQL Query:</p>
<p>
<textarea rows="4" cols="50" name="query" id="querybox">

</textarea>
</p>
<p><button type="submit">Ok Submit</button></p>
</form>

</td>
<td width="50%" valign="top" >
<div style="height:400px; overflow:auto;">
<%  
GenericQuery genqry = new GenericQuery(ApplicationResource.database, application);
Connection conn = genqry.Connect();
DatabaseMetaData md=conn.getMetaData();
String[] tbl_types = {"TABLE"} ;
ResultSet rslt = md.getTables(null,null,null,tbl_types );
int no=0;
while(rslt.next())
{ 
no++;
String TableName = rslt.getString("TABLE_NAME");	
%>
[ <%=no %> ]&nbsp;&nbsp;<a href="javascript:void(0)" onclick="InsertSQL('<%=TableName %>')"><%=TableName %> </a><br/>
<% 
}
rslt.close();
genqry.Disconnect(conn);
 %>
</td>

</tr>
</table>

</div>

<!-- Div  for  AltTxt DHTML tooltip -->
<div id="navtxt" class="navtext" style="visibility:hidden; position:absolute; top:0px; left:-400px; z-index:10000; padding:10px"></div>

</body>
</html>
