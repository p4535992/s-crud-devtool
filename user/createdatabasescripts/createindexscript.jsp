<%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.*, com.webapp.utils.*" %><% 
 %><jsp:useBean id="OverrideMap" scope="session" class="java.util.TreeMap" /><%! 
 
   String EngNames[] = { "UNKNOWN" , "MYSQL", "POSTGRE", "DB2", "MSSQL", "ORACLE", "H2", "SQLITE" } ;
	 
  %><%
  
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 
response.setContentType("text/plain");
String appPath= request.getContextPath();
String thisFile = appPath+request.getServletPath();
String JNDIDSN= request.getParameter("JNDIDSN");
short nSQLEngine = PortableSQL.UNKNOWN ;
try
{
  nSQLEngine =  Short.parseShort(request.getParameter("SQLEngine"));
}catch(NumberFormatException ex){ nSQLEngine = PortableSQL.UNKNOWN ; }

String Database = "";
String DriverName = "";
String[] exld = null ;
Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
com.webapp.utils.PortableSQL psql = new com.webapp.utils.PortableSQL(conn) ;



out.println("/* SQL script creation time: "+DateHelper.showNow()+", Database Engine: "+EngNames[nSQLEngine]+ " */\r\n");
try
{
    DatabaseMetaData md=conn.getMetaData();
    Database=conn.getCatalog();
    DriverName=md.getDriverName(); 

		String DBUseStmt = "" ;
    switch(nSQLEngine)
    {
         case PortableSQL.MYSQL:
				 DBUseStmt = "USE `"+Database+"` ;" ;
				 break;

				 case PortableSQL.POSTGRE:
				 DBUseStmt = "" ;
				 break;
				 
				 case PortableSQL.DB2:
				 DBUseStmt = "" ;
				 break;
				 
				 case PortableSQL.MSSQL:
				 DBUseStmt = "" ;
				 break;
				
				 case PortableSQL.ORACLE:
	            DBUseStmt = "" ;
         break ;
				 
				 case PortableSQL.H2:
				 break;

				 case PortableSQL.SQLITE:
				 break;
   } // end case switch(psql.nSQLEngine)

    switch(psql.getEngine())
    {
         case PortableSQL.MYSQL:
				 break;

				 case PortableSQL.POSTGRE:
				 break;
				 
				 case PortableSQL.DB2:
				 break;
				 
				 case PortableSQL.MSSQL:
				 break;
				
				 case PortableSQL.ORACLE:
               exld =  new String[] { "DR$", 	"WWV_" , "BIN$", "OGIS_" , "SDO_", "AUDIT_ACTIONS", "ODCI_",	"OL$" , 
	                                     "XDB$", "DUAL", "IMPDP_STATS", "KU$NOEXP_TAB", "PLAN_TABLE$", "PSTUBTBL",  "STMT_AUDIT_OPTION_MAP", 
	                                    "SYSTEM_PRIVILEGE_MAP", "TABLE_PRIVILEGE_MAP", "WRI$_ADV_ASA_RECO_DATA" , "DEF$_TEMP$LOB", "HELP"  } ;
         break ;

				 case PortableSQL.H2:
				 break;

				 case PortableSQL.SQLITE:
				     exld =  new String[]{ "sqlite_sequence" };
				 break;
   }  // end case switch(psql.getEngine())
		
		if(DBUseStmt !=null && DBUseStmt.length()>0) out.println(DBUseStmt+"\r\n");
		
    String[] tbl_types = {"TABLE"} ;
    java.sql.ResultSet rsltList = md.getTables(null,null,null,tbl_types );
    int no=0;
    while(rsltList.next())
    { 
	      
		      String TableName = rsltList.getString("TABLE_NAME");	
		      // Check in exlusion list
		      boolean bNotThere = true ;
		     if(exld != null)
		   	 {
		           for(int i=0 ; i< exld.length ; i++) 
			         {
			            if( TableName.startsWith(exld[i]) ) bNotThere = false ;
			         }
		     }
		
		  
	     if(bNotThere)
		   {	
			   no++;
				 String PKField=null; 
				 boolean bAuto = false;
				 
				 java.sql.ResultSet rsPk = md.getPrimaryKeys(Database, null,TableName);
				 if(rsPk !=null )
				 {
				   while(rsPk.next())
					 {
					     PKField = rsPk.getString("COLUMN_NAME");
					 } // end while
				 
				 } 
				 java.sql.Statement stmt = conn.createStatement();
         java.sql.ResultSet rslt = null ;
         rslt = stmt.executeQuery(BeanwizHelper.openTableSQL(conn, TableName)); 
         java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
         int count  = rsmd.getColumnCount();
 	       for(int n = 1 ; n <= count ; n++ )
         {	
	            if( rsmd.isAutoIncrement(n))
							{
							  PKField=rsmd.getColumnName(n) ;
								 
              }
         }// end for(int n = 1 ; n <= count ; n++ ) 
				 
				 // result.getMetaData().isAutoIncrement(i);
				 
				  
					
				   
				 out.println("/* Indexes For Table No: ["+no+"] "+TableName+", Primary Key: "+PKField+"   */\r\n");
				 ResultSet rsltIdx = md.getIndexInfo(Database, null, TableName, false, true);
				   while(rsltIdx.next())
					 {
					   String IdxName = rsltIdx.getString("INDEX_NAME");
						 String IdxCol = rsltIdx.getString("COLUMN_NAME");
						 String IdxScript = null;
						 
						 if(PKField!=null && !( PKField.equalsIgnoreCase(IdxCol)) )
						 {
	
	               switch(nSQLEngine)
                 {
                     case PortableSQL.MYSQL:
				             IdxScript = "ALTER TABLE `"+TableName+"` ADD INDEX `"+IdxName+"` (`"+IdxCol+"`) ;" ;
				             break;

				             case PortableSQL.POSTGRE:
				             IdxScript = "CREATE INDEX  \""+IdxName+"\" ON \""+TableName+"\" ( \""+IdxCol+"\" ) ;" ; 
				             break;
				 
				             case PortableSQL.DB2:
				             IdxScript = "CREATE INDEX  "+IdxName+" ON "+TableName+" ( "+IdxCol+" ) ;" ; 
				             break;
				 
				             case PortableSQL.MSSQL:
				             IdxScript = "CREATE INDEX   "+IdxName+" ON "+TableName+" ( "+IdxCol+" ) ;" ; 
				             break;
				
				             case PortableSQL.ORACLE:
				             IdxScript = "CREATE INDEX  "+IdxName+" ON "+TableName+" ( "+IdxCol+" ) ;" ; 
				             break;
				 
				             case PortableSQL.H2:
				             IdxScript = "CREATE INDEX IF NOT EXISTS  \""+IdxName+"\" ON \""+TableName+"\" ( \""+IdxCol+"\" ) ;" ;
				             break;
				             case PortableSQL.SQLITE:
				             IdxScript = "CREATE INDEX IF NOT EXISTS "+IdxName+" ON "+TableName+" ( "+IdxCol+" ) ;" ; 
				             break;
                 } // end case switch(nSQLEngine)
					        if(IdxScript!=null && IdxScript.length()>0) out.println(IdxScript); 
						 } // if(PKField!=null && !( PKField.equalsIgnoreCase(IdxCol)) )
           } //  end while (rsltIdx.next())	
					 out.println("");	  
       } // end if (bNotThere)

    } // end while while(rsltList.next())
   rsltList.close();		
}
finally
{
   conn.close();
}



%>