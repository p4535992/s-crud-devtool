<%@ page import="java.util.*"%><%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="org.apache.commons.codec.binary.Hex" %>
<%@ page import="com.beanwiz.*, com.webapp.utils.*" %>
<% 
response.setContentType("text/plain");
String appPath= request.getContextPath();
String JNDIDSN= request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String DriverName= request.getParameter("DriverName");
%>-- Dumpling table: <%=TableName %>
<%

Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();

com.webapp.utils.PortableSQL _psql = new com.webapp.utils.PortableSQL(conn);
DatabaseMetaData md = conn.getMetaData() ;
String Database = conn.getCatalog();
if(Database == null )
{
   // Do some stupid guesswork :
	    Database = JNDIDSN.substring(JNDIDSN.indexOf("/",0)+1 );
}
String query = _psql.SQL(" SELECT * FROM `"+TableName+"` " ) ; 
StringBuffer AddSQL = new StringBuffer("INSERT INTO \""+TableName+"\" ( " );

int n = 0;     // variable for iteration
int count=0;   // variable for number of columns
String AutoColVariable ="";
int nAuto=0;
int nAutoPos = 0;
try 
{

   java.sql.Statement stmt = conn.createStatement();
   java.sql.ResultSet rslt = stmt.executeQuery(query);
   java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
   count  = rsmd.getColumnCount();
   
	 TreeMap<Integer, String> delims = new TreeMap <Integer, String>(); 
   
   
   for( n = 1 ; n <= count ; n++ )
   {
       if( rsmd.isAutoIncrement(n))
       {
           nAuto=1;
					 nAutoPos=n;
					 AutoColVariable = rsmd.getColumnName(n);
       }
			 
       %><%@ include file="sqldatatype.inc" %><%			  
        
				if(!rsmd.getColumnName(n).equals(AutoColVariable) ) 
        {
            // Field should not be autoincrement type
	          AddSQL.append("\""+rsmd.getColumnName(n)+"\""+((n < count)?", ":" "  ));
        }
   } // end for - ( n = 1 ; n <= count ; n++ )

   AddSQL.append(") VALUES ( ");
   int no=0;
	  
	 
	 while(rslt.next())
	 {
				   no++;
					 
					 out.print(AddSQL.toString());
					 
				   for(  int x = 1 ;x <= count ; x++ )
					 {     
					        if( x==nAutoPos ) continue ; 
									String delim =   delims.get(new Integer(x));
					        
								  if(x!=nAutoPos)
									{
									   if("#".equals(delim))
										 {
										       // Brinary DATA
											     byte[] bts = rslt.getBytes(x);
											     if(bts != null )
											     {
											         out.print("X'");
											         out.print(Hex.encodeHexString(bts));
											         out.print("'");
											     }
											     else
											     {
											         out.print("X''");
											     } 
										 }
										 else
										 {
										   // Other data types 
										   String colval = rslt.getString(x);
										   if(colval!=null && colval.contains("'") ) colval = colval.replace("'", "''" );
					             out.print(delim);
									     out.print((colval!=null)? colval:"");
										   out.print(delim);
									   }
										  
									   if(x<count) out.print(", ");
					        }
									  
					 }
				   
					  
					 out.println(" ) ; ");
					 
	  } // end while
				
    
	 
   stmt.close(); 
}
catch(Exception e)
{

}
finally
{
	conn.close();
}
 %>

