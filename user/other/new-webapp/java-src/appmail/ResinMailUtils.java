package com.$WEBAPP.appmail;

import javax.servlet.* ;
import javax.servlet.http.* ;

import com.webapp.utils.* ;
import com.webapp.resin.* ;

public class ResinMailUtils
{

    public static com.$WEBAPP.appmail.MailAttachment  attachmentFromUpload(ServletContext cntx, HttpServletRequest req, String UploadField , String CidField ) 
    {
         com.$WEBAPP.appmail.MailAttachment ath = null;
	       ResinFileUpload upld = new ResinFileUpload();
	       upld.load(cntx, req, UploadField) ;
				 
	       byte[] filebytes = null ;
	       filebytes = upld.getFileBytes();
				 String cid = req.getParameter(CidField);
				  
	       if(filebytes != null )
	       {
	             ath = new com.$WEBAPP.appmail.MailAttachment() ;
			         ath.RecordID = 0;
			         ath.MailID = 0 ;
			         ath.FileData = filebytes;
			         ath.FileName = upld.getFileName();
			         ath.FileSize = upld.getFileSize();
							 ath.MimeType = upld.getMimeType();
			         ath.ContentID = (cid !=null && cid.length() > 0)? cid : ath.FileName ;
	       }
         return ath ;
    }
	 
    public static com.$WEBAPP.appmail.MailAttachment attachmentFromDB()
	  {
	       com.$WEBAPP.appmail.MailAttachment ath = null;
	  
	       return ath ;
	  }

} // End class definition