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
  
   String ContentType = "application/x-download" ;
   String ContentDisp = "attachment; filename="+TableName+"-data-matrix.jsp";	
   response.setContentType(ContentType);
   response.setHeader("Content-Disposition", ContentDisp);
 
  String MatrixColumnNames[] = request.getParameterValues("MatrixColumnNames");
 
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


%>
<!DOCTYPE html>

<html>
<head>
<title>Data Matrix</title>
<link rel="stylesheet" href="<\%=appPath %><\%=ApplicationResource.stylesheet %>" type ="text/css" />
<style type="text/css">
<!-- 
 
 .datalist th { font-size:10pt ;}
 .datalist td { font-size:10pt ;}
 .value{ color: #61a0bf;}
 
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
<td valign="top" width="40%"><span class="title">Data Matrix</span>
<td valign="top" width="30%"><span class="label">Table:</span> <span class="dataitem"><%=TableName %></span></td> 
<td valign="top" width="30%">&nbsp;</td>
</tr>
</table>
</div>
<div id="maindiv" style="padding:1em;">
<table border="1" cellpadding="6" cellspacing="0" summary="" width="100%">
 <thead><tr><th width="20%"  valign="top"  >Data Field</th><th width="80%"  valign="top"  >Data Matrix</th></tr></thead>
 <tbody>
<\% 
 
GenericQuery genqry = new GenericQuery(ApplicationResource.database, application);
genqry.beginExecute();

 %>
 <% 
 for(int i=0 ; i < MatrixColumnNames.length ; i++)
 { 
   String ColName = MatrixColumnNames[i] ;
 %>
 <tr>
 <td valign="top" ><span class="label"><%=ColName %></span></td>
 <td valign="top" >
       <!-- Inner table start -->
		       <table border="1" summary="" cellpadding="4" cellspacing="0" >
				   <tr>
				   <th  valign="top" >Data Item</th>
				   <th  valign="top" >Record Count</th>
				   </tr>

           <\% 
           String Qry_<%=ColName %> = " SELECT `<%=ColName %>`, COUNT(*) AS `CNT` FROM `<%=TableName %>` "+WhereClause+" GROUP BY `<%=ColName %>` " ;
           genqry.continueExecute(Qry_<%=ColName %>);
           ResultSet rs_<%=ColName %> = genqry.getLastResultSet();
			      
     			 while(rs_<%=ColName %>.next())
           {
              String item = rs_<%=ColName %>.getString(1);
              int count = rs_<%=ColName %>.getInt(2);
              %>
              <tr>
                  <td  valign="top"  ><\%=item %></td>
                  <td  valign="top"  ><\%=count %></td>
              </tr>
	            <\%
           } // end while
		 %>
        </table>
    <!-- Inner table end -->
 </td>
 </tr>
 <% 
 } 
 %> 
 
<\% 
genqry.beginExecute();
%>
</tbody>
</table>

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

</script>
</head>
<body>
<jsp:include page="/banner.jsp" flush="true" />
<div style="padding:1em;">
<h2>Generate Data Matrix Page</h2>



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
						 				 <select name="MatrixColumnNames" multiple="multiple" class="multi_select">
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
