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

  
String AjaxURL = TableName+"-ajax-quick-update.jsp" ;
String JavscriptURL = TableName+"-javascript-quick-update.jsp" ;


/* 
String ContentType =  "application/x-download" ;
String ContentDisp = "attachment; filename="+JavscriptURL;	
response.setContentType(ContentType);
response.setHeader("Content-Disposition", ContentDisp);
*/ 

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

String[] UpdateColumnNames = request.getParameterValues("UpdateColumnNames");
	
	
if(bDataOK)
{
%>
<\% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
String WaitCur=appPath+"/scripts/jedit/wait.gif" ;
%>
/* 
   Javascripts for in place edit controls 
   Create seperate editable function for each field

*/

<% 
 int i=0;
 for(String s:UpdateColumnNames)
 { 
  i++ ;
 %>
 /* --------- ( <%=i %> ) Edit Functions For Column:- <%=s %> Start */
 function CreateEdit<%=s %>()
 {
 
   $(".edit_<%=s %>").editable(OnEdit<%=s %>, { 
               indicator : "<img src='<\%=WaitCur %>'>",
               tooltip   : "Please click here to edit the result ...",
               event     : "dblclick",
			         width : '80',
			         height :'20',
			         submit  : "OK",
			         placeholder: "No data ...",
               style  : "display: inline"  
	      });
 
 } // End function - CreateEdit<%=s %>()
 
 
 function OnEdit<%=s %>(value, setting)
 {
      var ID="#"+this.id ;
	    var oldval = $(ID).data("OldVal");
	    var field  = $(ID).data("Field");
	    var idvalue  = $(ID).data("<%=IDField %>");
		  if( value==null && value.length ==0 )
		  {
		       alert("Field value can not be blank!");
			     return oldval ;
		  }
		  
		
		  var ajaxurl = "<%=AjaxURL %>?<%=IDField %>="+idvalue+"&Field="+field+"&Value="+value  ;
		  var retval = oldval ;
	    $.ajax(ajaxurl, {
                 dataType: 'json',
                 async: false
                 }).done(function(data){
					            if(data.Status == "Ok")
    			            {
    			                retval = value ;
    			            }
    			            else
    			            {
    			                 alert("Update error: "+data.Error);
    			            }
					      }).fail(function(data){
					             alert("HTTP Ajax request failed.");
					      });
		  return retval;
 }  // End function - OnEdit<%=s %>(value, setting)
 
/* ------- ( <%=i %> )  Edit Functions For Column :- <%=s %> End */ 
 
 <% 
 } 
 %>

/* Function SetupInPlaceEdit()  will be called from main page */
 
function SetupInPlaceEdit()
{
  /* 
	   Call in place edit creator 
	   functions for each editable column
  */
<% 
 for(String s:UpdateColumnNames)
 { 
%>   CreateEdit<%=s %>();
<% 
 } 
 %>
} // End function  SetupInPlaceEdit() 

<%
}
%>



