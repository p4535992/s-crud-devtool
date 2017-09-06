package   com.beanwiz ;
import java.sql.* ;
import javax.sql.* ;

public class BeanwizHelper
{
   public static String openTableSQL(java.sql.Connection conx, String table)
	 throws SQLException
	 {
    	  String ret = " SELECT * FROM "+table+" " ;
	      if(conx==null) return ret ;
        String DriverName = conx.getMetaData().getDriverName(); 
		    if( "MySQL-AB JDBC Driver".equalsIgnoreCase(DriverName))
		    {
		         ret = " SELECT * FROM `"+table+"` LIMIT 10 " ;
		    }
				else if("MySQL Connector Java".equalsIgnoreCase(DriverName) )
		  	{ 
				     ret = " SELECT * FROM `"+table+"` LIMIT 10 " ; 
		  	}
        else if("PostgreSQL Native Driver".equalsIgnoreCase(DriverName) )
		  	{ 
				 ret = " SELECT * FROM \""+table+"\" LIMIT 10 " ;		 
		  	}
		    else if ( "Microsoft SQL Server JDBC Driver 2.0".equalsIgnoreCase(DriverName)) 
		    {  
		         ret = "  SELECT TOP(10) * FROM "+table+" " ;
		    }
		    else if ( "Oracle JDBC driver".equalsIgnoreCase(DriverName)) 
		    {  
		         ret = " SELECT * from "+table+" WHERE ROWNUM <= 10" ;
		    }
				else if("IBM Data Server Driver for JDBC and SQLJ".equalsIgnoreCase(DriverName) )
				{
					   ret = "SELECT * FROM "+table+"  FETCH FIRST 10 ROWS ONLY " ;
				}
				else if ( "H2 JDBC Driver".equalsIgnoreCase(DriverName)) 
		    {  
		       ret = " SELECT * FROM \""+table+"\" LIMIT 10 " ;
		    }
		    else if ( "SQLiteJDBC".equalsIgnoreCase(DriverName)) 
		    {
		       ret = " SELECT * FROM  "+table+"  LIMIT 10 " ;
		    }
	      return ret ;
	 }


	 

}


