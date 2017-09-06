package com.beanwiz ; 
import java.io.*;
import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.naming.* ;
import javax.sql.* ;

public class FieldInputs
{
  public static final short NONE=0;
  public static final short TEXT=1;
  public static final short SELECT=2;
  public static final short TEXTAREA=3;
  public static final short RADIO=4;
  public static final short CHECK=5;
  public static final short FILE=6;
  
  public static final short MFTAG=7;
  public static final short YNTAG=8;
	public static final short DATEPICK=9;
	public static final short DATETIMEPICK=10;
	public static final short DATEINPUT=11;
	public static final short TIMEINPUT=12;
	public static final short STATELIST=13;
	public static final short COUNTRYLIST=14;
	
  public static final short DATEPICKER=15;
  public static final short DATETIMEPICKER=16;
  public static final short TIMEPICKER=17;  

  public static final short GETITEMLIST=18;
  public static final short DBDROPLIST=19;
  public static final short YESNOSELECT=20;  
  public static final short JAVACLASSENTITY=21; 
  
 public static String getInputType(short typ )
 {
   String ret="";
	 switch(typ)
	 {
	   case NONE:
	    ret="None" ;
		  break;
	   case TEXT:
	    ret="Text" ;
		  break;
	   case SELECT:
	    ret="Select" ;
		  break;
	   case TEXTAREA:
	    ret="Text Area" ;
		  break;
	   case RADIO:
	    ret="Radio Button" ;
		  break;
	   case CHECK:
	    ret="Check Box" ;
		  break;
	   case FILE:
	    ret="File Upload" ;
		  break;
	   case MFTAG:
	    ret="Male-Female Tag" ;
		  break;
	   case YNTAG:
	    ret="Yes-No Tag" ;
		  break;
	   case DATEPICK:
	    ret="Date Picker" ;
		  break;
		 case DATETIMEPICK:
	    ret="Date - Time Picker " ;
		  break;	
	   case DATEINPUT:
	    ret="Date Input" ;
		  break;
	   case TIMEINPUT:
	    ret="Time Input" ;
		  break;
		 case STATELIST:
	    ret="State List" ;
		  break;	
		 case COUNTRYLIST:
	    ret="Country List" ;
		  break;		
		 case DATEPICKER:
	    ret="Date Picker" ;
		  break;		
		 case DATETIMEPICKER:
	    ret="DateTime Picker" ;
		  break;		
		 case TIMEPICKER:
	    ret="Time Picker" ;
		  break;		
		 case GETITEMLIST:
	    ret="From Master-Droplist" ;
		  break;		
		 case DBDROPLIST:
	    ret="From Database-Droplist" ;
		  break;		
		 case YESNOSELECT:
	    ret="Yes-No SelectBox" ;
		  break;		
		 case JAVACLASSENTITY:
	    ret="From Java class" ;
		  break;		
			
	 }
 
   return ret ;
 }  
}