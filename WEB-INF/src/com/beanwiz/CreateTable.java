package com.beanwiz ;
import java.util.*;
import java.math.*;
import java.sql.*;
import javax.sql.*;

import javax.naming.*;
import com.webapp.utils.* ;
public class CreateTable
{

// BEFORE TABLE CREATE




public static String getTableCreateScript(short eng, String jndidsn, String table, String idfield, boolean auto_inc , java.util.TreeMap ovrd )
throws javax.naming.NamingException, java.sql.SQLException
{
     StringBuffer sb = new StringBuffer();
		 
	   Context env = (Context) new InitialContext().lookup("java:comp/env");
     DataSource source = (DataSource) env.lookup(jndidsn);
     Connection conn = source.getConnection();
     try
		 {
     
    		 String Database = conn.getCatalog();
    	   if(Database == null )
         {
            // Do some stupid guesswork :
    	      Database = jndidsn.substring(jndidsn.indexOf("/",0)+1 );
         }
    		 
    		 java.sql.Statement stmt = conn.createStatement();
         java.sql.ResultSet rslt = null ;
         com.webapp.utils.PortableSQL psql = new com.webapp.utils.PortableSQL(conn);
         rslt = stmt.executeQuery(psql.SQL(" SELECT * FROM `"+table+"` " )); 
         java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
         int count  = rsmd.getColumnCount();
    		 
    		  sb.append( beforeTableCreate( eng, table, idfield , auto_inc  ) );
    		   for(int n = 1 ; n <= count ; n++ )
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
               // Fallback  strategy, if the driver is incapable of detecting auto-incrementing 
    				   // colums or database may not support it as in case of oracle. 
    				   // Check to see if the identity column is requested by the user
    				 
    				  if(col.Auto==false)
    				  {
    				     if(col.ColName.equalsIgnoreCase(idfield) && auto_inc==true)
    						 {
    						   col.Auto =true;
    						 }
    				  }
    			   // Check to see if there is column type override
    				  String col_key = Database+"."+table+"."+col.ColName ;	
    	        if( ovrd !=null && ovrd.containsKey(col_key) )
    	        {
    	            col.TypeOverride = true;
    			        try
    			        {
    			            col.ColSQLType = Integer.parseInt( (String)ovrd.get(col_key) );
    			        }catch(NumberFormatException ex)
    			        {
    			             // revert back to original type
    			           col.ColSQLType = rsmd.getColumnType(n);
    			        }
    			        col.ColTypeName = ColTypeOverride.typeLabel(col.ColSQLType) ;
    	        }  // end if( ovrd !=null )
    	        sb.append( createLineForCol (eng, col,  (short)count, (short)n ) );
    					
    			   
           } // end - for(int n = 1 ; n <= count ; n++ )
    		   sb.append(afterTableCreate( eng , table, idfield , auto_inc  ));
		 }
		 catch(Exception e)
		 {
		 
		 }
		 finally
		 {
		   try{ conn.close(); }catch(Exception e2){}
		 }	 
			 
     return sb.toString()	;
		 
}

public static String dropTableStatement(short eng, String table )
{
    String ret = "" ; 
	   switch(eng)
		 {
         case  PortableSQL.UNKNOWN :
            ret = " DROP TABLE IF EXISTS  "+table+"  ;" ;
          break; 
   
          case  PortableSQL.MYSQL :
            ret = " DROP TABLE IF EXISTS  `"+table+"`  ;" ;
          break; 
   
          case  PortableSQL.POSTGRE :
            ret = " DROP TABLE IF EXISTS  \""+table+"\"  ;" ;
          break; 
   
          case  PortableSQL.DB2 :
            ret = " DROP TABLE IF EXISTS  \""+table+"\"  ;" ;
          break; 
   
          case  PortableSQL.MSSQL :
            ret = " DROP TABLE IF EXISTS  ["+table+"]  ;" ;
          break;
   
          case  PortableSQL.ORACLE : 
            ret = " DROP TABLE IF EXISTS  \""+table+"\"  ;" ;
          break;
   
          case  PortableSQL.H2 :
            ret = " DROP TABLE IF EXISTS  \""+table+"\"  ;" ;
          break;
   
          case  PortableSQL.SQLITE : 
            ret = " DROP TABLE IF EXISTS  "+table+"  ;" ;
          break;
		  
	        default:
           ret = " DROP TABLE IF EXISTS  "+table+"  ;" ;
	        break ;
		  
     } 
    return ret ;
} // end method


public static String  beforeTableCreate( short eng, String table, String IdCol , boolean isAuto  )
{  
    String ret = "" ;
        switch(eng)
        {   
          case  PortableSQL.UNKNOWN :
            ret = preCreateForUnknown(  table,   IdCol ,   isAuto ) ;
          break; 
   
          case  PortableSQL.MYSQL :
            ret = preCreateForMySQL(  table,   IdCol ,   isAuto ) ;
          break; 
   
          case  PortableSQL.POSTGRE :
            ret = preCreateForPostgre(  table,   IdCol ,   isAuto ) ;
          break; 
   
          case  PortableSQL.DB2 :
            ret = preCreateForIbmDB2(  table,   IdCol ,   isAuto ) ;
          break; 
   
          case  PortableSQL.MSSQL :
            ret = preCreateForMSSQL(  table,   IdCol ,   isAuto ) ;
          break;
   
          case  PortableSQL.ORACLE : 
            ret = preCreateForOracle(  table,   IdCol ,   isAuto ) ;
          break;
   
          case  PortableSQL.H2 :
            ret = preCreateForH2(  table,   IdCol ,   isAuto ) ;
          break;
   
          case  PortableSQL.SQLITE : 
            ret = preCreateForSqlite(  table,   IdCol ,   isAuto ) ;
          break;
		  
	     default:
           ret = preCreateForDefault(  table,   IdCol ,   isAuto ) ;
	     break ;
		  
        } 
    return ret  ;
	
} // end method beforeTableCreate



///////////// AFTER TABLE CREATE

public static String  afterTableCreate( short eng , String table, String IdCol , boolean isAuto  )
{ 
    String ret = "" ;
        switch(eng)
        {   
          case  PortableSQL.UNKNOWN :
            ret = postCreateForUnknown(  table,   IdCol ,   isAuto ) ;
          break; 
   
          case  PortableSQL.MYSQL :
            ret = postCreateForMySQL(  table,   IdCol ,   isAuto ) ;
          break; 
   
          case  PortableSQL.POSTGRE :
            ret = postCreateForPostgre(  table,   IdCol ,   isAuto ) ;
          break; 
   
          case  PortableSQL.DB2 :
            ret = postCreateForIbmDB2(  table,   IdCol ,   isAuto ) ;
          break; 
   
          case  PortableSQL.MSSQL :
            ret = postCreateForMSSQL(  table,   IdCol ,   isAuto ) ;
          break;
   
          case  PortableSQL.ORACLE : 
            ret = postCreateForOracle(  table,   IdCol ,   isAuto ) ;
          break;
   
          case  PortableSQL.H2 :
            ret = postCreateForH2(  table,   IdCol ,   isAuto ) ;
          break;
   
          case  PortableSQL.SQLITE : 
            ret = postCreateForSqlite(  table,   IdCol ,   isAuto ) ;
          break;
		  
	      default:
           ret = postCreateForDefault(  table,   IdCol ,   isAuto ) ;
	      break ;
        } 
     return ret ;  
	   
} // end method afterTableCreate



public static String  createLineForCol ( short eng, com.beanwiz.TableColumn colinfo, short count, short no  )
{ 
    String ret="";
        switch(eng)
        {   
          case  PortableSQL.UNKNOWN :
            ret = colForUnknown(colinfo, count, no ) ;
          break; 
   
          case  PortableSQL.MYSQL :
            ret = colForMySQL(colinfo, count, no  ) ;
          break; 
   
          case  PortableSQL.POSTGRE :
            ret = colForPostgre(colinfo, count, no  ) ;
          break; 
   
          case  PortableSQL.DB2 :
             ret = colForIbmDB2(colinfo, count, no  ) ;
          break; 
   
          case  PortableSQL.MSSQL :
             ret = colForMSSQL(colinfo, count, no  ) ;
          break;
   
          case  PortableSQL.ORACLE : 
            ret = colForOracle(colinfo, count, no  ) ;
          break;
   
          case  PortableSQL.H2 :
             ret = colForH2(colinfo, count, no  ) ;
          break;
   
          case  PortableSQL.SQLITE : 
            ret = colForSqlite(colinfo, count, no  ) ;
          break;
		  
    	  default:
           ret = colForDefault(colinfo, count, no  ) ;
	      break ;
		  
        } 
     return ret ;
} // end method CreateLineForCol


    public static String  colForUnknown(com.beanwiz.TableColumn colinfo, short count, short no  ) 
    {
      String ret="" ;
      return ret ;	
    } // end mehod colForUnknown

    public static String preCreateForUnknown( String table, String IdCol , boolean isAuto )
	{
      String ret="" ;
      return ret ;	
	} // end mehod preCreateForUnknown
    public static String postCreateForUnknown( String table, String IdCol , boolean isAuto )
	{
      String ret="" ;
      return ret ;	
	} // postCreateForUnknown

   // ----------------------- MYSQL ----------------------


    public static String  colForMySQL(com.beanwiz.TableColumn colinfo, short count, short no  ) 
    {
      String ret="" ;
	    if(colinfo.Auto ) 
	    {
	      return " `"+colinfo.ColName+"` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY "+( (count > no)? ",":" ")+"\r\n" ;
	    }
	    switch(colinfo.ColSQLType)
		{ 
            case java.sql.Types.ARRAY :
            case java.sql.Types.DATALINK :
            case java.sql.Types.DISTINCT :
            case java.sql.Types.JAVA_OBJECT :
            case java.sql.Types.NULL :
            case java.sql.Types.OTHER :
            case java.sql.Types.REF :
            case java.sql.Types.ROWID :
            case java.sql.Types.STRUCT :
            break ;
		
	        case java.sql.Types.BOOLEAN :
            case java.sql.Types.BIT :
            ret=" `"+colinfo.ColName+"` BIT(1)   DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	        case java.sql.Types.TINYINT :
            ret=" `"+colinfo.ColName+"` TINYINT(4)   DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	        case java.sql.Types.SMALLINT :
            ret=" `"+colinfo.ColName+"` SMALLINT(6)   DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	        case java.sql.Types.INTEGER :
            ret=" `"+colinfo.ColName+"` INT(11)   DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	        case java.sql.Types.BIGINT :
            ret=" `"+colinfo.ColName+"` BIGINT(20)   DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	        case java.sql.Types.FLOAT :
            ret=" `"+colinfo.ColName+"` FLOAT  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;
    
	        case java.sql.Types.REAL :		
            case java.sql.Types.DOUBLE :
            ret=" `"+colinfo.ColName+"` DOUBLE  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	        case java.sql.Types.NUMERIC :		
          case java.sql.Types.DECIMAL :
            ret=" `"+colinfo.ColName+"` DECIMAL("+colinfo.Precision+","+colinfo.Scale+")  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            case java.sql.Types.NCHAR :
            case java.sql.Types.CHAR :
            ret=" `"+colinfo.ColName+"` CHAR("+colinfo.Precision+")  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	        case java.sql.Types.NVARCHAR :
          case java.sql.Types.VARCHAR :
            ret=" `"+colinfo.ColName+"` VARCHAR("+colinfo.Precision+")  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

          case java.sql.Types.DATE :
            ret=" `"+colinfo.ColName+"` DATE  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	        case java.sql.Types.TIME :
            ret=" `"+colinfo.ColName+"` TIME  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;
          case java.sql.Types.TIMESTAMP :
            ret=" `"+colinfo.ColName+"` DATETIME  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	        case java.sql.Types.CLOB :
          case java.sql.Types.SQLXML :
          case java.sql.Types.NCLOB :
          case java.sql.Types.LONGNVARCHAR :
          case java.sql.Types.LONGVARCHAR :
            ret=" `"+colinfo.ColName+"` LONGTEXT  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

	        case java.sql.Types.BINARY :
            case java.sql.Types.BLOB :
            case java.sql.Types.LONGVARBINARY :
            case java.sql.Types.VARBINARY :
            ret=" `"+colinfo.ColName+"` LONGBLOB  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;
		}
	  
      return ret ;	
    } // end mehod colForMySQL

    public static String preCreateForMySQL(String table, String IdCol , boolean isAuto )
	{
      String ret=" CREATE TABLE IF NOT EXISTS `"+table+"` (\r\n" ;
      return ret ;	
	} // end mehod preCreateForMySQL
    public static String postCreateForMySQL(String table, String IdCol , boolean isAuto )
	{
      String ret=" ) ENGINE=MyISAM DEFAULT CHARSET=utf8 ;\r\n" ;
      return ret ;	
	} // end mehod postCreateForMySQL
	
   // ------------------------ POSTGRE --------------------

    public static String  colForPostgre(com.beanwiz.TableColumn colinfo, short count, short no  ) 
    {
       String ret="" ;
  	   if(colinfo.Auto ) 
	     {
	      return   " \""+colinfo.ColName+"\" SERIAL NOT NULL  PRIMARY KEY "+( (count > no)? ",":" ")+"\r\n" ;
	     }
       switch(colinfo.ColSQLType)
			 {
           case java.sql.Types.NULL : 
           case java.sql.Types.ARRAY : 
           case java.sql.Types.DATALINK : 
           case java.sql.Types.DISTINCT :
           case java.sql.Types.JAVA_OBJECT : 
           case java.sql.Types.REF :
           case java.sql.Types.STRUCT  :
           case java.sql.Types.ROWID : 
           case java.sql.Types.OTHER : 
            break ;

           case java.sql.Types.BOOLEAN :
           case java.sql.Types.BIT :
            ret = " \""+colinfo.ColName+"\"  boolean  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

           case java.sql.Types.TINYINT : 
           case java.sql.Types.SMALLINT : 
            ret = " \""+colinfo.ColName+"\"  smallint  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;  
 
           case java.sql.Types.INTEGER : 
            ret = " \""+colinfo.ColName+"\"  integer  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;  
			
           case java.sql.Types.BIGINT : 
            ret = " \""+colinfo.ColName+"\"  bigint  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;  

           case java.sql.Types.FLOAT : 
           case java.sql.Types.DOUBLE : 
            ret = " \""+colinfo.ColName+"\"  double precision  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;  
			
           case java.sql.Types.REAL : 
            ret = " \""+colinfo.ColName+"\"  real  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;  
			
           case java.sql.Types.NUMERIC : 
            ret = " \""+colinfo.ColName+"\"  numeric("+colinfo.Precision+","+colinfo.Scale+")   DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;  
			
           case java.sql.Types.DECIMAL : 
            ret = " \""+colinfo.ColName+"\"  money("+colinfo.Precision+","+colinfo.Scale+")   DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;  
			
           case java.sql.Types.CHAR : 
           case java.sql.Types.NCHAR : 
            ret = " \""+colinfo.ColName+"\"  char("+colinfo.Precision+")  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;  
			
           case java.sql.Types.VARCHAR : 
           case java.sql.Types.NVARCHAR : 
            ret = " \""+colinfo.ColName+"\"  varchar("+colinfo.Precision+")  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
	        break ;

           case java.sql.Types.DATE :
            ret = " \""+colinfo.ColName+"\"  date  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
	        break ;
 
           case java.sql.Types.TIME :
            ret = " \""+colinfo.ColName+"\"  time  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
	        break ;
 
           case java.sql.Types.TIMESTAMP :
            ret = " \""+colinfo.ColName+"\"  timestamp  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
	        break ;
	  

           case java.sql.Types.CLOB :
           case java.sql.Types.NCLOB :
           case java.sql.Types.LONGNVARCHAR :
           case java.sql.Types.LONGVARCHAR :
           case java.sql.Types.SQLXML :
            ret = " \""+colinfo.ColName+"\"  text  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break ;
	  
           case java.sql.Types.BLOB :
           case java.sql.Types.LONGVARBINARY :
           case java.sql.Types.VARBINARY :
           case java.sql.Types.BINARY :
            ret = " \""+colinfo.ColName+"\"  bytea  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;  
			 }
	  
      return ret ;	
    } // end mehod colForPostgre
	
    public static String preCreateForPostgre(String table, String IdCol , boolean isAuto )
	{
      String ret=" CREATE TABLE \""+table+"\" (\r\n"  ;
      return ret ;	
	}  // end method preCreateForPostgre
    public static String postCreateForPostgre(String table, String IdCol , boolean isAuto )
	{
      String ret= " ) ;\r\n" ;
      return ret ;	
	} // end mehod postCreateForPostgre
	
   // ------------------------IBM DB@ --------------------

    public static String  colForIbmDB2(com.beanwiz.TableColumn colinfo, short count, short no  ) 
    {
      String ret="" ;
   	  if(colinfo.Auto ) 
	    {
	      return " \""+colinfo.ColName+"\" INT NOT NULL GENERATED  BY DEFAULT  AS IDENTITY PRIMARY KEY "+( (count > no)? ",":" ")+"\r\n" ;
	    }
		switch(colinfo.ColSQLType)
		{

           case  java.sql.Types.ARRAY :
           case  java.sql.Types.DISTINCT :
           case  java.sql.Types.JAVA_OBJECT :
           case  java.sql.Types.NULL :
           case  java.sql.Types.OTHER :
           case  java.sql.Types.REF :
           case  java.sql.Types.STRUCT :
           break;
 
           case  java.sql.Types.DATALINK :
            ret = " \""+colinfo.ColName+"\" DATALINK DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
           break;
 
           case  java.sql.Types.ROWID :
            ret = " \""+colinfo.ColName+"\" ROWID DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
           break;
           case  java.sql.Types.TINYINT :
           case  java.sql.Types.BOOLEAN :
           case  java.sql.Types.BIT :
           case  java.sql.Types.SMALLINT :
            ret = " \""+colinfo.ColName+"\" SMALLINT DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
           break;
 
           case  java.sql.Types.INTEGER :
            ret = " \""+colinfo.ColName+"\" INTEGER DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
           break;
 
           case  java.sql.Types.BIGINT :
            ret = " \""+colinfo.ColName+"\" BIGINT DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
           break;
 
           case  java.sql.Types.FLOAT :
           case  java.sql.Types.DOUBLE :
            ret = " \""+colinfo.ColName+"\" DOUBLE DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
           break;
 
           case  java.sql.Types.REAL :
            ret = " \""+colinfo.ColName+"\" REAL DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
           break;
	   
           case  java.sql.Types.NUMERIC :	   
           case  java.sql.Types.DECIMAL :
            ret = " \""+colinfo.ColName+"\" DECIMAL("+colinfo.Precision+","+colinfo.Scale+")  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
           break;
           case  java.sql.Types.CHAR :
             ret = " \""+colinfo.ColName+"\" CHAR("+colinfo.Precision+") DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
            break;

           case  java.sql.Types.NCHAR :
            ret = " \""+colinfo.ColName+"\" GRAPHIC("+colinfo.Precision+") DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
           break;
           case  java.sql.Types.VARCHAR :
             ret = " \""+colinfo.ColName+"\" VARCHAR("+colinfo.Precision+") DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
           break;

           case  java.sql.Types.NVARCHAR :
            ret = " \""+colinfo.ColName+"\" VARGRAPHIC("+colinfo.Precision+") DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
           break;
 
           case  java.sql.Types.DATE :
            ret = " \""+colinfo.ColName+"\" DATE DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
           break;
           case  java.sql.Types.TIME :
            ret = " \""+colinfo.ColName+"\" TIME DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
           break;
           case  java.sql.Types.TIMESTAMP :
            ret = " \""+colinfo.ColName+"\" TIMESTAMP DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
           break;
 
           case  java.sql.Types.SQLXML :
           case  java.sql.Types.CLOB :
           case  java.sql.Types.LONGVARCHAR :
            ret = " \""+colinfo.ColName+"\" LONGVARCHAR DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
	   
           case  java.sql.Types.NCLOB :
           case  java.sql.Types.LONGNVARCHAR :
            ret = " \""+colinfo.ColName+"\" LONGVARGRAPHIC DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
           break;

           case  java.sql.Types.BINARY :
           case  java.sql.Types.BLOB :
           case  java.sql.Types.LONGVARBINARY :
           case  java.sql.Types.VARBINARY :
            ret = " \""+colinfo.ColName+"\" BLOB DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
           break;

		
        } // end switch(colinfo.ColSQLType)
		
      return ret ;	
    } // end mehod  colForIbmDB2
    public static String preCreateForIbmDB2(String table, String IdCol , boolean isAuto )
	{
      String ret=" CREATE TABLE \""+table+"\" (\r\n" ;
      return ret ;	
	} // end mehod preCreateForIbmDB2
    public static String postCreateForIbmDB2(String table, String IdCol , boolean isAuto )
	{
      String ret=" ) ;\r\n" ;
      return ret ;	
	}  // end mehod postCreateForIbmDB2

	// ----------------------MS SQL ----------------------

    public static String  colForMSSQL(com.beanwiz.TableColumn colinfo, short count, short no  ) 
    {
      String ret="" ;
	    if(colinfo.Auto ) 
	    {
	      return  " ["+colinfo.ColName+"] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY "+( (count > no)? ",":" ")+"\r\n" ; 
	    }
		switch(colinfo.ColSQLType)
		{ 
 
        case java.sql.Types.ARRAY  : 
        case java.sql.Types.DATALINK  : 
        case java.sql.Types.DISTINCT  : 
        case java.sql.Types.JAVA_OBJECT  : 
        case java.sql.Types.NULL  : 
        case java.sql.Types.OTHER  : 
        case java.sql.Types.REF  : 
        case java.sql.Types.STRUCT  : 
        case java.sql.Types.ROWID  : 
        break;

        case java.sql.Types.BOOLEAN  : 
        case java.sql.Types.BIT  : 
         ret = " ["+colinfo.ColName+"]  bit DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
        break;


        case java.sql.Types.TINYINT  : 
         ret = " ["+colinfo.ColName+"]  tinyint DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ; 
        break;
        case java.sql.Types.SMALLINT  : 
         ret = " ["+colinfo.ColName+"]  smallint DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
        break;
        case java.sql.Types.INTEGER  : 
         ret= " ["+colinfo.ColName+"]  int DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
        break;
        case java.sql.Types.BIGINT  : 
         ret = " ["+colinfo.ColName+"]  bigint DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
        break;

        case java.sql.Types.FLOAT  : 
        case java.sql.Types.DOUBLE  : 
         ret = " ["+colinfo.ColName+"] float DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
        break;
        case java.sql.Types.REAL  : 
         ret = " ["+colinfo.ColName+"] real DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
        break;
        case java.sql.Types.NUMERIC  :
         ret = " ["+colinfo.ColName+"] numeric("+colinfo.Precision+","+colinfo.Scale+") DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ; 
        break;
        case java.sql.Types.DECIMAL  : 
         ret = " ["+colinfo.ColName+"] decimal("+colinfo.Precision+","+colinfo.Scale+") DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
        break;

        case java.sql.Types.CHAR  : 
        case java.sql.Types.NCHAR  : 
         ret = " ["+colinfo.ColName+"]  nchar("+colinfo.Precision+") DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
        break;
        case java.sql.Types.VARCHAR  :
        case java.sql.Types.NVARCHAR  : 
         ret = " ["+colinfo.ColName+"]  nvarchar("+colinfo.Precision+") DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ; 
        break;

        case java.sql.Types.DATE  : 
         ret = " ["+colinfo.ColName+"]  date DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
        break;
        case java.sql.Types.TIME  : 
         ret = " ["+colinfo.ColName+"]  time DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
        break;
        case java.sql.Types.TIMESTAMP  : 
         ret = " ["+colinfo.ColName+"] datetime DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
        break;

        case java.sql.Types.SQLXML  : 
        case java.sql.Types.CLOB  : 
        case java.sql.Types.NCLOB  : 
        case java.sql.Types.LONGNVARCHAR  : 
        case java.sql.Types.LONGVARCHAR  : 
          ret = " ["+colinfo.ColName+"]  ntext DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
         break;

        case java.sql.Types.BINARY  : 
        case java.sql.Types.BLOB  : 
        case java.sql.Types.LONGVARBINARY  : 
        case java.sql.Types.VARBINARY  : 
         ret = " ["+colinfo.ColName+"]  varbinary(max) DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
        break;

		} // end switch(colinfo.ColSQLType)
		return ret ;	
    } // end mehod  colForMSSQL
    public static String preCreateForMSSQL(String table, String IdCol , boolean isAuto )
    {
      String ret=" CREATE TABLE ["+table+"] (\r\n" ;
      return ret ;	
    }  // end mehod preCreateForMSSQL
    public static String postCreateForMSSQL(String table, String IdCol , boolean isAuto )
    {
      String ret=" ) ;\r\n" ;
      return ret ;	
    }  // end mehod postCreateForMSSQL

	// ----------------------ORACLE ------------------------	
	
    public static String  colForOracle(com.beanwiz.TableColumn colinfo, short count, short no  ) 
    {
      String ret="" ;
			if(colinfo.Auto ) 
	    {
	       return   " \""+colinfo.ColName+"\" INTEGER PRIMARY KEY NOT NULL "+( (count > no)? ",":" ")+"\r\n" ; 
	    }
		switch(colinfo.ColSQLType)
		{ 
          case java.sql.Types.ARRAY :
          case java.sql.Types.DATALINK :
          case java.sql.Types.JAVA_OBJECT :
          case java.sql.Types.NULL :
          case java.sql.Types.OTHER :
          case java.sql.Types.REF :
          case java.sql.Types.STRUCT :
          case java.sql.Types.ROWID :
           break;
		   
          case java.sql.Types.BOOLEAN :
          case java.sql.Types.BIT :
          ret = " \""+colinfo.ColName+"\" NUMBER(3) DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;
		  
          case java.sql.Types.NUMERIC :
          ret = " \""+colinfo.ColName+"\" NUMERIC("+colinfo.Precision+","+colinfo.Scale+") DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;
		  
          case java.sql.Types.TINYINT :
          ret = " \""+colinfo.ColName+"\" NUMBER(3) DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
		      break;
		   
          case java.sql.Types.SMALLINT :
          ret = " \""+colinfo.ColName+"\" NUMBER(5) DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;
		  
          case java.sql.Types.INTEGER :
          ret = " \""+colinfo.ColName+"\" NUMBER(10) DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;
		  
          case java.sql.Types.BIGINT :
          ret = " \""+colinfo.ColName+"\" NUMBER(19) DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;
		  
          case java.sql.Types.FLOAT :
          ret = " \""+colinfo.ColName+"\" BINARY_FLOAT DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;
 
          case java.sql.Types.REAL :		  
          case java.sql.Types.DOUBLE :
          ret = " \""+colinfo.ColName+"\" BINARY_DOUBLE DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;

          case java.sql.Types.DECIMAL :
          ret = " \""+colinfo.ColName+"\" DECIMAL("+colinfo.Precision+","+colinfo.Scale+") DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;
		  
          case java.sql.Types.CHAR :
          ret = " \""+colinfo.ColName+"\" CHAR("+colinfo.Precision+") DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;
		  
          case java.sql.Types.NCHAR :
          ret = " \""+colinfo.ColName+"\" NCHAR("+colinfo.Precision+") DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;
		  
          case java.sql.Types.VARCHAR :
          ret = " \""+colinfo.ColName+"\" VARCHAR2("+colinfo.Precision+") DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ; 
          break;
		  
          case java.sql.Types.NVARCHAR :
          ret = " \""+colinfo.ColName+"\" NVARCHAR2("+colinfo.Precision+") DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;

          case java.sql.Types.DATE :
          ret = " \""+colinfo.ColName+"\" DATE DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;
 
          case java.sql.Types.TIME :
          case java.sql.Types.TIMESTAMP :
          ret = " \""+colinfo.ColName+"\" TIMESTAMP DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;
 
          case java.sql.Types.SQLXML :
          case java.sql.Types.CLOB :
          case java.sql.Types.LONGVARCHAR :
          ret = " \""+colinfo.ColName+"\" CLOB DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;
 
          case java.sql.Types.LONGNVARCHAR :
          case java.sql.Types.NCLOB :
          ret = " \""+colinfo.ColName+"\" NCLOB DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;
		  
          case java.sql.Types.BINARY :
          case java.sql.Types.BLOB :
          case java.sql.Types.LONGVARBINARY :
          case java.sql.Types.VARBINARY :
          ret = " \""+colinfo.ColName+"\" BLOB DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;
		
		
		} // end switch(colinfo.ColSQLType)
		
      return ret ;	
    } // end mehod 

    public static String preCreateForOracle(String table, String IdCol , boolean isAuto )
    {
      String ret=" CREATE TABLE \""+table+"\" (\r\n" ;
      return ret ;	
    }  // end mehod 
    public static String postCreateForOracle(String table, String IdCol , boolean isAuto )
    {
      String ret=" ) \r\n"
			           +"/\r\n" 
			           +" CREATE sequence \""+table+"_SEQ\" \r\n" 
                 +"/\r\n"
			           +" CREATE OR REPLACE TRIGGER  \"BI_"+table+"\" \r\n" 
                 +" before insert on \""+table+"\"\r\n" 
                 +" for each row \r\n"
								 +" begin \r\n"
								 +"   select \""+table+"_SEQ\".nextval into :NEW.\""+IdCol+"\"  from dual;  \r\n"
								 +" end;  \r\n\r\n"
                 +"/\r\n"
								 +" ALTER TRIGGER  \"BI_"+table+"\" ENABLE  \r\n"
								 +"/\r\n" ;
			return ret ;	
	
    } // end mehod 

	// ------------------- H2 DB -----------------------	
	

    public static String  colForH2(com.beanwiz.TableColumn colinfo, short count, short no  ) 
    {
      String ret="" ;
		if(colinfo.Auto ) 
	    {
	      return " \""+colinfo.ColName+"\" INTEGER NOT NULL IDENTITY PRIMARY KEY "+( (count > no)? ",":" ")+"\r\n" ; 
	    }
		switch(colinfo.ColSQLType)
		{ 
         case java.sql.Types.NULL : 
           break ;
 
         case java.sql.Types.ARRAY : 
          ret =  " \""+colinfo.ColName+"\" ARRAY  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break ;
	  
         case java.sql.Types.DATALINK : 
         case java.sql.Types.DISTINCT :
         case java.sql.Types.JAVA_OBJECT : 
         case java.sql.Types.REF :
         case java.sql.Types.STRUCT  :
		 case java.sql.Types.ROWID :
         break ;
		 
         case java.sql.Types.OTHER : 
		  ret =  " \""+colinfo.ColName+"\"  OTHER  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break ;

         case java.sql.Types.BOOLEAN :
         case java.sql.Types.BIT :
          ret =  " \""+colinfo.ColName+"\"  BOOLEAN  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;

		  case java.sql.Types.TINYINT : 
          ret =" \""+colinfo.ColName+"\" TINYINT  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;  

         case java.sql.Types.SMALLINT : 
          ret =  " \""+colinfo.ColName+"\" SMALLINT  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;  
 
         case java.sql.Types.INTEGER : 
          ret =  " \""+colinfo.ColName+"\" INTEGER  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;  

		  case java.sql.Types.BIGINT : 
          ret =  " \""+colinfo.ColName+"\" BIGINT  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;  

         case java.sql.Types.FLOAT : 
         case java.sql.Types.DOUBLE : 
          ret =  " \""+colinfo.ColName+"\" DOUBLE  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
	      break;  
		  
         case java.sql.Types.REAL : 
          ret =  " \""+colinfo.ColName+"\" REAL  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;  

         case java.sql.Types.NUMERIC : 
         case java.sql.Types.DECIMAL : 
          ret =  " \""+colinfo.ColName+"\" DECIMAL("+colinfo.Precision+","+colinfo.Scale+")   DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
         break;  
		 
         case java.sql.Types.CHAR : 
         case java.sql.Types.NCHAR : 
          ret =  " \""+colinfo.ColName+"\" CHAR("+colinfo.Precision+")  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
         break;  

         case java.sql.Types.VARCHAR : 
         case java.sql.Types.NVARCHAR : 
          ret =  " \""+colinfo.ColName+"\" VARCHAR_IGNORECASE("+colinfo.Precision+")  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
	      break ;

         case java.sql.Types.DATE :
          ret =  " \""+colinfo.ColName+"\" DATE  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
	      break ;
 
         case java.sql.Types.TIME :
          ret =  " \""+colinfo.ColName+"\" TIME  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
	      break ;
 
         case java.sql.Types.TIMESTAMP :
          ret =  " \""+colinfo.ColName+"\" TIMESTAMP  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
	      break ;
	  

         case java.sql.Types.CLOB :
         case java.sql.Types.NCLOB :
         case java.sql.Types.LONGNVARCHAR :
         case java.sql.Types.LONGVARCHAR :
         case java.sql.Types.SQLXML :
          ret =  " \""+colinfo.ColName+"\" CLOB  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break ;
	  
	  
         case java.sql.Types.LONGVARBINARY :
         case java.sql.Types.VARBINARY :
         case java.sql.Types.BINARY :
          ret =  " \""+colinfo.ColName+"\" LONGVARBINARY  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
	      break ;
	  
         case java.sql.Types.BLOB :
          ret =  " \""+colinfo.ColName+"\" BLOB  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
          break;
		
		} // end switch(colinfo.ColSQLType)
		return ret ;	
    } // end mehod  


    public static String preCreateForH2(String table, String IdCol , boolean isAuto )
    {
      String ret=" CREATE  TABLE IF NOT EXISTS \""+table+"\" (\r\n" ;
      return ret ;	
    }  // end mehod 
    public static String postCreateForH2(String table, String IdCol , boolean isAuto )
    {
      String ret=" ) ;\r\n" ;
      return ret ;	
    } // end mehod 

   	// --------------------- SQLITE -----------------------
	
    public static String  colForSqlite(com.beanwiz.TableColumn colinfo, short count, short no  ) 
    {
       String ret="" ;
  		 if(colinfo.Auto ) 
	     {
	        return  " "+colinfo.ColName+"  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL "+( (count > no)? ",":" ")+"\r\n" ; 
	     }
		   switch(colinfo.ColSQLType)
		   { 
	         case java.sql.Types.ARRAY :
           case java.sql.Types.DATALINK : 
           case java.sql.Types.DISTINCT :
           case java.sql.Types.JAVA_OBJECT :
           case java.sql.Types.NULL :
           case java.sql.Types.OTHER :
           case java.sql.Types.REF :
           case java.sql.Types.ROWID : 
           case java.sql.Types.STRUCT :
              break;
           case java.sql.Types.BOOLEAN :
           case java.sql.Types.BIT : 
              ret = " "+colinfo.ColName+" BOOLEAN  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;
           case java.sql.Types.TINYINT : 
              ret = " "+colinfo.ColName+" TINYINT  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;
           case java.sql.Types.SMALLINT : 
              ret = " "+colinfo.ColName+" SMALLINT  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;
           case java.sql.Types.INTEGER : 
              ret = " "+colinfo.ColName+" INTEGER  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;
           case java.sql.Types.BIGINT : 
              ret = " "+colinfo.ColName+" BIGINT  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;

           case java.sql.Types.FLOAT : 
              ret = " "+colinfo.ColName+" FLOAT  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;

           case java.sql.Types.DOUBLE : 
              ret = " "+colinfo.ColName+" DOUBLE  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;
           case java.sql.Types.REAL : 
              ret = " "+colinfo.ColName+" REAL  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;

           case java.sql.Types.NUMERIC : 
              ret = " "+colinfo.ColName+" NUMERIC("+colinfo.Precision+","+colinfo.Scale+")  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;

           case java.sql.Types.DECIMAL : 
              ret = " "+colinfo.ColName+" DECIMAL("+colinfo.Precision+","+colinfo.Scale+")  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;

           case java.sql.Types.CHAR : 
           case java.sql.Types.NCHAR : 
              ret = " "+colinfo.ColName+" CHAR("+colinfo.Precision+")  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;

           case java.sql.Types.VARCHAR : 
           case java.sql.Types.NVARCHAR : 
              ret = " "+colinfo.ColName+" VARCHAR("+colinfo.Precision+")  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;

           case java.sql.Types.DATE : 
              ret = " "+colinfo.ColName+" DATE  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;
           case java.sql.Types.TIME :
              ret = " "+colinfo.ColName+" DATE  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;
           case java.sql.Types.TIMESTAMP : 
              ret = " "+colinfo.ColName+" TIMESTAMP  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;

           case java.sql.Types.SQLXML :		  
           case java.sql.Types.CLOB :
           case java.sql.Types.NCLOB :
           case java.sql.Types.LONGNVARCHAR : 
           case java.sql.Types.LONGVARCHAR :
              ret = " "+colinfo.ColName+" TEXT  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;

           case java.sql.Types.BINARY :
           case java.sql.Types.BLOB :
           case java.sql.Types.LONGVARBINARY :
           case java.sql.Types.VARBINARY :
              ret = " "+colinfo.ColName+" BLOB  DEFAULT NULL "+( (count > no)? ",":" ")+"\r\n" ;
              break;
		   } // end switch(colinfo.ColSQLType)
		//  
      return ret ;	
    } // end mehod 

    public static String preCreateForSqlite(String table, String IdCol , boolean isAuto )
    {
      String ret=" CREATE TABLE IF NOT EXISTS "+table+"  (\r\n" ;  
      return ret ;	
    } // end mehod 
    public static String postCreateForSqlite(String table, String IdCol , boolean isAuto )
    {
      String ret=" ) ; \r\n" ;
      return ret ;	
    } // end mehod 

	// ------------------- DEFAULT --------------------

    public static String  colForDefault(com.beanwiz.TableColumn colinfo, short count, short no  ) 
    {
      String ret="" ;
      return ret ;	
    } // end mehod colForDefault
    public static String preCreateForDefault(String table, String IdCol , boolean isAuto )
    {
      String ret="" ;
      return ret ;	
    } // end mehod 
    public static String postCreateForDefault(String table, String IdCol , boolean isAuto )
    {
      String ret=" ) \r\n" ;
      return ret ;	
    } // end mehod 

	
} // End class declaration CreateTable



