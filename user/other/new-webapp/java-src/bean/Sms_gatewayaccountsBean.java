package com.db.$DATABASE ;
import  java.lang.* ;
import  java.io.* ;
import  java.sql.* ;
import  javax.naming.* ;
import  javax.sql.* ;	
/*
   Code generated on : 17/11/2016 10:07 PM
   The code is customized for MySQL  - MySQL Connector Java driver.
   The JDBC driver version is: mysql-connector-java-5.1.38 ( Revision: fe541c166cec739c74cc727c5da96c1028b4834a )
	 Autonumber column is: AccountID

*/
public class Sms_gatewayaccountsBean
{
	
/* JNDI data source name of database */
	public String _datasource = "jdbc/$DATABASE" ;
/* Table name in SQL databse */
	public String _tablename = "sms_gatewayaccounts"; 
/* Special public variable to hold last autonumber value */
	public int _autonumber = 0 ;
	
/* Variable to hold last error */
  public String lasterror=null;	
	
/* Variables corrosponding to table fields - field count: 37 */
	 
    public int AccountID = 0 ;  
    public String Title = "" ;  
    public short AccountType = (short)0 ;  
    public java.sql.Date StartDate = null ;  
    public java.sql.Date EndDate = null ;  
    public String ProviderName = "" ;  
    public String Website = "" ;  
    public String ContactPerson = "" ;  
    public String HelpNumbers = "" ;  
    public String UserID = "" ;  
    public String Password = "" ;  
    public String BalanceCheckURL = "" ;  
    public String BalanceCheckFormat = "" ;  
    public String BalanceCheckUserIDParam = "" ;  
    public String BalanceCheckPasswordParam = "" ;  
    public String BalanceCheckOtherParam = "" ;  
    public String BalanceCheckOtherValue = "" ;  
    public String PingURL = "" ;  
    public String PingResponse = "" ;  
    public String SMSSendURL = "" ;  
    public String SMSSendResponse = "" ;  
    public short BatchSize = (short)0 ;  
    public String NumberDelimiter = "" ;  
    public String ResponseDelimiter = "" ;  
    public String MobileNumberParam = "" ;  
    public String SMSTextParam = "" ;  
    public String SendSMSUserIDParam = "" ;  
    public String SendSMSPasswordParam = "" ;  
    public String SenderIDParam = "" ;  
    public String SenderIDValue = "" ;  
    public String OtherParam1 = "" ;  
    public String OtherValue1 = "" ;  
    public String OtherParam2 = "" ;  
    public String OtherValue2 = "" ;  
    public int LastSMSBalance = 0 ;  
    public java.sql.Timestamp BalanceCheckTime = null ;  
    public java.sql.Timestamp UpdateDateTime = null ;  



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

public void copyTo(com.db.$DATABASE.Sms_gatewayaccountsBean other )
{
   other.AccountID = this.AccountID ;
   other.Title = this.Title ;
   other.AccountType = this.AccountType ;
   other.StartDate = this.StartDate ;
   other.EndDate = this.EndDate ;
   other.ProviderName = this.ProviderName ;
   other.Website = this.Website ;
   other.ContactPerson = this.ContactPerson ;
   other.HelpNumbers = this.HelpNumbers ;
   other.UserID = this.UserID ;
   other.Password = this.Password ;
   other.BalanceCheckURL = this.BalanceCheckURL ;
   other.BalanceCheckFormat = this.BalanceCheckFormat ;
   other.BalanceCheckUserIDParam = this.BalanceCheckUserIDParam ;
   other.BalanceCheckPasswordParam = this.BalanceCheckPasswordParam ;
   other.BalanceCheckOtherParam = this.BalanceCheckOtherParam ;
   other.BalanceCheckOtherValue = this.BalanceCheckOtherValue ;
   other.PingURL = this.PingURL ;
   other.PingResponse = this.PingResponse ;
   other.SMSSendURL = this.SMSSendURL ;
   other.SMSSendResponse = this.SMSSendResponse ;
   other.BatchSize = this.BatchSize ;
   other.NumberDelimiter = this.NumberDelimiter ;
   other.ResponseDelimiter = this.ResponseDelimiter ;
   other.MobileNumberParam = this.MobileNumberParam ;
   other.SMSTextParam = this.SMSTextParam ;
   other.SendSMSUserIDParam = this.SendSMSUserIDParam ;
   other.SendSMSPasswordParam = this.SendSMSPasswordParam ;
   other.SenderIDParam = this.SenderIDParam ;
   other.SenderIDValue = this.SenderIDValue ;
   other.OtherParam1 = this.OtherParam1 ;
   other.OtherValue1 = this.OtherValue1 ;
   other.OtherParam2 = this.OtherParam2 ;
   other.OtherValue2 = this.OtherValue2 ;
   other.LastSMSBalance = this.LastSMSBalance ;
   other.BalanceCheckTime = this.BalanceCheckTime ;
   other.UpdateDateTime = this.UpdateDateTime ;
	
}

/* Copy Fields from other objects of same kind */

public void copyFrom(com.db.$DATABASE.Sms_gatewayaccountsBean other )
{
   this.AccountID = other.AccountID ;
   this.Title = other.Title ;
   this.AccountType = other.AccountType ;
   this.StartDate = other.StartDate ;
   this.EndDate = other.EndDate ;
   this.ProviderName = other.ProviderName ;
   this.Website = other.Website ;
   this.ContactPerson = other.ContactPerson ;
   this.HelpNumbers = other.HelpNumbers ;
   this.UserID = other.UserID ;
   this.Password = other.Password ;
   this.BalanceCheckURL = other.BalanceCheckURL ;
   this.BalanceCheckFormat = other.BalanceCheckFormat ;
   this.BalanceCheckUserIDParam = other.BalanceCheckUserIDParam ;
   this.BalanceCheckPasswordParam = other.BalanceCheckPasswordParam ;
   this.BalanceCheckOtherParam = other.BalanceCheckOtherParam ;
   this.BalanceCheckOtherValue = other.BalanceCheckOtherValue ;
   this.PingURL = other.PingURL ;
   this.PingResponse = other.PingResponse ;
   this.SMSSendURL = other.SMSSendURL ;
   this.SMSSendResponse = other.SMSSendResponse ;
   this.BatchSize = other.BatchSize ;
   this.NumberDelimiter = other.NumberDelimiter ;
   this.ResponseDelimiter = other.ResponseDelimiter ;
   this.MobileNumberParam = other.MobileNumberParam ;
   this.SMSTextParam = other.SMSTextParam ;
   this.SendSMSUserIDParam = other.SendSMSUserIDParam ;
   this.SendSMSPasswordParam = other.SendSMSPasswordParam ;
   this.SenderIDParam = other.SenderIDParam ;
   this.SenderIDValue = other.SenderIDValue ;
   this.OtherParam1 = other.OtherParam1 ;
   this.OtherValue1 = other.OtherValue1 ;
   this.OtherParam2 = other.OtherParam2 ;
   this.OtherValue2 = other.OtherValue2 ;
   this.LastSMSBalance = other.LastSMSBalance ;
   this.BalanceCheckTime = other.BalanceCheckTime ;
   this.UpdateDateTime = other.UpdateDateTime ;
	
}

/* Clear field instance variable data */
public void clearData()
{
	this.AccountID = 0 ; 
	this.Title = "" ; 
	this.AccountType = (short)0 ; 
	this.StartDate = null ; 
	this.EndDate = null ; 
	this.ProviderName = "" ; 
	this.Website = "" ; 
	this.ContactPerson = "" ; 
	this.HelpNumbers = "" ; 
	this.UserID = "" ; 
	this.Password = "" ; 
	this.BalanceCheckURL = "" ; 
	this.BalanceCheckFormat = "" ; 
	this.BalanceCheckUserIDParam = "" ; 
	this.BalanceCheckPasswordParam = "" ; 
	this.BalanceCheckOtherParam = "" ; 
	this.BalanceCheckOtherValue = "" ; 
	this.PingURL = "" ; 
	this.PingResponse = "" ; 
	this.SMSSendURL = "" ; 
	this.SMSSendResponse = "" ; 
	this.BatchSize = (short)0 ; 
	this.NumberDelimiter = "" ; 
	this.ResponseDelimiter = "" ; 
	this.MobileNumberParam = "" ; 
	this.SMSTextParam = "" ; 
	this.SendSMSUserIDParam = "" ; 
	this.SendSMSPasswordParam = "" ; 
	this.SenderIDParam = "" ; 
	this.SenderIDValue = "" ; 
	this.OtherParam1 = "" ; 
	this.OtherValue1 = "" ; 
	this.OtherParam2 = "" ; 
	this.OtherValue2 = "" ; 
	this.LastSMSBalance = 0 ; 
	this.BalanceCheckTime = null ; 
	this.UpdateDateTime = null ; 

} // End Method clearData




/* Move data from class variables to statement fields */
public void storeData(java.sql.PreparedStatement stmt )
throws java.sql.SQLException 
{
stmt.setInt( 1 , AccountID ) ; 
stmt.setString( 2 , Title ) ; 
stmt.setShort( 3 , AccountType ) ; 
stmt.setDate( 4 , StartDate ) ; 
stmt.setDate( 5 , EndDate ) ; 
stmt.setString( 6 , ProviderName ) ; 
stmt.setString( 7 , Website ) ; 
stmt.setString( 8 , ContactPerson ) ; 
stmt.setString( 9 , HelpNumbers ) ; 
stmt.setString( 10 , UserID ) ; 
stmt.setString( 11 , Password ) ; 
stmt.setString( 12 , BalanceCheckURL ) ; 
stmt.setString( 13 , BalanceCheckFormat ) ; 
stmt.setString( 14 , BalanceCheckUserIDParam ) ; 
stmt.setString( 15 , BalanceCheckPasswordParam ) ; 
stmt.setString( 16 , BalanceCheckOtherParam ) ; 
stmt.setString( 17 , BalanceCheckOtherValue ) ; 
stmt.setString( 18 , PingURL ) ; 
stmt.setString( 19 , PingResponse ) ; 
stmt.setString( 20 , SMSSendURL ) ; 
stmt.setString( 21 , SMSSendResponse ) ; 
stmt.setShort( 22 , BatchSize ) ; 
stmt.setString( 23 , NumberDelimiter ) ; 
stmt.setString( 24 , ResponseDelimiter ) ; 
stmt.setString( 25 , MobileNumberParam ) ; 
stmt.setString( 26 , SMSTextParam ) ; 
stmt.setString( 27 , SendSMSUserIDParam ) ; 
stmt.setString( 28 , SendSMSPasswordParam ) ; 
stmt.setString( 29 , SenderIDParam ) ; 
stmt.setString( 30 , SenderIDValue ) ; 
stmt.setString( 31 , OtherParam1 ) ; 
stmt.setString( 32 , OtherValue1 ) ; 
stmt.setString( 33 , OtherParam2 ) ; 
stmt.setString( 34 , OtherValue2 ) ; 
stmt.setInt( 35 , LastSMSBalance ) ; 
stmt.setTimestamp( 36 , BalanceCheckTime ) ; 
stmt.setTimestamp( 37 , UpdateDateTime ) ; 
	
} // end method storeData()
	 
/* Move data from result set fields to class variables */

public void loadData(java.sql.ResultSet rslt)
throws java.sql.SQLException
{
AccountID = rslt.getInt("AccountID"); 
Title = rslt.getString("Title"); 
AccountType = rslt.getShort("AccountType"); 
StartDate = rslt.getDate("StartDate"); 
EndDate = rslt.getDate("EndDate"); 
ProviderName = rslt.getString("ProviderName"); 
Website = rslt.getString("Website"); 
ContactPerson = rslt.getString("ContactPerson"); 
HelpNumbers = rslt.getString("HelpNumbers"); 
UserID = rslt.getString("UserID"); 
Password = rslt.getString("Password"); 
BalanceCheckURL = rslt.getString("BalanceCheckURL"); 
BalanceCheckFormat = rslt.getString("BalanceCheckFormat"); 
BalanceCheckUserIDParam = rslt.getString("BalanceCheckUserIDParam"); 
BalanceCheckPasswordParam = rslt.getString("BalanceCheckPasswordParam"); 
BalanceCheckOtherParam = rslt.getString("BalanceCheckOtherParam"); 
BalanceCheckOtherValue = rslt.getString("BalanceCheckOtherValue"); 
PingURL = rslt.getString("PingURL"); 
PingResponse = rslt.getString("PingResponse"); 
SMSSendURL = rslt.getString("SMSSendURL"); 
SMSSendResponse = rslt.getString("SMSSendResponse"); 
BatchSize = rslt.getShort("BatchSize"); 
NumberDelimiter = rslt.getString("NumberDelimiter"); 
ResponseDelimiter = rslt.getString("ResponseDelimiter"); 
MobileNumberParam = rslt.getString("MobileNumberParam"); 
SMSTextParam = rslt.getString("SMSTextParam"); 
SendSMSUserIDParam = rslt.getString("SendSMSUserIDParam"); 
SendSMSPasswordParam = rslt.getString("SendSMSPasswordParam"); 
SenderIDParam = rslt.getString("SenderIDParam"); 
SenderIDValue = rslt.getString("SenderIDValue"); 
OtherParam1 = rslt.getString("OtherParam1"); 
OtherValue1 = rslt.getString("OtherValue1"); 
OtherParam2 = rslt.getString("OtherParam2"); 
OtherValue2 = rslt.getString("OtherValue2"); 
LastSMSBalance = rslt.getInt("LastSMSBalance"); 
BalanceCheckTime = rslt.getTimestamp("BalanceCheckTime"); 
UpdateDateTime = rslt.getTimestamp("UpdateDateTime"); 
	
}// end method loadData();
	 
/* Add new record from class variable */
public boolean addRecord()
throws java.sql.SQLException 
{
 boolean bAdded = false ;
 java.sql.Connection conn = Connect();
 if(conn==null)return false;
 
 try{
    String query_add = " INSERT INTO `sms_gatewayaccounts` ( `AccountID`, `Title`, `AccountType`, `StartDate`, `EndDate`, `ProviderName`, `Website`, `ContactPerson`, `HelpNumbers`, `UserID`, `Password`, `BalanceCheckURL`, `BalanceCheckFormat`, `BalanceCheckUserIDParam`, `BalanceCheckPasswordParam`, `BalanceCheckOtherParam`, `BalanceCheckOtherValue`, `PingURL`, `PingResponse`, `SMSSendURL`, `SMSSendResponse`, `BatchSize`, `NumberDelimiter`, `ResponseDelimiter`, `MobileNumberParam`, `SMSTextParam`, `SendSMSUserIDParam`, `SendSMSPasswordParam`, `SenderIDParam`, `SenderIDValue`, `OtherParam1`, `OtherValue1`, `OtherParam2`, `OtherValue2`, `LastSMSBalance`, `BalanceCheckTime`, `UpdateDateTime` ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?  ) ";
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
     if ( _autonumber > 0 ) AccountID = _autonumber ;
		 
	  
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
  String query_insert = " INSERT INTO `sms_gatewayaccounts` ( `AccountID`, `Title`, `AccountType`, `StartDate`, `EndDate`, `ProviderName`, `Website`, `ContactPerson`, `HelpNumbers`, `UserID`, `Password`, `BalanceCheckURL`, `BalanceCheckFormat`, `BalanceCheckUserIDParam`, `BalanceCheckPasswordParam`, `BalanceCheckOtherParam`, `BalanceCheckOtherValue`, `PingURL`, `PingResponse`, `SMSSendURL`, `SMSSendResponse`, `BatchSize`, `NumberDelimiter`, `ResponseDelimiter`, `MobileNumberParam`, `SMSTextParam`, `SendSMSUserIDParam`, `SendSMSPasswordParam`, `SenderIDParam`, `SenderIDValue`, `OtherParam1`, `OtherValue1`, `OtherParam2`, `OtherValue2`, `LastSMSBalance`, `BalanceCheckTime`, `UpdateDateTime` ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?  ) ";
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
     if ( _autonumber > 0 ) AccountID = _autonumber ;

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
public boolean updateRecord(int update_AccountID)
	throws java.sql.SQLException 
{

  boolean bUpdated = false ;
  java.sql.Connection conn = Connect();
	if(conn==null) return false ;
  try
	  {
    String query_update = " UPDATE `sms_gatewayaccounts` SET `AccountID` = ?, `Title` = ?, `AccountType` = ?, `StartDate` = ?, `EndDate` = ?, `ProviderName` = ?, `Website` = ?, `ContactPerson` = ?, `HelpNumbers` = ?, `UserID` = ?, `Password` = ?, `BalanceCheckURL` = ?, `BalanceCheckFormat` = ?, `BalanceCheckUserIDParam` = ?, `BalanceCheckPasswordParam` = ?, `BalanceCheckOtherParam` = ?, `BalanceCheckOtherValue` = ?, `PingURL` = ?, `PingResponse` = ?, `SMSSendURL` = ?, `SMSSendResponse` = ?, `BatchSize` = ?, `NumberDelimiter` = ?, `ResponseDelimiter` = ?, `MobileNumberParam` = ?, `SMSTextParam` = ?, `SendSMSUserIDParam` = ?, `SendSMSPasswordParam` = ?, `SenderIDParam` = ?, `SenderIDValue` = ?, `OtherParam1` = ?, `OtherValue1` = ?, `OtherParam2` = ?, `OtherValue2` = ?, `LastSMSBalance` = ?, `BalanceCheckTime` = ?, `UpdateDateTime` = ?  WHERE `sms_gatewayaccounts`.`AccountID` = "+update_AccountID+" " ;
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
public boolean deleteRecord(int delete_AccountID)
throws java.sql.SQLException 
{

 boolean bDeleted = false ;
 java.sql.Connection conn =  Connect();
 if(conn==null) return false ;
 try{
    String query_del = "  DELETE FROM `sms_gatewayaccounts` WHERE `sms_gatewayaccounts`.`AccountID` = "+delete_AccountID+" " ;
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
public boolean  locateRecord(int locate_AccountID )
throws java.sql.SQLException 
{

 boolean bLocated = false ;
 java.sql.Connection conn = Connect();
 if(conn==null)return false;
 try{
    String query_locate = "  SELECT *  FROM `sms_gatewayaccounts` WHERE  `sms_gatewayaccounts`.`AccountID` = "+locate_AccountID+" " ;
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
    String query_locate_on_field = "  SELECT * FROM `sms_gatewayaccounts`  WHERE `"+field+"` = '"+value+"' " ;
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
		StringBuilder sbQry  = new StringBuilder( " SELECT * FROM `sms_gatewayaccounts` WHERE ") ;
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
      _query =   "  SELECT * FROM `sms_gatewayaccounts`  "+WhereClause+" "+OrderByClause ;
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
      _query =   "  SELECT * FROM `sms_gatewayaccounts`  "+Join+" `"+JoinTableName+"` ON (`sms_gatewayaccounts`.`"+OnIDField+"` = `"+JoinTableName+"`.`"+OnIDField+"`) "+WhereClause+" "+OrderByClause ;
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
     _query =   "  SELECT * FROM `sms_gatewayaccounts`  "+WhereClause+" "+OrderByClause+" LIMIT "+nLimit+" OFFSET "+nOffSet+" " ;
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
	query_count = "SELECT COUNT(*) FROM ( SELECT COUNT(*) FROM `sms_gatewayaccounts`  "+WhereClause+") AS X ";
 }
 else
 {
	query_count = " SELECT COUNT(*) FROM `sms_gatewayaccounts`  "+WhereClause;	 
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
	query_count = "SELECT COUNT(*) FROM ( SELECT COUNT(*) FROM `sms_gatewayaccounts`  "+Join+" `"+JoinTableName+"` ON (`sms_gatewayaccounts`.`"+OnIDField+"` = `"+JoinTableName+"`.`"+OnIDField+"`)  "+WhereClause+") AS X ";
 }
 else
 {
	query_count = " SELECT COUNT(*) FROM `sms_gatewayaccounts`  "+Join+" `"+JoinTableName+"` ON (`sms_gatewayaccounts`.`"+OnIDField+"` = `"+JoinTableName+"`.`"+OnIDField+"`)  "+WhereClause;	 
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
	


} /* End of class declaration for Sms_gatewayaccountsBean */	


