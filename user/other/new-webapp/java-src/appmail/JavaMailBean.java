package com.$WEBAPP.appmail;
import javax.mail.*;
import javax.mail.internet.*;
import java.util.*; 
import java.security.*;
import javax.activation.*;

/** JavaMailBean - a concrete class to send mail 


*/
public class JavaMailBean 
{
 
      protected java.util.TreeMap<String , com.$WEBAPP.appmail.MailAttachment> Attachments = new java.util.TreeMap();

      protected  String smtphost ;
      protected  String smtpport ;
      protected  Properties props  = new Properties();
      protected Session session = null; 
     
			
      protected String smtpuser =null;
      protected String smtppassword =null;
			
      protected  boolean bTls = false ;
			private    boolean bAuth = false ;
			
      public void setSMTPServer(String smtp, String port)
      {
          smtphost=smtp;
	        smtpport=port;
	       
          // if(props == null ) props  = new Properties();
          props.put("mail.host", smtphost);
          props.put("mail.smtp.host", smtphost);
          props.put("mail.smtp.port", smtpport);
      }

      public boolean authenticate(String user, String pass, boolean tls )
      {
          	this.smtpuser = user ;
		        this.smtppassword = pass ;
		        this.bTls = tls ;
		        java.security.Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());
		        
            // if(props == null ) props  = new Properties();						
		        props.put("mail.transport.protocol", "smtp");
						props.put("mail.smtp.auth", "true");
		        props.put("mail.user", this.smtpuser);
						props.put("mail.password", this.smtppassword);
		        
						if(this.bTls )
						{
						   props.put("mail.smtp.starttls.enable","true")   ;
							 props.put("mail.smtp.socketFactory.port", this.smtpport);
		           props.put("mail.smtp.socketFactory.class", 	"javax.net.ssl.SSLSocketFactory");
		           props.put("mail.smtp.socketFactory.fallback", "false");
							 props.put("mail.smtps.ssl.checkserveridentity", "false");
               props.put("mail.smtps.ssl.trust", "*");
						}
		        props.put("mail.smtp.quitwait", "false");
		        
		        bAuth = true ;
            return true;
      } 

			public boolean initSession()
			{
           if(bAuth)
           { 
                // Authentication requied
		            session = Session.getInstance(props, new MailAuth(this.smtpuser, this.smtppassword) );
		            // session.setProtocolForAddress("rfc822", "smtps");		
           }
           else
           {
                // Authentication not required
                session = Session.getDefaultInstance(props, null);
           }
 			
			
			   return true;
			}

			
      public void setAttachments(java.util.TreeMap<String , com.$WEBAPP.appmail.MailAttachment> aths )
			{
 			      // If aths is null, it would not affect TreeMap : Attachments
						// It aths in non-nul it would replace the old tree with new mapping
					if(aths == null) return;
			    if(this.Attachments!=null ) this.Attachments.clear();
					else this.Attachments = new java.util.TreeMap();
					
			    this.Attachments.putAll(aths) ;
			}

      public void clearAttachments()
			{
			    if(this.Attachments!=null ) this.Attachments.clear();
			}

			
			
      public void addAttachment(com.$WEBAPP.appmail.MailAttachment ath)
			{
			     String id = new String(ath.ContentID);
					 this.Attachments.put(id, ath);
			}
      public void addAttachment( String ID, com.$WEBAPP.appmail.MailAttachment ath )
			{
			    this.Attachments.put(ID,ath);
			}			
     
		  public void removeAttachment(String ID)
			{
			     this.Attachments.remove(ID);
			}
			

		  public 	MimeMessage  prepareMessage(String frm, String sub, String text, java.util.TreeMap<String , com.$WEBAPP.appmail.MailAttachment> aths )
			throws javax.mail.MessagingException
			{
			      this.setAttachments(aths);
			      MimeMessage msg = new MimeMessage(session);
					  InternetAddress addressFrom = new InternetAddress(frm);
		        msg.setFrom(addressFrom);
						msg.setReplyTo(new InternetAddress[] {new InternetAddress(frm)});
					  msg.setSubject(sub);
					   // Multi part message holder
					  Multipart mpart = new MimeMultipart();
	           // Main message part
						MimeBodyPart PartHTML  = new MimeBodyPart();
		        String HTMLText = "<html><body>"+text+"</body></html>" ;
            PartHTML.setContent(HTMLText, "text/html; charset=UTF-8");
            mpart.addBodyPart(PartHTML);
					  // Add additional MIME parts for attachments if needed
						// Iterate through Attachments TreeMap object 
						
						if(this.Attachments.size()>0)
						{
					        for( Map.Entry<String , com.$WEBAPP.appmail.MailAttachment> mapitem : Attachments.entrySet() )
						      {
							     // For Each Attachment in TreeMap - get reference to object
								      com.$WEBAPP.appmail.MailAttachment MAttach = (com.$WEBAPP.appmail.MailAttachment)mapitem.getValue();
								  // Create MimeBodyPart part object from attachment  
									    MimeBodyPart PartAttach = new MimeBodyPart();
									    PartAttach.setDataHandler( new DataHandler(MAttach));
									    PartAttach.setFileName( MAttach.getName());
									    PartAttach.setContentID( MAttach.ContentID);
									// Attach MimeBodyPart 	to Multipart
				             mpart.addBodyPart(PartAttach);
						     }
	           }
						 // Set content of message as MimeMultipart object 
             msg.setContent(mpart);
						 // return prepared message
						 return msg ; 
					 
			} // end method  prepareMessage
			
      public void sendMail(MimeMessage msg , String adr)
      throws javax.mail.internet.AddressException , javax.mail.MessagingException
      {
          InternetAddress addressTo[] = { new InternetAddress(adr) } ;
          msg.setRecipients(Message.RecipientType.TO, addressTo);
          Transport.send(msg);
      }

 
  

} // END class definition