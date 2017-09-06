<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page contentType="text/plain" %><%
String JNDIDSN = request.getParameter("JNDIDSN");
java.sql.Timestamp Now = new java.sql.Timestamp(System.currentTimeMillis());
Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
try 
{
  DatabaseMetaData md=conn.getMetaData();
  String DriverName=md.getDriverName(); 
	String DBName = conn.getCatalog();

%>-- Script creation time: <%=com.webapp.utils.DateHelper.showDateTime(Now) %>
CREATE DATABASE  IF NOT EXISTS `<%=DBName %>`   DEFAULT CHARACTER SET utf8  ;

USE `<%=DBName %>`;

<%
 
  String[] tbl_types = {"TABLE"} ;
  java.sql.ResultSet rsltList = md.getTables(null,null,null,tbl_types );
  int no=0;
  while(rsltList.next())
   { 
	  no++;
		String TableName = rsltList.getString("TABLE_NAME");	
		// {{  Begin For Each Table 
		
    java.sql.Statement stmtMySQL = conn.createStatement();
    java.sql.ResultSet rsltMySQL = stmtMySQL.executeQuery(" SHOW CREATE TABLE "+TableName);
    String sql = null ;
	  if(rsltMySQL.next()) sql = rsltMySQL.getString(2) ;
	  else sql = "Data structure retrival error" ;
	  // remove AUTO_INCREMENT=n with regexp  "AUTO_INCREMENT=\\d+"
	  String new_sql = sql.replaceAll("AUTO_INCREMENT=\\d+" , " ");
	  rsltMySQL.close(); 
    stmtMySQL.close();

 %>
--  Table No: <%=no %> Table name:  <%=TableName %> 

DROP TABLE IF EXISTS `<%=TableName %>` ;
<%= new_sql %> ;
<% 		
			
		//  }} End For Each Table
		
		
   } 
   rsltList.close();
  
} // end try
finally
{
 	 conn.close();
}
 %>
 

