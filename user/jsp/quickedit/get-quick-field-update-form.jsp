<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.* " %><%@ page  import="com.webapp.utils.*, com.webapp.jsp.*,com.webapp.db.* " %><jsp:useBean id="FieldMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="ManField" scope="session" class="java.util.Vector" /><%



String appPath = request.getContextPath() ;
String thisFile =appPath+request.getServletPath() ;
String thisFolder = appPath+JSPUtils.jspPageFolder( request );

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

	 String AjaxURL = TableName+"-ajax-quick-update.jsp" ;
	 String JavscriptURL = TableName+"-javascript-quick-update.jsp" ;



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
  

if(bDataOK)
{
   
	 
	  

%>
<!DOCTYPE HTML >
<html>
<head>
<title>Quick Edit Page</title>
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

function GeneratePage(option)
{
     
		 var form_action=$("#page_generate_form").prop("action");
		  
			
     switch(option)
     {
          case 1: /* main page */
             form_action = "<%=thisFolder %>/get-quick-field-update-page.jsp" ;
          break;
  
  				case 2: /* ajax update */
  	         form_action = "<%=thisFolder %>/get-ajax-quick-data-update-page.jsp" ;
          break;
  
  	      case 3: /* javascript page */
             form_action = "<%=thisFolder %>/get-javascript-quick-data-update-page.jsp" ;
          break;
					
					default:
					  form_action = "<%=appPath  %>/debug/formparam.jsp" ;
					break;	
					
     }
		 $("#page_generate_form").prop("action",form_action);
		 
		  var show_cols = $("#ShowColumnNames").val();
		  var upd_cols = $("#UpdateColumnNames").val();
			if(show_cols ==null)
			{
			  alert("Please select columns to show!");
				return;
			}
			if(upd_cols ==null)
			{
			  alert("Please select columns to update!");
				return;
			}
     $("#page_generate_form").submit();

}


// -->
</script>

</head>
<body>
<jsp:include page="/banner.jsp" flush="true" />
<div style="padding:2em;">
<h2>Generate Page For Quick Field Update</h2>
<p><span class="item">Using jQuery In Place Edit Controls</span></p></p>
 
<form action="<%=thisFile %>" method="post" target="_blank" id="page_generate_form">

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
				
				
				<table border="1" cellpadding="6" cellspacing="0" summary="">
        <tr>
				    <td valign="top">
						  <span class="label">Select Dispaly Fields:</span><br/>( Shown not updated )
						
						</td>
						<td valign="top">
						 				 <select name="ShowColumnNames" id="ShowColumnNames" multiple="multiple" class="multi_select">
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
				<tr>
				    <td valign="top">
						  <span class="label">Select Update Fields:</span><br/>( Inline update on click )
						
						</td>
						<td valign="top">
										<select name="UpdateColumnNames" id="UpdateColumnNames" multiple="multiple" class="multi_select">
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
				<tr>
				    <td valign="top">
						   <span class="label">Ok Submit:</span>
						
						</td>
				    <td valign="top">
						 <button type="button"  onclick="GeneratePage(1)">Ok Generate Quick Edit Page</button>&nbsp;&nbsp;( The main quick edit page )<br/><br/>
						 <button type="button"  onclick="GeneratePage(2)">Ok Generate Ajax Update Page</button>&nbsp;&nbsp;&nbsp;( page called by AJAX in main page )<br/><br/>
						 
			      <!--  
						<button type="button"  onclick="GeneratePage(3)">Ok Generate JavaScript Page</button>&nbsp;&nbsp;&nbsp;( javascirpts called in main page )<br/><br/>
            -->
						 
						 </td>
				</tr>
        </table>
				 
				
</form>

</div>
</body>
</html>
<% 
}
else
{ 
%>
<!DOCTYPE html>

<html>
<head>
title>ERROR</title>
</head>
<body>
<h2><span class="error">Data Access Error:</span></h2>
<br/>
Normally this error should not occur, please report this error.
</body>
</html>


<% 
} 
%>
