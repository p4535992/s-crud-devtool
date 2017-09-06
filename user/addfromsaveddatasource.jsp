<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="java.sql.*, nu.xom.*" %><%@ page import="com.beanwiz.*, com.webapp.jsp.*, com.webapp.utils.*" %><% 
 %><%@ page import="com.caucho.naming.*, oracle.sql.*, oracle.jdbc.* oracle.jdbc.driver.*, oracle.jdbc.pool.*"%><%@ page import="com.microsoft.sqlserver.jdbc.*"%><% 
 %><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><% 
 
 String appPath = request.getContextPath() ;
 
 String datasource = request.getParameter("datasource");
 String[] parts = datasource.split(":");
 
 String xpathqry = "/dslist/datasource[@wizuser='"+parts[0]+"' and @webappname='"+parts[1]+"' and @jndi='"+parts[2]+"' ]" ;
 
 String xmlfilepath = application.getRealPath("/WEB-INF/saved-jndi-ds.xml");
  File xmlfile = new File(xmlfilepath);
	Element item = null;
	
	boolean bFound = false;
	
	short nSQLEngine = 0 ;
	String SQLHost = "";
	int SQLPort=0;
	String SQLUser = "";
	String SQLPassword = "";
  String SQLDatabase = "";
	String JNDIDSN = "";
	String JDBCUrl = "" ;
	String JDBCDriver = "" ; 
	String Title = "" ;
	String WebAppName = "";
	
	com.mysql.jdbc.jdbc2.optional.MysqlConnectionPoolDataSource vds = null;
  // ? org.postgresql.ds.PGConnectionPoolDataSource  pgds = null ;
  org.postgresql.ds.PGSimpleDataSource pgds = null ;
  com.microsoft.sqlserver.jdbc.SQLServerDataSource mssqlds = null ;
  OracleDataSource ords = null ;
	
	
	
  if(xmlfile.exists())
	{
	  
	     Builder builder = new Builder();
	     Document doc =  builder.build(xmlfile);
			 Nodes list = doc.query(xpathqry);
			 if(list!=null && list.size() > 0 )
			 {
			      item = (Element)list.get(0);
					  if(item!=null)
					  {
						   bFound = true;
							 
					     SQLHost = item.getAttributeValue("dbhost");
	             SQLPort= Integer.parseInt(item.getAttributeValue("dbport"));
	             SQLUser = item.getAttributeValue("user");
	             SQLPassword = item.getAttributeValue("password");
               SQLDatabase = item.getAttributeValue("database");
	             JNDIDSN = item.getAttributeValue("jndi");
	             nSQLEngine = Short.parseShort(item.getAttributeValue("sqlengine"));
							 JDBCUrl = item.getAttributeValue("url");
							 JDBCDriver = item.getAttributeValue("driver");
							 Title = item.getAttributeValue("title");
							 WebAppName = item.getAttributeValue("webappname"); 
						
					  }
			  
			 }
  }
 
 if(bFound)
 {
     String NewContext="java:comp/env/"+JNDIDSN;
		 JndiDataSrc objRm =  new JndiDataSrc() ;
    
		  objRm.sqlengine= nSQLEngine ;
      objRm.database = SQLDatabase;
		  objRm.jndi =  JNDIDSN ; 
      objRm.user = SQLUser ;
      objRm.password = SQLPassword ;
		  objRm.dbhost =  SQLHost;
		  objRm.dbport = ""+SQLPort;
			objRm.title = Title;
			objRm.webappname = WebAppName ;
 
 	    if(nSQLEngine==com.webapp.utils.PortableSQL.MYSQL)
	    {
       	 vds = new com.mysql.jdbc.jdbc2.optional.MysqlConnectionPoolDataSource() ;
         vds.setServerName(SQLHost);
	       vds.setPort(SQLPort)  ;
				 vds.setDatabaseName(SQLDatabase);
         vds.setUser(SQLUser) ;
	       vds.setPassword(SQLPassword) ;
				 Jndi.bindDeep(NewContext,  vds);
				 objRm.url="jdbc:mysql://"+SQLHost+":"+SQLPort+"/"+SQLDatabase+"?characterEncoding=UTF-8";
				 objRm.driver = "com.mysql.jdbc.Driver" ;
		
		  }
		  else if (nSQLEngine==com.webapp.utils.PortableSQL.POSTGRE )
		  {
		     // ?  pgds = new org.postgresql.ds.PGConnectionPoolDataSource();
       	 
				 pgds = new org.postgresql.ds.PGSimpleDataSource(); 
				 pgds.setServerName(SQLHost);
				 pgds.setPortNumber(SQLPort)  ;
         pgds.setDatabaseName(SQLDatabase);
         pgds.setUser(SQLUser) ;
	       pgds.setPassword(SQLPassword) ;
				 Jndi.bindDeep(NewContext,  pgds);
				 objRm.url="jdbc:postgresql://"+SQLHost+":"+SQLPort+"/"+SQLDatabase ;
				 objRm.driver = "org.postgresql.Driver" ;
		  }	
		  else if (nSQLEngine==com.webapp.utils.PortableSQL.MSSQL)
		  {
		     mssqlds = new com.microsoft.sqlserver.jdbc.SQLServerDataSource();
			 	 mssqlds.setServerName(SQLHost) ;
				 mssqlds.setPortNumber(SQLPort) ;
				 mssqlds.setDatabaseName(SQLDatabase) ;
				 mssqlds.setUser(SQLUser);
				 mssqlds.setPassword(SQLPassword);
			   Jndi.bindDeep(NewContext,  mssqlds);
         objRm.url="jdbc:sqlserver://"+SQLHost+":"+SQLPort+";database="+SQLDatabase+";integratedSecurity=true;" ;
				 objRm.driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver" ;
		  }
		  else if (nSQLEngine==com.webapp.utils.PortableSQL.ORACLE)
		  {	  
         String ourl = "jdbc:oracle:thin:@$H:$P:$D" ; // template of url
  	
  			 ourl=ourl.replace("$H", SQLHost );
  			 ourl=ourl.replace("$P", ""+SQLPort);
  			 ourl=ourl.replace("$D", SQLDatabase);
  			 ords = new OracleDataSource();
  			 ords.setURL(ourl);
  		   ords.setUser(SQLUser);
         ords.setPassword(SQLPassword);
  		   Jndi.bindDeep(NewContext,  ords);
  			 objRm.url="jdbc:oracle:thin:@"+SQLHost+":"+SQLPort+":"+SQLDatabase ;
  			 objRm.driver = "oracle.jdbc.driver.OracleDriver" ;
		 }
		 application.setAttribute("JNDI:"+JNDIDSN, objRm );
 }
 
 
 String redirect = appPath+"/user/index.jsp" ;
  response.sendRedirect(response.encodeRedirectURL(redirect));
 
 
 %>
 
