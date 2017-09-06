<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="java.sql.*" %><%@ page import="com.beanwiz.*, com.webapp.utils.*" %>
<%
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath();

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head> 
<title>Other Tools</title>
<link rel="stylesheet" type="text/css" href="<%=appPath %>/style.css" />
<style type="text/css">
.navtext 
{
    width:300px;
    font-size:10pt;
    font-family:verdana;
    border-width:2px;
    border-style:outset;
    border-color:#006BAE;
    layer-background-color:#FFF6D9;
    background-color:#FFF6D9;
    color:black;
}
</style>
<jsp:include page="/scripts/jquery/jquery.jsp" flush="true" />
<jsp:include page="/scripts/jvalidate/jvalidate.jsp" flush="true" />
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

   // End init
});


// -->
</script>

</head>
<body onload="InitPage()">
<jsp:include page="/banner.jsp" flush="true" />
<table border="1"  width="100%" cellpadding="6" cellspacing="0">
<tr>
<td width="60%" align="left">
<span class="title">Other Useful Tools</span>
</td>
<td width="20%"  align="center"><a href="<%=appPath %>/user/index.jsp">Go to JNDI DSN List</a></td> 
<td width="20%"  align="right">
<a href="<%=appPath %>/index.jsp">  &#x25C4; Back to Home</a>
</td>
</tr>
</table>
<div style="padding:1em" id="maindiv">
<ul>
<li><p><a href="<%=appPath %>/user/other/statusflags" onmouseout="writetxt(0)" onmouseover="writetxt('entity_help')" >Status Flag Entities</a></p></li>
<li><p><a href="<%=appPath %>/user/other/generic/index.jsp" onmouseout="writetxt(0)" onmouseover="writetxt('generic_help')" >Generic JSP Page</a></p></li>
<li><p><a href="<%=appPath %>/user/other/excel-to-mysql-code/index.jsp" onmouseout="writetxt(0)" onmouseover="writetxt('excel_mysql_help')" >Get JSP Code For Excel To MySQL</a></p></li>
<li><p><a href="<%=appPath %>/user/other/excel-mysql-data-migrate/index.jsp" onmouseout="writetxt(0)" onmouseover="writetxt('excel_mysql_migrate')" >Migrate Data From Excel To MySQL</a></p></li>




<li><p><a href="webapp.zip"   onmouseout="writetxt(0)" onmouseover="writetxt('webapp_help')" >Get Web App Framework</a></p></li>
<li><p><a href="excelexport.zip"   onmouseout="writetxt(0)" onmouseover="writetxt('table_excel_export')" >Get Excel Export From Query</a></p></li>
<li><p><a href="labelprint.zip"   onmouseout="writetxt(0)" onmouseover="writetxt('label_print_help')" >Get Label Printing Code</a></p></li>
<li><p><a href="email-support.zip"   onmouseout="writetxt(0)" onmouseover="writetxt('email_support')" >Get Email Sending Code</a></p></li>
<li><p><a href="sms-support.zip"   onmouseout="writetxt(0)" onmouseover="writetxt('sms_support')" >Get SMS Sending Code</a></p></li>


</ul>

<div id="help-divs"  style="display:none" >
   <div id="webapp_help">
       Download zip file : <b>webapp.zip </b> which contains basic JSP / Java / JavaScript files used in
       pages generated by this wizard. It provides basic <span style="color:navy; text-decoration: italics;" >Web Application Framework</span> 
		   code which you can modify to suite your specific needs.
   </div>
   <div id="entity_help">
      Create classs for entities. Define short/integer constants.
   </div>
	  <div id="generic_help">
      Create generic JSP page usefull in any application.
   </div>
   <div id="excel_mysql_help">
      Generate JSP page that can insert records from Excel file into mysql table.
   </div>
	 <div id="excel_mysql_migrate">
      Migrate data from MS Excel to MySQL tables. Either create table or append to existing table
   </div>
	 <div id="table_excel_export">
      Get JSP code to export query result to MS Excel file.
   </div>
	 <div id="label_print_help">
      Get JSP code to print lables from database table. The lable will be in A4, 2row X 6col layout. The output will be in PDF file.
   </div>
	 <div id="email_support">
      Get JSP code to send bulk emails from web application.
   </div>
	 <div id="sms_support">
      Get JSP code to send bulk SMS from web application.
   </div>
	 
	 
</div> <!-- end #help-divs-->

</div> <!-- end #maindiv -->
<!-- Div  for  AltTxt DHTML tooltip -->
<div id="navtxt" class="navtext" style="visibility:hidden; position:absolute; top:0px; left:-400px; z-index:10000; padding:10px"></div>

</body>
</html>
