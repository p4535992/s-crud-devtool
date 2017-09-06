package com.$WEBAPP.apputil ;
import java.util.*;
import java.sql.* ;
import java.text.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.joda.time.*;
 
 
public class DateTimeHelper
{

  public static java.text.SimpleDateFormat FMT_DATE = new java.text.SimpleDateFormat("dd/MM/yyyy");
  public static java.text.SimpleDateFormat FMT_DATETIME = new java.text.SimpleDateFormat("dd/MM/yyyy hh:mm a");
  public static java.text.SimpleDateFormat FMT_TS_READ = new java.text.SimpleDateFormat("dd/MM/yyyy hh:mm:ss a");
  public static java.text.SimpleDateFormat FMT_TIME = new java.text.SimpleDateFormat("hh:mm a") ;
  public static java.text.SimpleDateFormat FMT_TIME_READ = new java.text.SimpleDateFormat("hh:mm:ss a") ;
  
  public static java.text.SimpleDateFormat FMT_DATEPICKER = new java.text.SimpleDateFormat("dd/MM/yyyy");
  public static java.text.SimpleDateFormat FMT_TIME_CLOCKPICKER_READ = new java.text.SimpleDateFormat("HH:mm") ;
  public static java.text.SimpleDateFormat FMT_TIME_CLOCKPICKER = new java.text.SimpleDateFormat("hh:mm a") ;
  public static java.text.SimpleDateFormat FMT_DATETIME_PICKER_READ = new java.text.SimpleDateFormat("dd/MM/yyyy hh:mm a");	
  public static java.text.SimpleDateFormat FMT_DATETIME_PICKER = new java.text.SimpleDateFormat("dd/MM/yyyy hh:mm a");	
  
	public static String showDatePicker(java.util.Date dt)
	{
	   if(dt != null) return FMT_DATEPICKER.format(dt);
		 else return "" ;
	}
	
	public static String showTimeClockPicker(java.util.Date dt, String fm)
	{
	  if(fm!=null && fm.length()>0 )
      {
		  if(fm.equalsIgnoreCase("Read")) return FMT_TIME_CLOCKPICKER_READ.format(dt);
		  else if (fm.equalsIgnoreCase("Show")) return FMT_TIME_CLOCKPICKER.format(dt);
		  else return FMT_TIME_CLOCKPICKER_READ.format(dt);
	  }	
      else return "";	  
	}

	public static String showDateTimePicker(java.util.Date dt)
	{
	   if(dt != null ) return FMT_DATETIME_PICKER.format(dt);
		 else return "" ;
	}



	public static java.sql.Date parseDatePicker(String datestring )
	{
	  java.sql.Date sqlDate = null;
		try
		{
		  java.util.Date dt = FMT_DATEPICKER.parse(datestring);
			if(dt!=null) sqlDate = new java.sql.Date(dt.getTime());
		}
		catch(Exception ex){}
		return sqlDate ;
	}

	public static java.sql.Time parseTimeClockPicker(String time_string )
	{
	  java.sql.Time  sqlTm = null;
		try
		{
		  java.util.Date dt = FMT_TIME_CLOCKPICKER_READ.parse(time_string);
			if(dt!=null) sqlTm  = new java.sql.Time(dt.getTime());
		}
		catch(Exception ex){}
		return sqlTm   ;
	}

	public static java.sql.Timestamp parseDateTimePicker(String date_time_string )
	{
	  java.sql.Timestamp sqlTs = null;
		try
		{
		  java.util.Date dt = FMT_DATETIME_PICKER_READ.parse(date_time_string);
			if(dt!=null) sqlTs = new java.sql.Timestamp(dt.getTime());
		}
		catch(Exception ex){}
		return sqlTs  ;
	}


	public static java.sql.Date requestDatePicker(javax.servlet.http.HttpServletRequest req,  String field )
	{
	  if(req==null || field==null) return null ;
		return  parseDatePicker(req.getParameter(field));
	}
	
	public static java.sql.Time requestTimePicker(javax.servlet.http.HttpServletRequest req,  String field )
	{
		if(req==null || field==null) return null ;
		return  parseTimeClockPicker(req.getParameter(field));
	}

	public static java.sql.Timestamp requestDateTimePicker(javax.servlet.http.HttpServletRequest req,  String field )
	{
		if(req==null || field==null) return null ;
		return  parseDateTimePicker(req.getParameter(field));
	}

  public static boolean isExistBetweenTwoDates(java.sql.Date chkdate, java.sql.Date mindate, java.sql.Date maxdate, boolean inc)
  {
	boolean isExist = false ;
    if (chkdate == null || mindate == null || maxdate == null) return false;
	if(inc)
	{
		if(chkdate.compareTo(mindate) >= 0 && chkdate.compareTo(maxdate) <= 0) isExist = true ;
	}
	else
	{
		if(chkdate.compareTo(mindate) > 0 && chkdate.compareTo(maxdate) < 0) isExist = true ;
	}
    return isExist;
  }  
	
/*****-- Legacy Method --***************************************/	

	public static String showDate(java.util.Date dt)
	{
	   if(dt != null) return FMT_DATE.format(dt);
		 else return "" ;
	}

	public static String showDateTime(java.util.Date dt)
	{
	   if(dt != null ) return FMT_DATETIME.format(dt);
		 else return "" ;
	}
	
	public static String showTime(java.util.Date dt)
	{
	   if(dt != null) return FMT_TIME.format(dt);
		 else return "";
	}

	
	
	public static java.sql.Date parseDate(String datestring )
	{
	  java.sql.Date sqlDate = null;
		try
		{
		  java.util.Date dt = FMT_DATE.parse(datestring);
			if(dt!=null) sqlDate = new java.sql.Date(dt.getTime());
		}
		catch(Exception ex){}
		return sqlDate ;
	}
	
	public static java.sql.Timestamp parseDateTime(String date_time_string )
	{
	  java.sql.Timestamp sqlTs = null;
		try
		{
		  java.util.Date dt = FMT_TS_READ.parse(date_time_string);
			if(dt!=null) sqlTs = new java.sql.Timestamp(dt.getTime());
		}
		catch(Exception ex){}
		return sqlTs  ;
	}
	
	
	
	public static java.sql.Time parseTime(String time_string )
	{
	  java.sql.Time  sqlTm = null;
		try
		{
		  java.util.Date dt = FMT_TIME_READ.parse(time_string);
			if(dt!=null) sqlTm  = new java.sql.Time(dt.getTime());
		}
		catch(Exception ex){}
		return sqlTm   ;
	}
	
	
	
	
	public static java.sql.Date requestDate(javax.servlet.http.HttpServletRequest req,  String field )
	{
	  if(req==null || field==null) return null ;
		return  parseDate(req.getParameter(field));
	}
	
	public static java.sql.Timestamp requestDateTime(javax.servlet.http.HttpServletRequest req,  String field )
	{
	   java.sql.Timestamp ts = null ;
	   try
	   {
     String date_str  = req.getParameter(field); 
     String hr = req.getParameter( field+"Hour");
     String mn = req.getParameter( field+"Minute");
     String sc = req.getParameter( field+"Second");
	   String ampm = req.getParameter( field+"AmPm");
     if(sc==null || sc.length()==0) sc="00";
     String parse_str = date_str+" "+hr+":"+mn+":"+sc+" "+ampm ;
	   java.util.Date dt =  FMT_TS_READ.parse(parse_str);
		 if(dt!=null) ts = new java.sql.Timestamp(dt.getTime());
		 }catch(Exception ex){}
	   return ts ;
	}


	public static java.sql.Time requestTime(javax.servlet.http.HttpServletRequest req,  String field )
	{
	   java.sql.Time  tm = null ;
	   try
	   {
     String hr = req.getParameter( field+"Hour");
     String mn = req.getParameter( field+"Minute");
     String sc = req.getParameter( field+"Second");
	   String ampm = req.getParameter( field+"AmPm");
     if(sc==null || sc.length()==0) sc="00";
     String parse_str = ""+hr+":"+mn+":"+sc+" "+ampm ;
	   java.util.Date dt =  FMT_TIME_READ.parse(parse_str);
		 if(dt!=null) tm = new java.sql.Time(dt.getTime());
		 }catch(Exception ex){}
	   return tm ;
	}
	
	
/*****-- END Legacy Method --***************************************/

	
	  public static java.sql.Date laxDateParser(String source)
    {
          if(source == null || source.length()==0) return null;
    	    String reg = "[-/\\.\\\\,]" ;
    	    String[] parts = source.split(reg);
    	    if(parts==null) return null;
    	    if(parts.length !=3 ) return null;
    	    int yr=0, mn=0, dy = 0;
    	    try
    		  {
    		     yr = Integer.parseInt(parts[2].trim());
    			   mn = Integer.parseInt(parts[1].trim());
    			   dy = Integer.parseInt(parts[0].trim());
    		  }
    		  catch(NumberFormatException e)
    		  {
    		     yr =0;
    	       mn = 0;
    	       dy = 0;
    		  }
    	    boolean bValid = false ;
    		  if(yr > 0 && mn > 0 && dy > 0 && mn <=12 && dy <=31 ) bValid = true;
    		  if(!bValid) return null;
    		  // Corrections for 2 digit year value
    		  if(yr <= 20 ) yr +=2000;
    		  if(yr > 20 && yr < 100) yr+=1900;
    			
    		  String sqldate = ""+yr+"-"+mn+"-"+dy ;
    	    java.sql.Date dt = null;
    			try
    			{ 
    			    dt = java.sql.Date.valueOf(sqldate);
    			}catch(Exception e){}
    			return dt;
   }


	

	public static int daysBetween(java.sql.Date first, java.sql.Date second)
	{
	    if(first==null || second==null ) return 0;
	    org.joda.time.Days dys = org.joda.time.Days.daysBetween(new org.joda.time.DateTime(first),  new org.joda.time.DateTime(second) );
      int days = dys.getDays();
	    return days;
	}
	
	public static int[] getYearMonthDayBetween(java.sql.Date first, java.sql.Date second )
	{  
	       int[] itms = {0,0,0};
				 if(first==null || second==null ) return itms ;
         org.joda.time.Period prd = new org.joda.time.Period(first.getTime() , second.getTime(), PeriodType.yearMonthDay()  );
	       itms[0]= prd.getYears();
				 itms[1]= prd.getMonths();
				 itms[2]= prd.getDays();
	       return itms ;
	}
	
	
	public static  java.sql.Date plusDays(java.sql.Date dt, int days)
	{
       org.joda.time.DateTime tm = ( new org.joda.time.DateTime(dt)).plusDays( days);
	     return new java.sql.Date(tm.toDate().getTime());
	}

	public static  java.sql.Date minusDays(java.sql.Date dt, int days)
	{
       org.joda.time.DateTime tm = ( new org.joda.time.DateTime(dt)).minusDays( days);
	     return new java.sql.Date(tm.toDate().getTime());	
	}
	
	
	public static java.sql.Date plusWeeks(java.sql.Date dt, int weeks)
	{
	     org.joda.time.DateTime tm = ( new org.joda.time.DateTime(dt)).plus( org.joda.time.Weeks.weeks(weeks));
	     return new java.sql.Date(tm.toDate().getTime());
	}
  
  public static java.sql.Date minusWeeks(java.sql.Date dt, int weeks)
	{
	   	 org.joda.time.DateTime tm = ( new org.joda.time.DateTime(dt)).minus( org.joda.time.Weeks.weeks(weeks));
	     return new java.sql.Date(tm.toDate().getTime());
	}

	
	
	public static java.sql.Date plusMonths(java.sql.Date dt, int months)
	{
	     org.joda.time.DateTime tm = ( new org.joda.time.DateTime(dt)).plus( org.joda.time.Months.months(months));
	     return new java.sql.Date(tm.toDate().getTime());
	}
  
  public static java.sql.Date minusMonths(java.sql.Date dt, int months)
	{
	   	 org.joda.time.DateTime tm = ( new org.joda.time.DateTime(dt)).minus( org.joda.time.Months.months(months));
	     return new java.sql.Date(tm.toDate().getTime());
  
	}
	 
	public static java.sql.Date plusYears(java.sql.Date dt, int years )
	{
	   	 org.joda.time.DateTime tm = ( new org.joda.time.DateTime(dt)).plus( org.joda.time.Years.years(years));
	     return new java.sql.Date(tm.toDate().getTime());
  
	}
	
	public static java.sql.Date minusYears(java.sql.Date dt, int years )
	{
	     org.joda.time.DateTime tm = ( new org.joda.time.DateTime(dt)).minus( org.joda.time.Years.years(years));
	     return new java.sql.Date(tm.toDate().getTime());
	}

	 
	
	public static java.sql.Date today()
	{
	  Calendar rightNow = Calendar.getInstance();
		int year = rightNow.get(Calendar.YEAR) - 1900 ;
		int month = rightNow.get(Calendar.MONTH );
		int day = rightNow.get(Calendar.DAY_OF_MONTH) ;
	  return new java.sql.Date(year, month, day) ; 
	 
	 }
	public static java.sql.Timestamp now(){ return new java.sql.Timestamp(System.currentTimeMillis()); }
	public static String showToday(){ return showDate(today()); }
	public static String showNow(){ return showDateTime(now()); }
	
  public static String getDayOfWeek(java.sql.Date dt)
	{
	   String[] DayNames = new DateFormatSymbols(Locale.getDefault()).getWeekdays();
     Calendar caln = Calendar.getInstance();
		 caln.setTime(dt); 
		 return DayNames[caln.get(Calendar.DAY_OF_WEEK)] ;
	}
	
	
	

} // end of class definition