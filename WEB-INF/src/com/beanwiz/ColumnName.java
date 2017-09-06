package com.beanwiz ;
 
import java.util.* ;
import java.sql.* ;
import javax.sql.* ;


public class ColumnName
{
    public static String colVarName(String in)
    {
	String ret = in.replace((char)32, '_' ); 
	ret = ret.replace('.', '_' ) ;
        ret = ret.replace('-', '_' ) ;
        ret = ret.replace('+', '_' ) ;
        return ret  ;
    }

    

}  // End of class definition ColumnName
