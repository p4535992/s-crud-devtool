<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page contentType="text/plain" %><%@ page import="com.webapp.utils.*" %><%
String JNDIDSN = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");

Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
try 
{

DatabaseMetaData md=conn.getMetaData();
String DriverName=md.getDriverName(); 

if(DriverName.equalsIgnoreCase("MySQL-AB JDBC Driver")|| DriverName.equalsIgnoreCase("MySQL Connector Java") )
{
// MySQL Driver
   
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
 # Create table  <%=TableName %> , remove the old one with same name if exists
 #
 DROP TABLE IF EXISTS `<%=TableName %>` ;
 <%= new_sql %> ;
 <%

}
else
{

%>
Table create SQL retrival not supported. 
<%

}

	
}
finally
{
 	 conn.close();
}

%>

