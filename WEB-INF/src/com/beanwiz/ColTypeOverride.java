package com.beanwiz ; 
import java.io.*;
import java.util.*;
import java.sql.*;

public class ColTypeOverride
{ 
    public static String dropList()
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<select name=\"JDBCType\" id=\"JDBCType\" class=\"form-control selectpicker\"  >\r\n") ;
        sb.append("   <option value=\"0\" >UNKNOWN</option>\r\n");
        sb.append("   <option value=\""+Types.BIT+"\" >BIT</option>\r\n");
        sb.append("   <option value=\""+Types.SMALLINT+"\" >SMALLINT</option>\r\n");
        sb.append("   <option value=\""+Types.INTEGER+"\" >INTEGER</option>\r\n");
        sb.append("   <option value=\""+Types.BIGINT +"\" >BIGINT</option>\r\n");
        sb.append("   <option value=\""+Types.NUMERIC+"\" >NUMERIC</option>\r\n");
        sb.append("   <option value=\""+Types.FLOAT+"\" >FLOAT</option>\r\n");
        sb.append("   <option value=\""+Types.DOUBLE+"\" >DOUBLE</option>\r\n");
        sb.append("   <option value=\""+Types.DECIMAL+"\" >DECIMAL</option>\r\n");
        sb.append("   <option value=\""+Types.DATE+"\" >DATE</option>\r\n");
        sb.append("   <option value=\""+Types.TIME+"\" >TIME</option>\r\n");
        sb.append("   <option value=\""+Types.TIMESTAMP+"\" >TIMESTAMP</option>\r\n");
        sb.append("   <option value=\""+Types.CHAR+"\" >CHAR</option>\r\n");
        sb.append("   <option value=\""+Types.VARCHAR+"\" >VARCHAR</option>\r\n");
        sb.append("   <option value=\""+Types.CLOB+"\" >CLOB</option>\r\n");
        sb.append("   <option value=\""+Types.LONGVARCHAR+"\" >LONGVARCHAR</option>\r\n");
        sb.append("   <option value=\""+Types.BLOB+"\" >BLOB</option>\r\n");
        sb.append("   <option value=\""+Types.LONGVARBINARY+"\" >LONGVARBINARY</option>\r\n");
        sb.append("</select>\r\n");
        return sb.toString() ;
    }
    public static String typeLabel(int nType)
    {
	String ret="" ;
	switch(nType)
        {		
	 case Types.BIT:
            ret = "BIT" ; 
         break;
        
	 case Types.SMALLINT:
            ret = "SMALLINT" ; 
         break;
        
         case Types.INTEGER:
            ret = "INTEGER" ; 
         break;
        
         case Types.BIGINT :
            ret = "BIGINT" ; 
         break;
        
         case Types.NUMERIC:
            ret = "NUMERIC" ; 
         break;
        
         case Types.FLOAT:
            ret = "FLOAT" ; 
         break;
        
         case Types.DOUBLE:
            ret = "DOUBLE" ; 
         break;
        
         case Types.DECIMAL:
            ret = "DECIMAL" ; 
         break;
        
         case Types.DATE:
            ret = "DATE" ; 
         break;
        
         case Types.TIME:
            ret = "TIME" ; 
         break;
        
         case Types.TIMESTAMP:
            ret = "TIMESTAMP" ; 
         break;
        
         case Types.CHAR:
            ret = "CHAR" ; 
         break;
        
         case Types.VARCHAR:
            ret = "VARCHAR" ; 
         break;
        
         case Types.CLOB:
            ret = "CLOB" ; 
         break;
        
         case Types.LONGVARCHAR:
            ret = "LONGVARCHAR" ; 
         break;
        
         case Types.BLOB:
            ret = "BLOB" ; 
         break;
        
         case Types.LONGVARBINARY:
            ret = "LONGVARBINARY" ; 
         break;
          
	 default:
	   ret = "UNKNOWN" ;
		    }	// end switch
        return ret ;
     } // end method typeLabel
		
		
} // End class definition