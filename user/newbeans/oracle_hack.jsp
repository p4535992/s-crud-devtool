<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.TableColumn" %><%@ page import="com.beanwiz.*, com.webapp.utils.*" %>\
<%@ page import="oracle.sql.*, oracle.jdbc.* oracle.jdbc.driver.*, oracle.jdbc.pool.*"%>
<% 
String DriverName= request.getParameter("DriverName");
String BeanName = request.getParameter("BeanName");
String BeanClass = request.getParameter("BeanClass");
String BeanPackage = request.getParameter("BeanPackage");
String JNDIDSN   = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String IDField  =  request.getParameter("IDField");
IDField = IDField.trim() ;
String IDFieldType = request.getParameter("IDFieldType") ;

Context env = (Context) new InitialContext().lookup("java:comp/env");
OracleDataSource source = (OracleDataSource) env.lookup(JNDIDSN);

JndiDataSrc objJndi = (JndiDataSrc)application.getAttribute("JNDI:"+JNDIDSN);

String AddSQL = request.getParameter("AddSQL") ;
String auto_index = request.getParameter("count") ;

String webappid = JNDIDSN.substring("jdbc/".length());


 %>
/* BEGIN ORACLE HACK
   There are some non standard hacks required in JDBC for connecting to Oracle DB.
   This is for inserting record and retrieving auto generated primary keys from sequences.
   Since Oracle's implmentation of getGeneratedKeys is buggy, we need some work around 
	 till it is reliably fixed in Oracle DB. This bug is found in our test case of Oracle 10g XE.
	 This bug may not be there in higher versions.
*/
    public boolean _oracle_hack = true ;  // you may turn it off for testing whether the bug is fixed or not
    // oracle specific data source object
    private OracleDataSource _oracle_ds = null ;
	 // variables for oracle continue insert
    private java.sql.Connection  _oracle_conx_insert = null;
    private OraclePreparedStatement  _oracle_stmt_insert = null;
    private String _oracle_add_query = "<%=AddSQL %>  RETURNING \"<%=IDField %>\" INTO ? "  ;
   
    private String _oracle_url = "<%=objJndi.url %>" ;
    private String _oracle_user = "<%= objJndi.user %>" ;
    private String _oracle_password = "<%= objJndi.password %>" ;
	 
    private void init()
		throws java.sql.SQLException
	  {
	     // Create data source if null
			 // Check for JVM properties for url, user, password
       if(_oracle_ds == null )
       {
           String prop_url = System.getProperty("<%=webappid %>.oracle.url");
           String prop_user = System.getProperty("<%=webappid %>.oracle.user");
           String prop_password = System.getProperty("<%=webappid %>.oracle.password");
					 
           if(prop_url != null ) _oracle_url = prop_url ;
           if(prop_user != null ) _oracle_user = prop_user ;
           if(prop_password != null ) _oracle_password = prop_password ;
					 			 
           _oracle_ds = new OracleDataSource();
           _oracle_ds.setURL(_oracle_url);
           _oracle_ds.setUser(_oracle_user);
           _oracle_ds.setPassword(_oracle_password);   
       }

    }
     
   private  boolean addOracleRecord()
	 throws java.sql.SQLException
   {   
	     init();
	     java.sql.Connection oracle_conn_add =  _oracle_ds.getConnection();
       OraclePreparedStatement oracle_stmt_add  = (OraclePreparedStatement) oracle_conn_add.prepareStatement(_oracle_add_query);
       storeData(oracle_stmt_add);
       oracle_stmt_add.registerReturnParameter(<%=auto_index %>, OracleTypes.NUMBER);
       oracle_stmt_add.executeUpdate();
       // get DML return value 
       ResultSet rs_pk = oracle_stmt_add.getReturnResultSet();
       if (rs_pk.next()) _autonumber = rs_pk.getInt(1);
       rs_pk.close();
       oracle_stmt_add.close();
       oracle_conn_add.close();
       return true ;
		 
   }

   // replace public boolean beginInsert()

	 private  boolean beginInsertOracle()
	 throws java.sql.SQLException
   {
	     init();
       _oracle_conx_insert =  _oracle_ds.getConnection();
       _oracle_stmt_insert =  (OraclePreparedStatement) _oracle_conx_insert.prepareStatement(_oracle_add_query); 
       _oracle_stmt_insert.registerReturnParameter(<%=auto_index %>, OracleTypes.NUMBER);
       return true ;
   }
	 
	 // replace : public boolean continueInsert()

	 public boolean continueInsertOracle()
	 throws java.sql.SQLException
	 {
       if( _oracle_stmt_insert == null ) return false ;
       storeData(_oracle_stmt_insert);
       _oracle_stmt_insert.executeUpdate();
       ResultSet rs_pk = _oracle_stmt_insert.getReturnResultSet();
       if (rs_pk.next()) _autonumber = rs_pk.getInt(1);
       rs_pk.close();
			 return true ;
   }
	 

	 // replace public void endInsert()
	 
   public void endInsertOracle()
	 throws java.sql.SQLException
   {
       if(_oracle_stmt_insert != null ) _oracle_stmt_insert.close() ;
       if(_oracle_conx_insert !=null )  _oracle_conx_insert.close() ;
   }
   /* END ORACLE HACK */  