<%@ page import="com.beanwiz.*, java.util.*, java.io.* "%>\
<%@ page import="java.sql.*, javax.sql.*,javax.naming.* "%>\
<% 
String appPath = request.getContextPath() ;
String JNDIDSN = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
try 
{
String OpenTableQry = BeanwizHelper.openTableSQL(conn, TableName);


java.sql.Statement stmt = conn.createStatement();
java.sql.ResultSet rslt = stmt.executeQuery(OpenTableQry); 
java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
int count  = rsmd.getColumnCount();	

out.print("var fieldRequired = Array( "); 
for(int n = 1 ; n <= count ; n++ )
{	
	 int sqltype = rsmd.getColumnType(n);
	 String GetMethod = "";
	 String ColName = rsmd.getColumnName(n) ;
   out.print("\""+ColName+"\"" ); if(n<count)out.print(", ");
	 
}// end for(int n = 1 ; n <= count ; n++ ) 
out.println(" );");  
out.print(" var fieldDescription = Array( "); 
for(int n = 1 ; n <= count ; n++ )
{	
	 int sqltype = rsmd.getColumnType(n);
	 String GetMethod = "";
	 String ColName = rsmd.getColumnName(n) ;
   out.print("\""+ColName+"\"" ); if(n<count)out.print(", ");
	 
}// end for(int n = 1 ; n <= count ; n++ ) 
out.println(" );");  	 
	 
  stmt.close();
	
}
finally
{
 	 conn.close();
}

  %>

