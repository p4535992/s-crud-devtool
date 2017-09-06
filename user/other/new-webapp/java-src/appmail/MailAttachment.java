package com.$WEBAPP.appmail;
import java.lang.* ;
import java.io.* ;
import javax.servlet.* ;
import javax.servlet.http.* ;
import javax.activation.*;
import com.webapp.utils.* ; 

public class MailAttachment implements javax.activation.DataSource
{
     private java.io.InputStream is = null;
     private java.io.OutputStream os = null   ;

     public byte[]  FileData = null ;
     public String FileName = null ; 
     public String MimeType = null ;
     public String ContentID = null ;
	 public int FileSize = 0;
     public int RecordID = 0;
     public int MailID = 0 ;

		 public static MailAttachment createFromFile(String filename, String cid )
		 {
		    java.io.File fo = new  java.io.File(filename);
				if(!fo.exists()) return null;
				
				MailAttachment ath = new MailAttachment();
				
				String LongFileName = fo.getName();
				 
			    if( LongFileName.contains("/"))
	        {  
					   // get rid of linux path names
	           ath.FileName = LongFileName.substring( LongFileName.lastIndexOf("/")+1 );
	        }
	        else if ( LongFileName.contains("\\"))
	        {
					   // get rid of windows path names
	           ath.FileName = LongFileName.substring( LongFileName.lastIndexOf("\\")+1 );
	        }
	        else
	        {
	           ath.FileName=LongFileName ; 
	        }
				
				  String extn =  ath.FileName.substring(ath.FileName.lastIndexOf(".")+1 ) ;
          if(extn !=null && extn.length()>0) 	ath.MimeType =  MimeHelper.getMimeTypeForExt( extn );
					ath.ContentID = (cid!=null) ? cid : ath.FileName ;
					 
					 try
           {
                   java.io.FileInputStream inStream = new FileInputStream(fo);
                   ath.FileSize = inStream.available();
                   ath.FileData = new byte[ath.FileSize] ;
                   inStream.read( ath.FileData, 0, inStream.available());
                   inStream.close() ;
           }
           catch ( Exception ex)
           {
							     ath.FileData=null ;
								   ath.FileSize=0;
									 return null ;
           }

				return ath ;
		 }
		 
     /* Implementation of interface - javax.activation.DataSource */
		 
     public java.io.InputStream getInputStream()
     throws java.io.IOException
     { 
	        if(FileData != null )
	        {
	            is = new ByteArrayInputStream(FileData) ;
	 	      }
 		      return is ;
     }																

     public java.io.OutputStream getOutputStream()
     throws java.io.IOException
     {   
           os = new java.io.ByteArrayOutputStream();
 		       return os ;
     }
			
     public java.lang.String getContentType()
     {
		        if(MimeType == null ) MimeType = "application/octet-stream";
 		        return MimeType ;
     }			
			
     public java.lang.String getName() { return FileName  ; }
 		 public java.lang.String getContentID() {  return ContentID ;  }	 

}   // End class definition : MailAttachment 
