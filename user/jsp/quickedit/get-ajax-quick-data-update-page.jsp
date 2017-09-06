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
	 
 
String ContentType =  "application/x-download" ;
String ContentDisp = "attachment; filename="+AjaxURL ;	
response.setContentType(ContentType);
response.setHeader("Content-Disposition", ContentDisp);
 


%><\%@ page import="java.sql.*, org.json.simple.* com.webapp.db.*, com.webapp.jsp.*, <%=WebApp %>.*, <%=BeanPackage %>.* " %><% out.print("<jsp:useBean id=\""+BeanName+"\" scope=\"page\" class=\""+BeanPackage+"."+BeanClass+"\" />\r\n"); %><\% 
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

String Field = request.getParameter("Field");
String Value = request.getParameter("Value");
<% 
if("INT".equalsIgnoreCase(IDFieldType))
{ 
%>
// ID field is Integer ( number ) type
int <%=IDField %> = 0;
try
{
  <%=IDField %> = Integer.parseInt(request.getParameter("<%=IDField %>"));
}
catch(NumberFormatException ex)
{ 
   <%=IDField %> = 0;
}
String WhereClause = " WHERE `<%=IDField %>` = "+<%=IDField %>;


<% 
}
else
{
%> // ID field is String ( character data ) type
 String  <%=IDField %> = request.getParameter("<%=IDField %>") ;
 String WhereClause = " WHERE `<%=IDField %>` = '"+<%=IDField %>+"' ";
<% 
} 
%>
 String Status = "Ok";
 String Error = "None" ;

 if(Field!=null && Field.length()>0 && Value!=null && Value.length()>0)
 {
   
    String Query = " UPDATE `<%=TableName %>` SET `"+Field+"` = '"+Value+"' "+WhereClause ;
    try
    {
         <%=BeanName %>.executeUpdate(Query);
         Status = "Ok";
    }
    catch(Exception e)
    {
        Status="Error" ;
        Error="Database error: "+e.getMessage(); ;
    }
 }
 else
 {
   Status="Error" ;
	 Error="Invalid Ajax Request Parameters" ;
 } // end if(Field!=null && Field.length()>0 && Value!=null && Value.length()>0)

 JSONObject jobj = new JSONObject();
 jobj.put("Status" , Status);
 jobj.put("Error", Error);
 out.print(jobj);
%>
