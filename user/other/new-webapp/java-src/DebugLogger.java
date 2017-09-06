package com.$WEBAPP ;
import com.db.$DATABASE.*;

public class DebugLogger
{
	private static com.db.$DATABASE.DebuglogBean db = null ;
	public static void log(String cntx, String txt )
	{
    if ( db==null ) db = new com.db.$DATABASE.DebuglogBean();
    try
    {
		db.LogID=0 ; 
	    db.LogTime = new java.sql.Timestamp(System.currentTimeMillis()) ; ; 
	    db.Context = cntx  ; 
	    db.LogText = txt ;
		db.addRecord();
			 
    } catch(java.sql.SQLException ex) 
	{ 
		 
		System.err.println("------------------------\nLogging Error:"+ex.toString()+"\n----------------------\n");
		 
    }
   }
}