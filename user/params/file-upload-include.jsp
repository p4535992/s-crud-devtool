<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.*, com.webapp.utils.*" %><jsp:useBean id="OverrideMap" scope="session" class="java.util.TreeMap" /><%
String JNDIDSN = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String BeanName = request.getParameter("BeanName");
String Database = null ;
           
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
Database = conn.getCatalog();
if(Database == null )
{
   // Do some stupid guesswork :
	    Database = JNDIDSN.substring(JNDIDSN.indexOf("/",0)+1 );
}


com.webapp.utils.PortableSQL psql = new com.webapp.utils.PortableSQL(conn);
String query = BeanwizHelper.openTableSQL(conn, TableName);
StringBuffer dump = new StringBuffer();	

boolean bFileUpload = false;

try 
{
java.sql.Statement stmt = conn.createStatement();
java.sql.ResultSet rslt = stmt.executeQuery(query);
java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
int count  = rsmd.getColumnCount();	



for(int n = 1 ; n <= count ; n++ )
{	
	 int nJdbcType = rsmd.getColumnType(n);
	 String GetMethod = "";
	 String ColName = rsmd.getColumnName(n) ;
	 String ColTypeName = rsmd.getColumnTypeName(n);
	 String ColVarName = com.beanwiz.ColumnName.colVarName(ColName);
	 boolean bOverride=false ;
	 
	 int ColSize = rsmd.getColumnDisplaySize(n) ;
	 int Precision = rsmd.getPrecision(n);
	 int Scale = rsmd.getScale(n);

	 	 // Check for column type overrride 
	 String col_key = Database+"."+TableName+"."+ColName ;
	 
	 if( OverrideMap !=null && OverrideMap.containsKey(col_key) )
	 {
	    bOverride=true;
			try
			{
			    nJdbcType = Integer.parseInt( (String)OverrideMap.get(col_key) );
			}catch(NumberFormatException ex)
			{
			  // revert back to original type
			   nJdbcType = rsmd.getColumnType(n);
			}
			ColTypeName = ColTypeOverride.typeLabel(nJdbcType) ;
	 }  // end if
	 
	 if( bOverride )
	 {
	  dump.append( "\r\n// Warning: The  column '"+ColName+"' no. [ " + n + " ] is manually overriden, it is  not wizard detected.\r\n" ) ;
   }
	       if( rsmd.isAutoIncrement(n))   dump.append("/* Auto increment column: \r\n");//continue ;
         switch(nJdbcType)
	       {
	          case java.sql.Types.BINARY:
						case java.sql.Types.BLOB:
						case java.sql.Types.VARBINARY:
						case java.sql.Types.LONGVARBINARY:
			        
						   bFileUpload = true;
					 
					  break ;
					  
						default:
					  break ;

	      }		// END switch 
		   if( rsmd.isAutoIncrement(n))   dump.append("*/\r\n");
	    
	}// end for(int n = 1 ; n <= count ; n++ ) 
  rslt.close(); 
  stmt.close();
}
finally
{
 	 conn.close();
}


if(bFileUpload)
{ 
%>
/* 
    // Code to be considered for file upload fields
    ResinFileUpload RsUpload = new ResinFileUpload() ;
    RsUpload.load( application,request,"FileUploadField" ) ;
    byte[] FileBytes = RsUpload.getFileBytes() ;
    String FileName = RsUpload.getFileName();
    String FileExt = RsUpload.getFileExt();
    String MimeType = RsUpload.getMimeType(); // OR  RsUpload.getSafeMimeType();
    int FileSize = RsUpload.getFileSize();
*/

<% 
} 
%>