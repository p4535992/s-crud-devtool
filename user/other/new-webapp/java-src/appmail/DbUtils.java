package com.$WEBAPP.appmail;
import com.db.$DATABASE.* ;
import java.util.*;

public class DbUtils
{
    private static com.db.$DATABASE.Mail_singleattachmentsBean SnAth = new  com.db.$DATABASE.Mail_singleattachmentsBean() ;
    private static com.db.$DATABASE.Mail_bulkattachmentsBean BkAth = new com.db.$DATABASE.Mail_bulkattachmentsBean() ;

    private static com.db.$DATABASE.Mail_singlelogBean SiMail = new com.db.$DATABASE.Mail_singlelogBean() ;
    private static com.db.$DATABASE.Mail_bulkjobBean BkMail = new com.db.$DATABASE.Mail_bulkjobBean() ;
	

public static boolean saveSingleMailAttachment(MailServiceProvider prv, int nLogID,  java.util.TreeMap<String , com.$WEBAPP.appmail.MailAttachment> AthMap )
{
   if(AthMap ==null || AthMap.size()==0) return false ;
  
	 SnAth.setDatasource(prv.getMailDatasource());
	 SiMail.setDatasource(prv.getMailDatasource());
	 
	 
	 
	 try
	 {
	     SiMail.locateRecord(nLogID);
	     SnAth.beginInsert();
			 for( Map.Entry<String , com.$WEBAPP.appmail.MailAttachment> mapitem : AthMap.entrySet() )
			 {	
	           com.$WEBAPP.appmail.MailAttachment MAttach = (com.$WEBAPP.appmail.MailAttachment)mapitem.getValue();
						 
	           SnAth.MailSingleAttachmentID = 0  ; 
	           SnAth.MailSingleLogID = nLogID ; 
	           SnAth.FileName = MAttach.FileName ; 
			   SnAth.FileSize = MAttach.FileSize ;			   
	           SnAth.MimeType = MAttach.MimeType ;  ; 
	           SnAth.ContentID = MAttach.ContentID ;  
	           SnAth.FileData = MAttach.FileData  ; 
			   SnAth.continueInsert();
	 
	     } // end for loop
	     SnAth.endInsert();
	 }
	 catch(Exception e)
	 {
	    String Err =  "Exception while saving attachment: "+prv.exceptionDump(e,true);
			prv.debugLog(SiMail.MailTo, SiMail.MailSubject, "DbUtils.saveSingleMailAttachment()",Err);
			
	    return false;
	 }
   
	 return true;
}

public static java.util.TreeMap<String , com.$WEBAPP.appmail.MailAttachment> loadSingleMailAttachment(MailServiceProvider prv, int nLogID)
{

    SnAth.setDatasource(prv.getMailDatasource());
	  SiMail.setDatasource(prv.getMailDatasource());   

	  java.util.TreeMap<String , com.$WEBAPP.appmail.MailAttachment> AthMap = new java.util.TreeMap();
		
    try
    {
		    SiMail.locateRecord(nLogID);
        SnAth.openTable(" WHERE \"MailID\" ="+nLogID, " ");
        while(SnAth.nextRow() )
				{
				    com.$WEBAPP.appmail.MailAttachment ath = new com.$WEBAPP.appmail.MailAttachment() ;
				     
            ath.FileData  = SnAth.FileData ;
            ath.FileName  = SnAth.FileName  ; 
			ath.FileSize  = SnAth.FileSize ;
            ath.MimeType  = SnAth.MimeType ;
            ath.ContentID = SnAth.ContentID ;
            ath.FileSize  = SnAth.FileData!=null ? SnAth.FileData.length: 0 ;
            ath.RecordID  = SnAth.MailSingleAttachmentID ;
            ath.MailID    = SnAth.MailSingleLogID ;			
			AthMap.put(	new String(ath.ContentID) , ath) ;						
				
				} 				
		    SnAth.closeTable(); 
    
    }
    catch (Exception e)
    {
		     String Err =  "Exception while loading attachment: "+prv.exceptionDump(e,true);
         prv.debugLog(SiMail.MailTo, SiMail.MailSubject, "DbUtils.loadSingleMailAttachment()", Err);
				 return null ;

    }
										
	 return AthMap ;
}

public static boolean saveBulkMailAttachment(MailServiceProvider prv, int nJobID, int nLogID,  java.util.TreeMap<String , com.$WEBAPP.appmail.MailAttachment> AthMap )
{
   if(AthMap ==null || AthMap.size()==0) return false ;
   BkAth.setDatasource(prv.getMailDatasource());
	 BkMail.setDatasource(prv.getMailDatasource()); 
	 try
	 {
	     BkMail.locateRecord(nJobID);
       BkAth.beginInsert();
	     for( Map.Entry<String , com.$WEBAPP.appmail.MailAttachment> mapitem : AthMap.entrySet() )
       {	
	          com.$WEBAPP.appmail.MailAttachment MAttach = (com.$WEBAPP.appmail.MailAttachment)mapitem.getValue();
						
            BkAth.MailBulkAttachmentsID = 0; 
            BkAth.MailBulkJobID = nJobID ; 
			BkAth.MailSingleLogID = nLogID ;
            BkAth.FileName = MAttach.FileName ;
			BkAth.FileSize = MAttach.FileSize ;
            BkAth.MimeType = MAttach.MimeType ; 
            BkAth.ContentID = MAttach.ContentID ; 
            BkAth.FileData = MAttach.FileData ;
            BkAth.continueInsert();
	 
       } // end for
       BkAth.endInsert();
	 }
	 catch(Exception e)
	 {
	    String Err =  "Exception while saving attachment: "+prv.exceptionDump(e,true);
			prv.debugLog("N/A", BkMail.MailSubject, "DbUtils.saveBulkMailAttachment()", Err);
      return false;
	 }
   
	 return true;
}

public static java.util.TreeMap<String , com.$WEBAPP.appmail.MailAttachment> loadBulkMailAttachment(MailServiceProvider prv, int nJobID, int nLogID)
{  

	 BkAth.setDatasource(prv.getMailDatasource());
	 BkMail.setDatasource(prv.getMailDatasource()); 
	 
	 java.util.TreeMap<String , com.$WEBAPP.appmail.MailAttachment> AthMap = new java.util.TreeMap();
	 
	 String whrcls = (nLogID > 0) ?  " WHERE \"MailJobID\" ="+nJobID+" AND \"MailLogID\" = "+nLogID+" " : " WHERE \"MailJobID\" ="+nJobID+" " ;     
		
    try
    {
		    BkMail.locateRecord(nJobID);
        BkAth.openTable(whrcls, " ");
        while(BkAth.nextRow() )
				{
				    com.$WEBAPP.appmail.MailAttachment ath = new com.$WEBAPP.appmail.MailAttachment() ;
				     
            ath.FileData  = BkAth.FileData ;
            ath.FileName  = BkAth.FileName  ; 
            ath.MimeType  = BkAth.MimeType ;
            ath.ContentID = BkAth.ContentID ;
            ath.FileSize  = BkAth.FileData!=null ? BkAth.FileData.length: 0 ;
            ath.RecordID  = BkAth.MailBulkAttachmentsID ;
            ath.MailID    = BkAth.MailBulkJobID;			
			AthMap.put(	new String(ath.ContentID) , ath) ;						
				
				} 				
		    BkAth.closeTable(); 
    
    }
    catch (Exception e)
    {
		     String Err =  "Exception while loading attachment: "+prv.exceptionDump(e,true);
         prv.debugLog( "N/A", BkMail.MailSubject, "DbUtils.loadBulkMailAttachment()", Err);
         return null ;
    }
   return AthMap ;
}


}// End of class definition