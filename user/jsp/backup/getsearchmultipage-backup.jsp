<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.*" %><%@ page  import="com.webapp.utils.*" %><jsp:useBean id="FieldMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="ManField" scope="session" class="java.util.Vector" /><%
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

final String NEXT = "Next&nbsp;&#x25BA;" ;
final String PREVIOUS = "&#x25C4;&nbsp;Previous" ;
final String FIRST = "First Page";
final String LAST = "Last Page" ;
final String GOTO = "GO &#x25BC;" ;

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
	 entries in add or update
 	    
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
   final int SEARCH_RECORDS = 1 ;
   final int SEARCH_RESULT = 2;
   final int SHOW_RECORD = 3 ;
   final int NEW_FORM = 4 ;
   final int CHANGE_FORM = 5 ;
   final int ADD_RECORD = 6 ;
   final int UPDATE_RECORD = 7;
   final int DELETE_RECORD = 8 ;
   final int PROCESS_CHECKED=9;

final String DEFAULT_ACTION ="Action=Default";
final String QUERY_OBJECT_ID = "<%=TableName %>Query" ;

int  default_cmd = DEFAULT ;
// Show data flag
com.webapp.utils.MakeQueryString qStr =  null ;


int nAction = DEFAULT ;
String DelWarning = "" ;
String PageTitle = null ;
String MessageText = null ;
MessageText = request.getParameter("Message");

String ParamAction = request.getParameter("Action");
if(ParamAction==null)ParamAction = "Search" ;
StringBuffer ForeignKeyParam = new StringBuffer("");

if(ParamAction != null)
{
    if(ParamAction.equalsIgnoreCase("Default")) nAction = DEFAULT  ;
    else if (ParamAction.equalsIgnoreCase("Search")) nAction = SEARCH_RECORDS ;
    else if (ParamAction.equalsIgnoreCase("Result")) nAction = SEARCH_RESULT ;
    else if (ParamAction.equalsIgnoreCase("Show")) nAction = SHOW_RECORD ;
    else if (ParamAction.equalsIgnoreCase("New")) nAction = NEW_FORM ;
    else if (ParamAction.equalsIgnoreCase("Change")) nAction = CHANGE_FORM ;
    else if (ParamAction.equalsIgnoreCase("Add")) nAction = ADD_RECORD ;
    else if (ParamAction.equalsIgnoreCase("Update")) nAction = UPDATE_RECORD ;
    else if (ParamAction.equalsIgnoreCase("Delete")) nAction = DELETE_RECORD ;
    else if (ParamAction.equalsIgnoreCase("ProcessChecked")) nAction = PROCESS_CHECKED ;

}
com.webapp.login.SearchQuery QryObj = (com.webapp.login.SearchQuery) session.getAttribute(QUERY_OBJECT_ID) ;
if(QryObj!=null) default_cmd=SEARCH_RESULT ;
else default_cmd = SEARCH_RECORDS ;
if(nAction==DEFAULT) nAction = default_cmd ;

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
String CalendarImage=appPath+"<%=ScriptFolder %>/datepicker/calendar.gif" ;
<% } %>

if(nAction==ADD_RECORD)
{
<% if(bAuto){ %>
     <%=BeanName %>.<%=IDField %>= 0;
<%} %>
<jsp:include page="../params/paraminclude.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /></jsp:include>
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
// Revert nAction to default value
  nAction=default_cmd ;

}
if(nAction==UPDATE_RECORD)
{
         <%=BeanName %>.locateRecord(n<%=IDField %>);
    //  $CHECK <%=BeanName %>.<%=IDField %>= n<%=IDField %> ;
    <jsp:include page="../params/paraminclude.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /></jsp:include>
    <%=BeanName %>.updateRecord(n<%=IDField %>);
    MessageText = "One record updated. Updated ID = "+n<%=IDField %> ;
    // Revert nAction to default value
    nAction=default_cmd ;
}
if(nAction==DELETE_RECORD)
{
    // Get more information about record to deleted (optional) .
    <%=BeanName %>.locateRecord(n<%=IDField %>);
    // $CHECK
    <%=BeanName %>.deleteRecord(n<%=IDField %>);
    // Delete dependences in other related tables.
    // String DelRef = "DELETE FROM <table> WHERE <table>.<REF>="+n<%=IDField %> ;
    // <%=BeanName %>.executeUpdate(DelRef);
    MessageText = "One record deleted. Deleted ID = "+n<%=IDField %> ;
    // Revert nAction to default value
    nAction=default_cmd ;
}

<% 
// -JSP-  
if(bCheckBox)  
{ 
     String ENG =_psql.getEngineName();
%>
<jsp:include page="checkbox-process.jsp" flush="true">
<jsp:param name="TableName" value="<%=TableName %>" />
<jsp:param name="IDField" value="<%=IDField  %>" />
<jsp:param name="BeanName" value="<%=BeanName  %>" />
<jsp:param name="SQLEngine" value="<%=ENG  %>" />
</jsp:include>

<% 
} // -JSP-  end  if(bCheckBox) 
%> 

// Set the correct page title according to Action Flag
if(nAction==NEW_FORM)  PageTitle="Create New <%=EntityName %>'s Record";
else if (nAction==CHANGE_FORM) PageTitle="Change <%=EntityName %>'s Record" ;
else if (nAction==SEARCH_RECORDS) PageTitle="Search <%=EntityName %>'s Records" ;
else if (nAction==SEARCH_RESULT) PageTitle= "Search Results" ;
else if(nAction==SHOW_RECORD) PageTitle= "<%=EntityName %>'s Record Details " ;
else PageTitle="" ;

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
%>

<%
int nManCount = ManField.size();
String NewFormID = TableName+"_Add" ;
String UpdateFormID = TableName+"_Update" ;

%>



<script language="JavaScript" type="text/javascript">
<!--
function DeleteConfirm (ITEM)
{
return confirm("Please confirm !\nReally want to delete item: "+ITEM );
}
function NavigateTo(url)
{ 
document.location.href = url ;
}


function GoToBlock()
{
var obj = document.getElementById("block") ;
var val = obj.options[obj.selectedIndex].value ;
var moveto = "<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>&OFFSET="+val ;
NavigateTo(moveto);
}

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


function CheckSearchRange(search_field)
{
  var rng_chk = search_field+"_RNG_CHK" ;
	var opr_blk   = search_field+"_OPR_BLK" ;
	var rng_blk   = search_field+"_RNG_BLK" ;
	
	if( $("#"+rng_chk).prop("checked") )
	{
	  // Range check box is checked
	  // Show range input and hide operators
		$("#"+rng_blk).show(); 
		$("#"+opr_blk).hide(); 
	}
	else
	{
	  // Range check box is NOT checked
	  // Hide range input and show operators
		$("#"+rng_blk).hide(); 
		$("#"+opr_blk).show(); 
	}

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

// Initialize jQuery 
$(document).ready(function() {
// Other JQuery initialization here
<jsp:include page="form-validation.jsp" flush="true"><jsp:param name="TableName" value="<%=TableName %>" /></jsp:include>
});  
// end of jQuery Initialize block
// -->
</script>

</head>
<body class="main" onload="InitPage()" >
<\%-- Page Banner if relevent 
<% out.print("<jsp:include page=\"/banner.jsp\" flush=\"true\" />"); %>
 --%>
<div class="block">
<table border="0"  width="100%">
<tr>
<td width="33%" align="left"><span class="title"><%=PageTitle  %></span></td>
<td width="33%"  align="center"><big><\%=PageTitle %></big></td> 
<% 
if(bAltTxt)
{ 
%>
<td width="33%"  align="right"><a href="<\%=ReturnPath %>" onmouseover="writetxt('back_link')" onmouseout="writetxt(0)" ><b>&#x25C4; Go Back</b></a>
<div id="back_link" style="display:none;">Back to <b>main</b> page</div>
</td>
<% 
}
else
{ 
%>
<td width="33%"  align="right"><a href="<\%=appPath %>/index.jsp"><b>&lsaquo;&lsaquo;Done Go Back</b></a></td>
<%
} 
%> 
</tr>
</table>
</div><!-- end div .block -->

<\% 
if(MessageText!=null)
{ 
%>
<div  id="msg_block" style="width:100%; border: 1px outset;background-color: #ddfecf; ">
<table summary=""  cellpadding="4" cellspacing="0"  width="100%">
<tr>
<td width="90%" align="left">
<span style="color:maroon;"><\%=MessageText %></span>
</td>
<td width="10%" align="right">
[ <a href="javascript:void(0)"  onclick="{ $('#msg_block').hide(); }  ">&times;</a> ]
&nbsp;&nbsp;
</td>

</tr>
</table>
</div>
<\% 
} 
%>

<div id="maindiv" style="padding:1em"><!-- main div start -->

<\% if(nAction==NEW_FORM)
{
<% if(bDateSupport || bTimestampSupport)
{ 
%> 
// Uncoment for New Date: java.sql.Date Now = new java.sql.Date(System.currentTimeMillis() );
<% 
} 
%>
/* 
Hint: Use this to get form values in case new form is called from serach result.
Place value of form field as item before each field
String item=null;
if(QryObj!=null)item=QryObj.getKey("$Field") ; 
else item="";

*/


%>
<form action="<\%=thisFile %>" method="POST"  accept-charset="UTF-8" name="<%=TableName%>_Add" id="<%=TableName%>_Add" <%=multipart %>  >
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

</div> <!-- end- form button div -->
</form>

<\%
 } 
%>

<\% if(nAction==CHANGE_FORM)
{

<%=BeanName  %>.locateRecord(n<%=IDField  %>);
%>
<form action="<\%=thisFile %>" method="POST"  accept-charset="UTF-8" name="<%=TableName%>_Update" id="<%=TableName%>_Update" <%=multipart %>   >
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

<button type="submit" name="submit" value="Submit for update" >Submit For Update</button> &nbsp;&nbsp;&nbsp; 
<button type="reset" >Reset Form Entry</button>&nbsp;&nbsp;&nbsp; 
<!-- $CHECK Look for chain --> 
<button type="button" value="Cancel Update" onclick='NavigateTo("<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>")' >Cancel Update</button>

</div> <!-- End form button div -->

</form>

<\%
 } //end if(nAction==CHANGE_FORM)
%>
<\% if(nAction==SEARCH_RECORDS)
{ 
   session.removeAttribute(QUERY_OBJECT_ID);
%>


<!-- Outer main table begin -->
<table border="0" cellpadding="4" cellspacing="0" summary="" align="center" width="100%">
<tr>
<td valign="top" width="25%">
<!-- Left menu pane begin-->
<ul>
    <li><a href="<\%=thisFile %>?Action=New<\%=ForeignKeyParam %><\%=ReturnPathLink %>">Create New <%=EntityName %>'s Record</a></li>
</ul>



<!-- Left menu pane end-->
</td>

<td valign="top" width="75%">
<!-- Right form pane  begin-->

<form action="<\%=thisFile %>" method="POST"  accept-charset="UTF-8" >
<input type="hidden" name="Action" value="Result" />
<\%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<\%=ParamReturnPath %>" />
<\% 
} 
%>
<%  //FOREIGN KEYS SEARCH FROM
for(n=0; bForeignKey && n<ForeignFields.length ; n++)
{
out.print("<input type=\"hidden\" name=\""+ForeignFields[n]+"\" value=\""+"<"+"%="+ForeignFields[n]+" %"+">"+"\" />\r\n");
}

%>
<!-- Innter form table begin -->
<div id="search_form_div" class="round_corner">

<table summary="" align="center" cellpadding="6" cellspacing="0">
<tr>
     <td><span class="label">Search By ID:</span></td>
		 <td>
         <span class="dataitem">
				  <span id="<%=IDField  %>_OPR_BLK"><\%=NumberSearch.getOperatorList("<%=IDField  %>_OPERATOR", "<%=IDField  %>_OPERATOR", null )  %> </span>
          <input type="text" name="<%=IDField  %>" size="10" />
          <span id="<%=IDField  %>_RNG_BLK" style="display:none">&nbsp;&nbsp;TO&nbsp;&nbsp;<input type="text" name="<%=IDField  %>_TO" id="<%=IDField  %>_TO" size="10" />&nbsp;</span>&nbsp;				
		      <input type="checkbox" name="<%=IDField  %>_RNG_CHK" id="<%=IDField  %>_RNG_CHK" onchange="CheckSearchRange('<%=IDField  %>')" /> Range ?
         </span>
		 </td>
</tr>
<% 
for(n=0 ; SearchFields!=null && n<SearchFields.length ; n++)
{ 

   int nSerachFieldType = rsmd.getColumnType(rslt.findColumn(SearchFields[n])) ;
	switch(nSerachFieldType)
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
		%>
      <tr>
         <td><span class="label"><%= SearchFields[n] %>:</span></td>
         <td>
            <span class="dataitem">
				     <!-- Num. Operator --><span id="<%= SearchFields[n] %>_OPR_BLK"><\%=NumberSearch.getOperatorList("<%= SearchFields[n] %>_OPERATOR", "<%= SearchFields[n] %>_OPERATOR", null )  %> </span>
 					   <!-- Field Input --><input type="text" name="<%=SearchFields[n] %>" size="10"   />
             <!-- Range Input --><span id="<%= SearchFields[n] %>_RNG_BLK" style="display:none">&nbsp;&nbsp;TO&nbsp;&nbsp;<input type="text" name="<%= SearchFields[n] %>_TO" id="<%= SearchFields[n] %>_TO" size="10" />&nbsp;</span>&nbsp;				
		         <!-- Range Chk.Bx. --><input type="checkbox" name="<%= SearchFields[n] %>_RNG_CHK" id="<%= SearchFields[n] %>_RNG_CHK" onchange="CheckSearchRange('<%= SearchFields[n] %>')" /> Range ?
            </span>
         </td>
      </tr>
	  <%
		
		break;
		
	  case java.sql.Types.CHAR:
	  case java.sql.Types.VARCHAR:
		case java.sql.Types.NCHAR:
		case java.sql.Types.NVARCHAR:
    %>
     <tr>
        <td><span class="label"><%= SearchFields[n] %>:</span></td>
        <td>
           <span class="dataitem">
           <!-- Searth Type -->&nbsp;<\%= StringSearch.getDropList("<%= SearchFields[n] %>_SEARCHTYPE", StringSearch.START)	 %>&nbsp;
           <!-- Field Input --><input type="text" name="<%=SearchFields[n] %>"   />
           </span>
        </td>
     </tr>
		
		
		<%
		break;
		
	  case java.sql.Types.DATE:
	 %>
   <tr>
       <td><span class="label"><%=SearchFields[n] %>:</span></td>
	     <td>
			      <span class="dataitem">
			      <!-- Num. Operator --><span id="<%= SearchFields[n] %>_OPR_BLK"><\%=NumberSearch.getOperatorList("<%= SearchFields[n] %>_OPERATOR", "<%= SearchFields[n] %>_OPERATOR", null )  %> </span>
						<!-- Field Input --><%  out.print("<dtag:DatePicker  CalendarImage=\"<"+"%=CalendarImage %"+">\" ElementName=\""+SearchFields[n]+"\" ElementID=\""+SearchFields[n]+"\"  />"); %>
		        <!-- Range Input --><span id="<%= SearchFields[n] %>_RNG_BLK" style="display:none">&nbsp;&nbsp;TO&nbsp;&nbsp;<%  out.print("<dtag:DatePicker  CalendarImage=\"<"+"%=CalendarImage %"+">\" ElementName=\""+SearchFields[n]+"_TO\" ElementID=\""+SearchFields[n]+"_TO\"  />"); %>&nbsp;</span>&nbsp;				
						<!-- Range Chk.Bx. --><input type="checkbox" name="<%= SearchFields[n] %>_RNG_CHK" id="<%= SearchFields[n] %>_RNG_CHK" onchange="CheckSearchRange('<%= SearchFields[n] %>')" /> Range ?
						</span> 
						<!-- Set  year range as tag attribute if relevent:-  YearRange="1900:2100"    -->
			 </td> 
   </tr>	 
	 <%
	  break;
	
	 case java.sql.Types.TIMESTAMP:
 %>
   <tr>
       <td><span class="label"><%=SearchFields[n] %>:</span></td>
	     <td><span class="dataitem"><%  out.print("<dtag:DateTimePicker  CalendarImage=\"<"+"%=CalendarImage %"+">\" ElementName=\""+SearchFields[n]+"\" ElementID=\""+SearchFields[n]+"\" />"); %></span> <!-- Set  year range as tag attribute if relevent:-  YearRange="1900:2100"    --></td> 
   </tr>
 <%	 
	 break;
	 
	 default:
   %> 
  <tr>
       <td><span class="label"><%= SearchFields[n] %>:</span></td>
       <td><span class="dataitem"><input type="text" name="<%=SearchFields[n] %>"   /></span></td>
  </tr>
<%	 
	 break;

	} // end case switch(nSerachFieldType)
	
	
} // end for loop
%>
<tr>
<td>
<span class="label">Sort By:</span></td>
<td><span class="dataitem">
<select name="OrderBy">
<option selected="selected" value="<%=IDField  %>" ><%=IDField  %></option>
<% for(n=0 ; SearchFields!=null && n<SearchFields.length ; n++)
{ 
%><option value="<%=SearchFields[n] %>" ><%=SearchFields[n] %></option>
<%
}%>
</select>
</span>
</td>
</tr>

<tr>
 <td><span class="label">Records Per Page:</span></td>
 <td><span class="dataitem"><input type="text" name="ROWS" size="10"  value="20"/></span></td>
</tr>

<tr>
 <td><span class="label">Submit:</span></td>
 <td colspan="3"><span class="dataitem">
  <button type="submit">Submit For Search</button>&nbsp;&nbsp;&nbsp;
 <button type="reset">Reset Form Entry</button>&nbsp;&nbsp;&nbsp;
 <button type="button" name="CancelButton"  onclick='NavigateTo("<\%=ReturnPath %>")'  >Cancel Search</button>&nbsp;&nbsp;&nbsp;
<!-- <button type="button" name="NewRecordButton" onclick='NavigateTo("<\%=thisFile %>?Action=New<\%=ForeignKeyParam %><\%=ReturnPathLink %>")' >Create New <%=EntityName %>'s Record</button> -->

 
  </td>
</tr>


</table>
<!-- Innter form table end -->
</div><!-- end div .round_corner -->

</form>



<!-- Right form pane  end-->
</td>
</tr>
</table>
<!-- Outer main table end -->


<\% 
}// end if (nAction==SEARCH_RECORDS)
%>

<\% 
if(nAction==SEARCH_RESULT)
{ 
int sno = 0 ;
int LastBlock=0;
String WhereClause=null;
String OrderByClause=null;

  if(QryObj != null )
	{
	  // Query found in session use that instead of making new one.
		
		 WhereClause = QryObj.whereclause ;
		 OrderByClause = QryObj.orderbyclause ;
  	 try
		 {
		     QryObj.offset = java.lang.Integer.parseInt( request.getParameter("OFFSET") );
     }
     catch (NumberFormatException ex )
     {
	      
     }
	
	}
	else // else of  if(QryObj != null )
	{
	  // Query not is session create new one from submitted search form.
		 qStr = new com.webapp.utils.MakeQueryString( request, application );
		 // qStr = new com.webapp.utils.MakeQueryString( request, "<%=_psql.getEngineName() %>" );
		 
		 
     QryObj = new com.webapp.login.SearchQuery();
     qStr.setTablename(<%=BeanName  %>._tablename);
     // qStr.setOrderByClause(" ORDERBY ? ");
     
		 // Old Code: qStr.addNumberParam("<%=IDField %>") ;
	   if(request.getParameter("<%=IDField %>_RNG_CHK") != null)
		 {
		    qStr.addNumberInRangeParam("<%=IDField %>", "<%=IDField %>", "<%=IDField %>_TO")  ;
		 }
		 else
		 {
		    String  <%=IDField %>_OPERATOR = request.getParameter("<%=IDField %>_OPERATOR");
				qStr.addNumberParam("<%=IDField %>", <%=IDField %>_OPERATOR );
				
		 }
    // Automatically add Foreign Keys in Search Creterion
<% 
    for(n=0; bForeignKey&&n<ForeignFields.length ; n++)
    {
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
       %>
			 qStr.addNumberParam("<%=ForeignFields[n] %>");  // Foreign Key
    	 <%
	       break;
	       case java.sql.Types.DATE:
	    %>
			 qStr.addCalDateParam("<%=ForeignFields[n] %>" ,"/", "="); // Foreign Key
		  <%
	       break ;
	       case java.sql.Types.CHAR:
	       case java.sql.Types.VARCHAR:
           case java.sql.Types.NCHAR:
           case java.sql.Types.NVARCHAR:
	    %>
			qStr.addStringParam("<%=ForeignFields[n] %>", true);  // Foreign Key
	    <%
	       break;
	       default:
	    %>
			qStr.addStringParam("<%=ForeignFields[n] %>", false);  // Foreign Key
	    <%
	       break;
       } // end switch
    } // end for loop
%>
    // Add  Search Fields 
		/* Hint
		You may use this trick to retain selection in new  form values if new form
		is called from search result page
		if ( qStr.addStringParam("$Field", false) ) QryObj.setKey("$Field" ,request.getParameter("$Field"));
		*/
		
		
<% 
for (n=0 ;SearchFields!=null && n< SearchFields.length ; n++)
{ 
ColVarName= BeanName+"."+SearchFields[n].replace((char)32, '_' ) ;
switch(rsmd.getColumnType(rslt.findColumn(SearchFields[n])))
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
   %>	
	  // Old Code: qStr.addNumberParam("<%=SearchFields[n] %>");
	   if(request.getParameter("<%=SearchFields[n] %>_RNG_CHK") != null)
		 {
		    qStr.addNumberInRangeParam("<%=SearchFields[n] %>", "<%=SearchFields[n] %>", "<%=SearchFields[n] %>_TO")  ;
		 }
		 else
		 {
		    String  <%=SearchFields[n] %>_OPERATOR = request.getParameter("<%=SearchFields[n] %>_OPERATOR");
				qStr.addNumberParam("<%=SearchFields[n] %>", <%=SearchFields[n] %>_OPERATOR );
		 }
 	 // For multiple selection select drop list use: qStr.addMultiSelectParam("<%=SearchFields[n] %>", false );
	<%
	break;
	case java.sql.Types.DATE:
	 %>
	 // Old Code: qStr.addCalDateParam("<%=SearchFields[n] %>" ,"/", "="); 
	 // Let date behave like a number
	 	  if(request.getParameter("<%=SearchFields[n] %>_RNG_CHK") != null)
		 {
				qStr.addDateInRange("<%=SearchFields[n] %>", "<%=SearchFields[n] %>" ,"<%=SearchFields[n] %>_TO" );
		 }
		 else
		 {
		    String  <%=SearchFields[n] %>_OPERATOR = request.getParameter("<%=SearchFields[n] %>_OPERATOR");
				qStr.addCalDateParam("<%=SearchFields[n] %>" ,"/", <%=SearchFields[n] %>_OPERATOR);
		 }
	 <%
	break ;
	
	  case java.sql.Types.CHAR:
	  case java.sql.Types.VARCHAR:
		case java.sql.Types.NCHAR:
		case java.sql.Types.NVARCHAR:
	 %>
	 // Old Code: qStr.addStringParam("<%=SearchFields[n] %>", false);
	  short <%=SearchFields[n] %>_SEARCHTYPE = RequestHelper.getShort(request, "<%=SearchFields[n] %>_SEARCHTYPE");
	  qStr.addStringParam("<%=SearchFields[n] %>", <%=SearchFields[n] %>_SEARCHTYPE);
	 // For multiple selection select drop list use: qStr.addMultiSelectParam("<%=SearchFields[n] %>", true );
	
	 <%
	break;
  default:
	 %>
	 qStr.addStringParam("<%=SearchFields[n] %>", false);
	 <%
	break;
}  // end switch
} // end for
%>
 		 QryObj.jndidsn  = "<%=JNDIDSN  %>" ;
     QryObj.table = "<%=TableName %>"  ;
		  
     QryObj.whereclause = qStr.getWhereClause() ; 
		 QryObj.orderbyclause  = qStr.getOrderByClause("OrderBy") ;
		 QryObj.query =  qStr.getSQL() ;
		  
		 WhereClause = QryObj.whereclause ;
		 OrderByClause = QryObj.orderbyclause ;
		
     QryObj.count = <%=BeanName  %>.recordCount(WhereClause); 
     QryObj.offset = 0 ;
     QryObj.pagesize = 0 ;
		 try
		 {
		     QryObj.pagesize=java.lang.Integer.parseInt(request.getParameter("ROWS"));
     }
     catch (NumberFormatException ex )
     {
	       QryObj.pagesize=20;
     }
		 session.setAttribute(QUERY_OBJECT_ID, QryObj ) ;


 } // end if
  
  String WhrParam  = RequestHelper.encodeBase64( WhereClause.getBytes()) ;
  String RetPath = new String( com.webapp.base64.UrlBase64.encode( ( thisFile+"?Action=Default" ).getBytes() ) );
         

%>
<!-- RECORDS FOUND -->

<!-- $CHECK Look for chain -->
<table summary="" width="100%" border="1px" cellspacing="0" cellpadding="4" align="center">
<tr>
<td width="25%" align="left"><span class="title">List Of <%=EntityName %>'s Records</span> ( <\%=QryObj.count %> Records )
<br/><a href="<%=TableName %>-selection-activity.jsp?Count=<\%=QryObj.count %>&WhereClause=<\%=WhrParam %>&ReturnPath=<\%=RetPath %>" <% if( bAltTxt ){ %> onmouseover="writetxt('sel_menu_help')" onmouseout="writetxt(0)" <% } %>  >Selection Activity</a>
</td>
<td width="25%">
<span class="label"> Showing:</span> <span class="dataitem"><\%=QryObj.offset+1 %></span> To <span class="dataitem"><\%= ( ( QryObj.pagesize > QryObj.count )? QryObj.count : ( ( QryObj.offset+QryObj.pagesize <= QryObj.count ) ? QryObj.offset+QryObj.pagesize : QryObj.count ) ) %></span>&nbsp;&nbsp;&nbsp; 
</td>

<td width="25%" align="center"><a href="<\%=thisFile %>?Action=New<\%=ForeignKeyParam %><\%=ReturnPathLink %>"><b>Create New <%=EntityName %>'s Record</b></a></td>
<td width="25%" align="right"><a href="<\%=thisFile %>?Action=Search<\%=ForeignKeyParam %><\%=ReturnPathLink %>"><b> &lsaquo;&lsaquo;Search Again</b></a></td>
</tr>
</table>
<% if( bAltTxt )
{ 
%>
<div id="sel_menu_help" style="display:none" >
Activity for <\%=QryObj.count %> selected records,  like bulk messaging etc.
</div>
<% 
} 
%> 
<!-- NAVIGATION BAR BEGIN -->
<\% 
if(QryObj.count>QryObj.pagesize)
{ 
LastBlock= (QryObj.count/QryObj.pagesize)*QryObj.pagesize ;
if(LastBlock == QryObj.count) LastBlock-=QryObj.pagesize ;
%>
<table  border="1px, outset"  cellpadding="4" cellspacing="0" summary="" width="100%">
<tr>
<td width="10%" align="left" ><a href="<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>&OFFSET=0"><%=FIRST %></a></td>
<td width="20%" align="left" > 
<\% 
if(QryObj.offset >=QryObj.pagesize )
{ 
%>
<a href="<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>&OFFSET=<\%=QryObj.offset-QryObj.pagesize  %>"><%=PREVIOUS %></a>[<\%=QryObj.offset-QryObj.pagesize+1 %> to <\%=QryObj.offset %> ]
<\% }
else
{ %>
<%=PREVIOUS %> 
<\% 
} 
%>
</td>
<td  width="40%" align="center" >Go To Page
<select name="block" id="block">
<\% 
int i=0;
int j = LastBlock/QryObj.pagesize ;
int of = 0 ; 
for(i=0 ;i < j ; i++)
{ 
of = i*QryObj.pagesize ;
%>
<option value="<\%=of %>" <\% if(QryObj.offset==of) out.print("selected=\"selected\""); %> >[ <\%=of+1 %> to <\%=(i+1)*QryObj.pagesize %> ]</option>
<\% 
} 
if( ( j*QryObj.pagesize) < QryObj.count)
{
of = i*QryObj.pagesize ;
%>
<option value="<\%=of %>" <\% if(QryObj.offset==of) out.print("selected=\"selected\""); %> >[ <\%=of+1 %> to <\%=QryObj.count %> ]</option>
<\%
} 
%>
</select>
<button type="button" name="" onclick="GoToBlock()" value=""><%=GOTO %></button>
</td>
<td width="20%" align="right" >
<\% 
if(QryObj.offset < (QryObj.count - QryObj.pagesize) )
{ 
%>
<a href="<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>&OFFSET=<\%=QryObj.offset+QryObj.pagesize  %>"><%=NEXT %></a> [<\%=QryObj.offset+QryObj.pagesize+1 %> to <\%= ( (QryObj.offset+QryObj.pagesize+QryObj.pagesize)<=QryObj.count? QryObj.offset+QryObj.pagesize+QryObj.pagesize : QryObj.count ) %> ]
<\% }
else
{ %>
<%=NEXT %>
<\% 
} 
%>
</td>
<td width="10%" align="right" >
<a href="<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>&OFFSET=<\%=LastBlock %>">Last Page </a>
</td>
</tr>
</table>
<\% 
} 
%>
<!-- NAVIGATION BAR END -->
<\% 
if(QryObj.count > 0)  
{ 
//  Records are there
%>
<% 
if(bCheckBox)
{ 
%> 
 
<div align="center" id="multi_check_inst" style="background-color: #ffffcc; padding:4px">
	[ <a href="#" onclick="CheckAllItems()" >Check All</a>&nbsp; 
	| &nbsp;<a href="#" onclick="UnCheckAllItems()" >Un-Check All</a> ]&nbsp;&nbsp;&nbsp;
	( Applicable for S.No. <\%=QryObj.offset+1 %>  To  <\%= ( ( QryObj.pagesize > QryObj.count )? QryObj.count : ( ( QryObj.offset+QryObj.pagesize <= QryObj.count ) ? QryObj.offset+QryObj.pagesize : QryObj.count ) ) %> shown on this page only )&nbsp;&nbsp;&nbsp;
	[ <a href="#" onclick="DeleteAllChecked()" >Delete All Checked</a> ]&nbsp;&nbsp;&nbsp;
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

<table border="1" width="100%" cellpadding="4" cellspacing="0" class="datalist" >
<thead>
<tr>
<th valign="top" >S. No</th>
<% 
for (n=0 ;ShowFields!=null && n< ShowFields.length ; n++)
{ %><th valign="top" ><%=ShowFields[n] %></th>
<% 
} 
%>
<th valign="top" >Change</th>
<th valign="top" >Delete</th>
</tr>
</thead>
<tbody>

<\% 

/** Check for pagination support 
  if pagination is supported by SQL implementation ( LIMIT and OFFSET key words ) 
	than call :  <%=BeanName  %>.openTable(WhereClause, OrderByClause, QryObj.pagesize, QryObj.offset  ); 
	and remove while( <%=BeanName  %>.skipRow() ){} part of loop.
	This will give much better result that usual openTable(WhereClause, OrderByClause ); method call
	
*/

<%=BeanName  %>.openTable(WhereClause, OrderByClause );  

int n=0;
while(n< QryObj.offset)
{
 n++ ;
 <%=BeanName  %>.skipRow();
} 
 n=0;
sno=QryObj.offset;

while(<%=BeanName  %>.nextRow() && n < QryObj.pagesize )
{
sno++;
n++;
DelWarning = "  "+<%=BeanName  %>.<%=IDField  %>+" ? " ;
// $CHECK
%>
<tr>
<td valign="top" >
<\%=sno %>&nbsp;
<% 
if(bCheckBox)
{ 
%>
 <input type="checkbox" name="<%=IDField  %>" id="<%=IDField  %>_<\%=<%=BeanName  %>.<%=IDField  %> %>"  value="<\%=<%=BeanName  %>.<%=IDField  %> %>"/>&nbsp; 
<% 
} 
%> 
<br ><small>(ID# <\%=<%=BeanName  %>.<%=IDField  %> %> )</small>
<a href="<\%=thisFile %>?Action=Show&<%=IDField  %>=<\%=<%=BeanName  %>.<%=IDField  %> %><\%=ForeignKeyParam %><\%=ReturnPathLink %>">Details</a>
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
	 %> <td valign="top" > <\%=com.webapp.utils.DateHelper.showDateTime(<%=ColVarName %>) %></td> 
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
<td valign="top" ><a href="<\%=thisFile %>?Action=Change&<%=IDField  %>=<\%=<%=BeanName  %>.<%=IDField  %> %><\%=ForeignKeyParam %><\%=ReturnPathLink %>">Change</a></td>
<td valign="top" ><a href="<\%=thisFile %>?Action=Delete&<%=IDField  %>=<\%=<%=BeanName  %>.<%=IDField  %> %><\%=ForeignKeyParam %><\%=ReturnPathLink %>" onclick='return DeleteConfirm("<\%=DelWarning %>")'>Delete</a></td>
</tr>
<\% 
} // end while( <%=BeanName  %>.nextRow());
<%=BeanName  %>.closeTable();
 %>
</tbody>
</table>
</form>

<!-- RECORDS FOUND NOT FOUNT-->
<\% 
}
else // else of if(QryObj.count > 0) 
{
//  Records are not found
%>
<p align="center" ><big>Records satisfying search criteria not found! </big></p>

<\% 
} // end  if(QryObj.count > 0) 
%>

<\% 
} // end if (nAction==SEARCH_RESULT)
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
<jsp:include page="show-record-page.jsp" flush="true"><jsp:param name="BeanName" value="<%=BeanName  %>" /><jsp:param name="IDField" value="<%=IDField  %>" /><jsp:param name="EntityName" value="<%=EntityName  %>" /></jsp:include>
<\%

}//end if(nAction==SHOW_RECORD) 
%>

</div><!-- main div end #maindiv -->

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
