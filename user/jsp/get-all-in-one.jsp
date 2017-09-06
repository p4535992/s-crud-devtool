<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.*" %><%@ page  import="com.webapp.utils.*" %><jsp:useBean id="FieldLabelMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="FieldMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="ManField" scope="session" class="java.util.Vector" /><jsp:useBean id="ManFieldMap" scope="session" class="java.util.TreeMap" /><%
String PageType = "ALL-IN-ONE";
int nManCount = ManField.size();
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
String DriverName= request.getParameter("DriverName");
String BeanName = request.getParameter("BeanName");
String BeanClass = request.getParameter("BeanClass");
String BeanPackage = request.getParameter("BeanPackage");
String JNDIDSN = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");

char TFirst = TableName.charAt(0);
if(TFirst > 96) TFirst-=32 ;
String CTableName = TFirst+TableName.substring(1) ;

String IDField = request.getParameter("IDField").replace((char)32, '_' );
String IDFieldType = request.getParameter("IDFieldType") ;
String IsAuto = request.getParameter("IsAuto") ;
String WebApp = request.getParameter("WebApp");
String PageTitle = request.getParameter("PageTitle") ;
String EntityName = request.getParameter("EntityName") ;
String AltTxt = request.getParameter("AltTxt") ;
boolean bCheckBox = (request.getParameter("CheckBox") !=null )? true : false ;
boolean bDateTimeJSCSS = (request.getParameter("DateTimeJSCSS") !=null )? true : false ;
boolean bDatatablesJSCSS = (request.getParameter("DatatablesJSCSS") !=null )? true : false ;
boolean bConfigSMS = (request.getParameter("ConfigSMS") !=null )? true : false ;

String OutputFileName = request.getParameter("OutputFileName") ;

String LoginFolderName = request.getParameter("LoginFolderName") ;

String[] ShowFields = request.getParameterValues("ShowFields");
String[] SearchFields = request.getParameterValues("SearchFields");
String[] ForeignFields = request.getParameterValues("ForeignFields");
String[] DuplicateFields = request.getParameterValues("DuplicateFields");
StringBuffer FKeys= new StringBuffer("");
boolean bForeignKey = (ForeignFields!=null&&ForeignFields.length>0)?true:false;
boolean bCheckDup = (DuplicateFields!=null&&DuplicateFields.length>0)?true:false;
boolean bAuto=(IsAuto!=null)?true:false;
boolean bAltTxt = (AltTxt!=null)?true:false;
String AddFormName = TableName+"_Add";
String UpdateFormName = TableName+"_Update";
int n =0;
boolean bDateSupport =("YES".equalsIgnoreCase(request.getParameter("HasDate")))?true:false;
boolean bTimeSupport =("YES".equalsIgnoreCase(request.getParameter("HasTime")))?true:false;
boolean bTimestampSupport =("YES".equalsIgnoreCase(request.getParameter("HasTimestamp")))?true:false;
boolean bAddCMSSetting = (request.getParameter("AddCMSSetting") !=null )? true : false ;

if(PageTitle==null)
{
  PageTitle=TableName ;
}else if (PageTitle.equalsIgnoreCase("?"))
{
  PageTitle=TableName ;
}


final String FIRST = "<i class='icon fa fa-backward' aria-hidden='true'></i><span class='hidden-xs' style='font-size: 16px;'>&nbsp;First</span>";
final String PREVIOUS = "<i class='icon fa fa-step-backward' aria-hidden='true'></i><span class='hidden-xs' style='font-size: 16px;'>&nbsp;Previous</span>" ;
final String GOTO = "<i class='icon fa fa-list'></i>" ;
final String NEXT = "<span class='hidden-xs' style='font-size: 16px;'>Next&nbsp;</span><i class='icon fa fa-step-forward' aria-hidden='true'></i>" ;
final String LAST = "<span class='hidden-xs' style='font-size: 16px;'>Last&nbsp;</span><i class='icon fa fa-forward' aria-hidden='true'></i>" ;

//response.setContentType("text/plain");
/**/
String ContentType = "application/x-download" ;
response.setContentType(ContentType);
String ContentDisp = "attachment; filename="+OutputFileName;
response.setHeader("Content-Disposition", ContentDisp);

java.sql.Connection conn = null;
javax.naming.Context env =null;
javax.sql.DataSource source = null;
String ColVarName = null;
String ColName=null;
int ColType=0;

String multipart="" ;
boolean bMultiPart = (request.getParameter("multipart_form_upload") !=null )? true : false ;
if(bMultiPart) multipart=" enctype=\"multipart/form-data\"" ;

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

StringBuilder sbChdupADD = new StringBuilder();
StringBuilder sbChdupUPDATE = new StringBuilder();

StringBuilder sbChdupparam = new StringBuilder();
StringBuilder sbChdupWhr = new StringBuilder();

if(bCheckDup)
{
  java.util.Vector columns = new java.util.Vector();
  int i3 = 0 ;  		 
  for(String s:DuplicateFields)
  {
  int n4 = Integer.parseInt(s); 
  com.beanwiz.TableColumn col = new com.beanwiz.TableColumn();
  col.ColSQLType = rsmd.getColumnType(n4);
  %><%@ include file="/user/newbeans/COL-INIT.inc" %><%
  
  columns.add(col);
  
  PortableSQL psql = new PortableSQL(application);
  sbChdupparam.append(""+((com.beanwiz.TableColumn)columns.get(i3)).VarType+" "+psql.colName("`"+rsmd.getColumnName(n4)+"`")+"");
  //if(i3+1< DuplicateFields.length) 
  sbChdupparam.append(", ");
  
  boolean isString = (((com.beanwiz.TableColumn)columns.get(i3)).VarType).equals("String"); 
  sbChdupWhr.append(" `"+psql.colName("`"+rsmd.getColumnName(n4)+"`")+"` = ");
  sbChdupWhr.append( (isString) ? "'\""+(char)43+""+psql.colName("`"+rsmd.getColumnName(n4)+"`")+""+(char)43+"\"'" : "\""+(char)43+""+psql.colName("`"+rsmd.getColumnName(n4)+"`")+""+(char)43+"\""  );
  if(i3+1< DuplicateFields.length) sbChdupWhr.append(" AND");
  i3++;
  }
}
%><jsp:include page="include-page/directive-include.jsp" flush="true"><jsp:param name="WebApp" value="<%=WebApp %>" /><jsp:param name="BeanPackage" value="<%=BeanPackage %>" /><jsp:param name="ConfigSMS" value="<%=bConfigSMS %>" /></jsp:include>
<%
if(LoginFolderName.equalsIgnoreCase("admin")) 
{
out.print("<jsp:useBean id=\"SiMngrBn\" scope=\"page\" class=\""+BeanPackage+".SitemanagerBean\" />\r\n"); 
if(bAddCMSSetting){
out.print("<jsp:useBean id=\"InCourseBn\" scope=\"page\" class=\""+BeanPackage+".Institute_courseBean\" />\r\n");
out.print("<jsp:useBean id=\"SemBn\" scope=\"page\" class=\""+BeanPackage+".Institute_course_semesterBean\" />\r\n");
}
}
else if(LoginFolderName.equalsIgnoreCase("student")) 
{
out.print("<jsp:useBean id=\"CanBn\" scope=\"page\" class=\""+BeanPackage+".CandidateBean\" />\r\n");
}
out.print("<jsp:useBean id=\""+BeanName+"\" scope=\"page\" class=\""+BeanPackage+"."+BeanClass+"\" />\r\n");
%><\%! 
boolean CheckDuplicateEntry( <%=sbChdupparam.toString() %><%=BeanPackage %>.<%=BeanClass %> <%=BeanName %>, String sAction, int nIDField )
{<% if(!bCheckDup){%>
/*<% } %> 
   try
   {
	 		if(sAction.equals("AddChk"))
			{
			 	return ( <%=BeanName %>.recordCount(" WHERE<%=sbChdupWhr.toString() %>") > 0 ) ? false : true ;
			}
			else
			{
   		 	return ( <%=BeanName %>.recordCount(" WHERE<%=sbChdupWhr.toString() %> AND `<%=IDField %>` != "+nIDField+"") > 0 ) ? false : true ;
			}
   }  
   catch( java.sql.SQLException exSQL ) 
   {  
   		return false ; 
   }<% if(!bCheckDup){%>
*/<% } %><% if(!bCheckDup){%>
return true ; // remove this line to enable<% } %> 
}
%>
<\% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %>
<%=WebApp %>.LoggedSitemanager LogUsr = (<%=WebApp %>.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);
<% }else if(LoginFolderName.equalsIgnoreCase("student")) { %>
<%=WebApp %>.LoggedCandidate LogUsr = (<%=WebApp %>.LoggedCandidate)session.getAttribute("theCandidate") ;
CanBn.locateRecord(LogUsr.CandidateID);
<% }else{ %>
<%=WebApp %>.LoggedSitemanager LogUsr = (<%=WebApp %>.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);
<% } %><% if(bConfigSMS){ %>
<% out.print("%"+">"); %><!-- CHECK MAIL/SMS SERVICE -->
<\%@ include file="/include-page/master/mail-sms-check.inc" %>
<% out.print("<"+"%"); %>
<% } %><jsp:include page="include-page/formtablefieldlabel.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /></jsp:include>
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
<%=WebApp %>.apputil.appMakeQueryString qStr = null ;

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

// Action authorization || Enable : true & Disable : false
boolean bAllowAdd = false ;
boolean bAllowUpdate = false ;
boolean bAllowDelete = false;
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %>%>
<\%@include file="/admin/authorization.inc"%>
<\%
//override Action authorization
//bAllowDelete = false ;
//bAllowUpdate = true ;
//bAllowAdd = true ;<% } %>

//footer Page Navigation
boolean bAllowFooterPageNavigation = true;

//Result-Action Checkbox Visibility
boolean bResultActionCheckbox = true;

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
<%=BeanName %>.locateRecord(n<%=IDField %>);
<% 
}
else
{
%> // ID field is String ( character data ) type
 String n<%=IDField %> = request.getParameter("<%=IDField %>") ;
<% 
} 
%><% if(bForeignKey)
{  
   // FOREIGN KEY VARIABLE DECLARATION
   for(n=0; n<ForeignFields.length ; n++)
   {
   FKeys.append(ForeignFields[n]+":");
%>String <%=ForeignFields[n] %> = request.getParameter("<%=ForeignFields[n]%>");
if(<%=ForeignFields[n] %>==null) <%=ForeignFields[n] %> = ""; 
ForeignKeyParam.append("&<%=ForeignFields[n] %>="+<%=ForeignFields[n] %>) ;
<%
} // end for
}// end if
%><jsp:include page="../params/file-upload-include.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /></jsp:include>
if(nAction==ADD_RECORD)
{
<% if(bAuto){ %>
     <%=BeanName %>.<%=IDField %>= 0;
<%} %>
<jsp:include page="../params/paraminclude.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /></jsp:include>

		if( bAllowAdd == true )
		{
		    if(CheckDuplicateEntry( <% if(DuplicateFields!=null){ for(int n1=0 ; DuplicateFields!=null && n1<DuplicateFields.length ; n1++){ sbChdupADD.append(""+BeanName+"."+rsmd.getColumnName(Integer.parseInt(DuplicateFields[n1]))+""); sbChdupADD.append(", "); } %><%=sbChdupADD %><%=BeanName %>, "AddChk", 0<% }else {%><%=BeanName %>, "AddChk", 0<% } %> ))
        {
           <%=BeanName %>.addRecord();
					 if(<%=BeanName %>.recordCount("") == 1) QryObj.count = 1 ;
           MessageText = "One record added. New ID = "+<%=BeanName %>._autonumber ;
           // Page redirection code begin {{
        	 java.lang.StringBuffer rd = request.getRequestURL();
           rd.append("?"+DEFAULT_ACTION+ForeignKeyParam+"&Message="+MessageText);
           response.sendRedirect(response.encodeRedirectURL(rd.toString()));
        	 // }} Page redirection code end
        }
        else
        {
          MessageText = "Duplicate Entry Found!<br>No new record created." ;
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
    <jsp:include page="../params/paraminclude.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /></jsp:include>
   
	  if(bAllowUpdate == true)
		{
		    if(CheckDuplicateEntry( <% if(DuplicateFields!=null){ for(int n1=0 ; DuplicateFields!=null && n1<DuplicateFields.length ; n1++){ sbChdupUPDATE.append(""+BeanName+"."+rsmd.getColumnName(Integer.parseInt(DuplicateFields[n1]))+""); sbChdupUPDATE.append(", ");} %><%=sbChdupUPDATE %><%=BeanName %>, "UpdateChk", n<%=IDField %><% } else {%><%=BeanName %>, "UpdateChk", n<%=IDField %><% } %> ))
        {
    	     <%=BeanName %>.updateRecord(n<%=IDField %>);
           MessageText = "One record updated. Updated ID = "+n<%=IDField %> ;
           // Page redirection code begin {{
        	 java.lang.StringBuffer rd = request.getRequestURL();
           rd.append("?"+DEFAULT_ACTION+ForeignKeyParam+"&Message="+MessageText);
           response.sendRedirect(response.encodeRedirectURL(rd.toString()));
        	 // }} Page redirection code end
        }
        else
        {
          MessageText = "Duplicate Entry Found!<br>Record not Updated." ;
        }
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
<jsp:include page="include-page/checkbox-process.jsp" flush="true">
  <jsp:param name="TableName" value="<%=TableName %>" />
  <jsp:param name="IDField" value="<%=IDField %>" />
  <jsp:param name="BeanName" value="<%=BeanName %>" />
  <jsp:param name="SQLEngine" value="<%=ENG %>" />
  <jsp:param name="WebApp" value="<%=WebApp %>" />
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
{	 bRetPath=true;

   ReturnPath = new String( UrlBase64.decode( ParamReturnPath ));
	 ReturnPathLink="&ReturnPath="+ParamReturnPath;
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
	<title><%=PageTitle %></title>

  <% out.print("<jsp:include page =\"/include-page/css/main-css.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
	<% out.print("<jsp:include page =\"/include-page/css/bootstrap-select-css.jsp\" flush=\"true\" />"); %>
  <% if(bDateSupport){%><% out.print("<jsp:include page =\"/include-page/css/bootstrap-datepicker-css.jsp\" flush=\"true\" />"); %>
  <% } %><% if(bTimeSupport){%><% out.print("<jsp:include page =\"/include-page/css/bootstrap-clockpicker-css.jsp\" flush=\"true\" />"); %>
  <% } %><% if(bDateTimeJSCSS){%><% out.print("<jsp:include page =\"/include-page/css/bootstrap-datetimepicker-css.jsp\" flush=\"true\" />"); %>
  <% } %><% if(bDatatablesJSCSS){%><% out.print("<jsp:include page =\"/include-page/css/datatables-css.jsp\" flush=\"true\" />"); %>
  <% } %>	
  <% out.print("<jsp:include page =\"/include-page/common/main-head-js.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
</head>
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %>
<body class="<\%=menuTypeClass %> <\%=SiMngrBn.LoginRole %>" onload="InitPage()" >
<% }else if(LoginFolderName.equalsIgnoreCase("student")) { %>
<body class="<\%=menuTypeClass %> <\%=CanBn.LoginRole %>" onload="InitPage()" >
<% }else{ %>
<body class="<\%=menuTypeClass %> <\%=SiMngrBn.LoginRole %>" onload="InitPage()" >
<% } %>

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
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i><%=PageTitle %></h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<\%=appPath %>/<%=LoginFolderName %>/index.jsp"><i aria-hidden="true" class="fa fa-home fa-lg margin-right-5"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active"><%=CTableName %></li>
          </ol>			
  	    </div>
  		</div>	
<% 
if(bForeignKey)
{ 
%> 
<!-- 
<blockquote class="blockquote blockquote-success appblockquote">
<span class=" blue-grey-700">For : </span><%  //FOREIGN KEYS  NEW FROM
for(n=0; bForeignKey && n<ForeignFields.length ; n++)
{
%><%=ForeignFields[n] %>
<%
}   
%></blockquote>    
 -->
<%
}// end if
%>
<\% if(nAction==NEW_FORM)
{
  /* 
    Hint: Use this to get form values in case new form is called from serach result.
    Place value of form field as item before each field
    String item=null;
    if(QryObj!=null)item=QryObj.getKey("$Field") ; 
    else item="";
  */
%>			
<form action="<\%=thisFile %>" method="POST" name="<%=TableName%>_Add" id="<%=TableName%>_Add"<%=multipart %> accept-charset="UTF-8" >
<input type="hidden" name="Action" value="Add" />
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %><input type="hidden" name="M" value="<\%=nModuleID %>" /><% } %>
<\%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<\%=ParamReturnPath %>" />
<\% 
} 
%><%  //FOREIGN KEYS  NEW FROM
for(n=0; bForeignKey && n<ForeignFields.length ; n++)
{
out.print("<input type=\"hidden\" name=\""+ForeignFields[n]+"\" value=\""+"<"+"%="+ForeignFields[n]+" %"+">"+"\" />\r\n");
}   
%>
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><\%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Back" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>
	
<div class="panel-body panel-form-box-body container-fluid">

<!-- INSERT ADD FROM -->
<jsp:include page="../forms/forminclude.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /><jsp:param name="FormName" value="<%=AddFormName%>" /><jsp:param name="Mode" value="Add" /><jsp:param name="ForeignKey" value="<%=FKeys %>" /><jsp:param name="LoginFolderName" value="<%=LoginFolderName %>" /></jsp:include>

</div>

<div class="panel-form-box-footer text-center">
      <button type="submit" class="btn btn-primary" title="Submit for Addition"><i class="fa fa-plus" aria-hidden="true"></i>&nbsp;Add</button>
      <button type="button" class="btn btn-default btn-outline" title="Cancel Addition" onclick="history.go(-1);"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
</div>

</div>

</form>

<\%
 } 
%>

<\% if(nAction==CHANGE_FORM)
{

<%=BeanName %>.locateRecord(n<%=IDField %>);
%>
<form action="<\%=thisFile %>" method="POST" name="<%=TableName%>_Update" id="<%=TableName%>_Update"<%=multipart %> accept-charset="UTF-8" >
<input type="hidden" name="Action" value="Update" />
<input type="hidden" name="<%=IDField %>" value="<\%=n<%=IDField %> %>" />
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %><input type="hidden" name="M" value="<\%=nModuleID %>" /><% } %>
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
 
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><\%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Back" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">
 
<!-- INSERT UPDATE FORM  --> 
<jsp:include page="../forms/forminclude.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /><jsp:param name="FormName" value="<%=UpdateFormName%>" /><jsp:param name="Mode" value="Update" /><jsp:param name="ForeignKey" value="<%=FKeys %>" /></jsp:include>

</div>

<div class="panel-form-box-footer text-center">
      <button type="submit" class="btn btn-primary" title="Submit for update"><i class="fa fa-check" aria-hidden="true"></i>&nbsp;Update</button>
      <button type="button" class="btn btn-default btn-outline" title="Cancel Update" onclick="history.go(-1);"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
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
<form action="<\%=thisFile %>" method="POST" class="form-horizontal" id="<%=TableName%>_Search" accept-charset="UTF-8" >
<input type="hidden" name="Action" value="Result" />
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %><input type="hidden" name="M" value="<\%=nModuleID %>" /><% } %>
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

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><\%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="submit" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Go To Result" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover"><i aria-hidden="true" class="icon wb-arrow-right" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

<!-- 
      <div class="form-group">
        <label class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600">Search By ID :
          <span class="checkbox-custom checkbox-inline checkbox-primary" style="padding-top: 2px;display:none;">&nbsp;<input type="checkbox" name="<%=IDField %>_RNG_CHK" id="<%=IDField %>_RNG_CHK" onchange="CheckSearchRange('<%=IDField %>')"><label for="<%=IDField %>_RNG_CHK"></label></span>
        </label>
      	<div class="col-md-1 col-sm-2 col-xs-12" id="<%=IDField %>_OPR_BLK"><\%=NumberSearchdroplist.getOperatorList("<%=IDField %>_OPERATOR", "<%=IDField %>_OPERATOR", "form-control show-tick", "data-plugin='selectpicker'" ) %></div>
      	<span id="<%=IDField %>_RNG_XSVIS" class="visible-xs-*">&nbsp;</span>
      	<div class="col-md-2 col-sm-3 col-xs-12"><input type="text" name="<%=IDField %>" id="<%=IDField %>" class="form-control" /></div>
      	<label class="control-label col-sm-1 text-center" id="<%=IDField %>_RNG_LBL" style="display:none;width: 5.333%;margin-bottom: 0px;">TO</label>
      	<div class="col-md-2 col-sm-3 col-xs-12" id="<%=IDField %>_RNG_BLK" style="display:none"><input type="text" name="<%=IDField %>_TO" id="<%=IDField %>_TO" class="form-control" /></div>
      </div>			
 -->
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
        <label for="<%=SearchFields[n] %>" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%out.print("<"+"%=FieldLabel["+BeanName+"_"+SearchFields[n]+"] %"+">" ) ;%> :</label>
        <div class="col-md-3 col-sm-3 col-xs-12"><input type="text" name="<%=SearchFields[n] %>" id="<%=SearchFields[n] %>" class="form-control" /></div>
      </div>	
<!-- 
      <div class="form-group">
        <label class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%=SearchFields[n] %> :
          <span class="checkbox-custom checkbox-inline checkbox-primary" style="padding-top: 2px;display:none;">&nbsp;<input type="checkbox" name="<%= SearchFields[n] %>_RNG_CHK" id="<%= SearchFields[n] %>_RNG_CHK" onchange="CheckSearchRange('<%= SearchFields[n] %>')"><label for="<%= SearchFields[n] %>_RNG_CHK"></label></span>
        </label>
      	<div class="col-md-1 col-sm-2 col-xs-12" id="<%= SearchFields[n] %>_OPR_BLK"><\%=NumberSearchdroplist.getOperatorList("<%= SearchFields[n] %>_OPERATOR", "<%= SearchFields[n] %>_OPERATOR", "form-control show-tick", "data-plugin='selectpicker'" ) %></div>
      	<span id="<%= SearchFields[n] %>_RNG_XSVIS" class="visible-xs-*">&nbsp;</span>
      	<div class="col-md-2 col-sm-3 col-xs-12"><input type="text" name="<%= SearchFields[n] %>" id="<%= SearchFields[n] %>" class="form-control" /></div>
      	<label class="col-sm-1 control-label blue-grey-600 text-center" id="<%= SearchFields[n] %>_RNG_LBL" style="display:none;width: 5.333%;margin-bottom: 0px;">TO</label>
      	<div class="col-md-2 col-sm-3 col-xs-12" id="<%= SearchFields[n] %>_RNG_BLK" style="display:none"><input type="text" name="<%= SearchFields[n] %>_TO" id="<%= SearchFields[n] %>_TO" class="form-control" /></div>
      </div>	
 -->					
	  <%
		
		break;
		
	  case java.sql.Types.CHAR:
	  case java.sql.Types.VARCHAR:
		case java.sql.Types.NCHAR:
		case java.sql.Types.NVARCHAR:
   %>
<!-- 
      <div class="form-group">
        <label for="<%=SearchFields[n] %>" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%out.print("<"+"%=FieldLabel["+BeanName+"_"+SearchFields[n]+"] %"+">" ) ;%> :</label>
        <div class="col-md-3 col-sm-4 col-xs-12"><input type="text" name="<%=SearchFields[n] %>" id="<%=SearchFields[n] %>" class="form-control" /></div>
      </div>	
 -->
      <div class="form-group">
        <label class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%out.print("<"+"%=FieldLabel["+BeanName+"_"+SearchFields[n]+"] %"+">" ) ;%> :</label>
      	<div class="col-md-2 col-sm-3 col-xs-12"><\%= StringSearchdroplist.getDropList("<%= SearchFields[n] %>_SEARCHTYPE", StringSearch.START, null, "form-control show-tick", "data-plugin='selectpicker'") %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-md-3 col-sm-3 col-xs-12"><input type="text" name="<%= SearchFields[n] %>" id="<%= SearchFields[n] %>" class="form-control" /></div>
      </div>		
		<%
		break;
		
	  case java.sql.Types.DATE:
	 %>
      <div class="form-group">
        <label class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%out.print("<"+"%=FieldLabel["+BeanName+"_"+SearchFields[n]+"] %"+">" ) ;%> :
        <span class="checkbox-custom checkbox-inline checkbox-primary" style="padding-top: 2px;display:none;"><input type="checkbox" name="<%= SearchFields[n] %>_RNG_CHK" id="<%= SearchFields[n] %>_RNG_CHK" onchange="CheckSearchRange('<%= SearchFields[n] %>')"><label for="<%= SearchFields[n] %>_RNG_CHK"></label></span>
      	</label>
      	<div class="col-md-1 col-sm-2 col-xs-12" id="<%=SearchFields[n] %>_OPR_BLK"><\%=NumberSearchdroplist.getOperatorList("<%=SearchFields[n] %>_OPERATOR", "<%=SearchFields[n] %>_OPERATOR", "form-control show-tick", "data-plugin='selectpicker'" ) %></div>
      	<span id="<%= SearchFields[n] %>_RNG_XSVIS" class="visible-xs-*">&nbsp;</span>
      	<div class="col-md-3 col-sm-3 col-xs-12"><div class="input-group input-group-icon"><input type="text" readonly="true" name="<%=SearchFields[n] %>" id="<%=SearchFields[n] %>" class="form-control readonlybg" data-plugin="datepicker"><span class="input-group-addon"><span class="icon fa fa-calendar" aria-hidden="true"></span></span></div></div>
      	<label class="col-sm-1 control-label blue-grey-600 text-center" id="<%=SearchFields[n] %>_RNG_LBL" style="display:none;width: 5.333%;margin-bottom: 0px;">TO</label>
      	<div class="col-md-3 col-sm-3 col-xs-12" id="<%=SearchFields[n] %>_RNG_BLK" style="display:none"><div class="input-group input-group-icon"><input type="text" readonly="true" name="<%=SearchFields[n] %>_TO" id="<%=SearchFields[n] %>_TO" class="form-control readonlybg" data-plugin="datepicker"><span class="input-group-addon"><span class="icon fa fa-calendar" aria-hidden="true"></span></span></div></div>
      </div>
	 <%
	  break;
	
	 case java.sql.Types.TIMESTAMP:
 %>
      <div class="form-group">
        <label class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%out.print("<"+"%=FieldLabel["+BeanName+"_"+SearchFields[n]+"] %"+">" ) ;%> :
        <span class="checkbox-custom checkbox-inline checkbox-primary" style="padding-top: 2px;display:none;"><input type="checkbox" name="<%= SearchFields[n] %>_RNG_CHK" id="<%= SearchFields[n] %>_RNG_CHK" onchange="CheckSearchRange('<%= SearchFields[n] %>')"><label for="<%= SearchFields[n] %>_RNG_CHK"></label></span>
      	</label>
      	<div class="col-md-1 col-sm-2 col-xs-12" id="<%=SearchFields[n] %>_OPR_BLK"><\%=NumberSearchdroplist.getOperatorList("<%=SearchFields[n] %>_OPERATOR", "<%=SearchFields[n] %>_OPERATOR", "form-control show-tick", "data-plugin='selectpicker'" ) %></div>
      	<span id="<%=SearchFields[n] %>_RNG_XSVIS" class="visible-xs-*">&nbsp;</span>
      	<div class="col-md-3 col-sm-3 col-xs-12"><div class="input-group input-group-icon"><input type="text" name="<%=SearchFields[n] %>" id="<%=SearchFields[n] %>" class="form-control datetimepicker readonlybg"><span class="input-group-addon"><span class="icon fa fa-calendar" aria-hidden="true"></span></span></div></div>
      	<label class="col-sm-1 control-label blue-grey-600 text-center" id="<%=SearchFields[n] %>_RNG_LBL" style="display:none;width: 5.333%;margin-bottom: 0px;">TO</label>
      	<div class="col-md-3 col-sm-3 col-xs-12" id="<%=SearchFields[n] %>_RNG_BLK" style="display:none"><div class="input-group input-group-icon"><input type="text" name="<%=SearchFields[n] %>_TO" id="<%=SearchFields[n] %>_TO" class="form-control datetimepicker readonlybg"><span class="input-group-addon"><span class="icon fa fa-calendar" aria-hidden="true"></span></span></div></div>
      </div>
 <%	 
	 break;
	 
	 default:
  %> 
      <div class="form-group">
        <label for="<%=SearchFields[n] %>" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%out.print("<"+"%=FieldLabel["+BeanName+"_"+SearchFields[n]+"] %"+">" ) ;%> :</label>
        <div class="col-md-3 col-sm-4 col-xs-12"><input type="text" name="<%=SearchFields[n] %>" id="<%=SearchFields[n] %>" class="form-control" /></div>
      </div>	
<%	 
	 break;

	} // end case switch(nSerachFieldType)
	
	
} // end for loop
%>

      <div class="form-group">
        <label for="OrderBy" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600">Sort By :</label>
        <div class="col-sm-2">
      	  <select name="OrderBy" id="OrderBy" class="form-control show-tick" data-plugin="selectpicker">
					<option selected="selected" value="<%=IDField %>" ><%=IDField %></option><% for(n=0 ; SearchFields!=null && n<SearchFields.length ; n++){ %>
      		  <option value="<%=SearchFields[n] %>" ><%out.print("<"+"%=FieldLabel["+BeanName+"_"+SearchFields[n]+"] %"+">" ) ;%></option><% } %>		
      		</select>
        </div>
				<span class="visible-xs-block" style="line-height: 0.5;">&nbsp;</span>
				<div class="col-sm-3">
				  <div class="radio-custom radio-inline radio-primary" data-original-title="Ascending" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover">
            <input type="radio" name="Sort" id="ASC" value="ASC" checked="checked">
            <label for="ASC"><i aria-hidden="true" class="icon wb-sort-asc" style="font-size: 18px;"></i></label>
          </div>
				  <div class="radio-custom radio-inline radio-primary" style="margin-left: 20px;" data-original-title="Descending" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover">
            <input type="radio" name="Sort" id="DESC" value="DESC">
            <label for="DESC"><i aria-hidden="true" class="icon wb-sort-des" style="font-size: 18px;"></i></label>
          </div>
				</div>
      </div>

      <div class="form-group">
        <label for="ROWS" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600">Records Per Page :</label>
        <div class="col-sm-2"><input type="text" name="ROWS" id="ROWS" class="form-control" value="20" /></div>
      </div>	

</div>

<div class="panel-form-box-footer">
			  <div class="col-md-offset-3 col-sm-offset-4" style="padding-left: 15px;">
          <button type="submit" class="btn btn-primary" title="Submit For Search"><i class="fa fa-search" aria-hidden="true"></i>&nbsp;Search</button>
          <button type="button" class="btn btn-default btn-outline" title="Cancel Search" onclick="history.go(-1);"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
					<!-- <button type="button" class="btn btn-default btn-outline" title="Cancel Search" onclick="NavigateTo('<\%=appPath %>/<%=LoginFolderName %>/index.jsp')"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button> -->
  				<\% if(bAllowAdd == true){ %>
  				<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="NavigateTo('<\%=thisFile %>?Action=New<\%=ForeignKeyParam %><\%=ReturnPathLink %>')"><i aria-hidden="true" class="icon fa fa-plus"></i></button>
  				<\% } %>
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
int RePaginateCount = 0 ;
try
{
  RePaginateCount=java.lang.Integer.parseInt(request.getParameter("RePaginateCount"));
}
catch (NumberFormatException ex )
{
  RePaginateCount=0;
}


  if(QryObj != null )
	{
	  // Query found in session use that instead of making new one.
		
		 WhereClause = QryObj.whereclause ;
		 OrderByClause = QryObj.orderbyclause ;
if(RePaginateCount > 0)
{
     QryObj.offset = 0 ;
		 QryObj.pagesize = RePaginateCount ;
}
else
{
  	 try
		 {
		     QryObj.offset = java.lang.Integer.parseInt( request.getParameter("OFFSET") );
     }
     catch (NumberFormatException ex )
     {
	      
     }
}		 
	
	}
	else // else of  if(QryObj != null )
	{
	  // Query not is session create new one from submitted search form.
		 qStr = new <%=WebApp %>.apputil.appMakeQueryString( request, application );
		 // qStr = new <%=WebApp %>.apputil.appMakeQueryString( request, "<%=_psql.getEngineName() %>" );
		 
		 
     QryObj = new com.webapp.login.SearchQuery();
     qStr.setTablename(<%=BeanName %>._tablename);
     // qStr.setOrderByClause(<%=BeanName %>._tablename, String FieldName, true)
     
		 // Old Code: qStr.addNumberParam(<%=BeanName %>._tablename, "<%=IDField %>") ;
	   if(request.getParameter("<%=IDField %>_RNG_CHK") != null)
		 {
		    qStr.addNumberInRangeParam(<%=BeanName %>._tablename, "<%=IDField %>", "<%=IDField %>", "<%=IDField %>_TO")  ;
		 }
		 else
		 {
		    String  <%=IDField %>_OPERATOR = request.getParameter("<%=IDField %>_OPERATOR");
				qStr.addNumberParam(<%=BeanName %>._tablename, "<%=IDField %>", <%=IDField %>_OPERATOR );
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
			 qStr.addNumberParam(<%=BeanName %>._tablename, "<%=ForeignFields[n] %>");  // Foreign Key
    	 <%
	       break;
	       case java.sql.Types.DATE:
	   %>
			 qStr.addCalDateParam(<%=BeanName %>._tablename, "<%=ForeignFields[n] %>" ,"/", "="); // Foreign Key
		  <%
	       break ;
	       case java.sql.Types.CHAR:
	       case java.sql.Types.VARCHAR:
           case java.sql.Types.NCHAR:
           case java.sql.Types.NVARCHAR:
	   %>
			qStr.addStringParam(<%=BeanName %>._tablename, "<%=ForeignFields[n] %>", true);  // Foreign Key
	    <%
	       break;
	       default:
	   %>
			qStr.addStringParam(<%=BeanName %>._tablename, "<%=ForeignFields[n] %>", false);  // Foreign Key
	    <%
	       break;
       } // end switch
    } // end for loop
%>
    // Add  Search Fields 
		/* Hint
		You may use this trick to retain selection in new  form values if new form
		is called from search result page
		if ( qStr.addStringParam(<%=BeanName %>._tablename, "$Field", false) ) QryObj.setKey("$Field" ,request.getParameter("$Field"));
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
	      qStr.addNumberParam(<%=BeanName %>._tablename, "<%=SearchFields[n] %>");
		/*
	   if(request.getParameter("<%=SearchFields[n] %>_RNG_CHK") != null)
		 {
		    qStr.addNumberInRangeParam(<%=BeanName %>._tablename, "<%=SearchFields[n] %>", "<%=SearchFields[n] %>", "<%=SearchFields[n] %>_TO")  ;
		 }
		 else
		 {
		    String  <%=SearchFields[n] %>_OPERATOR = request.getParameter("<%=SearchFields[n] %>_OPERATOR");
				qStr.addNumberParam(<%=BeanName %>._tablename, "<%=SearchFields[n] %>", <%=SearchFields[n] %>_OPERATOR );
		 }
		 */
 	 // For multiple selection select drop list use: qStr.addMultiSelectParam("<%=SearchFields[n] %>", false );
	<%
	break;
	case java.sql.Types.DATE:
	 %>
	 // Old Code: qStr.addCalDateParam(<%=BeanName %>._tablename, "<%=SearchFields[n] %>" ,"/", "="); 
	 // Let date behave like a number
	 	  if(request.getParameter("<%=SearchFields[n] %>_RNG_CHK") != null)
		 {
				qStr.addDateInRange(<%=BeanName %>._tablename, "<%=SearchFields[n] %>", "<%=SearchFields[n] %>" ,"<%=SearchFields[n] %>_TO" );
		 }
		 else
		 {
		    String  <%=SearchFields[n] %>_OPERATOR = request.getParameter("<%=SearchFields[n] %>_OPERATOR");
				qStr.addCalDateParam(<%=BeanName %>._tablename, "<%=SearchFields[n] %>" ,"/", <%=SearchFields[n] %>_OPERATOR);
		 }
	 <%
	break ;
	case java.sql.Types.TIMESTAMP:
	%>
	 // Old Code: qStr.addCalDateTimeParam(<%=BeanName %>._tablename, "<%=SearchFields[n] %>", "="); 
	 // Let dateTime behave like a number
	 	  if(request.getParameter("<%=SearchFields[n] %>_RNG_CHK") != null)
		 {
				qStr.addDateTimeInRange(<%=BeanName %>._tablename, "<%=SearchFields[n] %>", "<%=SearchFields[n] %>" ,"<%=SearchFields[n] %>_TO" );
		 }
		 else
		 {
		    String <%=SearchFields[n] %>_OPERATOR = request.getParameter("<%=SearchFields[n] %>_OPERATOR");
				qStr.addCalDateTimeParam(<%=BeanName %>._tablename, "<%=SearchFields[n] %>", <%=SearchFields[n] %>_OPERATOR);
		 }	
	<% 
	  break; 
	  case java.sql.Types.CHAR:
	  case java.sql.Types.VARCHAR:
		case java.sql.Types.NCHAR:
		case java.sql.Types.NVARCHAR:
	 %>
	 // Old Code: qStr.addStringParam(<%=BeanName %>._tablename, "<%=SearchFields[n] %>", false);
	  short <%=SearchFields[n] %>_SEARCHTYPE = RequestHelper.getShort(request, "<%=SearchFields[n] %>_SEARCHTYPE");
	  qStr.addStringParam(<%=BeanName %>._tablename, "<%=SearchFields[n] %>", <%=SearchFields[n] %>_SEARCHTYPE);
	 // For multiple selection select drop list use: qStr.addMultiSelectParam("<%=SearchFields[n] %>", true );
	
	 <%
	break;
  default:
	 %>
	 qStr.addStringParam(<%=BeanName %>._tablename, "<%=SearchFields[n] %>", false);
	 <%
	break;
}  // end switch 
} // end for
%>
 		 QryObj.jndidsn = "<%=JNDIDSN %>" ;
     QryObj.table = "<%=TableName %>"  ;
		 
		 String Sort = request.getParameter("Sort") ;
	   if(Sort == null ) Sort = "ASC" ;
		  
     QryObj.whereclause = qStr.getWhereClause() ; 
		 QryObj.orderbyclause = qStr.getOrderByClause(<%=BeanName %>._tablename, "OrderBy") + Sort ;
		 QryObj.query = qStr.getSQL() ;
		  
		 WhereClause = QryObj.whereclause ;
		 OrderByClause = QryObj.orderbyclause ;

     QryObj.count = <%=BeanName %>.recordCount(WhereClause); // joinrecordCount(String Join, String JoinTableName, String OnIDField, String WhereClause)
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
<% if(bConfigSMS){ %>
	String WhrParam = "SELECT * FROM `<%=TableName %>` "+ WhereClause + " ";
  String SQLWhrParam = RequestHelper.encodeBase64( WhrParam.getBytes()) ;
  <% }else{ %>
	String WhrParam = RequestHelper.encodeBase64( WhereClause.getBytes()) ;
  <% } %>String RetPath = new String( com.webapp.base64.UrlBase64.encode( ( thisFile+"?Action=Default" ).getBytes() ) );         
%>
<!-- RECORDS FOUND -->

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><% if(!bConfigSMS){ %><\%=PageTitle %> ( <\%=QryObj.count %> )
		<% }else{ %><span class="dropdown">
		<a href="#" id="ResultIconDropdown" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false" aria-hidden="true"><i class="fa fa-th-list iccolor"></i></a>&nbsp;&nbsp;Search Result ( <\%=QryObj.count %> )
  		<\% if(mbSMS && bSMS) { %>
			<ul class="dropdown-menu" aria-labelledby="ResultIconDropdown" role="menu">
  				<li role="presentation"><a href="javascript:void(0)" role="menuitem" onclick="SendBulkSMSToResult('<\%=QryObj.count %>','<\%=SQLWhrParam %>')">Send SMS to Result</a></li>
  		</ul>	
			<\% } %>	
		</span>
		<% } %><a href="<\%=thisFile %>?Action=Search<\%=ForeignKeyParam %><\%=ReturnPathLink %>" class="pull-right" style="text-decoration: none;"><i class='icon fa fa-search iccolor' aria-hidden='true'></i><span class="hidden-xs iccolor" style="font-size: 15px;">Search Again</span></a>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

<!-- Header Pagination-->
<\%@include file="/include-page/master/pagination-header.inc"%>
<!-- END Header Pagination-->
<\% if(bAllowAdd == true){ %>
		<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="NavigateTo('<\%=thisFile %>?Action=New<\%=ForeignKeyParam %><\%=ReturnPathLink %>')"><i aria-hidden="true" class="icon fa fa-plus"></i></button>
<\% } %>
<\% 
if(QryObj.count > 0)  
{ 
%>
<% 
if(bCheckBox)
{ 
%> 
		
<%		
} 
%>
<form action="<\%=thisFile %>" method="post" id="<%=TableName %>_list" accept-charset="UTF-8" >
<input type="hidden" name="Action" value="ProcessChecked" />
<input type="hidden" name="CheckedAction" id="CheckedAction" value="Unknown" />
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %><input type="hidden" name="M" value="<\%=nModuleID %>" /><% } %>
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
%><% if(bDatatablesJSCSS){%>
<div class="table-responsive wd-table-responsive">
<table class="table table-bordered table-striped table-hover Rslt-Act-tbl wdatatable" id="<%=TableName%>_Result_tbl" width="100%" >
<% }else{ %>
<div class="table-responsive">
<table class="table table-bordered table-striped table-hover Rslt-Act-tbl" id="<%=TableName%>_Result_tbl">
<% } %><thead>
<tr><% if(bDatatablesJSCSS){%><!--for hidden column th: class="wd_col_notvisible" --><% } %>
<th><% if(bCheckBox){ %>
<\% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary" data-original-title="Check / Uncheck All" data-trigger="hover" data-placement="right" data-toggle="tooltip" data-container="body"><input type="checkbox" name="<%=TableName%>_Result_checkall" id="<%=TableName%>_Result_checkall"><label></label></span>
<% if(bConfigSMS){ %><\% if(mbSMS && bSMS) { %>&nbsp;&nbsp;<a href="javascript:void(0);" onclick="SendBulkSMS()"><i class="fa fa-envelope-o fa-lg" aria-hidden="true"></i></a><\% } %><% } %><\% } %><% } %>&nbsp;
</th>
<% 
for (n=0 ;ShowFields!=null && n< ShowFields.length ; n++)
{ %><th><%out.print("<"+"%=FieldLabel["+BeanName+"_"+ShowFields[n]+"] %"+">" ) ;%></th>
<% 
} 
%>
<\% if(bAllowUpdate == false && bAllowDelete == false){ %> <\% } else { %>
<th<% if(bDatatablesJSCSS){%> class="text-center"<% }else{ %> class="text-center"<% } %>>
<!-- for multiselect action -->
<button class="btn btn-icon btn-default btn-outline" type="button" style="padding: 5px;display: none;" data-original-title="View" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"><i aria-hidden="true" class="icon wb-info"></i></button>
<\% if(bAllowDelete == true){ %>
<button onclick="DeleteAllChecked()" class="btn btn-icon btn-default btn-outline" type="button" style="padding: 5px;color: #f96868;" data-original-title="Delete All Checked" data-trigger="hover" data-placement="left" data-toggle="tooltip" data-container="body"><i aria-hidden="true" class="icon wb-trash"></i></button>
<\% } %>&nbsp;
</th>
<\% } %>
</tr>
</thead>
<tbody>

<\% 

/** Check for pagination support 
  if pagination is supported by SQL implementation ( LIMIT and OFFSET key words ) 
	than call :  <%=BeanName %>.openTable(WhereClause, OrderByClause, QryObj.pagesize, QryObj.offset  ); 
	and remove while( <%=BeanName %>.skipRow() ){} part of loop.
	This will give much better result that usual openTable(WhereClause, OrderByClause ); method call
	
*/
// joinopenTable(String Join, String JoinTableName, String OnIDField, String WhereClause, String OrderByClause )
<%=BeanName %>.openTable(WhereClause, OrderByClause );  

int n=0;
while(n< QryObj.offset)
{
 n++ ;
 <%=BeanName %>.skipRow();
} 
 n=0;
sno=QryObj.offset;

while(<%=BeanName %>.nextRow() && n < QryObj.pagesize )
{
sno++;
n++;
DelWarning = "Really want to Delete <%=IDField %> : "+<%=BeanName %>.<%=IDField %>+" " ;
// $CHECK
%>
<tr>
<td><% if(bCheckBox){ %>
<\% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary"><input type="checkbox" name="<%=IDField %>" id="<%=IDField %>_<\%=<%=BeanName %>.<%=IDField %> %>"  value="<\%=<%=BeanName %>.<%=IDField %> %>"><label for="<%=IDField %>_<\%=<%=BeanName %>.<%=IDField %> %>"> <\%=sno %></label></span><\% }else{ %>
<\%=sno %><\% } %>
<% } %>
<button onclick="NavigateTo('<\%=thisFile %>?Action=Show&<%=IDField %>=<\%=<%=BeanName %>.<%=IDField %> %><\%=ForeignKeyParam %><\%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon wb-eye" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="View" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button>
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
	 %> <td> <\%=DateTimeHelper.showDateTimePicker(<%=ColVarName %>) %></td> 
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
<\% if(bAllowUpdate == false && bAllowDelete == false){ %> <\% } else { %>
<td class="text-center">
<\% if(bAllowUpdate == true){ %>
<button onclick="NavigateTo('<\%=thisFile %>?Action=Change&<%=IDField %>=<\%=<%=BeanName %>.<%=IDField %> %><\%=ForeignKeyParam %><\%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon fa fa-pencil" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="Edit" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button>
<\% } %>
<\% if(bAllowDelete == true){ %>
<button onclick="AppConfirm('question','Are you sure ?','<\%=thisFile %>?Action=Delete<\%=ForeignKeyParam %><\%=ReturnPathLink %>&<%=IDField %>=<\%=<%=BeanName %>.<%=IDField %> %>','<\%=DelWarning %>')" class="btn btn-pure btn-primary icon fa fa-trash-o" type="button" style="font-size: 20px;padding: 0;margin-left: 12px;" data-original-title="Delete" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button>
<\% } %>
</td>
<\% } %>
</tr>
<\% 
} // end while( <%=BeanName %>.nextRow());
<%=BeanName %>.closeTable();
 %>
</tbody>
</table>
</div>
</form>

<\% if(bAllowFooterPageNavigation == true)
{ 
%>
<!-- Footer Pagination-->
<\% 
if(QryObj.count >= 10 && QryObj.pagesize >= 10 && QryObj.offset < (QryObj.count - QryObj.pagesize)  ) 
{
%>
<!-- Footer Pagination-->
<\%@include file="/include-page/master/pagination-footer.inc"%>
<!-- END Footer Pagination-->
<\%  
} // END if(QryObj.count >= 10 && QryObj.pagesize >= 10 && QryObj.offset < (QryObj.count - QryObj.pagesize)  )
%>
<!-- END Footer Pagination-->

<\% 
} // END if(bAllowFooterPageNavigation == true)
%>

<\% 
}
else // else of if(QryObj.count > 0) 
{
//  Records are not found
%>
<p>&nbsp;</p>
<p align="center" ><big>Records satisfying search criteria not found ! </big></p>

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
<%=BeanName %>.locateRecord(n<%=IDField %>);
DelWarning = "Really want to Delete <%=IDField %> : "+<%=BeanName %>.<%=IDField %>+" " ;
%><% if(bConfigSMS){%>
<!-- umcomment this & put after mobile field value
<\% if(mbSMS && bSMS && <%=BeanName %>.Mobile != null && <%=BeanName %>.Mobile.length()>0) { %>&nbsp;&nbsp;[ <a href="javascript:void(0);" onclick="SendSMS('<\%=<%=BeanName %>.Mobile %>')">SMS</a> ]<\% } %> 
--><% } %>
		<\% if(bAllowAdd == true){ %>
  	<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="NavigateTo('<\%=thisFile %>?Action=New<\%=ForeignKeyParam %><\%=ReturnPathLink %>')"><i aria-hidden="true" class="icon fa fa-plus"></i></button>
  	<\% } %>

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><\%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Back To Result" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="NavigateTo('<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>')" ><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<\% if(bAllowDelete == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Delete" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="AppConfirm('question','Are you sure ?','<\%=thisFile %>?Action=Delete<\%=ForeignKeyParam %><\%=ReturnPathLink %>&<%=IDField %>=<\%=<%=BeanName %>.<%=IDField %> %>','<\%=DelWarning %>')" ><i aria-hidden="true" class="icon wb-trash" style="margin: 0;"></i></button>
		<\% } %>
		<\% if(bAllowUpdate == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;" data-original-title="Edit" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="NavigateTo('<\%=thisFile %>?Action=Change&<%=IDField %>=<\%=<%=BeanName %>.<%=IDField %> %><\%=ForeignKeyParam %><\%=ReturnPathLink %>')"><i aria-hidden="true" class="icon wb-pencil" style="margin: 0;"></i></button>
    <\% } %>
		</h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

<% 
request.setAttribute("RSMD", rsmd);
%><jsp:include page="include-page/show-record-page.jsp" flush="true"><jsp:param name="BeanName" value="<%=BeanName %>" /><jsp:param name="IDField" value="<%=IDField %>" /><jsp:param name="EntityName" value="<%=EntityName %>" /></jsp:include>

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
	<% out.print("<jsp:include page =\"/include-page/js/jfield-js.jsp\" flush=\"true\" />"); %>
  <% out.print("<jsp:include page =\"/include-page/js/bootstrap-select-js.jsp\" flush=\"true\" />"); %>
  <% if(bDateSupport){%><% out.print("<jsp:include page =\"/include-page/js/bootstrap-datepicker-js.jsp\" flush=\"true\" />"); %>
  <% } %><% if(bTimeSupport){%><% out.print("<jsp:include page =\"/include-page/js/bootstrap-clockpicker-js.jsp\" flush=\"true\" />"); %>
  <% } %><% if(bDateTimeJSCSS){%><% out.print("<jsp:include page =\"/include-page/js/bootstrap-datetimepicker-js.jsp\" flush=\"true\" />"); %>
  <% } %><% if(bDatatablesJSCSS){%><% out.print("<jsp:include page =\"/include-page/js/datatables-js.jsp\" flush=\"true\" />"); %>
	<% } %><% if(bConfigSMS){%><% out.print("<jsp:include page =\"/include-page/js/bootstrap-eModal-js.jsp\" flush=\"true\" />"); %>
  <% } %><% if(nManCount > 0){%><% out.println("<jsp:include page=\"/include-page/js/formValidation-js.jsp\" flush=\"true\" />"); %>
	<% }else{ %><% out.println("<!-- /include-page/js/formValidation-js.jsp -->"); %>
	<% } %>
<script>
<\% 
if(MessageText!=null)
{ 
	String Notify = MessageText.replace("\n","<br/>").replace("\r","");
%>
	toastr.success('<\%= Notify %>');
<\% 
} 
%> 

function InitPage()
{
// Do something on page init
}

function GoToBlock()
{
   var obj = document.getElementById("block") ;
   var val = obj.options[obj.selectedIndex].value ;
   var moveto = "<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>&OFFSET="+val ;
   NavigateTo(moveto);
}

function RePaginate()
{
  var nrows = parseInt( $("#RowCount").val() );
	if(isNaN(nrows) || nrows <= 0 )
	{
	  swal({title: '',text: 'Invalid number entered !',type: 'error',confirmButtonText:'OK'})
		return;
	}
	
  var RepaginateURL = "<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>&RePaginateCount="+nrows ;
	NavigateTo(RepaginateURL);
}
<% if(bConfigSMS){%>
function SendSMS(num)
{
var options = {
        url: "<\%=appPath %>/admin/sms/singlesms-POPUP.jsp?MobileNumber="+num,
        title:'<i class="icon fa fa-cogs iccolor" aria-hidden="true"></i>&nbsp;Send SMS',
        size: eModal.size.lg
    };
  eModal.iframe(options)
}

function SendBulkSMSToResult(cnt,sqlwhrcls)
{
		   var options = {
        url: "<\%=appPath %>/admin/sms/bulksmsResult-POPUP.jsp?sql="+sqlwhrcls+"&Count="+cnt+"&Target=Mobile&Refno=<%=IDField %>",
        title:'<i class="icon fa fa-cogs iccolor" aria-hidden="true"></i>&nbsp;Send Bulk SMS',
        size: eModal.size.lg
       };
  		eModal.iframe(options)
}

function SendBulkSMS()
{
     var Base64={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=Base64._utf8_encode(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._keyStr.charAt(s)+this._keyStr.charAt(o)+this._keyStr.charAt(u)+this._keyStr.charAt(a)}return t},decode:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9+/=]/g,"");while(f<e.length){s=this._keyStr.indexOf(e.charAt(f++));o=this._keyStr.indexOf(e.charAt(f++));u=this._keyStr.indexOf(e.charAt(f++));a=this._keyStr.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=Base64._utf8_decode(t);return t},_utf8_encode:function(e){e=e.replace(/\r\n/g,"\n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},_utf8_decode:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}};
		 //var Base64={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(a){var c,d,e,f,g,h,i,b="",j=0;for(a=Base64._utf8_encode(a);j<a.length;)c=a.charCodeAt(j++),d=a.charCodeAt(j++),e=a.charCodeAt(j++),f=c>>2,g=(3&c)<<4|d>>4,h=(15&d)<<2|e>>6,i=63&e,isNaN(d)?h=i=64:isNaN(e)&&(i=64),b=b+this._keyStr.charAt(f)+this._keyStr.charAt(g)+this._keyStr.charAt(h)+this._keyStr.charAt(i);return b},decode:function(a){var c,d,e,f,g,h,i,b="",j=0;for(a=a.replace(/[^A-Za-z0-9\+\/\=]/g,"");j<a.length;)f=this._keyStr.indexOf(a.charAt(j++)),g=this._keyStr.indexOf(a.charAt(j++)),h=this._keyStr.indexOf(a.charAt(j++)),i=this._keyStr.indexOf(a.charAt(j++)),c=f<<2|g>>4,d=(15&g)<<4|h>>2,e=(3&h)<<6|i,b+=String.fromCharCode(c),64!=h&&(b+=String.fromCharCode(d)),64!=i&&(b+=String.fromCharCode(e));return b=Base64._utf8_decode(b)},_utf8_encode:function(a){a=a.replace(/\r\n/g,"\n");for(var b="",c=0;c<a.length;c++){var d=a.charCodeAt(c);d<128?b+=String.fromCharCode(d):d>127&&d<2048?(b+=String.fromCharCode(d>>6|192),b+=String.fromCharCode(63&d|128)):(b+=String.fromCharCode(d>>12|224),b+=String.fromCharCode(d>>6&63|128),b+=String.fromCharCode(63&d|128))}return b},_utf8_decode:function(a){for(var b="",c=0,d=c1=c2=0;c<a.length;)d=a.charCodeAt(c),d<128?(b+=String.fromCharCode(d),c++):d>191&&d<224?(c2=a.charCodeAt(c+1),b+=String.fromCharCode((31&d)<<6|63&c2),c+=2):(c2=a.charCodeAt(c+1),c3=a.charCodeAt(c+2),b+=String.fromCharCode((15&d)<<12|(63&c2)<<6|63&c3),c+=3);return b}};
     
		 var sel_items = $("input[name='<%=IDField %>']").fieldArray();
	   var sel_count = ( sel_items !=null ) ?  sel_items.length: 0 ;

		 if(sel_count==0)
		 {
		   swal({title: '',text: 'You must check at least one item for SMS !',type: 'info',confirmButtonText:'OK'})
			 return false ;
		 }
		 else
		 {
		   var sqlparam = " SELECT * FROM `<%=TableName %>` WHERE `<%=IDField %>` IN ("+sel_items+") ";
		   // Encode the String
       var encodedString = Base64.encode(sqlparam.toString());
		   var options = {
        url: "<\%=appPath %>/admin/sms/bulksms-POPUP.jsp?sql="+encodedString+"&Count="+sel_count+"&Target=Mobile&Refno=<%=IDField %>",
        title:'<i class="icon fa fa-cogs iccolor" aria-hidden="true"></i>&nbsp;Send Bulk SMS',
        size: eModal.size.lg
       };
  		eModal.iframe(options)

		 }
}<% } %><% 
// -JSP-  
if(bCheckBox)  
{ 
%>
<jsp:include page="include-page/checkbox-support.jsp" flush="true">
<jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="IDField" value="<%=IDField %>" /><jsp:param name="DatatablesJSCSS" value="<%=bDatatablesJSCSS %>" />
</jsp:include>
<% 
} // -JSP-  end  if(bCheckBox) 
%>

function CheckSearchRange(search_field)
{  
  var rng_chk = search_field+"_RNG_CHK" ;
	var opr_blk = search_field+"_OPR_BLK" ;
	var rng_blk = search_field+"_RNG_BLK" ;
	var rng_lbl = search_field+"_RNG_LBL" ;
	var rng_xsvis = search_field+"_RNG_XSVIS" ;
	
	if( $("#"+rng_chk).prop("checked") )
	{
	  // Range check box is checked
	  // Show range input and hide operators
		$("#"+rng_blk).show();
		$("#"+rng_lbl).show(); 
		$("#"+opr_blk).hide(); 
		$("#"+rng_xsvis).hide();
	}
	else
	{
	  // Range check box is NOT checked
	  // Hide range input and show operators
		$("#"+rng_blk).hide();
		$("#"+rng_lbl).hide();
		$("#"+opr_blk).show(); 
		$("#"+rng_xsvis).show();
	}

}
<% if(LoginFolderName.equalsIgnoreCase("admin")){ if(bAddCMSSetting){%>
function fetch_Semester(InstituteID,CourseID,ModuleID,Action)
{
	     $.ajax({ 
				url: "<\%=appPath %>/include-page/ajaxpage/get_Semester.jsp?InstituteID="+InstituteID+"&CourseID="+CourseID+"&ModuleID="+ModuleID+"&Action="+Action+" " ,
				type: "GET",
				data: {},
        success: function (response) {
            $('#CMS_SEMESTER_LIST').html(response);
						$('.selectpicker').selectpicker({style:"btn-select",iconBase:"icon",tickIcon:"wb-check"});
				},
        error: function () {
            $('#CMS_SEMESTER_LIST').html('Record Not Found !');
        }
    });
}

function fetch_Course(InstituteID,ModuleID,Action)
{
	     $.ajax({ 
				url: "<\%=appPath %>/include-page/ajaxpage/get_course.jsp?InstituteID="+InstituteID+"&ModuleID="+ModuleID+"&Action="+Action+" ",
				type: "GET",
				data: {},
        success: function (response) {
            $('#CMS_COURSE_LIST').html(response);
						$('.selectpicker').selectpicker({style:"btn-select",iconBase:"icon",tickIcon:"wb-check"});
				},
        error: function () {
            $('#CMS_COURSE_LIST').html('Record Not Found !');
        }
    });
}
<% }} %>
// Initialize jQuery 
$(document).ready(function() {
// Other JQuery initialization here
<jsp:include page="include-page/form-validation.jsp" flush="true"><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="LoginFolderName" value="<%=LoginFolderName %>" /><jsp:param name="PageType" value="<%=PageType %>" /></jsp:include>

/* Search autocomplete support -Start */
  // JSP Block Start
  <\%  
	if( nAction==SEARCH_RECORDS ) 
	{ 
	%>
	  /* un comment this to enable
		//Css : page="/include-page/css/autocomplete-css.jsp"
		//JS : page="/include-page/js/autocomplete-js.jsp"

	  $('#?FieldID').devbridgeAutocomplete({
    serviceUrl: "<\%=appPath %>/include-page/master/autocomplete-list.jsp",
		params: {table:"<%=TableName %>",field:"?FieldName"} 
	  });
    */
	
	<\% 
	} 
	%>
	// JSP Block End
/* Search autocomplete support -End */

});  
// end of jQuery Initialize block

</script>
	
<% out.print("<jsp:include page =\"/include-page/common/Google-Analytics.jsp\" flush=\"true\" />"); %>
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
