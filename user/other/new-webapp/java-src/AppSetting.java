package com.$WEBAPP ;
import com.webapp.utils.* ;
import java.lang.* ;
import java.io.* ;
import java.sql.* ;
import javax.naming.* ;
import javax.sql.* ;	
import com.webapp.utils.* ;
	
public class AppSetting 
{
	public final short NONE = 0;
	public final short BOOLVAL = 1;
	public final short INTVAL  = 2;
	public final short NUMVAL  = 3;
	public final short DATEVAL = 4;
	public final short TIMEVAL = 5;
	public final short CHARVAL = 6;
	
	public boolean Found = false ;
	public short Type = 0 ;
	public String Value = null ;
	public String URL = null ;
	
	com.webapp.utils.PortableSQL psql =null ;
	
	public AppSetting()
	{
	    psql = null;  // new com.webapp.utils.PortableSQL();
	}
	
	public AppSetting(short eng)
	{
	    psql = new com.webapp.utils.PortableSQL(eng);
	}
	
	public AppSetting(String streng)
	{
	    psql = new com.webapp.utils.PortableSQL( streng );
	}
	
	public AppSetting( javax.servlet.ServletContext cnt )
	{
	    psql = new com.webapp.utils.PortableSQL( cnt );
	}
	
	public boolean lookup( String itemname)
	{
	Type = 0 ;
	Value = null ;
	URL = null ;
	Found=false;
	try
	{
	    Context env = (Context) new InitialContext().lookup("java:comp/env");
	    DataSource source = (DataSource) env.lookup("jdbc/$DATABASE");
	    java.sql.Connection conn = source.getConnection();
		if( psql==null) psql = new com.webapp.utils.PortableSQL( conn );
	    String Qry = psql.SQL(" SELECT SQL_CACHE * FROM `appsetting` WHERE `appsetting`.`Name` = '"+itemname+"' " ) ;
		try
		{
		 	java.sql.Statement stmt = conn.createStatement();
			java.sql.ResultSet rslt = stmt.executeQuery(Qry);
			if(rslt.next())
			{
			 	Found = true ;
				Type = rslt.getShort("Type");
				Value = rslt.getString("Value");
				URL = rslt.getString("URL");
			}	    
			stmt.close();
		}
		finally
		{
 		    conn.close();
		}
	}
	catch(java.sql.SQLException exSQL){}
	catch(javax.naming.NamingException exNam ){}	
	return Found ;
	}
	

	public String getValue(String item )
	{
	   return (lookup(item))? Value: "" ;
	}	



	public boolean updateSettingItem(String itemname , String newvalue )
	{
		boolean bStatus = false;
		java.sql.Connection conn = null;
		try
		{
			Context env = (Context) new InitialContext().lookup("java:comp/env");
			DataSource source = (DataSource) env.lookup("jdbc/$DATABASE");
			try
			{
				conn = source.getConnection();
				if( psql==null) psql = new com.webapp.utils.PortableSQL( conn );
				String updateQry = psql.SQL(" UPDATE `appsetting` SET `appsetting`.`Value` = '"+newvalue+"' WHERE `appsetting`.`Name` = '"+itemname+"' ") ;
				java.sql.Statement stmtUpdate = conn.createStatement();
				if( stmtUpdate.executeUpdate(updateQry)==1 ) bStatus  = true ;
				stmtUpdate.close();
			}
			finally
			{
				conn.close();
			}	
		}
		catch(java.sql.SQLException exSQL){}
		catch(javax.naming.NamingException exNam ){}	
		return bStatus;
	}

	public boolean updateSettingItemAndURL(String itemname, String itemval, String URLval )
	{
		boolean bStatus = false;
		java.sql.Connection conn = null;
		try
		{
			Context env = (Context) new InitialContext().lookup("java:comp/env");
			DataSource source = (DataSource) env.lookup("jdbc/$DATABASE");
			try
			{
				conn = source.getConnection();
				if( psql==null) psql = new com.webapp.utils.PortableSQL( conn );
				String updateQry = psql.SQL(" UPDATE `appsetting` SET `appsetting`.`Value` = '"+itemval+"', `appsetting`.`URL` = '"+URLval +"' WHERE `appsetting`.`Name` = '"+itemname+"' ") ;
				java.sql.Statement stmtUpdate = conn.createStatement();
				if( stmtUpdate.executeUpdate(updateQry)==1 ) bStatus  = true ;
				stmtUpdate.close();
			}
			finally
			{
				conn.close();
			}	
		}
		catch(java.sql.SQLException exSQL){}
		catch(javax.naming.NamingException exNam ){}	
		return bStatus;
	} // end method

} // end class definition
	
