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

String LoginFolderName = request.getParameter("LoginFolderName") ;

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


final String FIRST = "<i class='icon fa fa-backward fa-lg' aria-hidden='true'></i><span class='hidden-xs' style='font-size: 15px;'>&nbsp;&nbsp;First Page</span>";
final String PREVIOUS = "<i class='icon fa fa-step-backward fa-lg' aria-hidden='true'></i><span class='hidden-xs' style='font-size: 15px;'>&nbsp;&nbsp;Previous</span>" ;
final String GOTO = "<span class='hidden-xs'>Go&nbsp;</span><i class='fa fa-arrow-right'></i>" ;
final String NEXT = "<span class='hidden-xs' style='font-size: 15px;'>Next&nbsp;&nbsp;</span><i class='icon fa fa-step-forward fa-lg' aria-hidden='true'></i>" ;
final String LAST = "<span class='hidden-xs' style='font-size: 15px;'>Last Page&nbsp;&nbsp;</span><i class='icon fa fa-forward fa-lg' aria-hidden='true'></i>" ;

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

// Action authorization
boolean bAllowAdd = true ;
boolean bAllowUpdate = true;
boolean bAllowDelete = true;



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

 
<jsp:include page="../params/file-upload-include.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /></jsp:include>
if(nAction==ADD_RECORD)
{
<% if(bAuto){ %>
     <%=BeanName %>.<%=IDField %>= 0;
<%} %>
<jsp:include page="../params/paraminclude.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /></jsp:include>

		if( bAllowAdd == true )
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
		     MessageText="Record addition not permitted."; 
		} // if( bAllowAdd == true )

     // Revert nAction to default value
	  nAction=default_cmd ;

} // End if (nAction==ADD_RECORD )

if(nAction==UPDATE_RECORD )
{
         <%=BeanName %>.locateRecord(n<%=IDField %>);
    //  $CHECK <%=BeanName %>.<%=IDField %>= n<%=IDField %> ;
    <jsp:include page="../params/paraminclude.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /></jsp:include>
   
	  if(bAllowUpdate == true)
		{
	      <%=BeanName %>.updateRecord(n<%=IDField %>);
        MessageText = "One record updated. Updated ID = "+n<%=IDField %> ;
		}
		else
		{
		    MessageText="Record update not permitted."; 
		}		
    // Revert nAction to default value
    nAction=default_cmd ;
		
}  // End if (nAction==UPDATE_RECORD)

if(nAction==DELETE_RECORD )
{
    // Get more information about record to deleted (optional) .
    <%=BeanName %>.locateRecord(n<%=IDField %>);
    // $CHECK
		if(bAllowDelete == true)
		{
       <%=BeanName %>.deleteRecord(n<%=IDField %>);
		    MessageText = "Record Deleted. ID = "+n<%=IDField %> ;
				// Delete dependences in other related tables.
        // String DelRef = "DELETE FROM <table> WHERE <table>.<REF>="+n<%=IDField %> ;
        // <%=BeanName %>.executeUpdate(DelRef);

				
		}
		else
    {
         MessageText="Record deletion not permitted."; 
	       nAction=default_cmd ;
    }

      // Revert nAction to default value
      nAction=default_cmd ;
}  // End  if(nAction==DELETE_RECORD )

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




// Set the correct page title according to Action Flag
if(nAction==NEW_FORM)  PageTitle="<i class='fa fa-plus iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Add Record";
else if (nAction==CHANGE_FORM) PageTitle="<i class='fa fa-edit iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Update Record" ;
else if (nAction==SEARCH_RECORDS) PageTitle="<i class='fa fa-search iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Search Record" ;
else if (nAction==SEARCH_RESULT) PageTitle= "<i class='fa fa-th-list iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Search Result" ;
else if(nAction==SHOW_RECORD) PageTitle= "<i class='fa fa-bookmark iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Record Detail " ;
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
   ReturnPath = appPath+"/<%=LoginFolderName %>/index.jsp" ;
}
%>
<\%@include file="/<%=LoginFolderName %>/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <% out.print("<jsp:include page =\"/include-page/common/meta-tag.jsp\" flush=\"true\" />"); %>
	<title><%=PageTitle  %></title>

  <% out.print("<jsp:include page =\"/include-page/css/main-css.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
	<% out.print("<jsp:include page =\"/include-page/css/bootstrap-select-css.jsp\" flush=\"true\" />"); %>
  <% if(bDateSupport){%>
  <% out.print("<jsp:include page =\"/include-page/css/bootstrap-datepicker-css.jsp\" flush=\"true\" />"); %>
  <% } %>
  <% out.print("<jsp:include page =\"/include-page/common/main-head-js.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
</head>
<body class="<\%=menuTypeClass %> Siteadmin" >

  <% out.print("<jsp:include page =\"/"+LoginFolderName+"/include-page/nav-body.jsp\" >"); %>	
	 	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
  <% out.print("<jsp:include page =\"/"+LoginFolderName+"/include-page/menu-body.jsp\" >"); %>	
	 	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
	 	 <% out.print("<jsp:param name=\"MenuTitle\" value=\"???\" />"); %>
	 	 <% out.print("<jsp:param name=\"MenuLink\" value=\"???\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>	
  <!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
  	  <div class="row">
        <div class="col-sm-6">
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i><%=PageTitle  %></h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<\%=appPath %>/<%=LoginFolderName %>/index.jsp"><i aria-hidden="true" class="icon fa fa-home fa-lg"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active"><%=PageTitle  %></li>
          </ol>			
  	    </div>
  		</div>	
			<hr class="hr-res" />

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
<div class="panel">
  <div class="panel-heading">
    <h3 class="panel-title page-title-action"><\%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" onclick="NavigateTo('<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>')"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;" data-original-title="Reset Form" data-placement="left" data-toggle="tooltip"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body container-fluid">
<hr class="hr-res" />	

<!-- $CHECK Look for chain --> 
<!-- INSERT ADD FROM -->
<jsp:include page="../forms/forminclude.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /><jsp:param name="FormName" value="<%=AddFormName%>" /><jsp:param name="Mode" value="Add" /><jsp:param name="ForeignKey" value="<%=FKeys %>" /></jsp:include>
<hr size="1" />

<div class="row text-center">
    <div class="form-group col-sm-12">
      <button type="submit" class="btn btn-primary" title="Submit for Addition"><i class="fa fa-plus" aria-hidden="true"></i>&nbsp;Add</button>
      <button type="button" class="btn btn-default btn-outline" title="Cancel Addition" onclick="NavigateTo('<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>')"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
	  </div>
</div>

</div>
</div>

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
 
<div class="panel">
  <div class="panel-heading">
    <h3 class="panel-title page-title-action"><\%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" onclick="NavigateTo('<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>')"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;" data-original-title="Reset Form" data-placement="left" data-toggle="tooltip"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body container-fluid">
<hr class="hr-res" />	
 
<!-- $CHECK Look for chain --> 
<!-- INSERT UPDATE FORM  --> 
<jsp:include page="../forms/forminclude.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /><jsp:param name="FormName" value="<%=UpdateFormName%>" /><jsp:param name="Mode" value="Update" /><jsp:param name="ForeignKey" value="<%=FKeys  %>" /></jsp:include>
<hr size="1" />
 
<div class="row text-center">
    <div class="form-group col-sm-12">
      <button type="submit" class="btn btn-primary" title="Submit for update"><i class="fa fa-check" aria-hidden="true"></i>&nbsp;Update</button>
      <button type="button" class="btn btn-default btn-outline" title="Cancel Update" onclick="NavigateTo('<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>')"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
	  </div>
</div>


</div>
</div>

</form>


<\%
 } //end if(nAction==CHANGE_FORM)
%>
<\% if(nAction==SEARCH_RECORDS)
{ 
   session.removeAttribute(QUERY_OBJECT_ID);
%>
<form action="<\%=thisFile %>" method="POST"  accept-charset="UTF-8" class="form-horizontal" id="<%=TableName%>_Search">
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

<div class="panel">
  <div class="panel-heading">
    <h3 class="panel-title page-title-action"><\%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;" data-original-title="Reset Form" data-placement="left" data-toggle="tooltip"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body container-fluid">
<hr class="hr-res" />	

      <div class="form-group">
        <label class="control-label col-sm-3">Search By ID :
          <span class="checkbox-custom checkbox-inline checkbox-primary" style="padding-top: 2px;display:none;">&nbsp;<input type="checkbox" name="<%=IDField %>_RNG_CHK" id="<%=IDField %>_RNG_CHK" onchange="CheckSearchRange('<%=IDField %>')"><label for="<%=IDField %>_RNG_CHK"></label></span>
        </label>
      	<div class="col-sm-1" id="<%=IDField %>_OPR_BLK"><\%=NumberSearchdroplist.getOperatorList("<%=IDField %>_OPERATOR", "<%=IDField %>_OPERATOR", "form-control show-tick", "data-plugin='selectpicker'" )  %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-sm-2"><input type="text" name="<%=IDField %>" id="<%=IDField %>" class="form-control" /></div>
      	<label class="control-label col-sm-1 text-center" id="<%=IDField %>_RNG_LBL" style="display:none;width: 5.333%;margin-bottom: 0px;">TO</label>
      	<div class="col-sm-2" id="<%=IDField %>_RNG_BLK" style="display:none"><input type="text" name="<%=IDField %>_TO" id="<%=IDField %>_TO" class="form-control" /></div>
      </div>			
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
      <div class="form-group">
        <label class="control-label col-sm-3"><%=SearchFields[n] %> :
          <span class="checkbox-custom checkbox-inline checkbox-primary" style="padding-top: 2px;display:none;">&nbsp;<input type="checkbox" name="<%= SearchFields[n] %>_RNG_CHK" id="<%= SearchFields[n] %>_RNG_CHK" onchange="CheckSearchRange('<%= SearchFields[n] %>')"><label for="<%= SearchFields[n] %>_RNG_CHK"></label></span>
        </label>
      	<div class="col-sm-1" id="<%= SearchFields[n] %>_OPR_BLK"><\%=NumberSearchdroplist.getOperatorList("<%= SearchFields[n] %>_OPERATOR", "<%= SearchFields[n] %>_OPERATOR", "form-control show-tick", "data-plugin='selectpicker'" )  %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-sm-2"><input type="text" name="<%= SearchFields[n] %>" id="<%= SearchFields[n] %>" class="form-control" /></div>
      	<label class="control-label col-sm-1 text-center" id="<%= SearchFields[n] %>_RNG_LBL" style="display:none;width: 5.333%;margin-bottom: 0px;">TO</label>
      	<div class="col-sm-2" id="<%= SearchFields[n] %>_RNG_BLK" style="display:none"><input type="text" name="<%= SearchFields[n] %>_TO" id="<%= SearchFields[n] %>_TO" class="form-control" /></div>
      </div>			
	  <%
		
		break;
		
	  case java.sql.Types.CHAR:
	  case java.sql.Types.VARCHAR:
		case java.sql.Types.NCHAR:
		case java.sql.Types.NVARCHAR:
    %>
      <div class="form-group">
        <label class="col-sm-3 control-label"><%=SearchFields[n] %> :</label>
      	<div class="col-sm-2"><\%= StringSearchdroplist.getDropList("<%= SearchFields[n] %>_SEARCHTYPE", StringSearch.START, null, "form-control show-tick", "data-plugin='selectpicker'") %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-sm-3"><input type="text" name="<%= SearchFields[n] %>" id="<%= SearchFields[n] %>" class="form-control" /></div>
      </div>		
		<%
		break;
		
	  case java.sql.Types.DATE:
	 %>
      <div class="form-group">
        <label class="col-sm-3 control-label"><%=SearchFields[n] %> :
        <span class="checkbox-custom checkbox-inline checkbox-primary" style="padding-top: 2px;display:none;"><input type="checkbox" name="<%= SearchFields[n] %>_RNG_CHK" id="<%= SearchFields[n] %>_RNG_CHK" onchange="CheckSearchRange('<%= SearchFields[n] %>')"><label for="<%= SearchFields[n] %>_RNG_CHK"></label></span>
      	</label>
      	<div class="col-sm-1" id="<%=SearchFields[n] %>_OPR_BLK"><\%=NumberSearchdroplist.getOperatorList("<%=SearchFields[n] %>_OPERATOR", "<%=SearchFields[n] %>_OPERATOR", "form-control show-tick", "data-plugin='selectpicker'" ) %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-sm-3"><div class="input-group input-group-icon"><input type="text" readonly="true" name="<%=SearchFields[n] %>" id="<%=SearchFields[n] %>" class="form-control readonlybg" data-plugin="datepicker"><span class="input-group-addon"><span class="icon fa fa-calendar" aria-hidden="true"></span></span></div></div>
      	<label class="control-label col-sm-1 text-center" id="<%=SearchFields[n] %>_RNG_LBL" style="display:none;width: 5.333%;margin-bottom: 0px;">TO</label>
      	<div class="col-sm-3" id="<%=SearchFields[n] %>_RNG_BLK" style="display:none"><div class="input-group input-group-icon"><input type="text" readonly="true" name="<%=SearchFields[n] %>_TO" id="<%=SearchFields[n] %>_TO" class="form-control readonlybg" data-plugin="datepicker"><span class="input-group-addon"><span class="icon fa fa-calendar" aria-hidden="true"></span></span></div></div>
      </div>
	 <%
	  break;
	
	 case java.sql.Types.TIMESTAMP:
 %>
      <div class="form-group">
        <label class="col-sm-3 control-label"><%=SearchFields[n] %> :</label>
        <div class="col-sm-2"><input type="text" name="<%=SearchFields[n] %>" id="<%=SearchFields[n] %>" class="form-control" /></div>
      </div>	
 <%	 
	 break;
	 
	 default:
   %> 
      <div class="form-group">
        <label class="col-sm-3 control-label"><%=SearchFields[n] %> :</label>
        <div class="col-sm-2"><input type="text" name="<%=SearchFields[n] %>" id="<%=SearchFields[n] %>" class="form-control" /></div>
      </div>	
<%	 
	 break;

	} // end case switch(nSerachFieldType)
	
	
} // end for loop
%>

      <div class="form-group">
        <label class="col-sm-3 control-label">Sort By :</label>
        <div class="col-sm-2">
      	  <select name="OrderBy" id="OrderBy" class="form-control show-tick" data-plugin="selectpicker"><% for(n=0 ; SearchFields!=null && n<SearchFields.length ; n++){ %>
      		  <option value="<%=SearchFields[n] %>" ><%=SearchFields[n] %></option><% } %>		
      		</select>
        </div>
      </div>

      <div class="form-group">
        <label class="col-sm-3 control-label">Records Per Page :</label>
        <div class="col-sm-2"><input type="text" name="ROWS" id="ROWS" class="form-control" value="20" /></div>
      </div>	
			
<hr />

      <div class="form-group">
			  <div class="col-sm-offset-3">
          <button type="submit" class="btn btn-primary" title="Submit For Search"><i class="fa fa-search" aria-hidden="true"></i>&nbsp;Search</button>
          <button type="button" class="btn btn-default btn-outline" title="Cancel Search" onclick="NavigateTo('<\%=ReturnPath %>')"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
  				<\% if(bAllowAdd == true){ %>
  				<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="NavigateTo('<\%=thisFile %>?Action=New<\%=ForeignKeyParam %><\%=ReturnPathLink %>')"><i aria-hidden="true" class="icon fa fa-plus"></i></button>
  				<\% } %>
				</div>
      </div>	

</div>
</div>

</form>


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

 <div class="panel">
  <div class="panel-heading">
    <h3 class="panel-title page-title-action"><\%=PageTitle %> ( <\%=QryObj.count %> )
		<a href="<\%=thisFile %>?Action=Search<\%=ForeignKeyParam %><\%=ReturnPathLink %>" class="pull-right"><i class='icon fa fa-search iccolor' aria-hidden='true'></i><span class="hidden-xs iccolor" style="font-size: 15px;">Search Again</span></a>
    </h3>
	</div>

<div class="panel-body container-fluid">
<hr class="hr-res" />	

<!-- $CHECK Look for chain -->
<!-- NAVIGATION BAR BEGIN -->
<\% 
if(QryObj.count>QryObj.pagesize)
{ 
LastBlock= (QryObj.count/QryObj.pagesize)*QryObj.pagesize ;
if(LastBlock == QryObj.count) LastBlock-=QryObj.pagesize ;
%>
<div class="table-responsive">
<table class="table table-bordered table-condensed Rslt-Act-nav-tbl" >
<tr>
<td width="10%" align="left" >
<\% 
if(QryObj.offset >=QryObj.pagesize )
{ 
%>
<a href="<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>&OFFSET=0"><%=FIRST %></a></td>
<\% }
else
{ %>
<%=FIRST %>
<\% 
} 
%>

<td width="20%" align="left" > 
<\% 
if(QryObj.offset >=QryObj.pagesize )
{ 
%>
<a href="<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>&OFFSET=<\%=QryObj.offset-QryObj.pagesize  %>"><%=PREVIOUS %></a><span class="hidden-xs"> [ <\%=QryObj.offset-QryObj.pagesize+1 %> to <\%=QryObj.offset %> ]</span>
<\% }
else
{ %>
<%=PREVIOUS %> 
<\% 
} 
%>
</td>
<td  width="40%" align="center" >
<div class="input-group col-sm-6">
<select name="block" id="block" class="form-control">
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
  <span class="input-group-btn">
	  <button class="btn btn-primary" type="button" onclick="GoToBlock()"><%=GOTO %></button>
	</span>
</div>
</td>
<td width="20%" align="right" >
<\% 
if(QryObj.offset < (QryObj.count - QryObj.pagesize) )
{ 
%>
<span class="hidden-xs">[ <\%=QryObj.offset+QryObj.pagesize+1 %> to <\%= ( (QryObj.offset+QryObj.pagesize+QryObj.pagesize)<=QryObj.count? QryObj.offset+QryObj.pagesize+QryObj.pagesize : QryObj.count ) %> ] </span><a href="<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>&OFFSET=<\%=QryObj.offset+QryObj.pagesize  %>"><%=NEXT %></a>
<\% }
else
{ %>
<%=NEXT %>
<\% 
} 
%>
</td>
<td width="10%" align="right" >
<\% 
if(QryObj.offset < (QryObj.count - QryObj.pagesize) )
{ 
%>
<a href="<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>&OFFSET=<\%=LastBlock %>"><%=LAST %></a>
<\% }
else
{ %>
<%=LAST %>
<\% 
} 
%>

</td>
</tr>
</table>
</div>
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
		
<%		
} 
%>
<\% if(bAllowAdd == true){ %>
		<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="NavigateTo('<\%=thisFile %>?Action=New<\%=ForeignKeyParam %><\%=ReturnPathLink %>')"><i aria-hidden="true" class="icon fa fa-plus"></i></button>
<\% } %>

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

<div class="table-responsive">
<table class="table table-bordered table-condensed" id="<%=TableName%>_Result_tbl">
<thead>
<tr>
<th width="5%"><span class="checkbox-custom checkbox-inline checkbox-primary"><input type="checkbox" name="<%=TableName%>_Result_checkall" id="<%=TableName%>_Result_checkall"><label></label></span>&nbsp;&nbsp;#</th>
<% 
for (n=0 ;ShowFields!=null && n< ShowFields.length ; n++)
{ %><th><%=ShowFields[n] %></th>
<% 
} 
%>
<\% if(bAllowUpdate == true){ %> <th valign="top" >Change</th> <\% } %>
<\% if(bAllowDelete == true){ %> <th valign="top" >Delete</th> <\% } %>
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
DelWarning = "  "+<%=BeanName  %>.<%=IDField  %>+"  " ;
// $CHECK
%>
<tr>
<td><% if(bCheckBox){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary"><input type="checkbox" name="<%=IDField  %>" id="<%=IDField  %>_<\%=<%=BeanName  %>.<%=IDField  %> %>"  value="<\%=<%=BeanName  %>.<%=IDField  %> %>"><label></label></span>
<% } %>
&nbsp;&nbsp;<\%=sno %> 
</td>
<%
for (n=0 ; ShowFields!=null && n< ShowFields.length ; n++)
{ 
ColVarName= BeanName+"."+ShowFields[n].replace((char)32, '_' ) ;
switch(rsmd.getColumnType(rslt.findColumn(ShowFields[n])))
{
  case java.sql.Types.DATE:
	 %> <td><\%=DateTimeHelper.showDatePicker(<%=ColVarName %>) %></td> 
	 <% 
	break;
	case java.sql.Types.TIMESTAMP:
	 %> <td valign="top" > <\%=DateTimeHelper.showDateTimePicker(<%=ColVarName %>) %></td> 
	 <%
	break;
	case java.sql.Types.TIME:
	 %> <td><\%=DateTimeHelper.showTimeClockPicker(<%=ColVarName %>, "Show") %></td> 
	 <%
	break;

	case java.sql.Types.LONGVARBINARY:
	case java.sql.Types.VARBINARY:
	case java.sql.Types.BINARY:
	 %><td>Binary Data</td>
	 <%
	break;
	default: %><td><\%=<%=ColVarName %> %></td>
	<%
}
} 
%>
<\% if(bAllowUpdate == true){ %>  <td valign="top" ><a href="<\%=thisFile %>?Action=Change&<%=IDField  %>=<\%=<%=BeanName  %>.<%=IDField  %> %><\%=ForeignKeyParam %><\%=ReturnPathLink %>">Change</a></td> <\% } %>
<\% if(bAllowDelete == true){ %>  <td valign="top" ><a href="javascript:void(0)" onclick="DeleteRecord('<\%=<%=BeanName  %>.<%=IDField  %> %>', '<\%=DelWarning %>' )">Delete</a></td> <\% } %>
</tr>
<\% 
} // end while( <%=BeanName  %>.nextRow());
<%=BeanName  %>.closeTable();
 %>
</tbody>
</table>
</div>
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
</div>
</div>

<\% 
} // end if (nAction==SEARCH_RESULT)
%>

<\% if(nAction==SHOW_RECORD)
{
// $CHECK
<%=BeanName  %>.locateRecord(n<%=IDField  %>);
DelWarning = "Really want to Delete <%=IDField  %> : "+<%=BeanName  %>.<%=IDField  %>+" " ;
%>
<div class="panel">
  <div class="panel-heading">
    <h3 class="panel-title page-title-action"><\%=PageTitle %>&nbsp;[ ID : <\%=<%=BeanName  %>.<%=IDField  %> %> ]
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" onclick="NavigateTo('<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>')"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<\% if(bAllowDelete == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-left: 5px;" data-original-title="Delete" data-placement="bottom" data-toggle="tooltip" onclick="DeleteRecord('<\%=<%=BeanName  %>.<%=IDField  %> %>', '<\%=DelWarning %>', '<\%=thisFile %>?Action=Delete<\%=ForeignKeyParam %><\%=ReturnPathLink %>&<%=IDField  %>=<\%=<%=BeanName  %>.<%=IDField  %> %>' )"><i aria-hidden="true" class="icon wb-trash" style="margin: 0;"></i></button>
		<\% } %>
		<\% if(bAllowUpdate == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;" data-original-title="Edit" data-placement="left" data-toggle="tooltip" onclick="NavigateTo('<\%=thisFile %>?Action=Change&<%=IDField %>=<\%=<%=BeanName  %>.<%=IDField  %> %><\%=ForeignKeyParam %><\%=ReturnPathLink %>')"><i aria-hidden="true" class="icon wb-pencil" style="margin: 0;"></i></button>
    <\% } %>
		</h3>
	</div>

<div class="panel-body container-fluid">
<hr class="hr-res" />	

<% 
request.setAttribute("RSMD", rsmd);
%>
<jsp:include page="show-record-page.jsp" flush="true"><jsp:param name="BeanName" value="<%=BeanName  %>" /><jsp:param name="IDField" value="<%=IDField  %>" /><jsp:param name="EntityName" value="<%=EntityName  %>" /></jsp:include>

</div>
</div>
<\%
}//end if(nAction==SHOW_RECORD) 
%>

</div><!-- main div end #maindiv -->

</div><!--   div end .page_container -->

	<% out.print("<jsp:include page =\"/"+LoginFolderName+"/include-page/footer.jsp\" flush=\"true\" />"); %>
	 
  <% out.print("<jsp:include page =\"/include-page/js/main-js.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
  <% out.print("<jsp:include page =\"/include-page/js/bootstrap-select-js.jsp\" flush=\"true\" />"); %>
  <% if(bDateSupport){%>
  <% out.print("<jsp:include page =\"/include-page/js/bootstrap-datepicker-js.jsp\" flush=\"true\" />"); %>
  <% } %>
	<% out.print("<jsp:include page =\"/include-page/common/Google-Analytics.jsp\" flush=\"true\" />"); %>

<% 
out.println("<jsp:include page=\""+ScriptFolder+"/jvalidate/jvalidate.jsp\" flush=\"true\" />");
out.println("<jsp:include page=\""+ScriptFolder+"/devbridge-autocomplete/autocomplete.jsp\" flush=\"true\" />");

%>
<script type="text/javascript" src="<\%=appPath %><%=ScriptFolder %>/field/jquery.field.min.js"></script>
<script language="JavaScript" type="text/javascript">
<!--
<\% 
if(MessageText!=null)
{ 
	String Notify = MessageText.replace("\n","<br/>").replace("\r","");
%>
	toastr.success('<\%= Notify %>');
<\% 
} 
%> 

function DeleteRecord(del_id, del_msg, del_url) {
swal({
  title: 'Are you sure?',
  text:  del_msg,
  type: 'question',
  showCancelButton: true
	//,animation: false
}).then(function() {
  NavigateTo(del_url);
}, function(dismiss) {
  // dismiss can be 'cancel', 'overlay', 'close', 'timer'
  if (dismiss === 'cancel') {
    //toastr.info("Delete Cancel !");
  }
});	
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
	var rng_lbl   = search_field+"_RNG_LBL" ;
	
	if( $("#"+rng_chk).prop("checked") )
	{
	  // Range check box is checked
	  // Show range input and hide operators
		$("#"+rng_blk).show();
		$("#"+rng_lbl).show(); 
		$("#"+opr_blk).hide(); 
	}
	else
	{
	  // Range check box is NOT checked
	  // Hide range input and show operators
		$("#"+rng_blk).hide();
		$("#"+rng_lbl).hide();
		$("#"+opr_blk).show(); 
	}

}

// Initialize jQuery 
$(document).ready(function() {
// Other JQuery initialization here
<jsp:include page="form-validation.jsp" flush="true"><jsp:param name="TableName" value="<%=TableName %>" /></jsp:include>

/* Search autocomplete support -Start */
  // JSP Block Start
  <\%  
	if( nAction==SEARCH_RECORDS ) 
	{ 
	%>
	  /* un comment this to enable
	  $('#?FieldName').devbridgeAutocomplete({
    serviceUrl: "<\%=appPath %>/autocomplete-list.jsp",
		params: {table:"members",field:"?FieldName"} 
	  });
    */
	
	<\% 
	} 
	%>
	// JSP Block End
/* Search autocomplete support -End */

});  
// end of jQuery Initialize block
// -->
</script>
	

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
