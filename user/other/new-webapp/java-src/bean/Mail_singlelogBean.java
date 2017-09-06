package com.db.$DATABASE ;
import  java.lang.* ;
import  java.io.* ;
import  java.sql.* ;
import  javax.naming.* ;
import  javax.sql.* ;	
/*
   Code generated on : 17/11/2016 10:23 PM
   The code is customized for MySQL  - MySQL Connector Java driver.
   The JDBC driver version is: mysql-connector-java-5.1.38 ( Revision: fe541c166cec739c74cc727c5da96c1028b4834a )
	 Autonumber column is: MailSingleLogID

*/
public class Mail_singlelogBean
{
	
/* JNDI data source name of database */
	public String _datasource = "jdbc/$DATABASE" ;
/* Table name in SQL databse */
	public String _tablename = "mail_singlelog"; 
/* Special public variable to hold last autonumber value */
	public int _autonumber = 0 ;
	
/* Variable to hold last error */
  public String lasterror=null;	
	
/* Variables corrosponding to table fields - field count: 10 */
	 
    public int MailSingleLogID = 0 ;  
    public java.sql.Timestamp MailDateTime = null ;  
    public String ExecuteBy = "" ;  
    public int ExecutorID = 0 ;  
    public String MailFrom = "" ;  
    public String MailTo = "" ;  
    public String MailSubject = "" ;  
    public String MailText = "" ;  
    public short MailSingleLogFlag = (short)0 ;  
    public String Response = "" ;  



/* Method to set JNDI Datasource name */

public void setDatasource(String jndi_dsn )
{
 _datasource = jndi_dsn ;
}

/* Method to get connection */

private java.sql.Connection Connect()
throws java.sql.SQLException 
{
 java.sql.Connection conx=null;
 try
 {
  javax.naming.Context env = (javax.naming.Context) new InitialContext().lookup("java:comp/env");
  javax.sql.DataSource source = (javax.sql.DataSource) env.lookup(_datasource);
  conx= source.getConnection();
 }
 catch(javax.naming.NamingException ex)
 {
  lasterror=ex.toString();
  conx=null;
 }
 /* Alternate  DriverManager Based Code
  try
	{
	 Class.forName ("com.mysql.jdbc.Driver").newInstance();
   conx = DriverManager.getConnection ("jdbc:mysql://localhost/$DATABASE", "root", "");
  }
	catch(java.lang.InstantiationException ex1){}
	catch(java.lang.ClassNotFoundException ex2){}
	catch(java.lang.IllegalAccessException ec3){}

  */
 return conx ;
}


/* Method to close connecion */

private void Disconnect(java.sql.Connection cnx)
throws java.sql.SQLException 
{
 if(cnx==null) return ;
 cnx.close();
}

/* Copy Fields to other object of same kind */

public void copyTo(com.db.$DATABASE.Mail_singlelogBean other )
{
   other.MailSingleLogID = this.MailSingleLogID ;
   other.MailDateTime = this.MailDateTime ;
   other.ExecuteBy = this.ExecuteBy ;
   other.ExecutorID = this.ExecutorID ;
   other.MailFrom = this.MailFrom ;
   other.MailTo = this.MailTo ;
   other.MailSubject = this.MailSubject ;
   other.MailText = this.MailText ;
   other.MailSingleLogFlag = this.MailSingleLogFlag ;
   other.Response = this.Response ;
	
}

/* Copy Fields from other objects of same kind */

public void copyFrom(com.db.$DATABASE.Mail_singlelogBean other )
{
   this.MailSingleLogID = other.MailSingleLogID ;
   this.MailDateTime = other.MailDateTime ;
   this.ExecuteBy = other.ExecuteBy ;
   this.ExecutorID = other.ExecutorID ;
   this.MailFrom = other.MailFrom ;
   this.MailTo = other.MailTo ;
   this.MailSubject = other.MailSubject ;
   this.MailText = other.MailText ;
   this.MailSingleLogFlag = other.MailSingleLogFlag ;
   this.Response = other.Response ;
	
}

/* Clear field instance variable data */
public void clearData()
{
	this.MailSingleLogID = 0 ; 
	this.MailDateTime = null ; 
	this.ExecuteBy = "" ; 
	this.ExecutorID = 0 ; 
	this.MailFrom = "" ; 
	this.MailTo = "" ; 
	this.MailSubject = "" ; 
	this.MailText = "" ; 
	this.MailSingleLogFlag = (short)0 ; 
	this.Response = "" ; 

} // End Method clearData




/* Move data from class variables to statement fields */
public void storeData(java.sql.PreparedStatement stmt )
throws java.sql.SQLException 
{
stmt.setInt( 1 , MailSingleLogID ) ; 
stmt.setTimestamp( 2 , MailDateTime ) ; 
stmt.setString( 3 , ExecuteBy ) ; 
stmt.setInt( 4 , ExecutorID ) ; 
stmt.setString( 5 , MailFrom ) ; 
stmt.setString( 6 , MailTo ) ; 
stmt.setString( 7 , MailSubject ) ; 
stmt.setString( 8 , MailText ) ; 
stmt.setShort( 9 , MailSingleLogFlag ) ; 
stmt.setString( 10 , Response ) ; 
	
} // end method storeData()
	 
/* Move data from result set fields to class variables */

public void loadData(java.sql.ResultSet rslt)
throws java.sql.SQLException
{
MailSingleLogID = rslt.getInt("MailSingleLogID"); 
MailDateTime = rslt.getTimestamp("MailDateTime"); 
ExecuteBy = rslt.getString("ExecuteBy"); 
ExecutorID = rslt.getInt("ExecutorID"); 
MailFrom = rslt.getString("MailFrom"); 
MailTo = rslt.getString("MailTo"); 
MailSubject = rslt.getString("MailSubject"); 
MailText = rslt.getString("MailText"); 
MailSingleLogFlag = rslt.getShort("MailSingleLogFlag"); 
Response = rslt.getString("Response"); 
	
}// end method loadData();
	 
/* Add new record from class variable */
public boolean addRecord()
throws java.sql.SQLException 
{
 boolean bAdded = false ;
 java.sql.Connection conn = Connect();
 if(conn==null)return false;
 
 try{
    String query_add = " INSERT INTO `mail_singlelog` ( `MailSingleLogID`, `MailDateTime`, `ExecuteBy`, `ExecutorID`, `MailFrom`, `MailTo`, `MailSubject`, `MailText`, `MailSingleLogFlag`, `Response` ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?  ) ";
    java.sql.PreparedStatement stmt_add = conn.prepareStatement(query_add, Statement.RETURN_GENERATED_KEYS);
    // move data from bean variables to prepared statement
    storeData(stmt_add);
    if( stmt_add.executeUpdate() == 1) bAdded = true ;
		
		
    java.sql.ResultSet rs_auto = stmt_add.getGeneratedKeys();
    if (rs_auto.next())  _autonumber = rs_auto.getInt(1);
	  else _autonumber=0;
		rs_auto.close();
		
		
    stmt_add.close();
    }
 finally
    {
      Disconnect(conn) ;
    }
		
     /* 
       If the JDBC driver has detected auto_increment field properly
       than move auto generated key value to that field variable.
     */
     if ( _autonumber > 0 ) MailSingleLogID = _autonumber ;
		 
	  
  return bAdded ;	
} // end method addRecord()
	
	
/* Create and prepare connection for multiple record inserts	 */

private  java.sql.Connection _conn_insert = null;
private  java.sql.PreparedStatement _stmt_insert=null;

public boolean beginInsert()
 throws java.sql.SQLException 
{
  boolean bReady = false ;
  _conn_insert = null;
  _stmt_insert=null;
   _conn_insert = Connect();
  if(_conn_insert==null )return false;
  String query_insert = " INSERT INTO `mail_singlelog` ( `MailSingleLogID`, `MailDateTime`, `ExecuteBy`, `ExecutorID`, `MailFrom`, `MailTo`, `MailSubject`, `MailText`, `MailSingleLogFlag`, `Response` ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?  ) ";
  _stmt_insert = _conn_insert.prepareStatement(query_insert , Statement.RETURN_GENERATED_KEYS);
  if(_stmt_insert != null ) bReady = true ;
  return bReady ;
} // end method beginInsert()

/* Insert record from fields */

public boolean continueInsert()
 throws java.sql.SQLException 
{
  boolean bInsDone=false ;
  if ( _conn_insert == null ||  _stmt_insert == null ) return false ;
  storeData(_stmt_insert);
  if( _stmt_insert.executeUpdate() == 1) bInsDone = true ;
	
   java.sql.ResultSet rs_auto_ins = _stmt_insert.getGeneratedKeys();
   if (rs_auto_ins.next() ) _autonumber = rs_auto_ins.getInt(1);
   else _autonumber=0;
   rs_auto_ins.close();
    /* 
       If the JDBC driver has detected auto_increment field properly
       than move auto generated key value to that field variable.
     */
     if ( _autonumber > 0 ) MailSingleLogID = _autonumber ;

  return bInsDone ;
} // end method continueInsert()

/* Close connection for  multiple inserts */
public void endInsert()
 throws java.sql.SQLException
{
  if(_stmt_insert!=null)_stmt_insert.close();
  Disconnect(_conn_insert) ;
  _conn_insert = null;
  _stmt_insert=null;
} // end method endInsert	 
	 
	 
/* Update the - argument record- from field variables */
public boolean updateRecord(int update_MailSingleLogID)
	throws java.sql.SQLException 
{

  boolean bUpdated = false ;
  java.sql.Connection conn = Connect();
	if(conn==null) return false ;
  try
	  {
    String query_update = " UPDATE `mail_singlelog` SET `MailSingleLogID` = ?, `MailDateTime` = ?, `ExecuteBy` = ?, `ExecutorID` = ?, `MailFrom` = ?, `MailTo` = ?, `MailSubject` = ?, `MailText` = ?, `MailSingleLogFlag` = ?, `Response` = ?  WHERE `mail_singlelog`.`MailSingleLogID` = "+update_MailSingleLogID+" " ;
    java.sql.PreparedStatement stmt_update = conn.prepareStatement(query_update);
    // move data from bean variables to prepared statement
    storeData(stmt_update);
    if( stmt_update.executeUpdate()==1 ) bUpdated = true ;
    stmt_update.close();
    }
   finally
   {
      Disconnect(conn);
   }
   return bUpdated ;
} // end method updateRecord()

/* Delete the - argument record- from table */
public boolean deleteRecord(int delete_MailSingleLogID)
throws java.sql.SQLException 
{

 boolean bDeleted = false ;
 java.sql.Connection conn =  Connect();
 if(conn==null) return false ;
 try{
    String query_del = "  DELETE FROM `mail_singlelog` WHERE `mail_singlelog`.`MailSingleLogID` = "+delete_MailSingleLogID+" " ;
    java.sql.Statement  stmt_del = conn.createStatement();
		if( stmt_del.executeUpdate(query_del) >0)bDeleted = true ; 
    stmt_del.close();
    }
  finally
    {
       Disconnect(conn);
    }
 return bDeleted ;
} // end method deleteRecord()

/* locate  the - argument record-  */
public boolean  locateRecord(int locate_MailSingleLogID )
throws java.sql.SQLException 
{

 boolean bLocated = false ;
 java.sql.Connection conn = Connect();
 if(conn==null)return false;
 try{
    String query_locate = "  SELECT *  FROM `mail_singlelog` WHERE  `mail_singlelog`.`MailSingleLogID` = "+locate_MailSingleLogID+" " ;
    java.sql.Statement  stmt_locate = conn.createStatement();
    java.sql.ResultSet rslt_locate = stmt_locate.executeQuery(query_locate); 
    if( rslt_locate.next())
      {
        bLocated = true ;
        loadData(rslt_locate);
      } 
    stmt_locate.close();
    }
   finally
    {
      Disconnect(conn);
    }
  return bLocated ;
} // end method locateRecord();



/* locate  item on particular field  */

public boolean  locateOnField(String field, String value )
throws java.sql.SQLException 
{
	 value = escapeQuote(value);
	 boolean bLocated = false ;
   java.sql.Connection conn = Connect();
   if(conn==null)return false;
   try
	 {
    String query_locate_on_field = "  SELECT * FROM `mail_singlelog`  WHERE `"+field+"` = '"+value+"' " ;
    java.sql.Statement  stmt_locate_on_field = conn.createStatement();
    java.sql.ResultSet rslt_locate_on_field  = stmt_locate_on_field.executeQuery(query_locate_on_field); 
    if( rslt_locate_on_field.next())
      {
         bLocated = true ;
         loadData(rslt_locate_on_field);
      } 
    stmt_locate_on_field.close();
		rslt_locate_on_field.close();
   }
   finally
   {
      Disconnect(conn);
   }
  return bLocated ;
} // end method locateRecord();

/* End method locateOnField */


/* locate  Multiple item on Multiple field  */
public boolean  locateMultipleField(String fields, String values )
throws java.sql.SQLException 
{
   boolean bLocated = false ;
   java.sql.Connection conn = Connect();
   if(conn==null)return false;
   if(fields == null || fields.length()==0 || values==null || values.length()==0) return false;
   try
	{
		StringBuilder sbQry  = new StringBuilder( " SELECT * FROM `mail_singlelog` WHERE ") ;
		String[] fldnames = com.webapp.utils.CSVHelper.stringArrayFromCsv(fields);
		String[] fldvals  = com.webapp.utils.CSVHelper.stringArrayFromCsv(values);
		if(fldnames.length != fldvals.length ) return false;
		for(int idx=0 ; idx < fldnames.length ; idx++)
		{
			if(idx > 0) sbQry.append(" AND ");
			sbQry.append("`"+fldnames[idx]+"` = '"+fldvals[idx]+"' ");	  
		}	
    
    java.sql.Statement  stmt_locate_multiple_field = conn.createStatement();
    java.sql.ResultSet rslt_locate_multiple_field  = stmt_locate_multiple_field.executeQuery(sbQry.toString()); 
    if( rslt_locate_multiple_field.next())
      {
         bLocated = true ;
         loadData(rslt_locate_multiple_field);
      } 
    stmt_locate_multiple_field.close();
		rslt_locate_multiple_field.close();
   }
   finally
   {
      Disconnect(conn);
   }
  return bLocated ;
} // end method locateMultipleRecord();


	/* Open and close methods for data access */
	private  java.sql.Connection _conn  ;
	private  java.sql.ResultSet _result ;
	private  java.sql.Statement _stmt ;
	private  String _query = null;

/* General purpose table opening method  */	
  public ResultSet  openTable(String WhereClause, String OrderByClause )
  throws java.sql.SQLException
  {
      _conn = Connect();
	    if(_conn==null) return null;
      _query =   "  SELECT * FROM `mail_singlelog`  "+WhereClause+" "+OrderByClause ;
      _stmt = _conn.createStatement();
      _result  = _stmt.executeQuery(_query); 
      return _result ;
  } // end method openTable();

/* General purpose Join table opening method  */
  public ResultSet  joinopenTable(String Join, String JoinTableName, String OnIDField, String WhereClause, String OrderByClause )
  throws java.sql.SQLException
  {
      _conn = Connect();
	    if(_conn==null) return null;
      _query =   "  SELECT * FROM `mail_singlelog`  "+Join+" `"+JoinTableName+"` ON (`mail_singlelog`.`"+OnIDField+"` = `"+JoinTableName+"`.`"+OnIDField+"`) "+WhereClause+" "+OrderByClause ;
      _stmt = _conn.createStatement();
      _result  = _stmt.executeQuery(_query); 
      return _result ;
  } // end method joinopenTable();

/* Additional table opening method as MySQL supports pagination through limit and offset key words */	
  public ResultSet  openTable(String WhereClause, String OrderByClause, int nLimit, int nOffSet )
  throws java.sql.SQLException
  {
      _conn = Connect();
	   if(_conn==null) return null;
     _query =   "  SELECT * FROM `mail_singlelog`  "+WhereClause+" "+OrderByClause+" LIMIT "+nLimit+" OFFSET "+nOffSet+" " ;
     _stmt = _conn.createStatement();
     _result  = _stmt.executeQuery(_query); 
     return _result ;
  } // end method openTable();
	
  public boolean nextRow()
  throws java.sql.SQLException
  {
      boolean retVal=false;
      if(_result==null)return false;
      retVal=_result.next();
      if(retVal==true)loadData(_result);
      return retVal;
  } // end method nextRow();

  public boolean skipRow()
  throws java.sql.SQLException
  {
       if(_result==null)return false;
       return _result.next();
  } //  end method skipRow();

	
public void closeTable()
throws java.sql.SQLException
{
  _stmt.close();
  Disconnect(_conn);
  _result=null;
} // end method closeTable()


/* General purpose arbitrary query executing method that updates table */	

public int executeUpdate( java.lang.String query )
  throws java.sql.SQLException 
 {
 int ret_val = 0;
 java.sql.Connection conn = Connect();
 if(conn==null) return 0;
 try{
    java.sql.Statement stmt = conn.createStatement();
    ret_val = stmt.executeUpdate(query , Statement.RETURN_GENERATED_KEYS);
    stmt.close();
    }
 finally
    {
      Disconnect(conn);
    }
  return ret_val ;
 } // end method executeUpdate()
	
	private  java.sql.Connection _conn_qry  ;
	private  java.sql.ResultSet _result_qry ;
	private  java.sql.Statement _stmt_qry ;

/* General purpose arbitrary query executing method that retrives the data */	
public java.sql.ResultSet  openQuery(String query )
throws java.sql.SQLException
{
 
 _conn_qry = Connect();
 if(_conn_qry==null) return null ;
 _stmt_qry = _conn_qry.createStatement();
 _result_qry  = _stmt_qry.executeQuery(query); 
 return _result_qry ;
} // end method openQuery()
	
public void closeQuery()
throws java.sql.SQLException 
{
  _stmt_qry.close();
  Disconnect(_conn_qry);
  _result_qry=null;
} // end method closeQuery()
	

public int  recordCount(String WhereClause )
throws java.sql.SQLException 
{
 int nCount=0;
 String query_count = ""; 
 java.sql.Connection conn = Connect();
 if(conn==null) return 0;
 if(WhereClause.contains("GROUP BY"))
 {
	query_count = "SELECT COUNT(*) FROM ( SELECT COUNT(*) FROM `mail_singlelog`  "+WhereClause+") AS X ";
 }
 else
 {
	query_count = " SELECT COUNT(*) FROM `mail_singlelog`  "+WhereClause;	 
 }	 
    try
    {
    java.sql.Statement stmt_count = conn.createStatement();
    java.sql.ResultSet rslt_count = stmt_count.executeQuery(query_count); 
    if(rslt_count.next()) nCount=rslt_count.getInt(1);
    rslt_count.close();
    stmt_count.close();
    }
    finally
    {
      Disconnect(conn);
    }
 return nCount ;		
} // end method recordCount();

public int joinrecordCount(String Join, String JoinTableName, String OnIDField, String WhereClause)
throws java.sql.SQLException 
{
 int nCount=0;
 String query_count = "";
 java.sql.Connection conn = Connect();
 if(conn==null) return 0;
 if(WhereClause.contains("GROUP BY"))
 {
	query_count = "SELECT COUNT(*) FROM ( SELECT COUNT(*) FROM `mail_singlelog`  "+Join+" `"+JoinTableName+"` ON (`mail_singlelog`.`"+OnIDField+"` = `"+JoinTableName+"`.`"+OnIDField+"`)  "+WhereClause+") AS X ";
 }
 else
 {
	query_count = " SELECT COUNT(*) FROM `mail_singlelog`  "+Join+" `"+JoinTableName+"` ON (`mail_singlelog`.`"+OnIDField+"` = `"+JoinTableName+"`.`"+OnIDField+"`)  "+WhereClause;	 
 }	 
    try
    {
    java.sql.Statement stmt_count = conn.createStatement();
    java.sql.ResultSet rslt_count = stmt_count.executeQuery(query_count); 
    if(rslt_count.next()) nCount=rslt_count.getInt(1);
    rslt_count.close();
    stmt_count.close();
    }
    finally
    {
      Disconnect(conn);
    }
 return nCount ;		
} // end method joinrecordCount();

	
private  String escapeQuote(String src)
{
	   if(src.contains("'")) src = src.replace("'", "''");
		 return src;
} // end method escapeQuotes
	


} /* End of class declaration for Mail_singlelogBean */	


