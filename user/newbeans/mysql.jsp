<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.* " %><%@ page import="com.beanwiz.*, com.webapp.utils.*" %><jsp:useBean id="OverrideMap" scope="session" class="java.util.TreeMap" /><%
     
String DriverName= request.getParameter("DriverName");
String BeanName = request.getParameter("BeanName");
String BeanClass = request.getParameter("BeanClass");
String BeanPackage = request.getParameter("BeanPackage");
String JNDIDSN   = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String IDField  =  request.getParameter("IDField");
IDField = IDField.trim() ;
String IDFieldType = request.getParameter("IDFieldType") ;

 String ContentType =  "application/x-download" ;
 String ContentDisp = "attachment; filename="+BeanClass+".java";	
 response.setContentType(ContentType);
 response.setHeader("Content-Disposition", ContentDisp);
//  For Debug: response.setContentType("text/plain");

String Database = null ;

java.util.Vector columns = new java.util.Vector();
int n = 0;     // variable for iteration
int count=0;   // variable for number of columns
String AutoColVariable = null ; // variable for name of auto-incremental column
boolean bIntegerIDField = true; // boolean flag, wheter ID field is integer or not ?
String Quotes=""; // ' Quote needed for character expression in SQL string

/* 
  Decide about data type of ID field int or String accrordingly 
  data access method will be defined. Needed for methods
	(1) locateRecord (2) updateRecord (3) deleteRecord .
*/

if("INT".equalsIgnoreCase(IDFieldType))
{
   // ID field is Integer quotes not needed in SQL expression.
   bIntegerIDField=true;
	 Quotes="";
}
else
{
   // ID field is Character type, quotes needed in SQL expression
 		bIntegerIDField=false;
	  Quotes="'";
}
 
Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
com.webapp.utils.PortableSQL _psql = new com.webapp.utils.PortableSQL(conn);
DatabaseMetaData md = conn.getMetaData() ;
Database = conn.getCatalog();
if(Database == null )
{
   // Do some stupid guesswork :
	    Database = JNDIDSN.substring(JNDIDSN.indexOf("/",0)+1 );
}

String query = BeanwizHelper.openTableSQL(conn, TableName);

try 
{

java.sql.Statement stmt = conn.createStatement();
java.sql.ResultSet rslt = stmt.executeQuery(query);
java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
count  = rsmd.getColumnCount();
     
StringBuffer AddSQL = new StringBuffer("INSERT INTO `"+TableName+"` ( " );
StringBuffer UpdSQL = new StringBuffer("UPDATE `"+TableName+"` SET ");
String DeleteSQL = " DELETE FROM `"+TableName+"` WHERE `"+TableName+"`.`"+IDField+"` = ";
String LocateSQL = " SELECT *  FROM `"+TableName+"` WHERE  `"+TableName+"`.`"+IDField+"` = ";
String OpenTableSQL = " SELECT * FROM `"+TableName+"` ";
String RecordCountSQL= " SELECT COUNT(*) FROM `"+TableName+"` ";
// Poll through all column

for( n = 1 ; n <= count ; n++ )
{
com.beanwiz.TableColumn col = new com.beanwiz.TableColumn();
col.ColNo= n;
col.ColName = rsmd.getColumnName(n);
col.ColSQLType = rsmd.getColumnType(n);
col.ColTypeName = rsmd.getColumnTypeName(n);
col.ColSize = rsmd.getColumnDisplaySize(n);
col.Precision = rsmd.getPrecision(n);
col.Scale = rsmd.getScale(n);
col.VarName = com.beanwiz.ColumnName.colVarName(col.ColName);
col.Auto = rsmd.isAutoIncrement(n);
if(col.Auto)AutoColVariable=col.VarName;
  // check column data type

   // CHECK FOR COLUMN SQL TYPE OVERRIDE
	  String col_key = Database+"."+TableName+"."+col.ColName ;	
	  if( OverrideMap !=null && OverrideMap.containsKey(col_key) )
	  {
	     col.TypeOverride = true;
			 try
			 {
			    col.ColSQLType = Integer.parseInt( (String)OverrideMap.get(col_key) );
			 }catch(NumberFormatException ex)
			 {
			  // revert back to original type
			   col.ColSQLType = rsmd.getColumnType(n);
			 }
			col.ColTypeName = ColTypeOverride.typeLabel(col.ColSQLType) ;
	 }  // end if
	
	
	
//### Include column intitialization
%><%@ include file="COL-INIT.inc" %><%
         
  // Add column to list
  columns.add(col);	 
	 
 AddSQL.append("`"+rsmd.getColumnName(n)+"`"+((n < count)?", ":" "  ));
 UpdSQL.append("`"+rsmd.getColumnName(n)+"` = ?"+((n < count)?", ":" "  ) );
} // end for loop

AddSQL.append(") VALUES ( ");
if(IDField.length() > 0)
{
UpdSQL.append(" WHERE `"+TableName+"`.`"+IDField+"` = ");
}

for( n = 1 ; n <= count ; n++ )
{
AddSQL.append( "?"+((n < count)?", ":" "  )) ;
}
AddSQL.append(" )");
//response.setContentType("application/x-download");
//response.setHeader("Content-Disposition", BeanClass+".java");
//java.sql.Timestamp Now = new java.sql.Timestamp(System.currentTimeMillis()); 
%>package <%=BeanPackage %> ;
import  java.lang.* ;
import  java.io.* ;
import  java.sql.* ;
import  javax.naming.* ;
import  javax.sql.* ;	

/*
   Code generated on : <%=com.webapp.utils.DateHelper.showNow() %>
   The code is customized for MySQL  - <%=DriverName %> driver.
   The JDBC driver version is : <%=md.getDriverVersion() %>
	 Autonumber column is : <%=AutoColVariable %>
	 
    <%=BeanClass %>.addRecord()
    <%=BeanClass %>.beginInsert()
    <%=BeanClass %>.continueInsert()
    <%=BeanClass %>.endInsert()
    
    <%=BeanClass %>.updateRecord(int update_<%=AutoColVariable %>)
    <%=BeanClass %>.deleteRecord(int delete_<%=AutoColVariable %>)	 
    
    <%=BeanClass %>.locateRecord(int locate_<%=AutoColVariable %>)
    <%=BeanClass %>.locateOnField(String field, String value)
    <%=BeanClass %>.locateMultipleField(String fields, String values)
    <%=BeanClass %>.clearData()
    
    <%=BeanClass %>.openTable(String WhereClause, String OrderByClause)
    <%=BeanClass %>.joinopenTable(String Join, String JoinTableName, String OnIDField, String WhereClause, String OrderByClause)
    
    <%=BeanClass %>.openTable(String WhereClause, String OrderByClause, int nLimit, int nOffSet)
    
    <%=BeanClass %>.nextRow()
    <%=BeanClass %>.lastRow()
    <%=BeanClass %>.skipRow()
    
    <%=BeanClass %>.closeTable()
    
    <%=BeanClass %>.executeUpdate(java.lang.String query)
    
    <%=BeanClass %>.openQuery(String query)
    <%=BeanClass %>.closeQuery()
    
    <%=BeanClass %>.recordCount(String WhereClause)
    <%=BeanClass %>.joinrecordCount(String Join, String JoinTableName, String OnIDField, String WhereClause)

*/
public class <%=BeanClass %>
{
	
/* JNDI data source name of database */
	public String _datasource = "<%=JNDIDSN %>" ;
/* Table name in SQL databse */
	public String _tablename = "<%=TableName %>"; 
/* Special public variable to hold last autonumber value */
	public int _autonumber = 0 ;
	
/* Variable to hold last error */
  public String lasterror=null;	
	
/* Variables corrosponding to table fields - field count: <%=columns.size() %> */
	 <%@ include file="FIELD-VARS.inc" %>

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
   conx = DriverManager.getConnection ("jdbc:mysql://localhost/<%=JNDIDSN.substring("jdbc/".length() ) %>", "root", "");
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

public void copyTo(<%=BeanPackage %>.<%=BeanClass %> other )
{
<%
for (n=0 ; n<count ; n++)
{ 
out.print("   other."+((com.beanwiz.TableColumn)columns.get(n)).VarName+" = this."+((com.beanwiz.TableColumn)columns.get(n)).VarName+" ;\r\n" );
}  
%>	
}

/* Copy Fields from other objects of same kind */

public void copyFrom(<%=BeanPackage %>.<%=BeanClass %> other )
{
<%
for (n=0 ; n<count ; n++)
{ 
out.print("   this."+((com.beanwiz.TableColumn)columns.get(n)).VarName+" = other."+((com.beanwiz.TableColumn)columns.get(n)).VarName+" ;\r\n" );
}  
%>	
}

/* Clear field instance variable data */
public void clearData()
{<%
   out.print("\r\n");
	 for (n=0 ; n<count ; n++)
	 { 
    out.print("\tthis."+((com.beanwiz.TableColumn)columns.get(n)).VarName+((com.beanwiz.TableColumn)columns.get(n)).NullInit+" \r\n");
	 } 
	%>
} // End Method clearData




/* Move data from class variables to statement fields */
public void storeData(java.sql.PreparedStatement stmt )
throws java.sql.SQLException 
{
<%
	for (n=0 ; n<count ; n++){ 
	out.print("stmt."+((com.beanwiz.TableColumn)columns.get(n)).SetMethod+"; \r\n" );
	}  
	%>	
} // end method storeData()
	 
/* Move data from result set fields to class variables */

public void loadData(java.sql.ResultSet rslt)
throws java.sql.SQLException
{
<%
for (n=0 ; n<count ; n++)
{ 
out.print(((com.beanwiz.TableColumn)columns.get(n)).VarName+" = rslt."+((com.beanwiz.TableColumn)columns.get(n)).GetMethod+"; \r\n" );
}  
%>	
}// end method loadData();
	 
/* Add new record from class variable */
public boolean addRecord()
throws java.sql.SQLException 
{
 boolean bAdded = false ;
 java.sql.Connection conn = Connect();
 if(conn==null)return false;
 
 try{
    String query_add = " <%=AddSQL.toString() %> ";
    java.sql.PreparedStatement stmt_add = conn.prepareStatement(query_add, Statement.RETURN_GENERATED_KEYS);
    // move data from bean variables to prepared statement
    storeData(stmt_add);
    if( stmt_add.executeUpdate() == 1) bAdded = true ;
		
		<% 
		if(AutoColVariable!=null)
		{
		 %>
    java.sql.ResultSet rs_auto = stmt_add.getGeneratedKeys();
    if (rs_auto.next())  _autonumber = rs_auto.getInt(1);
	  else _autonumber=0;
		rs_auto.close();
		<% 
		} 
		%>
		
    stmt_add.close();
    }
 finally
    {
      Disconnect(conn) ;
    }
		<% if(AutoColVariable!=null)
			 {
		 %>
     /* 
       If the JDBC driver has detected auto_increment field properly
       than move auto generated key value to that field variable.
     */
     if ( _autonumber > 0 ) <%=AutoColVariable %> = _autonumber ;
		 
	  <% } %>
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
  String query_insert = " <%=AddSQL.toString() %> ";
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
	<% 
  if(AutoColVariable!=null)
	{
	%>
   java.sql.ResultSet rs_auto_ins = _stmt_insert.getGeneratedKeys();
   if (rs_auto_ins.next() ) _autonumber = rs_auto_ins.getInt(1);
   else _autonumber=0;
   rs_auto_ins.close();
    /* 
       If the JDBC driver has detected auto_increment field properly
       than move auto generated key value to that field variable.
     */
     if ( _autonumber > 0 ) <%=AutoColVariable %> = _autonumber ;
<% } %>
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
<% if(bIntegerIDField)
   {
 %>public boolean updateRecord(int update_<%=IDField %>)
<% }
   else
	 {
  %>public boolean updateRecord(String update_<%=IDField %>)	
<% } %>	throws java.sql.SQLException 
{
<%   
  if(!bIntegerIDField)
	{
 %>  update_<%=IDField %> = escapeQuote(update_<%=IDField %>);
<% 	
  } 
%>
  boolean bUpdated = false ;
  java.sql.Connection conn = Connect();
	if(conn==null) return false ;
  try
	  {
    String query_update = " <%=UpdSQL %><%=Quotes %>"+update_<%=IDField %>+"<%=Quotes %> " ;
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
<% if(bIntegerIDField)
   {
 %>public boolean deleteRecord(int delete_<%=IDField %>)
<% }
   else
	 {
  %>public boolean deleteRecord(String delete_<%=IDField %>)	
<% } %>throws java.sql.SQLException 
{
<%   
  if(!bIntegerIDField)
	{
 %>  delete_<%=IDField %> = escapeQuote(delete_<%=IDField %>);
<% 	
  } 
%>
 boolean bDeleted = false ;
 java.sql.Connection conn =  Connect();
 if(conn==null) return false ;
 try{
    String query_del = " <%=DeleteSQL %><%=Quotes %>"+delete_<%=IDField %>+"<%=Quotes %> " ;
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
<% if(bIntegerIDField)
   {
 %>public boolean  locateRecord(int locate_<%=IDField %> )
<% }
   else
	 {
  %>public boolean  locateRecord(String locate_<%=IDField %> )
<% } %>throws java.sql.SQLException 
{
<%   
  if(!bIntegerIDField)
	{
 %>  locate_<%=IDField %> = escapeQuote(locate_<%=IDField %>);
<% 	
  } 
%>
 boolean bLocated = false ;
 java.sql.Connection conn = Connect();
 if(conn==null)return false;
 try{
    String query_locate = " <%=LocateSQL %><%=Quotes %>"+locate_<%=IDField %>+"<%=Quotes %> " ;
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
    String query_locate_on_field = " <%=OpenTableSQL  %> WHERE `"+field+"` = '"+value+"' " ;
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
		StringBuilder sbQry  = new StringBuilder( " SELECT * FROM `<%=TableName %>` WHERE ") ;
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
} // end method locateMultipleField();


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
      _query =   " <%=OpenTableSQL %> "+WhereClause+" "+OrderByClause ;
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
      _query =   " <%=OpenTableSQL %> "+Join+" `"+JoinTableName+"` ON (`<%=TableName %>`.`"+OnIDField+"` = `"+JoinTableName+"`.`"+OnIDField+"`) "+WhereClause+" "+OrderByClause ;
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
     _query =   " <%=OpenTableSQL %> "+WhereClause+" "+OrderByClause+" LIMIT "+nLimit+" OFFSET "+nOffSet+" " ;
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

  public boolean lastRow()
  throws java.sql.SQLException
  {
      boolean retVal=false;
      if(_result==null)return false;
      retVal=_result.last();
      if(retVal==true)loadData(_result);
      return retVal;
  } // end method lastRow();
	
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
	query_count = "SELECT COUNT(*) FROM (<%=RecordCountSQL %> "+WhereClause+") AS X ";
 }
 else
 {
	query_count = "<%=RecordCountSQL %> "+WhereClause;	 
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
	query_count = "SELECT COUNT(*) FROM (<%=RecordCountSQL %> "+Join+" `"+JoinTableName+"` ON (`<%=TableName %>`.`"+OnIDField+"` = `"+JoinTableName+"`.`"+OnIDField+"`)  "+WhereClause+") AS X ";
 }
 else
 {
	query_count = "<%=RecordCountSQL %> "+Join+" `"+JoinTableName+"` ON (`<%=TableName %>`.`"+OnIDField+"` = `"+JoinTableName+"`.`"+OnIDField+"`)  "+WhereClause;	 
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
	


} /* End of class declaration for <%=BeanClass %> */	

<%
stmt.close(); 
}
finally
{
	conn.close();
}
 %>
