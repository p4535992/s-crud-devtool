<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.* " %><%@ page  import="com.webapp.utils.*" %><jsp:useBean id="FieldMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="ManField" scope="session" class="java.util.Vector" /><%


String DriverName= request.getParameter("DriverName");
String BeanName = request.getParameter("BeanName");
String BeanClass = request.getParameter("BeanClass");
String BeanPackage = request.getParameter("BeanPackage");
String JNDIDSN   = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String IDField  =  request.getParameter("IDField").replace((char)32, '_' );
String IDFieldType = request.getParameter("IDFieldType") ;
String IsAuto = request.getParameter("IsAuto") ;
String WebApp =  request.getParameter("WebApp");
String PageTitle =  request.getParameter("PageTitle") ;
String EntityName = request.getParameter("EntityName") ;
String ScriptFolder = request.getParameter("ScriptFolder");
String AltTxt = request.getParameter("AltTxt") ;
boolean bCheckBox = (request.getParameter("CheckBox") !=null )? true : false ;
String OutputFileName = request.getParameter("OutputFileName") ;

String[] ShowFields = request.getParameterValues("ShowFields");
String[] SearchFields = request.getParameterValues("SearchFields");
String[] ForeignFields =  request.getParameterValues("ForeignFields");
StringBuffer FKeys= new StringBuffer("");
boolean bForeignKey = (ForeignFields!=null&&ForeignFields.length>0)?true:false;
boolean bAuto=(IsAuto!=null)?true:false;
boolean bAltTxt = (AltTxt!=null)?true:false;
String AddFormName = TableName+"_Add";
String UpdateFormName = TableName+"_Update";
int n =0;
boolean bDateSupport =("YES".equalsIgnoreCase(request.getParameter("HasDate")))?true:false;
boolean bTimestampSupport =("YES".equalsIgnoreCase(request.getParameter("HasTimestamp")))?true:false;

String ContentType = "application/x-download" ;
String ContentDisp = "attachment; filename="+TableName+"-selection-activity.jsp";	
response.setContentType(ContentType);
response.setHeader("Content-Disposition", ContentDisp);



if(PageTitle==null)
{
  PageTitle=TableName ;
}else if (PageTitle.equalsIgnoreCase("?"))
{
  PageTitle=TableName ;
}
%>
<\%@ page errorPage = "/errorpage.jsp" %>
<\%@ page import="java.util.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, <%=WebApp %>.*, <%=BeanPackage %>.*"%>
<\%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<\% 
   String appPath = request.getContextPath() ;
   String thisFile = appPath+request.getServletPath() ;
 
   int nCount = RequestHelper.getInteger(request, "Count");
   String ReturnPath = RequestHelper.getBase64param(request, "ReturnPath");
   if(ReturnPath==null ) ReturnPath = "<%=OutputFileName %>?Action=Default" ;
   String WhereClause = RequestHelper.getBase64param(request, "WhereClause");
   if(WhereClause==null) WhereClause="";

%>
<!DOCTYPE html>
<html>
<head>
<title>Activity for selected <%=EntityName %> </title>
<link rel="stylesheet" href="<\%=appPath %><\%=ApplicationResource.stylesheet %>" type ="text/css" />
<style type="text/css">
<% 
if(bAltTxt)
{ 
%>
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
<% 
} 
%>
.datalist th {  font-size:10pt; }
.datalist td {  font-size:10pt; }
</style>
<% 
if(bAltTxt)
{  
%>
<script type="text/javascript" src="<\%=appPath %>/scripts/alttxt/alttxt-div.js"></script>
<% 
} 
out.println("<jsp:include page=\"/scripts/jquery/jquery.jsp\" flush=\"true\" />");
%>
<script type="text/javascript">
 
function NavigateTo(url)
{ 
  document.location.href = url ;
}

function InitPage()
{
   // Do something on page init
	 <% 
   if(bAltTxt)
   {  
   %>
       InitAltTxt();
   <% 
   } 
  %>
   
}
 
$(document).ready(function(){
   // Init jQuery 
   // Access objects  $("#ID").$func()
  

   // End init
});

 
 
</script>
</head>
<body  class="main" onload="InitPage()">
<\%-- Page Banner if relevent 
<% out.print("<jsp:include page=\"/banner.jsp\" flush=\"true\" />"); %>
 --%>
<div class="block"><!-- Header block begin -->
<table width="100%">
<tr>
	<td valign="top" align="left" width="70%" ><span class="title">Activity For <span class="dataitem"><\%=nCount %></span> Selected <%=EntityName %> </span></td>
	<!-- <td valign="top" align="center" width="30%" >?? </td> -->
	<td valign="top"  align="right" width="30%" > <a href="<\%=ReturnPath %>"> &#x25C4; Go Back</a>&nbsp;&nbsp;( <%=EntityName %> List )</td>
</tr>
</table>
</div><!-- Header block end -->
<\% 
/*
*  We have got WhereClause passed to this page as Base64 encoded string.
*  Reconstruct full sql string appending where clause
*  Encode full sql again as Base64 encoded string and pass on as SQL parameter in the action links
*/
String Target ="Selected <%=EntityName %>" ;
String FullQuery = " SELECT * FROM `<%=TableName %>` "+WhereClause;
String ParamSQL = RequestHelper.encodeBase64( FullQuery.getBytes());

String ReturPathLink = "";
String ParamReturnPath = request.getParameter("ReturnPath");
if(ParamReturnPath!=null || ParamReturnPath.length()>0)
{
  // If return path is provided than it must be chained
  ReturPathLink = "&ReturnPath="+ParamReturnPath;
}

String TitleFields = "FirstName,MiddleName,LastName"; // Coma seperated list of  <%=TableName %> fields.
String AddressFields = "Address" ; // Coma seperated list of fields eg: Address,City,PIN
String MobileField="Mobile" ; // Only one mobile field allowed

// Support to pass on only where clause instead of full SQL
String ParamWhere = request.getParameter("WhereClause");


%>

<div id="maindiv" style="margin: 1em"><!-- main div begin -->
  <ul>
      <li><p><a href="<\%=appPath %>/admin/sms/bulksms.jsp?Count=<\%=nCount %>&SQL=<\%=ParamSQL %>&Target=<\%=Target %>&MobileField=Mobile<\%=ReturPathLink %>" >Send bulk SMS</a></p></li>
      <li><p><a href="<\%=appPath %>/admin/email/bulkmail.jsp?Count=<\%=nCount %>&SQL=<\%=ParamSQL %>&Target=<\%=Target %>&EmailField=Email<\%=ReturPathLink %>" >Send bulk Email</a></p></li>
      <li><p><a href="<\%=appPath %>/admin/labelprint/print-A4-2x6-sticker.jsp?Count=<\%=nCount %>&SQL=<\%=ParamSQL %>&Title=<\%=TitleFields %>&Address=<\%=AddressFields %>&Mobile=<\%=MobileField %>" target="_blank" >Print address labels A4 (2x6) layout</a></p></li>
      <li><p><a href="<\%=appPath %>/admin/excelexport/getexcel.jsp?Count=<\%=nCount %>&SQL=<\%=ParamSQL %><\%=ReturPathLink %>"  >Export records to MS Excel file</a></p></li>
      
			<!-- Link realted to passing only where clause:
			     <li><p><a href="some-activity-page.jsp?Count=<\%=nCount %>&WhereClause=<\%=ParamWhere %><\%=ReturPathLink %>"  target="_blank" >Some Activity For Selection</a></p></li>
			 -->
			
			<!-- Other links related to bulk update, quick field update data matirx etc - assuming pages are in same folder
	     <li><p><a href="<%=TableName %>-quick-field-update.jsp?Count=<\%=nCount %>&WhereClause=<\%=ParamWhere %><\%=ReturPathLink %>"  target="_blank" >Quickly Update Some Fields</a></p></li>
	     <li><p><a href="<%=TableName %>-selection-data-update.jsp?Count=<\%=nCount %>&WhereClause=<\%=ParamWhere %><\%=ReturPathLink %>" target="_blank" >Bulk Update Some Fields</a></p></li>
	     <li><p><a href="<%=TableName %>-data-matrix.jsp?Count<\%=nCount %>&WhereClause=<\%=ParamWhere %><\%=ReturPathLink %>" target="_blank"  >Table Data Matrix</a></p></li>
			 -->
 
  </ul>
</div><!-- main div end -->
<% 
if(bAltTxt)
{  
%>
<!-- Div  for  AltTxt DHTML tooltip -->
<div id="navtxt" class="navtext" style="visibility:hidden; position:absolute; top:0px; left:-400px; z-index:10000; padding:10px"></div>
<% 
} 
%>
</body>
</html>

