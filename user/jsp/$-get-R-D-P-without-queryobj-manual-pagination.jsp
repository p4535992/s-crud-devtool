<%@ page errorPage = "/errorpage.jsp" %><%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.*" %><%@ page  import="com.webapp.utils.*" %><jsp:useBean id="FieldMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="ManField" scope="session" class="java.util.Vector" /><%
String PageType = "R-D-P";
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
String DriverName= request.getParameter("DriverName");
String BeanName = request.getParameter("BeanName");
String BeanClass = request.getParameter("BeanClass");
String BeanPackage = request.getParameter("BeanPackage");
String JNDIDSN   = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");

char TFirst  = TableName.charAt(0);
if(TFirst > 96) TFirst-=32 ;
String CTableName = TFirst+TableName.substring(1) ;

String IDField  =  request.getParameter("IDField").replace((char)32, '_' );
String IDFieldType = request.getParameter("IDFieldType") ;
String IsAuto = request.getParameter("IsAuto") ;
String WebApp =  request.getParameter("WebApp");
String PageTitle =  request.getParameter("PageTitle") ;
String EntityName = request.getParameter("EntityName") ;
String AltTxt = request.getParameter("AltTxt") ;
boolean bCheckBox = (request.getParameter("CheckBox") !=null )? true : false ;
boolean bDateTimeJSCSS = (request.getParameter("DateTimeJSCSS") !=null )? true : false ;
boolean bDatatablesJSCSS = (request.getParameter("DatatablesJSCSS") !=null )? true : false ;

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
String ContentType =  "application/x-download" ;
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
Boolean bMultiPart=(Boolean)FieldMap.get("multipart_form_upload");
if( bMultiPart!=null && bMultiPart.booleanValue() ) multipart=" enctype=\"multipart/form-data\"" ;

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
%><jsp:include page="include-page/directive-include.jsp" flush="true"><jsp:param name="WebApp" value="<%=WebApp %>" /><jsp:param name="BeanPackage" value="<%=BeanPackage %>" /></jsp:include>
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
%><\% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);
<% if(LoginFolderName.equalsIgnoreCase("admin")){ %>
<%=WebApp %>.LoggedSitemanager LogUsr =  (<%=WebApp %>.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);
<% }else if(LoginFolderName.equalsIgnoreCase("student")) { %>
<%=WebApp %>.LoggedCandidate LogUsr =  (<%=WebApp %>.LoggedCandidate)session.getAttribute("theCandidate") ;
CanBn.locateRecord(LogUsr.CandidateID);
<% }else{ %>
<%=WebApp %>.LoggedSitemanager LogUsr =  (<%=WebApp %>.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);
<% } %><jsp:include page="include-page/formtablefieldlabel.jsp" flush="true"><jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" /><jsp:param name="TableName" value="<%=TableName %>" /><jsp:param name="BeanName" value="<%=BeanName %>" /></jsp:include>

   final int DEFAULT = 0 ;
   final int SEARCH_RESULT = 1;
   final int SHOW_RECORD = 2 ;

final String DEFAULT_ACTION ="Action=Default";
int  default_cmd = DEFAULT ;
int nAction = DEFAULT ;
String PageTitle = null ;

String ActionLink = "Action=Default" ;

String ParamAction = request.getParameter("Action");
if(ParamAction==null)ParamAction = "Result" ;
StringBuffer ForeignKeyParam = new StringBuffer("");

if(ParamAction != null)
{
    if(ParamAction.equalsIgnoreCase("Default")) nAction = DEFAULT  ;
    else if (ParamAction.equalsIgnoreCase("Result")) nAction = SEARCH_RESULT ;
    else if (ParamAction.equalsIgnoreCase("Show")) nAction = SHOW_RECORD ;
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

default_cmd=SEARCH_RESULT ;
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
%>
<% if(bForeignKey)
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
%>
int nOffset = RequestHelper.getInteger(request, "Offset");
int nCount = RequestHelper.getInteger(request, "Count");
int nRows = RequestHelper.getInteger(request, "Rows");

String WhereClause = " ";
String OrderByClause = " ";

String ParamWhere = request.getParameter("WhereClause");
String ParamOrderBy = request.getParameter("OrderByClause");

if(ParamWhere!=null && ParamWhere.length()>0)
{
   WhereClause  = new String( UrlBase64.decode( ParamWhere ));
}

if(ParamOrderBy!=null && ParamOrderBy.length()>0)
{
   OrderByClause = new String( UrlBase64.decode( ParamOrderBy ));
}

if(nRows ==0 ) nRows = 20; // Paginate with 20 rows if not specified
if(nCount == 0) nCount = <%=BeanName  %>.recordCount(WhereClause); // Calculate record count if not specified

// Current Page
int curPgLimit = ( (nOffset+nRows)>nCount )? nCount:(nOffset+nRows) ;
String CurPg = " "+(nOffset+1)+" to "+curPgLimit+" ";

// First Page
String FirstPg = "1 to "+nRows ;

// Last Page
int nMaxNumPgs = nCount / nRows ;
int nTotalPages = (nCount%nRows >0)? nMaxNumPgs+1 : nMaxNumPgs ;

int nLastOffset =  nMaxNumPgs *nRows ;
String LastPg =  " "+( nLastOffset+1)+"  to "+ nCount+" " ;

// Previouse Page
int nPrevOffset = ( (nOffset-nRows)>0 ) ? nOffset-nRows : 0 ;
String PrevPg =  " "+(nPrevOffset+1)+"  to "+(nPrevOffset+nRows)+" " ;

// Next Page
int nNextOffset = ((nOffset+nRows) > nCount )? nLastOffset : (nOffset+nRows) ;
int nNextLimit  = ((nOffset+nRows+nRows) > nCount )? nCount : (nOffset+nRows+nRows) ;
String NextPg =  " "+(nNextOffset+1)+"  to "+nNextLimit+" " ;

// Set the correct page title according to Action Flag
if (nAction==SEARCH_RESULT) PageTitle= "<i class='fa fa-th-list iccolor' aria-hidden='true'></i>&nbsp;&nbsp;List Of Records" ;
else if(nAction==SHOW_RECORD) PageTitle= "<i class='fa fa-bookmark iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Record Detail " ;
else PageTitle="" ;

boolean bRetPath=false;
String ReturnPath = "";
String ReturnPathLink = "";
String ParamReturnPath = request.getParameter("ReturnPath");
if(ParamReturnPath !=null && ParamReturnPath.length()>0)
{	 
	 bRetPath=true;
   ReturnPath = new String( UrlBase64.decode( ParamReturnPath ));
	 ReturnPathLink="&ReturnPath="+ParamReturnPath;
}
else  // Default return path
{
   ReturnPath = appPath+"/<%=LoginFolderName %>/index.jsp" ;
}

// Chain additional parameter if needed

StringBuilder sbChain = new StringBuilder(ReturnPathLink);
if(ParamWhere!=null && ParamWhere.length()>0)
{
  sbChain.append("&WhereClause="+ParamWhere);
}
if(ParamOrderBy!=null && ParamOrderBy.length()>0)
{
  sbChain.append("&OrderByClause="+ParamOrderBy);
}

/* 
Random number chaining

int nRand = new Random().nextInt() ;
if(nRand <0) nRand= nRand*(-1);
sbChain.append("&Rand="+nRand);
*/
String ParamChain = sbChain.toString();

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
  <% if(bDatatablesJSCSS){%><% out.print("<jsp:include page =\"/include-page/css/datatables-css.jsp\" flush=\"true\" />\r\n"); %><% } %>	
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
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i><%=PageTitle  %></h3>
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
<\% 
if(nAction==SEARCH_RESULT)
{ 
%>

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><\%=PageTitle %>
				<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="NavigateTo('<\%=ReturnPath %>')"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

<\% 
if(nCount > nRows)
{
 %>    <div id="Pagination_Links" style="">
    <table border="1" cellpadding="0" cellspacing="0" summary="" width="100%" id="pagination_table" >
    <tr>
    <td width="12%"><button type="button" value="" onclick="GoToFirstPage()" >|&#x25C4; First Page</button><br/>( <\%=FirstPg %> )</td>
    <td width="13%"><button type="button" value="" onclick="GoToPreviousPage()">&#x25C4; Previous Page</button><br/>( <\%=PrevPg %> )</td>
    <td width="*" align="center">Showing <b><\%=CurPg %></b> of <b><\%=nCount %></b> records. ( <b><\%=nRows %></b> per page,  <b><\%=nTotalPages %></b> pages. ) <br/>
    Go To Page
     <select name="PageOffset" id="PageOffset">
     <\% 
     for(int  n=0; n<nCount; n += nRows)
     { 
        int lim = ( ( n+nRows ) > nCount  )? nCount : ( n+nRows );
     
     %>
     <option value="<\%=n %>">[ <\%= n +1 %> - <\%= lim  %> ]</option>
     <\% 
     } 
     %>
     
     </select> <button type="button" value="" onclick="GoToPage()">Go</button>&nbsp;&nbsp;&nbsp;[<a href="javascript:void(0)" onclick="{ $('#repag_form').slideDown(); }" >Re-paginate</a>]
		 <div id="repag_form" style="display:none">
		 Realod page with: <input type="text" name="RowCount" id="RowCount" size="6" value="20" /> records per page. <button type="button" value="" onclick="RePaginate()">Re-Paginate</button>&nbsp;<button type="button" value="" onclick="$('#repag_form').slideUp();">Cancel</button>&nbsp;
		 </div>
    
    
    </td>
    <td width="13%"><button type="button" value=""  onclick="GoToNextPage()" >Next Page &#x25BA;</button><br/>( <\%=NextPg %> )</td>
    <td width="12%"><button type="button" value=""  onclick="GoToLastPage()" >Last Page&#x25BA;|</button><br/>( <\%= LastPg %> )</td>
    </tr>
    </table>
    </div><!-- End div #Pagination_Links -->

<\% 
} // End if if(nCount > nRows)
%>

<br/>


<% if(bDatatablesJSCSS){%>
<div class="table-responsive wd-table-responsive">
<table class="table table-bordered table-striped table-hover Rslt-Act-tbl wdatatable" id="<%=TableName%>_Result_tbl" width="100%" >
<% }else{ %>
<div class="table-responsive">
<table class="table table-bordered table-striped table-hover Rslt-Act-tbl" id="<%=TableName%>_Result_tbl">
<% } %><thead>
<tr><% if(bDatatablesJSCSS){%><!--for hidden column th: class="wd_col_notvisible" --><% } %>
<th>&nbsp;</th>
<% 
for (n=0 ;ShowFields!=null && n< ShowFields.length ; n++)
{ %><th><%out.print("<"+"%=FieldLabel["+BeanName+"_"+ShowFields[n]+"] %"+">" ) ;%></th>
<% 
} 
%>
</tr>
</thead>
<tbody>
<\% 
int sno = nOffset;
<%=BeanName  %>.openTable(WhereClause, OrderByClause, nRows, nOffset ) ; 
while(<%=BeanName  %>.nextRow())
{
sno++;
%>
<tr>
<td><\%=sno %><button onclick="NavigateTo('<\%=thisFile %>?Action=Show&<%=IDField %>=<\%=<%=BeanName %>.<%=IDField %> %><\%=ForeignKeyParam %><\%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon wb-eye" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="View" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button></td>
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
</tr>
<\% 
} // end while( <%=BeanName  %>.nextRow());
<%=BeanName  %>.closeTable();
 %>
</tbody>
</table>
</div>

</div>
</div>

<\% 
} // end if (nAction==SEARCH_RESULT)
%>

<\% if(nAction==SHOW_RECORD)
{
// $CHECK
<%=BeanName  %>.locateRecord(n<%=IDField  %>);
%>

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><\%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Back To Result" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="NavigateTo('<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>')" ><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		</h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

<% 
request.setAttribute("RSMD", rsmd);
%>
<jsp:include page="include-page/show-record-page.jsp" flush="true"><jsp:param name="BeanName" value="<%=BeanName  %>" /><jsp:param name="IDField" value="<%=IDField  %>" /><jsp:param name="EntityName" value="<%=EntityName  %>" /></jsp:include>

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
	<% if(bDatatablesJSCSS){%><% out.print("<jsp:include page =\"/include-page/js/datatables-js.jsp\" flush=\"true\" />"); %><% } %>
<script>

function GoToFirstPage()
{
  var FirstURL = "<\%=thisFile %>?<\%=ActionLink %>&Count=<\%=nCount %>&Rows=<\%=nRows %>&Offset=0<\%=ParamChain %>" ;
	NavigateTo(FirstURL);
}

function GoToPreviousPage()
{
  var PreviousURL = "<\%=thisFile %>?<\%=ActionLink %>&Count=<\%=nCount %>&Rows=<\%=nRows %>&Offset=<\%=nPrevOffset %><\%=ParamChain %>" ;
	NavigateTo(PreviousURL);
}

function GoToNextPage()
{
  var NextURL = "<\%=thisFile %>?<\%=ActionLink %>&Count=<\%=nCount %>&Rows=<\%=nRows %>&Offset=<\%=nNextOffset %><\%=ParamChain %>" ;
	NavigateTo(NextURL);
}

function GoToPage()
{
   var offset = $("#PageOffset").val();
	 var GoToURL = "<\%=thisFile %>?<\%=ActionLink %>&Count=<\%=nCount %>&Rows=<\%=nRows %>&Offset="+offset+"<\%=ParamChain %>" ;
	 NavigateTo(GoToURL);
}

function GoToLastPage()
{
   var LastURL = "<\%=thisFile %>?<\%=ActionLink %>&Count=<\%=nCount %>&Rows=<\%=nRows %>&Offset=<\%=nLastOffset %><\%=ParamChain %>" ;
	 NavigateTo(LastURL);
}

function RePaginate()
{
  var nrows = parseInt( $("#RowCount").val() );
	if(isNaN(nrows) || nrows <= 0 )
	{
	  alert("Invalid record number entered.");
		return;
	}
	
  var RepaginateURL = "<\%=thisFile %>?<\%=ActionLink %>&Count=<\%=nCount %>&Rows="+nrows+"&Offset=0<\%=ParamChain %>" ;
	NavigateTo(RepaginateURL);
}


function InitPage()
{
// Do something on page init
}
// Initialize jQuery 
$(document).ready(function() {

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
