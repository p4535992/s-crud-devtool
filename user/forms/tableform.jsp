<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %>
<%@ page import="com.beanwiz.*, com.webapp.utils.*" %>
<% 
String appPath = request.getContextPath() ;

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Table Form Fields</title>
<link rel="stylesheet" type="text/css" href="<%=appPath %>/style.css" />
</head>
<body>
<% 
String JNDIDSN = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
String query = BeanwizHelper.openTableSQL(conn, TableName);

try 
{
java.sql.Statement stmt = conn.createStatement();
java.sql.ResultSet rslt = stmt.executeQuery(query);
java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
int count  = rsmd.getColumnCount();	
%>
<table summary="" width="100%" border="0">
<%

for(int n = 1 ; n <= count ; n++ )
{	
	 String ColName = rsmd.getColumnName(n) ;
%>
<tr>
<td width="50%" ><%=ColName %>:</td><td width="50%"> <input type="text" name="<%=ColName %>" value="" /></td>
</tr>
<%	 
}// end for(int n = 1 ; n <= count ; n++ ) 
%>
</table>

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
