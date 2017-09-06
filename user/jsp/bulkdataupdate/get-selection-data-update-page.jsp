<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.* " %><%@ page  import="com.webapp.utils.*, com.webapp.jsp.*,com.webapp.db.* " %><jsp:useBean id="FieldMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="ManField" scope="session" class="java.util.Vector" /><%


String appPath = request.getContextPath() ;
String thisFile =appPath+request.getServletPath() ;
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

String Action = RequestHelper.paramValue(request, "Action", "Form");

 boolean bDataOK = false;
  int count = 0;
	boolean bDateSupport=false;
	boolean  bTimestampSupport=false;
	String PK = "";
	String Database = "";
	
	ArrayList<String> col_list = new ArrayList<String>();
	TreeMap<String, Integer> col_type = new TreeMap<String, Integer>();
	TreeMap<String, String>  col_type_name = new TreeMap<String, String>();
	
  Context env = (Context) new InitialContext().lookup("java:comp/env");
  DataSource source = (DataSource) env.lookup(JNDIDSN);
  Connection conn = source.getConnection();
  // Database=conn.getCatalog();
  String query = BeanwizHelper.openTableSQL(conn, TableName);
  try 
  {
        java.sql.Statement stmt = conn.createStatement();
        java.sql.ResultSet rslt = stmt.executeQuery(query);
        java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
        count  = rsmd.getColumnCount();
				for(int n = 1 ; n <= count ; n++ )
        {	
	         String ColName = rsmd.getColumnName(n) ;
	         String ColType = rsmd.getColumnTypeName(n);
	         int ColSQLType = rsmd.getColumnType(n);
	         if( rsmd.isAutoIncrement(n))PK=ColName; ;
	         if(ColSQLType==java.sql.Types.DATE) bDateSupport=true;
	         if(ColSQLType==java.sql.Types.TIMESTAMP)bTimestampSupport=true;
					 col_list.add(ColName);
					 col_type.put(ColName, new Integer(ColSQLType));
					 col_type_name.put(ColName, ColType);
			  }
				
				bDataOK = true;
	}catch(Exception e)
	{
	  %>
		<!DOCTYPE html>

       <html>
        <head>
         <title>ERROR</title>
        </head>
        <body>
       <h2><span class="error">Error:</span></h2><br/>
		    <%=  e.getMessage() %>
      </body>
    </html>

		
		
	  <%
	}
	finally
	{
	  conn.close();
	}

if("Generate".equalsIgnoreCase(Action) && bDataOK )
{
 // Page generate Code
   
   String ContentType = "application/x-download" ;
   String ContentDisp = "attachment; filename="+TableName+"-selection-data-update.jsp";	
   response.setContentType(ContentType);
   response.setHeader("Content-Disposition", ContentDisp);
  
  	 String[] UpdateColumnNames = request.getParameterValues("UpdateColumnNames");

 %>
<jsp:include page="../directive-include.jsp" flush="true"><jsp:param name="WebApp" value="<%=WebApp %>" /><jsp:param name="BeanPackage" value="<%=BeanPackage %>" /></jsp:include>
<% out.print("<jsp:useBean id=\""+BeanName+"\" scope=\"page\" class=\""+BeanPackage+"."+BeanClass+"\" />\r\n"); %>
<\% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
String WaitCur=appPath+"/scripts/jedit/wait.gif" ;
String CalendarImage=appPath+"/scripts/datepicker/calendar.gif" ;
String WhereClause = RequestHelper.getBase64param(request, "WhereClause"); 
if(WhereClause == null) WhereClause = " ";

String ParamWhere = request.getParameter("WhereClause");
int nCount = RequestHelper.getInteger(request, "Count" );

String Action = RequestHelper.paramValue(request, "Action", "Form"); // Other action: Update
String UpdateFields[] = { <% for(int i=0; i< UpdateColumnNames.length ; i++) {  if( i>0) out.print(", "); out.print("\""+UpdateColumnNames[i]+"\"" ) ; } %> };


%>
<!DOCTYPE html>

<html>
<head>
<title>Bulk Data Update For Selection</title>
<link rel="stylesheet" href="<\%=appPath %><\%=ApplicationResource.stylesheet %>" type ="text/css" />
<style type="text/css">
<!-- 
 
 .datalist th { font-size:10pt ;}
 .datalist td { font-size:10pt ;}
 
 
-->
</style>
<% 
out.println("<jsp:include page=\"/scripts/jquery/jquery.jsp\" flush=\"true\" />");
out.println("<jsp:include page=\"/scripts/datepicker/datepicker.jsp\" flush=\"true\" />");
out.println("<jsp:include page=\"/scripts/jvalidate/jvalidate.jsp\" flush=\"true\" />");
 %>
<script type="text/javascript">
<!--

function NavigateTo(url)
{ 
    document.location.href = url ;
}


function CheckSubmit()
{
   
	 var chk_cnt = $(".chxbox:checked").length ;
	 if(chk_cnt==0)
	 {
	    alert("Please check some fields for update.");
			return;
	 }
   
	 if( confirm("Please confirm!\nSubmit form for bulk update ? "))
	 {
	   $("#data_update_form").submit();
	 }
	 
}


$(document).ready(function(){
 // {{ Begin Init jQuery 
 
  
 // }} End Init jQuery 
});

// -->
</script>
</head>
<body class="main">
<\%-- Page Banner if relevent 
<% out.print("<jsp:include page=\"/banner.jsp\" flush=\"true\" />"); %>
 --%>
<div class="block"> 
<table border="0" cellpadding="4" cellspacing="0" summary="" width="100%">
<tr>
<td valign="top" width="40%"><span class="title">Update Bulk Records For Selection</span>
<td valign="top" width="30%"><span class="label">Record Count:</span> <span class="dataitem"><\%=nCount %></span></td> 
<td valign="top" width="30%">&nbsp;</td>
</tr>
</table>
</div>
<div id="maindiv" style="padding:1em;">

<\% 
if("Form".equalsIgnoreCase(Action))
{ 
%>
<div align="center"><h3>Please check the fields to include in bulk update.</h3></div>
<form action="<\%=thisFile %>" id="data_update_form" method="post">
<input type="hidden" name="Action" value="Update" />
<input type="hidden" name="Count" value="<\%=nCount %>" />
<input type="hidden" name="WhereClause" value="<\%=ParamWhere %>" />
<table border="1" cellpadding="4" cellspacing="0" summary="" align="center">

  <thead>
	   <th>Data Field</th> <th>Check And Select Value</th>
	</thead>
	<tbody>
	  <%  
		 for(int i=0; i< UpdateColumnNames.length ; i++) 
		 { 
		   String ColVar = UpdateColumnNames[i];
			 ColVar.replace(" ", "_");
		   
		 %>
		 <tr>
		    <td><%=UpdateColumnNames[i] %></td>
				<td><input type="checkbox" class="chxbox" name="CHK_<%=ColVar %>" />&nbsp;&nbsp;&nbsp; 
				 
				    <% 
						 int typ = col_type.get(UpdateColumnNames[i]);
						 switch(typ)
						 {
						   case java.sql.Types.DATE:
               out.print("<dtag:DatePicker ElementName=\""+UpdateColumnNames[i]+"\" "); out.print(" ElementID=\""+UpdateColumnNames[i]+"\" "); out.print(" CalendarImage=\"<"+"%=CalendarImage %"+">\" ");	 out.print("/>"); 
							 break;
							 
							  
							 
							 case java.sql.Types.TIMESTAMP:
							 out.print("<dtag:DateTimePicker ElementName=\""+UpdateColumnNames[i]+"\" "); out.print(" ElementID=\""+UpdateColumnNames[i]+"\" "); out.print(" CalendarImage=\"<"+"%=CalendarImage %"+">\" ");	 out.print("/>"); 
							 break;
							 
							 default:
							 %><input type="text" name="<%=UpdateColumnNames[i] %>"  /><%
							 break;
						 }
						 
						 
						 %>
				
				
				</td>
		 </tr>
		 
		 
		 
		 <% 
		 } 
		 %>
	   <tr>
		     <td>Submit Form</td>
		     <td><button type="button" onclick="CheckSubmit()">Ok Update Data</button>&nbsp;&nbsp;(In checked fields)</td>
		 </tr>
	</tbody>

</table>



</form>


<\% 
}
else if ("Update".equalsIgnoreCase(Action))
{ 
     StringBuilder sbQry = new StringBuilder(" UPDATE `<%=TableName %>` SET ");
     int cnt =0;
     <% 
		 
		 for(int i=0; i< UpdateColumnNames.length ; i++) 
		 {  
		   String ColVar = UpdateColumnNames[i];
		   ColVar.replace(" ", "_");
			 int typ = col_type.get(UpdateColumnNames[i]);
			 
		 %>
      // Check Field:- <%=UpdateColumnNames[i] %>
      if(request.getParameter("CHK_<%=ColVar %>")!=null)
      {
					        <% 
						     typ = col_type.get(UpdateColumnNames[i]);
						     switch(typ)
						     {
						            case java.sql.Types.DATE:
							   %>
               java.sql.Date dt_<%=ColVar %> = DateHelper.requestDate(request, "<%=ColVar %>");
               if(dt_<%=ColVar %> !=null)
               {
                    if(cnt>0) sbQry.append(", ");
                    sbQry.append(" `<%=UpdateColumnNames[i] %>` = '"+dt_<%=ColVar %>.toString()+"' ");
                    cnt++;
               }
                         <%
 							          break;
							 
							          case java.sql.Types.TIMESTAMP:
							         %>
               java.sql.Timestamp ts_<%=ColVar %> = DateHelper.requestDateTime(request, "<%=ColVar %>");
               if(ts_<%=ColVar %> !=null)
               {
                   if(cnt>0) sbQry.append(", ");
                   sbQry.append(" `<%=UpdateColumnNames[i] %>` = '"+ts_<%=ColVar %>.toString()+"' ");
                   cnt++;
               }
                      <%

							           break;
							 
							           default:
							        %>
               String <%=ColVar %> = request.getParameter("<%=ColVar %>");
               if(<%=ColVar %>!=null && <%=ColVar %>.length()>0)
               {
                     if(cnt>0) sbQry.append(", ");
                     sbQry.append(" `<%=UpdateColumnNames[i] %>` = '"+<%=ColVar %>+"' ");
                     cnt++;
               }
               <%
							           break;
					   } // end case
			   %>
       } // End if if(request.getParameter("CHK_<%=ColVar %>")!=null)
				 
				<% 
			 
			 } //  for(int i=0; i< UpdateColumnNames.length ; i++) 
		 
		    
		    %>
		   sbQry.append(WhereClause);
			 
			 
			 
			 

%>
<div style="padding:2em;"> 
<!-- 
Debug: Executed Query: <\%=sbQry.toString() %>
 -->
  <\% 
	if(cnt > 0 )
	{ 
	    <%=BeanName %>.executeUpdate(sbQry.toString());
	%>
	  <b>( <\%=cnt %> ) fields updated in <\%=nCount %> records.</b>
	<\% 
	}
	else
	{ 
	%>
	 <b>Noting updated. possible reason unchecked fields or misssing data.</b>
	
	<\%
	} 
	%>

</div>

<\% 
}
else
{ 
%>

<div id="err" style="padding:2em;">
<h2 class="error">Error</h2>
<p>Request parameter error</p>
</div>

<\% 
}  // end if   ("Update".equalsIgnoreCase(Action))
%>
</div><!-- end div #maindiv -->
</body>
</html> 

<%
}
else if ("Form".equalsIgnoreCase(Action) && bDataOK )
{

%>
<!DOCTYPE HTML >
<html>
<head>
<title>The Bean Wizard</title>
<link rel="stylesheet" type="text/css" href="<%=appPath %>/style.css" />
<jsp:include page="/scripts/jquery/jquery.jsp" flush="true" />
<jsp:include page="/scripts/jmultiselect/jmultiselect.jsp" flush="true" />
<script type="text/javascript">
<!--

$(document).ready(function(){
 // {{ Begin Init jQuery 
 
  $(".multi_select").multipleSelect({width: 300});
 // }} End Init jQuery 
});


// -->
</script>

</head>
<body>
<jsp:include page="/banner.jsp" flush="true" />
<div style="padding:1em;">
<h2>Generate Bulk Data Update Page For Selection</h2>

<form action="<%=thisFile %>" method="post">
<input type="hidden" name="Action" value="Generate" />
				<input type="hidden" name="BeanClass" value="<%=BeanClass%>" />
				<input type="hidden" name="WebApp" value="<%=WebApp%>" />
				<input type="hidden" name="BeanPackage" value="<%=BeanPackage%>" />
				<input type="hidden" name="TableName" value="<%=TableName%>" />
				<input type="hidden" name="IsAuto" value="<%=IsAuto%>" />
				<input type="hidden" name="IDField" value="<%=IDField%>" />
				<input type="hidden" name="AltTxt" value="<%=AltTxt%>" />
				<input type="hidden" name="OutputFileName" value="<%=OutputFileName%>" />
				<input type="hidden" name="PageTitle" value="<%=PageTitle%>" />
				<input type="hidden" name="EntityName" value="<%=EntityName%>" />
				<input type="hidden" name="DriverName" value="<%=DriverName%>" />
				<input type="hidden" name="JNDIDSN" value="<%=JNDIDSN%>" />
				<input type="hidden" name="ScriptFolder" value="<%=ScriptFolder%>" />
				<input type="hidden" name="IDFieldType" value="<%=IDFieldType%>" />
				<input type="hidden" name="BeanName" value="<%=BeanName%>" />
				
				
				<table border="1" cellpadding="6" cellspacing="0" summary="" align="center">
        <tr>
				    <td valign="top">
						  <span class="label">Select Data Update Fields:</span><br/>( Fields to be updated. )
						
						</td>
						<td valign="top">
						 				 <select name="UpdateColumnNames" multiple="multiple" class="multi_select">
				               <% 
					                 for(int i=0; i<col_list.size(); i++)
					                 {
					                    String cname = col_list.get(i);
						                  String ctyp = col_type_name.get(cname);
						               %><option value="<%=cname %>"><%=cname %>&nbsp;&nbsp;[ <%=ctyp %> ]</option>
						               <%
					                 }// end for
					             %>
				   
				             </select>
					  </td>
				  </tr>
					<tr> <td valign="top">Ok Submit:</td>
				       <td><button type="submit" value="">OK Generate Page</button></td>
				  </tr>
        </table>
</form>

</div>
</body>
</html>
<% 
} // end if("Generate".equalsIgnoreCase(Action))
%>

