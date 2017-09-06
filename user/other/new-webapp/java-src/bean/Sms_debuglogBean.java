package com.db.$DATABASE ;
import  java.lang.* ;
import  java.io.* ;
import  java.sql.* ;
import  javax.naming.* ;
import  javax.sql.* ;	
/*
   Code generated on : 17/11/2016 10:06 PM
   The code is customized for MySQL  - MySQL Connector Java driver.
   The JDBC driver version is: mysql-connector-java-5.1.38 ( Revision: fe541c166cec739c74cc727c5da96c1028b4834a )
	 Autonumber column is: SmsDebugLogID

*/
public class Sms_debuglogBean
{
	
/* JNDI data source name of database */
	public String _datasource = "jdbc/$DATABASE" ;
/* Table name in SQL databse */
	public String _tablename = "sms_debuglog"; 
/* Special public variable to hold last autonumber value */
	public int _autonumber = 0 ;
	
/* Variable to hold last error */
  public String lasterror=null;	
	
/* Variables corrosponding to table fields - field count: 6 */
	 
    public int SmsDebugLogID = 0 ;  
    public java.sql.Timestamp LogDateTime = null ;  
    public String Number = "" ;  
    public String Message = "" ;  
    public String Context = "" ;  
    public String LogText = "" ;  



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

public void copyTo(com.db.$DATABASE.Sms_debuglogBean other )
{
   other.SmsDebugLogID = this.SmsDebugLogID ;
   other.LogDateTime = this.LogDateTime ;
   other.Number = this.Number ;
   other.Message = this.Message ;
   other.Context = this.Context ;
   other.LogText = this.LogText ;
	
}

/* Copy Fields from other objects of same kind */

public void copyFrom(com.db.$DATABASE.Sms_debuglogBean other )
{
   this.SmsDebugLogID = other.SmsDebugLogID ;
   this.LogDateTime = other.LogDateTime ;
   this.Number = other.Number ;
   this.Message = other.Message ;
   this.Context = other.Context ;
   this.LogText = other.LogText ;
	
}

/* Clear field instance variable data */
public void clearData()
{
	this.SmsDebugLogID = 0 ; 
	this.LogDateTime = null ; 
	this.Number = "" ; 
	this.Message = "" ; 
	this.Context = "" ; 
	this.LogText = "" ; 

} // End Method clearData




/* Move data from class variables to statement fields */
public void storeData(java.sql.PreparedStatement stmt )
throws java.sql.SQLException 
{
stmt.setInt( 1 , SmsDebugLogID ) ; 
stmt.setTimestamp( 2 , LogDateTime ) ; 
stmt.setString( 3 , Number ) ; 
stmt.setString( 4 , Message ) ; 
stmt.setString( 5 , Context ) ; 
stmt.setString( 6 , LogText ) ; 
	
} // end method storeData()
	 
/* Move data from result set fields to class variables */

public void loadData(java.sql.ResultSet rslt)
throws java.sql.SQLException
{
SmsDebugLogID = rslt.getInt("SmsDebugLogID"); 
LogDateTime = rslt.getTimestamp("LogDateTime"); 
Number = rslt.getString("Number"); 
Message = rslt.getString("Message"); 
Context = rslt.getString("Context"); 
LogText = rslt.getString("LogText"); 
	
}// end method loadData();
	 
/* Add new record from class variable */
public boolean addRecord()
throws java.sql.SQLException 
{
 boolean bAdded = false ;
 java.sql.Connection conn = Connect();
 if(conn==null)return false;
 
 try{
    String query_add = " INSERT INTO `sms_debuglog` ( `SmsDebugLogID`, `LogDateTime`, `Number`, `Message`, `Context`, `LogText` ) VALUES ( ?, ?, ?, ?, ?, ?  ) ";
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
     if ( _autonumber > 0 ) SmsDebugLogID = _autonumber ;
		 
	  
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
  String query_insert = " INSERT INTO `sms_debuglog` ( `SmsDebugLogID`, `LogDateTime`, `Number`, `Message`, `Context`, `LogText` ) VALUES ( ?, ?, ?, ?, ?, ?  ) ";
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
     if ( _autonumber > 0 ) SmsDebugLogID = _autonumber ;

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
public boolean updateRecord(int update_SmsDebugLogID)
	throws java.sql.SQLException 
{

  boolean bUpdated = false ;
  java.sql.Connection conn = Connect();
	if(conn==null) return false ;
  try
	  {
    String query_update = " UPDATE `sms_debuglog` SET `SmsDebugLogID` = ?, `LogDateTime` = ?, `Number` = ?, `Message` = ?, `Context` = ?, `LogText` = ?  WHERE `sms_debuglog`.`SmsDebugLogID` = "+update_SmsDebugLogID+" " ;
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
public boolean deleteRecord(int delete_SmsDebugLogID)
throws java.sql.SQLException 
{

 boolean bDeleted = false ;
 java.sql.Connection conn =  Connect();
 if(conn==null) return false ;
 try{
    String query_del = "  DELETE FROM `sms_debuglog` WHERE `sms_debuglog`.`SmsDebugLogID` = "+delete_SmsDebugLogID+" " ;
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
public boolean  locateRecord(int locate_SmsDebugLogID )
throws java.sql.SQLException 
{

 boolean bLocated = false ;
 java.sql.Connection conn = Connect();
 if(conn==null)return false;
 try{
    String query_locate = "  SELECT *  FROM `sms_debuglog` WHERE  `sms_debuglog`.`SmsDebugLogID` = "+locate_SmsDebugLogID+" " ;
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
    String query_locate_on_field = "  SELECT * FROM `sms_debuglog`  WHERE `"+field+"` = '"+value+"' " ;
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
		StringBuilder sbQry  = new StringBuilder( " SELECT * FROM `sms_debuglog` WHERE ") ;
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
      _query =   "  SELECT * FROM `sms_debuglog`  "+WhereClause+" "+OrderByClause ;
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
      _query =   "  SELECT * FROM `sms_debuglog`  "+Join+" `"+JoinTableName+"` ON (`sms_debuglog`.`"+OnIDField+"` = `"+JoinTableName+"`.`"+OnIDField+"`) "+WhereClause+" "+OrderByClause ;
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
     _query =   "  SELECT * FROM `sms_debuglog`  "+WhereClause+" "+OrderByClause+" LIMIT "+nLimit+" OFFSET "+nOffSet+" " ;
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
	query_count = "SELECT COUNT(*) FROM ( SELECT COUNT(*) FROM `sms_debuglog`  "+WhereClause+") AS X ";
 }
 else
 {
	query_count = " SELECT COUNT(*) FROM `sms_debuglog`  "+WhereClause;	 
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
	query_count = "SELECT COUNT(*) FROM ( SELECT COUNT(*) FROM `sms_debuglog`  "+Join+" `"+JoinTableName+"` ON (`sms_debuglog`.`"+OnIDField+"` = `"+JoinTableName+"`.`"+OnIDField+"`)  "+WhereClause+") AS X ";
 }
 else
 {
	query_count = " SELECT COUNT(*) FROM `sms_debuglog`  "+Join+" `"+JoinTableName+"` ON (`sms_debuglog`.`"+OnIDField+"` = `"+JoinTableName+"`.`"+OnIDField+"`)  "+WhereClause;	 
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
	


} /* End of class declaration for Sms_debuglogBean */	


