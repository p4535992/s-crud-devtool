package com.db.$DATABASE ;
import  java.lang.* ;
import  java.io.* ;
import  java.sql.* ;
import  javax.naming.* ;
import  javax.sql.* ;	
/*
   Code generated on : 29/06/2016 11:17 PM
   The code is customized for MySQL  - MySQL Connector Java driver.
   The JDBC driver version is: mysql-connector-java-5.1.38 ( Revision: fe541c166cec739c74cc727c5da96c1028b4834a )
	 Autonumber column is: AdminID

*/
public class SitemanagerBean
{
	
/* JNDI data source name of database */
	public String _datasource = "jdbc/$DATABASE" ;
/* Table name in SQL databse */
	public String _tablename = "sitemanager"; 
/* Special public variable to hold last autonumber value */
	public int _autonumber = 0 ;
	
/* Variable to hold last error */
  public String lasterror=null;	
	
/* Variables corrosponding to table fields - field count: 28 */
	       
 	public int AdminID ; 
	public String FirstName ; 
	public String MiddleName ; 
	public String LastName ; 
	public String Gender ; 
	public java.sql.Date BirthDate ; 
	public String MaritalStatus ; 
	public String EmpCode ; 
	public java.sql.Date JoiningDate ; 
	public java.sql.Date LeavingDate ; 
	public String Address ; 
	public String City ; 
	public String State ; 
	public String PIN ; 
	public String Landline ; 
	public String Mobile ; 
	public String Email ; 
	public String Username ; 
	public String Password ; 
	public short PasswordType ; 
	public String AccessModule ; 
	public short SuperAdminRight ; 
	public String LoginRole ; 
	public short CurrentStatus ; 
	public short LoginStatus ; 
	public short MultiLogin ; 
	public String MenuType ; 
	public java.sql.Timestamp UpdateDateTime ; 



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

public void copyTo(com.db.$DATABASE.SitemanagerBean other )
{
   other.AdminID = this.AdminID ;
   other.FirstName = this.FirstName ;
   other.MiddleName = this.MiddleName ;
   other.LastName = this.LastName ;
   other.Gender = this.Gender ;
   other.BirthDate = this.BirthDate ;
   other.MaritalStatus = this.MaritalStatus ;
   other.EmpCode = this.EmpCode ;
   other.JoiningDate = this.JoiningDate ;
   other.LeavingDate = this.LeavingDate ;
   other.Address = this.Address ;
   other.City = this.City ;
   other.State = this.State ;
   other.PIN = this.PIN ;
   other.Landline = this.Landline ;
   other.Mobile = this.Mobile ;
   other.Email = this.Email ;
   other.Username = this.Username ;
   other.Password = this.Password ;
   other.PasswordType = this.PasswordType ;
   other.AccessModule = this.AccessModule ;
   other.SuperAdminRight = this.SuperAdminRight ;
   other.LoginRole = this.LoginRole ;
   other.CurrentStatus = this.CurrentStatus ;
   other.LoginStatus = this.LoginStatus ;
   other.MultiLogin = this.MultiLogin ;
   other.MenuType = this.MenuType ;
   other.UpdateDateTime = this.UpdateDateTime ;
	
}

/* Copy Fields from other objects of same kind */

public void copyFrom(com.db.$DATABASE.SitemanagerBean other )
{
   this.AdminID = other.AdminID ;
   this.FirstName = other.FirstName ;
   this.MiddleName = other.MiddleName ;
   this.LastName = other.LastName ;
   this.Gender = other.Gender ;
   this.BirthDate = other.BirthDate ;
   this.MaritalStatus = other.MaritalStatus ;
   this.EmpCode = other.EmpCode ;
   this.JoiningDate = other.JoiningDate ;
   this.LeavingDate = other.LeavingDate ;
   this.Address = other.Address ;
   this.City = other.City ;
   this.State = other.State ;
   this.PIN = other.PIN ;
   this.Landline = other.Landline ;
   this.Mobile = other.Mobile ;
   this.Email = other.Email ;
   this.Username = other.Username ;
   this.Password = other.Password ;
   this.PasswordType = other.PasswordType ;
   this.AccessModule = other.AccessModule ;
   this.SuperAdminRight = other.SuperAdminRight ;
   this.LoginRole = other.LoginRole ;
   this.CurrentStatus = other.CurrentStatus ;
   this.LoginStatus = other.LoginStatus ;
   this.MultiLogin = other.MultiLogin ;
   this.MenuType = other.MenuType ;
   this.UpdateDateTime = other.UpdateDateTime ;
	
}


/* Move data from class variables to statement fields */
public void storeData(java.sql.PreparedStatement stmt )
throws java.sql.SQLException 
{
stmt.setInt( 1 , AdminID ) ; 
stmt.setString( 2 , FirstName ) ; 
stmt.setString( 3 , MiddleName ) ; 
stmt.setString( 4 , LastName ) ; 
stmt.setString( 5 , Gender ) ; 
stmt.setDate( 6 , BirthDate ) ; 
stmt.setString( 7 , MaritalStatus ) ; 
stmt.setString( 8 , EmpCode ) ; 
stmt.setDate( 9 , JoiningDate ) ; 
stmt.setDate( 10 , LeavingDate ) ; 
stmt.setString( 11 , Address ) ; 
stmt.setString( 12 , City ) ; 
stmt.setString( 13 , State ) ; 
stmt.setString( 14 , PIN ) ; 
stmt.setString( 15 , Landline ) ; 
stmt.setString( 16 , Mobile ) ; 
stmt.setString( 17 , Email ) ; 
stmt.setString( 18 , Username ) ; 
stmt.setString( 19 , Password ) ; 
stmt.setShort( 20 , PasswordType ) ; 
stmt.setString( 21 , AccessModule ) ; 
stmt.setShort( 22 , SuperAdminRight ) ; 
stmt.setString( 23 , LoginRole ) ; 
stmt.setShort( 24 , CurrentStatus ) ; 
stmt.setShort( 25 , LoginStatus ) ; 
stmt.setShort( 26 , MultiLogin ) ; 
stmt.setString( 27 , MenuType ) ; 
stmt.setTimestamp( 28 , UpdateDateTime ) ; 
	
} // end method storeData()
	 
/* Move data from result set fields to class variables */

public void loadData(java.sql.ResultSet rslt)
throws java.sql.SQLException
{
AdminID = rslt.getInt("AdminID"); 
FirstName = rslt.getString("FirstName"); 
MiddleName = rslt.getString("MiddleName"); 
LastName = rslt.getString("LastName"); 
Gender = rslt.getString("Gender"); 
BirthDate = rslt.getDate("BirthDate"); 
MaritalStatus = rslt.getString("MaritalStatus"); 
EmpCode = rslt.getString("EmpCode"); 
JoiningDate = rslt.getDate("JoiningDate"); 
LeavingDate = rslt.getDate("LeavingDate"); 
Address = rslt.getString("Address"); 
City = rslt.getString("City"); 
State = rslt.getString("State"); 
PIN = rslt.getString("PIN"); 
Landline = rslt.getString("Landline"); 
Mobile = rslt.getString("Mobile"); 
Email = rslt.getString("Email"); 
Username = rslt.getString("Username"); 
Password = rslt.getString("Password"); 
PasswordType = rslt.getShort("PasswordType"); 
AccessModule = rslt.getString("AccessModule"); 
SuperAdminRight = rslt.getShort("SuperAdminRight"); 
LoginRole = rslt.getString("LoginRole"); 
CurrentStatus = rslt.getShort("CurrentStatus"); 
LoginStatus = rslt.getShort("LoginStatus"); 
MultiLogin = rslt.getShort("MultiLogin"); 
MenuType = rslt.getString("MenuType"); 
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
    String query_add = " INSERT INTO `sitemanager` ( `AdminID`, `FirstName`, `MiddleName`, `LastName`, `Gender`, `BirthDate`, `MaritalStatus`, `EmpCode`, `JoiningDate`, `LeavingDate`, `Address`, `City`, `State`, `PIN`, `Landline`, `Mobile`, `Email`, `Username`, `Password`, `PasswordType`, `AccessModule`, `SuperAdminRight`, `LoginRole`, `CurrentStatus`, `LoginStatus`, `MultiLogin`, `MenuType`, `UpdateDateTime` ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?  ) ";
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
     if ( _autonumber > 0 ) AdminID = _autonumber ;
		 
	  
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
  String query_insert = " INSERT INTO `sitemanager` ( `AdminID`, `FirstName`, `MiddleName`, `LastName`, `Gender`, `BirthDate`, `MaritalStatus`, `EmpCode`, `JoiningDate`, `LeavingDate`, `Address`, `City`, `State`, `PIN`, `Landline`, `Mobile`, `Email`, `Username`, `Password`, `PasswordType`, `AccessModule`, `SuperAdminRight`, `LoginRole`, `CurrentStatus`, `LoginStatus`, `MultiLogin`, `MenuType`, `UpdateDateTime` ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?  ) ";
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
     if ( _autonumber > 0 ) AdminID = _autonumber ;

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
public boolean updateRecord(int update_AdminID)
	throws java.sql.SQLException 
{

  boolean bUpdated = false ;
  java.sql.Connection conn = Connect();
	if(conn==null) return false ;
  try
	  {
    String query_update = " UPDATE `sitemanager` SET `AdminID` = ?, `FirstName` = ?, `MiddleName` = ?, `LastName` = ?, `Gender` = ?, `BirthDate` = ?, `MaritalStatus` = ?, `EmpCode` = ?, `JoiningDate` = ?, `LeavingDate` = ?, `Address` = ?, `City` = ?, `State` = ?, `PIN` = ?, `Landline` = ?, `Mobile` = ?, `Email` = ?, `Username` = ?, `Password` = ?, `PasswordType` = ?, `AccessModule` = ?, `SuperAdminRight` = ?, `LoginRole` = ?, `CurrentStatus` = ?, `LoginStatus` = ?, `MultiLogin` = ?, `MenuType` = ?, `UpdateDateTime` = ?  WHERE `sitemanager`.`AdminID` = "+update_AdminID+" " ;
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
public boolean deleteRecord(int delete_AdminID)
throws java.sql.SQLException 
{

 boolean bDeleted = false ;
 java.sql.Connection conn =  Connect();
 if(conn==null) return false ;
 try{
    String query_del = "  DELETE FROM `sitemanager` WHERE `sitemanager`.`AdminID` = "+delete_AdminID+" " ;
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
public boolean  locateRecord(int locate_AdminID )
throws java.sql.SQLException 
{

 boolean bLocated = false ;
 java.sql.Connection conn = Connect();
 if(conn==null)return false;
 try{
    String query_locate = "  SELECT *  FROM `sitemanager` WHERE  `sitemanager`.`AdminID` = "+locate_AdminID+" " ;
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
    String query_locate_on_field = "  SELECT * FROM `sitemanager`  WHERE `"+field+"` = '"+value+"' " ;
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
      _query =   "  SELECT * FROM `sitemanager`  "+WhereClause+" "+OrderByClause ;
      _stmt = _conn.createStatement();
      _result  = _stmt.executeQuery(_query); 
      return _result ;
  } // end method openTable();

/* Additional table opening method as MySQL supports pagination through limit and offset key words */	
  public ResultSet  openTable(String WhereClause, String OrderByClause, int nLimit, int nOffSet )
  throws java.sql.SQLException
  {
      _conn = Connect();
	   if(_conn==null) return null;
     _query =   "  SELECT * FROM `sitemanager`  "+WhereClause+" "+OrderByClause+" LIMIT "+nLimit+" OFFSET "+nOffSet+" " ;
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
 java.sql.Connection conn = Connect();
 if(conn==null) return 0;
 String query_count = "  SELECT COUNT(*) FROM `sitemanager`  "+WhereClause;
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
	
private  String escapeQuote(String src)
{
	   if(src.contains("'")) src = src.replace("'", "''");
		 return src;
} // end method escapeQuotes
	


} /* End of class declaration for SitemanagerBean */	


