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

if(PageTitle==null)
{
  PageTitle=TableName ;
}else if (PageTitle.equalsIgnoreCase("?"))
{
  PageTitle=TableName ;
}
String ContentType =  "application/x-download" ;
String ContentDisp = "attachment; filename="+OutputFileName;	
response.setContentType(ContentType);
response.setHeader("Content-Disposition", ContentDisp);
//response.setContentType("text/plain");
java.sql.Connection conn = null;
javax.naming.Context env =null;
javax.sql.DataSource source = null;
String ColVarName = null;
String ColName=null;
int ColType=0;

String multipart="" ;
Boolean bMultiPart=(Boolean)FieldMap.get("multipart_form_upload");
if( bMultiPart!=null && bMultiPart.booleanValue() ) multipart="enctype=\"multipart/form-data\"" ;

com.webapp.utils.PortableSQL _psql = null ; 

env = (Context) new InitialContext().lookup("java:comp/env");
source = (DataSource) env.lookup(JNDIDSN);
try 
{
conn = source.getConnection();
_psql = new com.webapp.utils.PortableSQL(conn);
String query = BeanwizHelper.openTableSQL(conn, TableName);

java.sql.Statement stmt = conn.createStatement();
java.sql.ResultSet rslt = stmt.executeQuery(query);
java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
%><jsp:include page="directive-include.jsp" flush="true"><jsp:param name="WebApp" value="<%=WebApp %>" /><jsp:param name="BeanPackage" value="<%=BeanPackage %>" /></jsp:include>
<%
 
out.print("<jsp:useBean id=\""+BeanName+"\" scope=\"page\" class=\""+BeanPackage+"."+BeanClass+"\" />\r\n");
// out.print("<jsp:useBean id=\"AppRes\" scope=\"application\" class=\""+WebApp+".ApplicationResource\" />\r\n");

  //FOREIGN KEYS BEAN DECLARATION HING
if(bForeignKey)
{
 out.print("<"+"%"+"-- Hint: You may need declaration of beans for foreign key fields\r\n");
 for(n=0; bForeignKey && n<ForeignFields.length ; n++)
  {
   out.print("<jsp:useBean id=\""+ForeignFields[n]+"_Bean\" class=\""+BeanPackage+"."+ForeignFields[n]+"_ClassName\"  />\r\n");
  } 
 out.print("--"+"%"+">\r\n");	  
}
%><\%! 

/* Un comment this block of code to enable support to show foreign key field values
// Replace $Bean with BeanClass, $var with Bean Variable, $field[n] with table columns
<%=BeanPackage %>.$Bean $var = new <%=BeanPackage %>.$Bean();
String Show$ForeignKeyField(int ID)
{
  String ret="";
	try
	{
	   if($var.locateRecord(ID))
     {
	    ret=$var.$Field1+" "+$var.$Field2+" "+$var.$Field3 ;
	   }
	}
	catch(java.sql.SQLException ex)
	{
	   ret=ex.toString();
	}
return ret ;
}

*/

boolean CheckDuplicateEntry(<%=BeanPackage %>.<%=BeanClass %> dbBean )
{
 /* 
   Enable this in case you do not want duplicate entried.
   Just set appropriate SQL WHERE condition, to avoid creating duplicate
	 entries in additions:
 	    
 try
 {
  return  ( dbBean.recordCount(" WHERE ? ")> 0) ? false : true ;
 }  catch( java.sql.SQLException exSQL ) {  return false ; }
 */
 return true ; // remove this line to enable

}

String StrValue(Object ob )
{
     if(ob==null) return "";
		 return StringEscapeUtils.escapeHtml4(ob.toString());
}
%>
<\% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);

final int DEFAULT = 0 ;
final int SHOW = 1 ;
final int NEW_FORM = 2 ;
final int CHANGE_FORM = 3 ;
final int ADD_RECORD = 4 ;
final int UPDATE_RECORD = 5;
final int DELETE_RECORD = 6 ;
final int SHOW_RECORD=7;
final int PROCESS_CHECKED=8;

final String DEFAULT_ACTION ="Action=Show";
int  default_cmd = SHOW ;
com.webapp.utils.MakeQueryString qStr =  null ;

// Show data flag

int nAction = DEFAULT ;
String MessageText = null ;
MessageText = request.getParameter("Message");

String DelWarning = "" ;

String ParamAction = request.getParameter("Action");
if(ParamAction==null)ParamAction="Show";

StringBuffer ForeignKeyParam = new StringBuffer("");

if(ParamAction != null)
{
if(ParamAction.equalsIgnoreCase("Show")) nAction = SHOW  ;
else if (ParamAction.equalsIgnoreCase("New")) nAction = NEW_FORM ;
else if (ParamAction.equalsIgnoreCase("Change")) nAction = CHANGE_FORM ;
else if (ParamAction.equalsIgnoreCase("Add")) nAction = ADD_RECORD ;
else if (ParamAction.equalsIgnoreCase("Update")) nAction = UPDATE_RECORD ;
else if (ParamAction.equalsIgnoreCase("Delete")) nAction = DELETE_RECORD ;
else if (ParamAction.equalsIgnoreCase("Record")) nAction = SHOW_RECORD ;
else if (ParamAction.equalsIgnoreCase("ProcessChecked")) nAction = PROCESS_CHECKED ;
}

// Action authorization
boolean bAllowAdd = true ;
boolean bAllowUpdate = true;
boolean bAllowDelete = true;

<% 
if("INT".equalsIgnoreCase(IDFieldType))
{ 
%>
// ID field is Integer ( number ) type
int n<%=IDField %> = 0;
try
{
   n<%=IDField %> = Integer.parseInt(request.getParameter("<%=IDField %>"));
}
catch(NumberFormatException ex)
{ 
   n<%=IDField %> = 0;
}

<% 
}
else
{
%> // ID field is String ( character data ) type
 String n<%=IDField %> = request.getParameter("<%=IDField %>") ;
<% 
} 
%>



<% 
if(bForeignKey)
{  
   // FOREIGN KEY VARIABLE DECLARATION
   for(n=0; n<ForeignFields.length ; n++)
   {
   FKeys.append(ForeignFields[n]+":");
%>
String <%=ForeignFields[n] %> = request.getParameter("<%=ForeignFields[n]%>");
if(<%=ForeignFields[n] %>==null) <%=ForeignFields[n] %> = ""; 
ForeignKeyParam.append("&<%=ForeignFields[n] %>="+<%=ForeignFields[n] %>) ;
<%
   } // end for
}// end if
 %>

<% 
if(bDateSupport || bTimestampSupport)
{
 %>
// OLD CODE: com.webapp.utils.ReadDateParams DateReader  = new com.webapp.utils.ReadDateParams(request);
String CalendarImage=appPath+"<%=ScriptFolder %>/datepicker/calendar.gif" ;
<% } %>

<jsp:include page="../params/file-upload-include.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /></jsp:include>

if(nAction==ADD_RECORD )
{
<% if(bAuto){ %>
<%=BeanName %>.<%=IDField %>= 0;
<%} %>
<jsp:include page="../params/paraminclude.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /></jsp:include>
 if(bAllowAdd == true)
 {
      if(CheckDuplicateEntry( <%=BeanName %> ))
      {
        <%=BeanName %>.addRecord();
        MessageText = "One record added. New ID = "+<%=BeanName  %>._autonumber ;
         // Page redirection code begin {{
    	 java.lang.StringBuffer rd = request.getRequestURL();
       rd.append("?"+DEFAULT_ACTION+ForeignKeyParam+"&Message="+MessageText);
       response.sendRedirect(response.encodeRedirectURL(rd.toString()));
    	  // }} Page redirection code end
      }
      else
      {
       MessageText = "<span class=\"error\">Duplicate Entry Found!</span><br>No new record created." ;
      }
 }
 else
 {
    MessageText = "Record addition is not permitted." ;
 } // end if(bAllowAdd == true)			
// Revert nAction to default value
 nAction=default_cmd ;
}

if(nAction==UPDATE_RECORD)
{
<%=BeanName %>.locateRecord(n<%=IDField %>);
//  $CHECK <%=BeanName %>.<%=IDField %>= n<%=IDField %> ;
<jsp:include page="../params/paraminclude.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /></jsp:include>
  
	if( bAllowUpdate == true )
	{
	  <%=BeanName %>.updateRecord(n<%=IDField %>);
    MessageText = "One record updated. Updated ID = "+n<%=IDField %> ;
    // Revert nAction to default value
	}
	else
	{
	   MessageText = "Record update is not permitted.";
	}
  nAction=default_cmd ;
}

if(nAction==DELETE_RECORD)
{
  // Get more information about record to deleted (optional) .
  <%=BeanName %>.locateRecord(n<%=IDField %>);
  // $CHECK

  if(bAllowDelete == true )
  {
      <%=BeanName %>.deleteRecord(n<%=IDField %>);
      // Delete dependences in other related tables.
      // String DelRef = "DELETE FROM <table> WHERE <table>.<REF>="+n<%=IDField %> ;
      // <%=BeanName %>.executeUpdate(DelRef);
      MessageText = "One record deleted. Deleted ID = "+n<%=IDField %> ;
  }
  else
  {
     MessageText = "Record deletion is not permitted.";
  }
  // Revert nAction to default value
  nAction=default_cmd ;
	
}

<% 
// -JSP-  
if(bCheckBox)  
{ 
%>
<jsp:include page="checkbox-process.jsp" flush="true">
<jsp:param name="TableName" value="<%=TableName %>" />
<jsp:param name="IDField" value="<%=IDField  %>" />
<jsp:param name="BeanName" value="<%=BeanName  %>" />
</jsp:include>
<% 
} // -JSP-  end  if(bCheckBox) 
%> 

// Redirect if not authorized for add or update activity.

if(nAction==NEW_FORM && bAllowAdd==false)
{
   MessageText="Record addition is not permitted.";
   java.lang.StringBuffer rdAdd = request.getRequestURL();
   rdAdd.append("?"+DEFAULT_ACTION+ForeignKeyParam+"&Message="+MessageText);
   response.sendRedirect(response.encodeRedirectURL(rdAdd.toString()));
}
if(nAction==CHANGE_FORM && bAllowUpdate==false)
{
   MessageText="Record update is not permitted.";
   java.lang.StringBuffer rdUpd = request.getRequestURL();
   rdUpd.append("?"+DEFAULT_ACTION+ForeignKeyParam+"&Message="+MessageText);
   response.sendRedirect(response.encodeRedirectURL(rdUpd.toString()));
}


 
boolean bRetPath=false;
String ReturnPath = "";
String ReturnPathLink = "";
String ParamReturnPath = request.getParameter("ReturnPath");
if(ParamReturnPath !=null && ParamReturnPath.length()>0)
{
   ReturnPath = new String( UrlBase64.decode( ParamReturnPath ));
	 ReturnPathLink="&ReturnPath="+ParamReturnPath;
	 bRetPath=true;
}
else  // Default return path
{
   ReturnPath = appPath+"/index.jsp" ;
}

 
%>
<!DOCTYPE html>
<html>
<head>
<title><%=PageTitle  %></title>
<link rel="stylesheet" href="<\%=appPath %><\%=ApplicationResource.stylesheet %>" type ="text/css" />
<style type="text/css">
  
 /* common styles */
 
    .round_corner
    {
          padding:1em;
	        border:1px  solid;
	        border-radius: 15px;

    }
    .datalist td { font-size:10pt}
		.datalist th { font-size:10pt}
		
</style>
<% 
out.println("<jsp:include page=\""+ScriptFolder+"/jquery/jquery.jsp\" flush=\"true\" />");
out.println("<jsp:include page=\""+ScriptFolder+"/jvalidate/jvalidate.jsp\" flush=\"true\" />");
out.println("<jsp:include page=\""+ScriptFolder+"/jmultiselect/jmultiselect.jsp\" flush=\"true\" />");
out.println("<jsp:include page=\""+ScriptFolder+"/zebra-dialog/zebra-dialog.jsp\" flush=\"true\" />");
out.println("<jsp:include page=\""+ScriptFolder+"/zebra-dialog/dialog-types.jsp\" flush=\"true\" />");

 %>
<script type="text/javascript" src="<\%=appPath %><%=ScriptFolder %>/checkbox/jquery.checkboxes.js"></script>
<script type="text/javascript" src="<\%=appPath %><%=ScriptFolder %>/field/jquery.field.min.js"></script>
<% if(bDateSupport || bTimestampSupport)
{ 
out.print("<jsp:include page=\""+ScriptFolder+"/datepicker/datepicker.jsp\" flush=\"true\" />");
}  
%>

 
<% 
if(bAltTxt)
{ 
%>
<jsp:include page="alttxt-include.jsp" flush="true"><jsp:param name="ScriptFolder" value="<%=ScriptFolder %>" /></jsp:include>  
<% 
}
int nManCount = ManField.size();
String NewFormID = TableName+"_Add" ;
String UpdateFormID = TableName+"_Update" ;
%>
<script language="JavaScript" type="text/javascript">
<!--

function NavigateTo(url)
{ 
document.location.href = url ;
}

function DeleteRecord(del_id, del_msg)
{
	var del_url =  "<\%=thisFile %>?Action=Delete<\%=ForeignKeyParam %><\%=ReturnPathLink %>&RecordID="+del_id ;
	var msg = "<span class=\"label\">Really want to delete item: </span> <span class=\"dataitem\" >"+del_msg+" (ID:"+del_id+") </span>" ;
   ConfirmAction( msg, function(btn, id, msg){
    		        if(btn==="Yes")
		     	      {
			             NavigateTo(del_url);
			          }  },null,null) ;
} // end function DeleteRecord(del_id, del_msg)



<% 
// -JSP-  
if(bCheckBox)  
{ 
%>
<jsp:include page="checkbox-support.jsp" flush="true">
<jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="IDField" value="<%=IDField  %>" />
</jsp:include>
<% 
} // -JSP-  end  if(bCheckBox) 
%>

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

    // JSP Block start 
	  <\% 
		if(MessageText!=null)
    { 
		  String Notify = MessageText.replace("\n","<br/>").replace("\r","");
		%>
		  ApplicationNotification("<\%= Notify %>", 3000) ;
		<\% 
		} 
		%> 
		// JSP Block end

} // End function - InitPage()

// Initialize jQuery 
$(document).ready(function() {
// Other JQuery initialization here
<jsp:include page="form-validation.jsp" flush="true"><jsp:param name="TableName" value="<%=TableName %>" /></jsp:include>
});  
// end of jQuery Initialize block

// -->
</script>

</head>
<body class="main" onload="InitPage()">
<\%-- Page Banner if relevent 
<% out.print("<jsp:include page=\"/banner.jsp\" flush=\"true\" />"); %>
 --%>
<div class="block">
<table border="0"  width="100%">
<tr>
<td width="75%" align="left"><span class="title"><%=PageTitle  %></span></td>
<!-- <td width="25%"  align="center"></td> -->
<% if(bAltTxt)
{ %>
<td width="25%"  align="right"><a href="<\%=ReturnPath %>" onmouseover="writetxt('back_link')" onmouseout="writetxt(0)" ><b>&#x25C4; Go Back</b></a>
<div id="back_link" style="display:none;">Back to <b>main</b> page</div>
</td>
<% 
}
else
{ %>
<td width="25%"  align="right"><a href="<\%=ReturnPath %>">&lsaquo;&lsaquo;Go Back</a></td>

<% 
} 
%>
</tr>
</table>
</div><!-- end div title block -->

<div id="maindiv" style="padding:1em;"><!-- main div start  -->

<\% if(nAction==NEW_FORM)
{
<% if(bDateSupport || bTimestampSupport)
{ 
%> 
// Uncoment for New Date: java.sql.Date Now = new java.sql.Date(System.currentTimeMillis() );
<% 
} 
%>
%>
<div align="center" ><big>Create New <%=EntityName %></big></div>
<form action="<\%=thisFile %>" method="POST"  accept-charset="UTF-8" name="<%=TableName%>_Add" id="<%=TableName%>_Add"  <%=multipart %>  >
<input type="hidden" name="Action" value="Add" />
<\%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<\%=ParamReturnPath %>" />
<\% 
} 
%>
<%  //FOREIGN KEYS  NEW FROM
for(n=0; bForeignKey && n<ForeignFields.length ; n++)
{
out.print("<input type=\"hidden\" name=\""+ForeignFields[n]+"\" value=\""+"<"+"%="+ForeignFields[n]+" %"+">"+"\" />\r\n");
}   
%>
<!-- $CHECK Look for chain --> 
<!-- INSERT ADD FROM -->
<jsp:include page="../forms/forminclude.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /><jsp:param name="FormName" value="<%=AddFormName%>" /><jsp:param name="Mode" value="Add" /><jsp:param name="ForeignKey" value="<%=FKeys %>" /></jsp:include>
<hr size="1" />
<div align="center"> <!-- form button div -->

<button type="submit" name="submit" value="Submit for addition" >Submit For Addition</button>&nbsp;&nbsp;&nbsp;
<button type="reset" >Reset Form Entry</button>&nbsp;&nbsp;&nbsp;
<button type="button" value="Cancel Addition" onclick='NavigateTo("<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>")' >Cancel Addition</button>

</div> <!-- End form button div -->

</form>
 
<\%
 } 
%>

<\% if(nAction==CHANGE_FORM)
{

<%=BeanName  %>.locateRecord(n<%=IDField  %>);
%>

<div align="center" ><big>Change <%=EntityName %>'s Record  ( ID: <\%=n<%=IDField  %> %> )</big></div>
<form action="<\%=thisFile %>" method="POST"  accept-charset="UTF-8"  name="<%=TableName%>_Update" id="<%=TableName%>_Update" <%=multipart %>  >
<input type="hidden" name="Action" value="Update" />
<input type="hidden" name="<%=IDField  %>" value="<\%=n<%=IDField  %> %>" />
<\%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<\%=ParamReturnPath %>" />
<\% 
} 
%>
<%
// FOREIGN KEYS CHANGE FROM
for(n=0; bForeignKey&&n<ForeignFields.length ; n++)
{
out.print("<input type=\"hidden\" name=\""+ForeignFields[n]+"\" value=\""+"<"+"%="+ForeignFields[n]+" %"+">"+"\" />\r\n");
}
 %>
<!-- $CHECK Look for chain --> 
<!-- INSERT UPDATE FORM  --> 
<jsp:include page="../forms/forminclude.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /><jsp:param name="FormName" value="<%=UpdateFormName%>" /><jsp:param name="Mode" value="Update" /><jsp:param name="ForeignKey" value="<%=FKeys  %>" /></jsp:include>
<hr size="1" />
<div align="center"> <!-- form button div -->

<button type="submit" name="submit" value="Submit for update" >Submit For Update</button>&nbsp;&nbsp;&nbsp; 
<button type="reset" >Reset Form Entry</button>&nbsp;&nbsp;&nbsp; 
<!-- $CHECK Look for chain --> 
<button type="button" value="Cancel Update" onclick='NavigateTo("<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>")' >Cancel Update</button>

</div> <!-- End - form button div -->
</form>
 
<\%
 } //end if(nAction==CHANGE_FORM)
%>

<\% 
if(nAction==SHOW)
{ 
int sno = 0 ;
String WhereClause=" ";
String OrderByClause=" ";
<% 
if(bForeignKey)
{
%>
// $CHECK
qStr = new com.webapp.utils.MakeQueryString( request, application );
qStr.setTablename("<%=BeanName  %>._tablename");

<%
for (n=0 ;ForeignFields!=null && n< ForeignFields.length ; n++)
{ 
ColVarName= BeanName+"."+ForeignFields[n].replace((char)32, '_' ) ;
switch(rsmd.getColumnType(rslt.findColumn(ForeignFields[n])))
{
  case java.sql.Types.BIT:
	case java.sql.Types.NUMERIC:
	case java.sql.Types.FLOAT:
	case java.sql.Types.DOUBLE:
	case java.sql.Types.REAL:
	case java.sql.Types.TINYINT:
	case java.sql.Types.SMALLINT:
	case java.sql.Types.INTEGER:
	case java.sql.Types.BIGINT:
   %>	qStr.addNumberParam("<%=ForeignFields[n] %>");<%
	break;
	case java.sql.Types.DATE:
	  %>qStr.addCalDateParam("<%=ForeignFields[n] %>" ,"/", "="); <%
	break ;
	case java.sql.Types.CHAR:
	case java.sql.Types.VARCHAR:
	%>qStr.addStringParam("<%=ForeignFields[n] %>", false);<%
	break;
} // end case 
} // end for
%>
WhereClause = qStr.SQL( qStr.getWhereClause() ); // where clause for <%=BeanName  %>.openTable() method.
<%
} // end if
%>
int ResultCount= <%=BeanName  %>.recordCount(WhereClause);

%>
<!-- $CHECK Look for chain -->
<% 
if(bCheckBox)
{ 
// Check box support needed
%>

<div align="center" id="multi_check_inst" style="background-color: #ffffcc; padding:4px">
[ <a href="#" onclick="CheckAllItems()" >Check All</a>&nbsp; 
| &nbsp;<a href="#" onclick="UnCheckAllItems()" >Un-Check All</a> ]&nbsp;&nbsp;&nbsp;
( Applicable for <\%=ResultCount %> shown on this page only )&nbsp;&nbsp;&nbsp;
<\% if(bAllowDelete == true){ %> [ <a href="#" onclick="DeleteAllChecked()" >Delete All Checked</a> ]&nbsp;&nbsp;&nbsp;<\% } %>
[ <a href="javascript:void(0)" onclick="CheckedActivity()"  <% if( bAltTxt ){ %> onmouseover="writetxt('check_activity_help')" onmouseout="writetxt(0)"> <% } %> Activity For Checked Items</a> ]
</div> 
  <% if( bAltTxt )
	{  
	%> 
    <div id="check_activity_help" style="display:none">
                Activity for checked records like bulk messaging etc.
    </div>
  <%  
	} 
  %>  

	
<% 
} 
%>
<form action="<\%=thisFile %>"  accept-charset="UTF-8" id="<%=TableName %>_list" method="post">
<input type="hidden" name="Action" value="ProcessChecked" />
<input type="hidden" name="CheckedAction" id="CheckedAction" value="Unknown" />
<\%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<\%=ParamReturnPath %>" />
<\% 
} 
%>
<%  //FOREIGN KEYS  NEW FROM
for(n=0; bForeignKey && n<ForeignFields.length ; n++)
{
out.print("<input type=\"hidden\" name=\""+ForeignFields[n]+"\" value=\""+"<"+"%="+ForeignFields[n]+" %"+">"+"\" />\r\n");
}   
%>
<table summary="" width="100%" border="1px" cellspacing="0" cellpadding="4">
<tr>
<td width="75%" align="left"><span class="title">List of <%=EntityName %>'s Records:  </span>( <\%=ResultCount %> Records )</td>
<td width="25%" align="center"> <\% if(bAllowAdd  == true){ %> <a href="<\%=thisFile %>?Action=New<\%=ForeignKeyParam %><\%=ReturnPathLink %>"><b>Create New <%=EntityName %></b></a> <\% } %> </td>
</tr>
</table>
<\% 
if(ResultCount > 0)
{ 
%>
<br/>
<table border="1px" width="100%" cellpadding="4" cellspacing="0">
<thead>
<tr>
<th valign="top" >S. No</th>
<% 
for (n=0 ;ShowFields!=null && n< ShowFields.length ; n++)
{ %> 
<th valign="top" ><%=ShowFields[n] %></th>
<% 
} 
%>
<\% if(bAllowUpdate == true){ %> <th valign="top" >Change</th> <\% } %>
<\% if(bAllowDelete == true){ %> <th valign="top" >Delete</th> <\% } %>
</tr>
</thead>
<tbody>

<\% 
<%=BeanName  %>.openTable(WhereClause, OrderByClause );
while(<%=BeanName  %>.nextRow())
{
sno++;
DelWarning = "  "+<%=BeanName  %>.<%=IDField  %>+"  " ;
// $CHECK
%>

<tr>
<td valign="top" ><\%=sno %>&nbsp;
<% 
if(bCheckBox)
{ 
%>
 <input type="checkbox" name="<%=IDField  %>" id="<%=IDField  %>_<\%=<%=BeanName  %>.<%=IDField  %> %>"  value="<\%=<%=BeanName  %>.<%=IDField  %> %>"/>&nbsp; 
<% 
} 
%> 
<br/ ></small>(ID# <\%=<%=BeanName  %>.<%=IDField  %> %> )</small>
<a href="<\%=thisFile %>?Action=Record&<%=IDField  %>=<\%=<%=BeanName  %>.<%=IDField  %> %><\%=ForeignKeyParam %><\%=ReturnPathLink %>">Details </a>
</td>
<%
for (n=0 ; ShowFields!=null && n< ShowFields.length ; n++)
{ 
ColVarName= BeanName+"."+ShowFields[n].replace((char)32, '_' ) ;
switch(rsmd.getColumnType(rslt.findColumn(ShowFields[n])))
{
  case java.sql.Types.DATE:
	 %> <td valign="top" ><\%=com.webapp.utils.DateHelper.showDate(<%=ColVarName %>) %></td> 
	 <% 
	break;
	case java.sql.Types.TIMESTAMP:
	 %> <td valign="top" ><\%=com.webapp.utils.DateHelper.showDateTime(<%=ColVarName %>) %></td> 
	 <%
	break;
	case java.sql.Types.TIME:
	 %> <td valign="top" ><\%=com.webapp.utils.DateHelper.showTime(<%=ColVarName %>) %></td> 
	 <%
	break;

	case java.sql.Types.LONGVARBINARY:
	case java.sql.Types.VARBINARY:
	case java.sql.Types.BINARY:
	 %><td valign="top" >Binary Data</td>
	 <%
	break;
	default: %><td valign="top" ><\%=<%=ColVarName %> %></td>
	<%
}
} 
%>
<td valign="top" ><\% if(bAllowUpdate == true){ %> <a href="<\%=thisFile %>?Action=Change&<%=IDField  %>=<\%=<%=BeanName  %>.<%=IDField  %> %><\%=ForeignKeyParam %><\%=ReturnPathLink %>">Change</a> <\% } %> </td>
<td valign="top" ><\% if(bAllowDelete == true){ %> <a href="javascript:void(0)" onclick="DeleteRecord('<\%=<%=BeanName  %>.<%=IDField  %> %>', '<\%=DelWarning %>' )">Delete</a> <\% } %> </td>


</tr>
<\% 
} // end while(rsSearchResult.next());
<%=BeanName  %>.closeTable();
 %>
</tbody>
</table>
</form>

<\% 
}
else // else of if(ResultCount > 0)
{
%>
<p align="center"><big>No Records Found.</big>

<\%
} // end if(ResultCount > 0)
%>


<\% 
} // end if (nAction==SHOW)
%>


<\% if(nAction==SHOW_RECORD)
{
// $CHECK
<%=BeanName  %>.locateRecord(n<%=IDField  %>);
DelWarning = "  "+<%=BeanName  %>.<%=IDField  %>+" ? " ;

%>
<% 
request.setAttribute("RSMD", rsmd);
%>
<jsp:include page="show-record-page.jsp" flush="true"><jsp:param name="BeanName" value="<%=BeanName  %>" /><jsp:param name="IDField" value="<%=IDField  %>" /><jsp:param name="EntityName" value="<%=EntityName %>" /> </jsp:include>
<\%

}//end if(nAction==SHOW_RECORD) 
%>

</div><!-- main div end  -->

<% if( bAltTxt )
{ 
%>
<!-- Div  for  AltTxt DHTML tooltip -->
<div id="navtxt" class="navtext" style="visibility:hidden; position:absolute; top:0px; left:-400px; z-index:10000; padding:10px"></div>
<% 
} 
%>
</body>
</html>
<%

rslt.close();
stmt.close();
}
finally
{
 	 conn.close();
}
 %>
