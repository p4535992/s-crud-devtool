package com.$WEBAPP.appsms;
import com.$WEBAPP.* ;
import java.io.* ;
import java.sql.* ;
import javax.naming.* ;
import javax.sql.* ;	
import javax.servlet.*;
import javax.servlet.http.*;

public class SMSSetting
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
			
	    private String jndidsn= null;
	
	  public SMSSetting(String data_src )
	  {
	      this.jndidsn = data_src;
	  }
		
		public SMSSetting(ServletContext cntx)
		{
		   this.jndidsn = cntx.getInitParameter("WEBSMS-DATASOURCE");
			 if( this.jndidsn==null ) this.jndidsn="jdbc/$WEBAPP" ; // Assume defualt value if not set
	      
	  }

		
	  public boolean checkNumber(String number)
		{ 
		     String RegExp =  getValue("NUMBER-CHECK-REGEXP");
         if (number==null|| RegExp==null) return false ;
         return number.matches(RegExp) ;
		}
   
	 public boolean getServiceStatus()
	 {
	     String val =  getValue("START-SMS-SERVICE");
			 return ( "YES".equalsIgnoreCase(val)  ) ? true : false ;
	 }
	 
	 public String getValidNumberAdvice()
	 {
	   String RetVal = "?" ;
		 if(lookup("NUMBER-CHECK-REGEXP"))RetVal = this.URL;
		 return RetVal;
		 
		 
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
	           DataSource source = (DataSource) env.lookup(this.jndidsn);
	           java.sql.Connection conn = source.getConnection();
		         String Qry =  " SELECT * FROM `sms_settings` WHERE `sms_settings`.`Name` = '"+itemname+"' "  ;
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
	 } // end function lookup( String itemname)
	
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
						 DataSource source = (DataSource) env.lookup(this.jndidsn);
             
         	   try
						 {
         	           conn = source.getConnection();
         	           String updateQry = "UPDATE `sms_settings` SET `sms_settings`.`Value` = '"+newvalue+"' WHERE `sms_settings`.`Name` = '"+itemname+"' "  ;
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

    }  // End: updateSettingItem(String itemname , String newvalue )

    public boolean updateSettingItemAndURL(String itemname, String itemval, String URLval )
    {
         boolean bStatus = false;
         java.sql.Connection conn = null;
         try
         {
             Context env = (Context) new InitialContext().lookup("java:comp/env");
             DataSource source = (DataSource) env.lookup(this.jndidsn);
             try
						 {
          	      conn = source.getConnection();
          	      String updateQry =  " UPDATE `sms_settings` SET `sms_settings`.`Value` = '"+itemval+"', `sms_settings`.`URL` = '"+URLval +"' WHERE `sms_settings`.`Name` = '"+itemname+"' "  ;
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
    } //  End: updateSettingItemAndURL(String itemname, String itemval, String URLval )







	
        


}