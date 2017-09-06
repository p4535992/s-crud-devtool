<%@ page import="java.util.*"%><%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="org.apache.commons.codec.binary.Hex" %>
<%@ page import="com.beanwiz.*, com.webapp.utils.*" %>
<% 
  response.setContentType("text/plain");
  String appPath= request.getContextPath();
  String JNDIDSN= request.getParameter("JNDIDSN");
  String TableName = request.getParameter("TableName");
  
  String ColDelim = "";
	
	Short nSQLEngine = (short)0;
	try
	{
	   nSQLEngine = Short.parseShort( request.getParameter("SQLEngine"));
	}
	catch(NumberFormatException e)
	{
	   nSQLEngine = (short)0;
	}
	

 

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

PortableSQL pSqlDest = new PortableSQL(nSQLEngine);

StringBuffer AddSQL = new StringBuffer("INSERT INTO "+pSqlDest.colName("`"+TableName+"`")+" ( " );

String[] ColNos =request.getParameterValues("ColNo");

int n = 0;     // variable for iteration
int count=0;   // variable for number of columns


try 
{

   java.sql.Statement stmt = conn.createStatement();
   java.sql.ResultSet rslt = stmt.executeQuery(query);
   java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
   count  = rsmd.getColumnCount();
	 
   
	 TreeMap<Integer, String> delims = new TreeMap <Integer, String>(); 
   int i=0 ;
	 
   if(ColNos!=null && ColNos.length > 0)
	 {
	          i=0 ;
						n=0 ;
            for( String strCol:ColNos )
            {
                 n = Integer.parseInt(strCol.trim());
								 i++;
			 
                %><%@ include file="sqldatatype.inc" %><%			  
        
				 
            // Field should not be autoincrement type
						String clm = pSqlDest.colName("`"+rsmd.getColumnName(n)+"`") ;
	          AddSQL.append(clm+((i < ColNos.length )?", ":" "  ));
        
           } // end for -for( String strCol:ColNos )
   
	 } // end if (ColNos!=null && ColNos.length > 0)
	 
	 
	 
	 
   AddSQL.append(") VALUES ( ");
   int no=0;
	  
	 
	 while(rslt.next())
	 {
				   no++;
					 
					 out.print(AddSQL.toString());
					 if(ColNos!=null && ColNos.length > 0)
	         {
					         i=0;
									 n=0;
							     for( String strCol:ColNos )
                   {
                         n = Integer.parseInt(strCol.trim());
								         i++;
				    		         String delim =   delims.get(new Integer(n));
					               if("#".equals(delim))
										     {
										            // Brinary data type
											          byte[] bts = rslt.getBytes(n);
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
										           // Other non binary data types 
										           String colval = rslt.getString(n);
										           if(colval!=null && colval.contains("'") ) colval = colval.replace("'", "''" );
					                     out.print(delim);
									             out.print((colval!=null)? colval:"");
										           out.print(delim);
									       }
										    if(i < ColNos.length) out.print(", ");
									} // end for -for( String strCol:ColNos )
				 } // end if (ColNos!=null && ColNos.length > 0)
					  
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

