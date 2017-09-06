<%@ page import="com.beanwiz.*, java.io.*, java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.webapp.utils.*" %><jsp:useBean id="FieldLabelMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="FieldMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="ManField" scope="session" class="java.util.Vector" /><% 
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

String JNDIDSN = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String BeanName = request.getParameter("BeanName");
Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
String query = BeanwizHelper.openTableSQL(conn, TableName);
try {
java.sql.Statement stmt = conn.createStatement();
java.sql.ResultSet rslt = stmt.executeQuery(query);
java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
int count  = rsmd.getColumnCount();	
int n = 0;
StringBuilder sb = new StringBuilder();
StringBuilder sb1 = new StringBuilder();
for(n = 1 ; n <= count ; n++ ){	
int n1 = n-1 ;
String ColName = rsmd.getColumnName(n);
sb.append("\""+FieldLabelMap.get(ColName)+"\"");
sb1.append(""+BeanName+"_"+ColName+"");
sb1.append(" = ");
sb1.append(""+n1+"");
if(n < count)sb.append(", ");
if(n % 5 == 0)sb.append("\n                       ");//23 space
if(n < count)sb1.append(", ");
if(n % 5 == 0)sb1.append("\n                       ");//23 space
}%>
final int <%=sb1 %> ;

String FieldLabel[] = {<%=sb %>} ;
<%  
stmt.close();}
finally{conn.close();}%>