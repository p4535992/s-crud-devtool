package com.$WEBAPP ;
import com.db.$DATABASE.* ;
import java.io.* ;
import java.sql.* ;
import javax.naming.* ;
import javax.sql.* ;	
import javax.servlet.*;
import javax.servlet.http.*;


public class UpdateAdminPhoto
{
	private com.db.$DATABASE.Sitemanager_photographBean SiphtBn = new com.db.$DATABASE.Sitemanager_photographBean() ;
	
	private HttpServletRequest request = null ;
	 
	public UpdateAdminPhoto(HttpServletRequest req )
	{
		this.request = req; 
	}
 
	public boolean updateAdminPhotograph(int AdminID, String UploadField )
	throws Exception
	{
		if(request ==null) return false ; 
			
		FileInputStream Photograph_Stream = new FileInputStream(request.getParameter(UploadField));
		int nsize = Photograph_Stream.available();
		if(nsize > 0)
		{	
			boolean rec_found = false ;
			
			if(SiphtBn.locateOnField("AdminID",""+AdminID)) rec_found = true ;
			
			SiphtBn.AdminID = AdminID ;
			SiphtBn.Photograph = new byte[Photograph_Stream.available()] ;
			Photograph_Stream.read( SiphtBn.Photograph, 0, Photograph_Stream.available());
			SiphtBn.FileSize = nsize;
			SiphtBn.FileName = request.getParameter( UploadField+".filename" );
			SiphtBn.MIMEType = request.getParameter( UploadField+".content-type" );
			SiphtBn.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()) ;		

			// Add or update 
			if(rec_found) 
			{
			  SiphtBn.updateRecord(SiphtBn.RecordID);	
			}	
			else 
			{
			  SiphtBn.RecordID = 0 ;
			  SiphtBn.addRecord();
			}
			return true ;
		}
		
		return false ;
	} // end updatePhotograph
 
}