package com.$WEBAPP.appmail;
import javax.mail.*;
import javax.mail.internet.*;
import com.db.$DATABASE.* ;

public class MailDispatchThread extends java.lang.Thread
{
    protected int nMailBulkJobID = 0;
    protected MailServiceProvider provider = null ;
		 
		
    public MailDispatchThread(  MailServiceProvider prv , int id)
		{
		    this.provider = prv ;
				this.nMailBulkJobID = id;
		}		
		     

    public void run()
    {
		    String Err = null;
        com.db.$DATABASE.Mail_bulkjobBean job = new com.db.$DATABASE.Mail_bulkjobBean();
        com.db.$DATABASE.Mail_bulkjoblogBean log = new com.db.$DATABASE.Mail_bulkjoblogBean();
        com.db.$DATABASE.Mail_bulkjoblogBean upd = new com.db.$DATABASE.Mail_bulkjoblogBean();
				
				int success =0 ;
				int failure =0 ;
				
				job.setDatasource(provider.getMailDatasource()) ;
				log.setDatasource(provider.getMailDatasource()) ;
				upd.setDatasource(provider.getMailDatasource()) ;

				try
				{
				
				    job.locateRecord(nMailBulkJobID);
						job.BulkMailJobFlag = MailDispatchStatus.INPROCESS ;
						job.updateRecord(nMailBulkJobID);
						
						com.$WEBAPP.appmail.JavaMailBean mb = provider.initMailBean() ;
						java.util.TreeMap<String , com.$WEBAPP.appmail.MailAttachment> Aths = null ;
						MimeMessage msgobj = null ;
            // Load attachments if there are no custom per mail attachments
						if(job.CustomAttach == 0 ) Aths  = DbUtils.loadBulkMailAttachment(provider, nMailBulkJobID, 0 ) ;
            
							// Load message text if there are no custom per mail attachments
						if(job.CustomText == 0 )
						{
						   try
							 {			
							   msgobj = mb.prepareMessage(job.MailFrom, job.MailSubject, job.MailText, Aths  ) ;
						   }catch (javax.mail.MessagingException ex)
							 {
				           Err  =  "Messaging Exception: ( Can not continue further ...) : "+provider.exceptionDump(ex,true);
                   provider.debugLog( "N/A", "Messaging Exception in getting MimeMessage object.", "MailDispatchThread.run()", Err);
                   return ;
							 }
						
						}
						 
            log.openTable(" WHERE \"MailJobID\"="+nMailBulkJobID, " ");
						while(log.nextRow())
						{ 
						       
									upd.locateRecord( log.MailBulkJobLogID);
									//  Load attachments if there are per mail seperate individual attachments. 
									if(job.CustomAttach > 0 )
						      {
									     // attachments for nMailBulkJobID job and MailBulkJobLogID log
						           Aths =   DbUtils.loadBulkMailAttachment(provider, nMailBulkJobID, log.MailBulkJobLogID);
						      }
	
	                try
                  {
			 								//  Load text if there is  per mail seperate individual text
											//  We will need seperate MimeMessage object for each mail. 
											 if(job.CustomText > 0)
									     {
						               msgobj = mb.prepareMessage(job.MailFrom, log.MailSubject, log.MailText, Aths  ) ;
                       }
											 
											 // Send mail to SMTP Server
									     try
							         {
							             mb.sendMail(msgobj, log.MailTo);
													 success++ ;
													 upd.MailBulkJobLogFlag = MailDispatchStatus.SUCCESS ;
													 // Success is assumed in absence of exceptions
							             upd.Response ="Mail Send Successfully" ;
											 }
							         catch (javax.mail.internet.AddressException exadr)
                       {   //Invalid address
											     failure++;
							             upd.MailBulkJobLogFlag = MailErrorCodes.BADFORMAT ; 
													 upd.Response = exadr.toString() ;
                       }
									}
									catch (javax.mail.MessagingException exmsg)
                  {    
									     // Messaging error socket or composition error
											 failure++;
					             upd.MailBulkJobLogFlag=MailErrorCodes.MESSAGING_ERROR; 
											 upd.Response = exmsg.toString() ;
                  }
									
									
							    upd.updateRecord( log.MailBulkJobLogID);   
						
						}		// End - while(log.nextRow())				
            log.closeTable();				
						// Update Job Status
   			    job.locateRecord(nMailBulkJobID);
						job.Success = success ;
						job.Failure = failure ;
						job.BulkMailJobFlag = MailDispatchStatus.SUCCESS ;
						job.updateRecord(nMailBulkJobID);
				}
				catch(java.sql.SQLException  ex)
				{
					  Err  =  "SQL Exception: "+provider.exceptionDump(ex,true);
            provider.debugLog( "N/A", "SQL Exception in mail dispatch.", "MailDispatchThread.run()", Err);
            return ;
 			  } // End try-catch
				
    } // End method run


}  // End class definition - MailDispatchThread