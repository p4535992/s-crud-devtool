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
  PageTitle=TableName+"_popup" ;
}else if (PageTitle.equalsIgnoreCase("?"))
{
  PageTitle=TableName+"_popup" ; ;
}
final String NEXT = "Next&nbsp;&#x25BA;" ;
final String PREVIOUS = "&#x25C4;&nbsp;Previous" ;
final String FIRST = "First Page";
final String LAST = "Last Page" ;
final String GOTO = "GO &#x25BC;" ;



String ContentType =  "application/x-download" ;
String ContentDisp = "attachment; filename="+PageTitle.replace((char)32, '_' )+".jsp";	
response.setContentType(ContentType);
response.setHeader("Content-Disposition", ContentDisp);
// response.setContentType("text/plain");
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
%><jsp:include page="directive-include.jsp" flush="true"><jsp:param name="WebApp" value="<%=WebApp %>" /><jsp:param name="BeanPackage" value="<%=BeanPackage %>" /></jsp:include><%
  
out.print("<jsp:useBean id=\""+BeanName+"\" scope=\"page\" class=\""+BeanPackage+"."+BeanClass+"\" />\r\n");
 
%><\% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);

String CalendarImage=appPath+"<%=ScriptFolder %>/datepicker/calendar.gif" ;

String Action = request.getParameter("Action") ;
if(Action==null) Action="Search" ; // Other Action: Result 
String Activity = request.getParameter("Activity");
if(Activity==null) Activity="Unknown" ;

final String FIRST = "First | &#x25C4;" ;
final String PREVIOUS = "&#x25C4;&nbsp;Previous" ;
final String GOTO = "GO &#x25BC;" ;
final String NEXT = "Next&nbsp;&#x25BA;" ;
final String LAST = "Last &#x25BA; |" ;

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
<!DOCTYPE html >
<html>
<head>
<title>Search <%=PageTitle %></title>
<link rel="stylesheet" href="<\%=appPath %><\%=ApplicationResource.stylesheet %>" type ="text/css" />
<style type="text/css">
.navtext 
{
    width:300px;
    font-size:10pt;
    font-family:verdana;
    border-width:2px;
    border-style:outset;
    border-color:#006BAE;
    color:black;
    background-color: #ffffcc;
}
.datalist td { font-size:10pt; } 
.datalist ht { font-size:10pt; }
</style>
<script type="text/javascript" src="<\%=appPath %>/scripts/alttxt/alttxt-div.js"></script>
<% 
out.println("<jsp:include page=\""+ScriptFolder+"/jquery/jquery.jsp\" flush=\"true\" />");
out.println("<jsp:include page=\""+ScriptFolder+"/jvalidate/jvalidate.jsp\" flush=\"true\" />");
%>
<script type="text/javascript">
<!--
  function NavigateTo(url)
  { 
    document.location.href = url ;
  }
	
  var goto_block_url = "<\%=thisFile %>";
  function GoToBlock()
  {
      var obj = document.getElementById("block") ;
      var val = obj.options[obj.selectedIndex].value ;
      NavigateTo( goto_block_url+"&Offset="+val);
  }
	
  function CancelSearch()
  {
	
  }
	
  function CloseDlg()
  {
      alert("Close dialog");
  }
  function selectItem(item)
  {
	     if(self==top) 
		   {
		    alert("Selected item: "+item);
				return;
		   }
	    parent.OnItemSelected(item, '<\%=Activity %>');
  }
	
  function	processChecked()
	{
  var chk_cnt = $("input[name='<%=IDField  %>']:checked").length;
	 if(chk_cnt > 0 )
	 {
	    var msg = "Please confirm !\nSumbit  for ("+chk_cnt+") checked items ?" ;
	    if( confirm(msg) ) $('#CHXBOX_LIST_FORM' ).submit();
			/* 
			  process checked items through jQuery script
				$("input[name='$FIELD_ID']:checked").each( function(){
				   this.id // checkbox ID
					 jQuery(this).val() // checkbox value
					 
				
				}) ;
			
			*/
	 }
	 else
	 {
	   alert("Not a single item checked !\nPlease check some items for requested action.");
	 }
	
	}

  function InitPage()
  {
	   InitAltTxt();
  }
	
	
  $(document).ready(function(){
    // {{ Begin Init jQuery 
 
 
    // }} End Init jQuery 
  });

  
	
// -->
</script>
</head>
<body onload="InitPage()">
<\%-- Page Banner if relevent 
<% out.print("<jsp:include page=\"/banner.jsp\" flush=\"true\" />"); %>
 --%>
<div id="maindiv" style="padding:1em;"> <!-- begin main div -->
<\% 
if("Search".equalsIgnoreCase(Action)) 
{
%>
<div class="block">
<table border="0"  width="100%">
<tr>
<td width="70%" align="left"><span class="title">Search <%=PageTitle  %></span></td>
<td width="30%"  align="right"><a href="<\%=ReturnPath %>" onmouseover="writetxt('back_link')" onmouseout="writetxt(0)" ><b>&#x25C4; Go Back</b></a>
<div id="back_link" style="display:none;">Back to <b>main</b> page</div>
</td>
</table>
</div><!-- End title block --> 
<form action="<\%=thisFile %>" method="POST"  accept-charset="UTF-8"  >
<input type="hidden" name="Action" value="Result" />
<input type="hidden" name="Activity" value="<\%=Activity %>" />
<input type="hidden" name="NewQuery" value="TRUE" />
<input type="hidden" name="Offset" value="0" />
<\%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<\%=ParamReturnPath %>" />
<\% 
} 
%>

<table summary="" align="center">
<tr><td><span class="label">Search By ID:</span></td><td><span class="dataitem"><input type="text" name="<%=IDField  %>" size="10" /></span></td></tr>
<% 
for(n=0 ; SearchFields!=null && n<SearchFields.length ; n++)
{ 
 
 if(rsmd.getColumnType(rslt.findColumn(SearchFields[n]))==java.sql.Types.DATE)
 {
 %>
<tr>
   <td><span class="label"><%=SearchFields[n] %>:</span></td>
	 <td><span class="dataitem"><%  out.print("<dtag:DatePicker  CalendarImage=\"<"+"%=CalendarImage %"+">\" ElementName=\""+SearchFields[n]+"\"  />"); %></span> <!-- Set  year range as tag attribute if relevent:-  YearRange="1900:2100"    --></td> 
</tr>
 <%
 }
 else
 {
%> 
<tr><td><span class="label"><%= SearchFields[n] %>:</span></td>
<td><span class="dataitem"><input type="text" name="<%=SearchFields[n] %>"   /></span></td></tr>
<%
 } 
} 
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
 <td><span class="dataitem"><input type="text" name="Rows" size="10"  value="20"/></span></td>
</tr>
</table>
<hr size="1" />

<!-- Begin Search Form Button -->
<div align="center"> 
<button type="submit">Submit For Search</button>&nbsp;&nbsp;&nbsp;
<button type="reset">Reset Form Entry</button>&nbsp;&nbsp;&nbsp;
<!-- $CHECK Look for chain --> 
<button type="button" name="CancelButton" value="" onclick='CancelSearch()'  >Cancel Search</button>&nbsp;&nbsp;&nbsp;
</div>
<!-- End Search Form Button -->

</form>




<\% 
}
else if ("Result".equalsIgnoreCase(Action))
{
  int nOffset = 0;
  int nRows = 0;
  int nCount =0;
  try
  {
	    nOffset=Integer.parseInt(request.getParameter("Offset")) ;
  }catch(NumberFormatException ex)
  {
	    nOffset=0 ;	
  }
	
  try
  {
	    nRows=Integer.parseInt(request.getParameter("Rows")) ;
  }catch(NumberFormatException ex)
  {
	    nRows=20 ;	
  }
	
  try
  {
	   nCount=Integer.parseInt(request.getParameter("Count")) ;
  }catch(NumberFormatException ex)
  {
	   nCount=0 ;	
  }
  String ParamWhereClause = "" ;
  String ParamOrderByClause = "" ; 
  String WhereClause = "" ;
  String OrderByClause = "" ;
	
  String NewQuery = request.getParameter("NewQuery");
  if(NewQuery !=null && "TRUE".equalsIgnoreCase(NewQuery))
  {
	
     String OrderBy= request.getParameter("OrderBy");
     OrderByClause = (OrderBy!=null && OrderBy.length()>0)? " ORDER BY "+OrderBy : " ";
		 
     MakeQueryString qStr = new MakeQueryString( request, application );
     qStr.setTablename(<%=BeanName  %>._tablename);
     qStr.setOrderByClause(OrderByClause);
     qStr.addNumberParam("<%=IDField %>") ;		 
		 
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
%>     qStr.addNumberParam("<%=SearchFields[n] %>");
<%
         	break;
	        case java.sql.Types.DATE:
%>     qStr.addCalDateParam("<%=SearchFields[n] %>" ,"/", "="); 
<%
         break ;
	       case java.sql.Types.CHAR:
	       case java.sql.Types.VARCHAR:
%>     qStr.addStringParam("<%=SearchFields[n] %>", false);
<%
       	break;
        default:
%>     qStr.addStringParam("<%=SearchFields[n] %>", false);
<%
      	break;
     }  // end switch
} // end for
%>
     WhereClause = qStr.getWhereClause();
     ParamWhereClause = new String(UrlBase64.encode(WhereClause.getBytes()));
     ParamOrderByClause= new String(UrlBase64.encode(OrderByClause.getBytes()));
     nOffset=0;
     nCount= <%=BeanName %>.recordCount(WhereClause); 
     try
     {
        nRows = Integer.parseInt(request.getParameter("Rows"));
     }
     catch (NumberFormatException ex )
     {
        nRows = 20;
     }
			
  }
  else
  {
     ParamWhereClause =  request.getParameter("WhereClause") ;
     ParamOrderByClause = request.getParameter("OrderByClause");
     if(ParamWhereClause!=null && ParamWhereClause.length()>0 )WhereClause =  new String( UrlBase64.decode(ParamWhereClause ));
     else WhereClause = "";
     if(OrderByClause!=null && OrderByClause.length()>0 )OrderByClause = new String( UrlBase64.decode(ParamOrderByClause ));
     else  OrderByClause="";
  }
	String QryParam = "?Action=Result&Activity="+Activity+"&Rows="+nRows+"&Count="+nCount+"&WhereClause="+ParamWhereClause+"&OrderByClause="+ParamOrderByClause ;
	
  int LastBlock=0; 
  LastBlock = ( nCount/nRows)* nRows ;
  if(LastBlock == nCount) LastBlock-=nRows ;
	
	
	
  boolean bPriv = false;
  boolean bNext = false;
  if(nOffset >= nRows) bPriv=true;  
  if(nOffset < (nCount - nRows) )bNext=true; 
  int nNextOffset = nOffset+nRows;
  int nPrevOffset = nOffset-nRows;
  if(nPrevOffset < 0) nPrevOffset=0;
  if(nNextOffset >= nCount) nNextOffset= (nCount - nRows);

%>
<div class="block">
<table border="0"  width="100%">
<tr>
<td width="20%" align="left"><span class="title">Search Results</span></td>
<td width="60%" align="center"> 
<a href="<\%=thisFile %>?Action=Search&Activity=<\%=Activity %><\%=ReturnPathLink %>">Search Again</a>
<% 
if(bCheckBox)
{ 
%>
&nbsp;&nbsp;&nbsp;
[ <a href="javascript:void(0)" onclick="{ $('.chkbox').prop('checked', true);   }">Check all</a> | <a href="javascript:void(0)" onclick="{  $('.chkbox').prop('checked', false);    }">Uncheck all</a> | <a href="javascript:void(0)" onclick="processChecked()">Process Checked</a> ]

&nbsp;&nbsp;&nbsp;

<% 
} 
%>

</td>
<td width="20%"  align="right"><a href="<\%=ReturnPath %>" onmouseover="writetxt('back_link')" onmouseout="writetxt(0)" ><b>&#x25C4; Go Back</b></a>
<div id="back_link" style="display:none;">Back to <b>main</b> page</div>
</td>
</table>
</div><!-- End title block --> 
<\% 
if(nCount>nRows)
{ 
%>

<table  border="1px, outset"  cellpadding="4" cellspacing="0" summary="" width="100%" class="datalist">
<tr>
<td width="10%" align="left" ><a href="<\%=thisFile %><\%=QryParam %><\%=ReturnPathLink %>&Offset=0"><%=FIRST %></a></td>
<td width="20%" align="left" > 
<\% 
if(bPriv )
{ 
%>
<a href="<\%=thisFile %><\%=QryParam %><\%=ReturnPathLink %>&Offset=<\%=(nPrevOffset) %>"><%=PREVIOUS %> </a>[<\%=nPrevOffset+1 %> to <\%=nPrevOffset+nRows %> ]
<\% 
}
else
{ 
%>
<%=PREVIOUS %>
<\% 
} 
%>
</td>
<td  width="40%" align="center" >[ Total: <b><\%=nCount %></b> Records ]&nbsp;&nbsp;
<select name="block" id="block">
<\% 
int i=0;
int j = LastBlock/nRows ;
int of = 0 ; 
for(i=0 ;i < j ; i++)
{ 
of = i*nRows ;
%>
<option value="<\%=of %>" <\% if(nOffset==of) out.print("selected=\"selected\""); %> >[ <\%=of+1 %> to <\%=(i+1)*nRows %> ]</option>
<\% 
} 

if( ( j*nRows) < nCount)
{
of = i*nRows ;
%>
<option value="<\%=of %>" <\% if(nOffset==of) out.print("selected=\"selected\""); %> >[ <\%=of+1 %> to <\%=nCount %> ]</option>
<\%
} 
%>
</select>
<button type="button" name="" onclick="GoToBlock()" value=""><%=GOTO %></button>
</td>
<td width="20%" align="right" >
<\% 
if(bNext)
{ 
%>
<a href="<\%=thisFile %><\%=QryParam %><\%=ReturnPathLink %>&Offset=<\%=nNextOffset %>"><%=NEXT %></a> [<\%=nNextOffset+1 %> to <\%=  nNextOffset+nRows %> ]

<\% 
}
else
{ 
%>
<%=NEXT %>
<\% 
} 
%>

</td>
<td width="10%" align="right" >
<a href="<\%=thisFile %><\%=QryParam %><\%=ReturnPathLink %>&Offset=<\%=LastBlock %>"><%=LAST %></a>
</td>
</tr>
</table>

<script type="text/javascript">
<!--
  goto_block_url =  "<\%=thisFile %><\%=QryParam %><\%=ReturnPathLink %>"
// -->
</script>
<\% 
} // end if(nCount>nRows)
%>
<!-- DATA TABLE START -->
<% 
if(bCheckBox)
{ 
%>
<form action="<\%=thisFile %>" id="CHXBOX_LIST_FORM" method="POST"  accept-charset="UTF-8"  >
<input type="hidden" name="Action" value="Process" />
<input type="hidden" name="Activity" value="<\%=Activity %>" />
<input type="hidden" name="Offset" value="<\%=nOffset %>" />
<input type="hidden" name="Rows" value="<\%=nRows %>" />
<input type="hidden" name="Count" value="<\%=nCount %>" />
<input type="hidden" name="WhereClause" value="<\%=ParamWhereClause %>" />
<input type="hidden" name="OrderByClause" value="<\%=ParamOrderByClause %>" />
<\%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<\%=ParamReturnPath %>" />
<\% 
} 
%>
	
<% 
} 
%>



<table border="1" width="100%" cellpadding="4" cellspacing="0" class="datalist" >
<thead>
<tr>
<th valign="top" align="left" >S. No</th><th>Select</th>
<% 
for (n=0 ;ShowFields!=null && n< ShowFields.length ; n++)
{ %><th valign="top" align="left" ><%=ShowFields[n] %></th>
<% 
} 
%>
</tr>
</thead>
<tbody>
<\% 
  int no=0;
  <%=BeanName %>.openTable(WhereClause, OrderByClause ,nRows, nOffset ); 
  while(<%=BeanName %>.nextRow())
  {
     no++;
	 
 %>   <!-- Begin data row -->
    <tr>
      <td><\%=no+nOffset %>&nbsp;
			
			<% 
			if(bCheckBox)
			{ 
			%>
			<input type="checkbox" class="chkbox" name="<%=IDField  %>" value="<\%=<%=BeanName  %>.<%=IDField  %> %>"/>
			<% 
			} 
			%>
			
			</td>
			<td><a href="javascript:void(0)" onclick="selectItem('<\%=<%=BeanName  %>.<%=IDField  %> %>')">Select</a>  </td>
<%
   for (n=0 ; ShowFields!=null && n< ShowFields.length ; n++)
   { 
       ColVarName= BeanName+"."+ShowFields[n].replace((char)32, '_' ) ;
       switch(rsmd.getColumnType(rslt.findColumn(ShowFields[n])))
       {
           case java.sql.Types.DATE:
	    %>      <td valign="top" ><\%=com.webapp.utils.DateHelper.showDate(<%=ColVarName %>) %></td> 
<% 
	break;
	case java.sql.Types.TIMESTAMP:
%>      <td valign="top" > <\%=com.webapp.utils.DateHelper.showDateTime(<%=ColVarName %>) %></td> 
<%
	break;
	case java.sql.Types.TIME:
%>      <td valign="top" ><\%=com.webapp.utils.DateHelper.showTime(<%=ColVarName %>) %></td> 
<%
	break;

	case java.sql.Types.LONGVARBINARY:
	case java.sql.Types.VARBINARY:
	case java.sql.Types.BINARY:
	 %>     <td valign="top" >Binary Data</td>
<%
	break;
	default: %>     <td valign="top" ><\%=<%=ColVarName %> %></td>
<%
     } // end switch
  } // end for
%>
   </tr>
	 <!-- Begin data row -->
<\% 
  }
  <%=BeanName %>.closeTable();
%>
</tbody>
</table>
<!-- DATA TABLE END -->
<% 
if(bCheckBox)
{ 
%>
</form><!-- end form  id="CHXBOX_LIST_FORM" -->
<% 
} 
%>

<\% 
} 
else if("Process".equalsIgnoreCase(Action)) 
{
  
	String ParamWhereClause =  request.getParameter("WhereClause") ;
  String ParamOrderByClause = request.getParameter("OrderByClause");
  String strOffset = request.getParameter("Offset") ;
	String strCount  = request.getParameter("Count") ;
	String strRows   = request.getParameter("Rows") ;
	 
	StringBuilder debug = new StringBuilder("IDs:");
	String[] strItems = request.getParameterValues("<%=IDField  %>");
	int nSelCount = (strItems!=null)? strItems.length:0;
  for(String item:strItems)
	{
	   int nID = Integer.parseInt(item.trim());
		 // do something with this nID
		 debug.append(" "+item+", ");
	}
	
%>
<div id="div1" style="padding:1em">
Processing <\%=nSelCount %> items<br/>
Debug: (Item IDs) : <\%=debug.toString() %><br/>
<form action="<\%=thisFile %>" method="POST"  accept-charset="UTF-8" >
<input type="hidden" name="Action" value="Result" />
<input type="hidden" name="Activity" value="<\%=Activity %>" />
<input type="hidden" name="Offset" value="<\%=strOffset %>" />
<input type="hidden" name="Rows" value="<\%=strRows %>" />
<input type="hidden" name="Count" value="<\%=strCount %>" />
<input type="hidden" name="WhereClause" value="<\%=ParamWhereClause %>" />
<input type="hidden" name="OrderByClause" value="<\%=ParamOrderByClause %>" />
<\%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<\%=ParamReturnPath %>" />
<\% 
} 
%>
<button type="submit">Done</button> ( Back to Search Results)
</form>


</div>


<\% 
}
else
{
%>
<div id="error_block" style="padding:1em;">
<h3 class="error">Request Parameter Error</h3>
</div>
<\% 
} 
%>

</div> <!-- end main div -->
<!-- Div  for  AltTxt DHTML tooltip -->
<div id="navtxt" class="navtext" style="visibility:hidden; position:absolute; top:0px; left:-400px; z-index:10000; padding:10px"></div>
</body>


<%

rslt.close();
stmt.close();
}
catch(Exception e)
{
out.print("Exception: "+e.getMessage());
}
finally
{
 	 conn.close();
}

 %>