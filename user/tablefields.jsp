<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="com.beanwiz.*, com.webapp.utils.*" %>
<% 
String appPath = request.getContextPath() ;
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Table Field Names</title>
<link rel="stylesheet" type="text/css" href="<%=appPath %>/style.css" />
</head>
<body>
<% 
String JNDIDSN = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
com.webapp.utils.PortableSQL psql = new com.webapp.utils.PortableSQL(conn);
String query =  BeanwizHelper.openTableSQL(conn, TableName);

try 
{
java.sql.Statement stmt = conn.createStatement();
java.sql.ResultSet rslt = stmt.executeQuery(query);
java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
int count  = rsmd.getColumnCount();	
StringBuffer dump = new StringBuffer();	
for(int n = 1 ; n <= count ; n++ )
{	
	 int sqltype = rsmd.getColumnType(n);
	 String GetMethod = "";
	 String ColName = rsmd.getColumnName(n) ;
%>
<%=ColName %><br>
<%	 
	 
}// end for(int n = 1 ; n <= count ; n++ ) 
	 
	 
out.print(dump.toString());	 
	
 %>
 
 
<%

  stmt.close();
	
}
finally
{
 	 conn.close();
}

  %>

	

</body>
</html>
