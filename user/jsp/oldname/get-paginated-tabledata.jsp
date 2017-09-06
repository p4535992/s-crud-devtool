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

String[] ShowFields = request.getParameterValues("ShowFields");
String[] SearchFields = request.getParameterValues("SearchFields");
String[] ForeignFields =  request.getParameterValues("ForeignFields");
StringBuffer FKeys= new StringBuffer("");
boolean bForeignKey = (ForeignFields!=null&&ForeignFields.length>0)?true:false;
boolean bAuto=(IsAuto!=null)?true:false;
boolean bAltTxt = (AltTxt!=null)?true:false;
String OutputFileName = request.getParameter("OutputFileName") ;
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
String ContentDisp = "attachment; filename="+PageTitle.replace((char)32, '_' )+"-paginated-table-data.jsp";	
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
%>
<\%! 

String StrValue(Object ob )
{
    return (ob==null)? "":ob.toString() ;
}
%>
<\% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

int nOffset = RequestHelper.getInteger(request, "Offset");
int nCount = RequestHelper.getInteger(request, "Count");
int nRows = RequestHelper.getInteger(request, "Rows");

String QueryTitle  = "List of records.";
String WhereClause = " ";
String OrderByClause = " ";

String ParamTitle = request.getParameter("QueryTitle");
String ParamWhere = request.getParameter("WhereClause");
String ParamOrderBy = request.getParameter("OrderByClause");


if(ParamTitle!=null && ParamTitle.length()>0)
{
   QueryTitle  = new String( UrlBase64.decode( ParamTitle ));
}

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



String ActionLink = "Action=Show" ;

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
// Chain additional parameter if needed

StringBuilder sbChain = new StringBuilder(ReturnPathLink);
if(ParamTitle!=null && ParamTitle.length()>0)
{
  sbChain.append("&QueryTitle="+ParamTitle);
}
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
<!DOCTYPE html>
<html>
<head>
<title>Paginated table data for: <%=TableName %></title>
<link rel="stylesheet" href="<\%=appPath %><\%=ApplicationResource.stylesheet %>" type ="text/css" />
<% 
out.println("<jsp:include page=\""+ScriptFolder+"/jquery/jquery.jsp\" flush=\"true\" />");
%>

<style type="text/css">

.datalist th {  font-size:10pt; }
.datalist td {  font-size:10pt; }

table
{
 border-collapse: collapse ;
}
th { vertical-align:text-top; }
td { vertical-align:text-top; }

#pagination_table th { padding:0.5em; }
#pagination_table td { padding:0.5em; }

</style>
 

<script type="text/javascript">
 
function NavigateTo(url)
{ 
  document.location.href = url ;
}

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
 
$(document).ready(function(){
 // Init jQuery 
 

 // End init
});

 
 
</script>
</head>
<body  class="main" >
<\%-- Page Banner if relevent 
<% out.print("<jsp:include page=\"/banner.jsp\" flush=\"true\" />"); %>
 --%>
<div class="block"><!-- Header block begin -->
<table width="100%">
<tr>
	<td valign="top" align="left" width="70%" ><span class="title"><\%=QueryTitle  %> </span></td>
	<!-- <td valign="top" align="center" width="30%" >?? </td> -->
	<td valign="top"  align="right" width="30%" > <a href="<\%=ReturnPath %>"> &#x25C4; Go Back</a>&nbsp;&nbsp;( Parent Page )</td>
</tr>
</table>
</div><!-- Header block end -->
<div id="maindiv" style="margin: 1em"><!-- main div begin -->

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


<!-- ### TABLE DATA BEGIN -->
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
<td valign="top" ><\%=sno %>&nbsp;<small>(ID# <\%=<%=BeanName  %>.<%=IDField  %> %> )</small>
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
</tr>
<\% 
} // end while 
<%=BeanName  %>.closeTable();
 %>
</tbody>
 
</table>


</div><!-- main div end -->

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

