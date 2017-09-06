package com.$WEBAPP.appmail;
import com.db.$DATABASE.* ;

import javax.servlet.* ;
import javax.servlet.http.* ;

import java.io.*;
import java.util.* ;

public class MailServiceProvider
{
    protected String maildsn = null;
    protected String smtp_host =null;
		protected String smtp_port = "25";

		protected String user = null;
		protected String password=null;
		protected String defaultsender = null;
		
		protected boolean bAuthRequired = false ;
		protected boolean bTlsRequired = false;
		
		protected int nAuthType = 0;
		
		protected ServletContext context = null;
		protected com.db.$DATABASE.Mail_debuglogBean DbgLog = new com.db.$DATABASE.Mail_debuglogBean();
		
		protected boolean bMailServiceStarted = false;
		
		protected static final String[] authtypes = { "None", "Basic", "Use TSL/SSL" };
		
		public void setMailDatasource(String ds){maildsn=ds ;}
		public String getMailDatasource(){return maildsn ; }
		
		public String getDefaultSenderID(){ return defaultsender ; }
		public void setDefaultSenderID(String newval){ defaultsender = newval ;}
		public void startMailService(){bMailServiceStarted  = true;}
		public void stopMailService(){bMailServiceStarted = false ;}
		public boolean getMailServiceStatus(){ return bMailServiceStarted ; }
		public String getAuthType(){ return authtypes[nAuthType] ; }
		public void setSMTPServer(String hst, String prt ){ this.smtp_host=hst; this.smtp_port = prt;}
		public String getSMTPServer(){ return this.smtp_host+" : "+this.smtp_port ;} ;
		
		
		public static boolean createService(ServletContext cntx )
		{
		   // Get context param MAIL-DATASOURCE
			 // Set service object MAIL-SERVICE-PROVIDER 
			  String err="";
			  
        String mail_dsn = cntx.getInitParameter("MAIL-DATASOURCE");
				if(mail_dsn==null)
				{
				    System.err.println("Error in context parameter definition : \n");
				    System.err.println("Servlet context parameters MAIL-DATASOURCE must be defined in web application ( web.xml file ).\n");
							
            return false;
				}
				MailServiceProvider prv = new MailServiceProvider();
				prv.context = cntx;
				prv.setMailDatasource(mail_dsn);
				prv.DbgLog.setDatasource(mail_dsn);
				MailSetting setbn = new MailSetting(mail_dsn);
									
				//SMTP-SERVER, SMTP-AUTH, DEFUALT-SENDER-ID
				
				    String smtp_srv = setbn.getValue("SMTP-SERVER");
				    if(smtp_srv != null && smtp_srv.length() >0 )
				    {
				          String[] part_srv = smtp_srv.split(":");
					        if(part_srv != null && part_srv.length==2)
					        {
					             prv.smtp_host = part_srv[0] ;
											 
											 try
											 {
											   int prt = Integer.parseInt(part_srv[1]);
												 prv.smtp_port = ""+prt;
											 }
											 catch(NumberFormatException e)
											 {		 
					                prv.smtp_port = "25" ;
													err="Invalid value set fot smtp port, resorting to 25 as default. ";
								          prv.debugLog("N/A", "Create service", "MailServiceProvider.createService()", err) ;
													
											 }		
					     
					        }
									else
									{
									       err="Invalid value set fot SMTP-SERVER, requires host:port, resorting to localhost:25 ";
								         prv.debugLog("N/A", "Create service- parse SMTP-SERVER", "MailServiceProvider.createService()", err) ;
				                 prv.smtp_host = "localhost";
					               prv.smtp_port = "25";
									}
				    }
				    else
				    {
								 err="Value for SMTP-SERVER not set, resorting to localhost:25 ";
								 prv.debugLog("N/A", "Create service- parse SMTP-SERVER", "MailServiceProvider.createService()", err) ;

				         prv.smtp_host = "localhost";
					       prv.smtp_port = "25";
				    }
				    
						
						 
				    try
						{
						     prv.nAuthType = Integer.parseInt(setbn.getValue("SMTP-AUTH"));
						}catch(NumberFormatException e)
						{
							   prv.bAuthRequired = false ; 
								 prv.bTlsRequired = false; 
								 prv.nAuthType=0;
								 err="Invalid value set fot SMTP-AUTH, must be 0,1 or 2. Assuming 0";
							   prv.debugLog("N/A", "Create service-parse SMTP-AUTH value", "MailServiceProvider.createService()", err) ;
						}			 
						
						String ath_string = setbn.URL ;
						switch(prv.nAuthType)
						{
							   case 0:
										    prv.bAuthRequired = false ; prv.bTlsRequired = false;
								 break ;
										 
							   case 1:
										    prv.bAuthRequired = true ; prv.bTlsRequired = false;
								 break ;

							   case 2:
										   prv.bAuthRequired = true ; prv.bTlsRequired = true;
								 break ;
								 default:
									     prv.bAuthRequired = false ; prv.bTlsRequired = false;
											 err="Invalid value set fot SMTP-AUTH, must be 0,1 or 2. Assuming 0";
											 prv.debugLog("N/A", "Create service-parse SMTP-AUTH value", "MailServiceProvider.createService()", err) ;
								 break;		 
						} // End of switch(nAuth)
							 
						if( prv.bAuthRequired)
						{
							
							 if(ath_string !=null & ath_string.contains(":") )	
							 {	      
							      String[] part_ath = ath_string.split(":");
									  if(part_ath != null && part_ath.length==2)
					          {
					             prv.user = part_ath[0] ;
					             prv.password = part_ath[1] ;
					          }
							 } 			
							 else // else of (ath_string !=null & ath_string.contains(":") )	
							 {
							     err = "Authentication required, but username and password not set. Quit without starting service..." ;
							     prv.debugLog("N/A", "Create service- parse authentication string.", "MailServiceProvider.createService()", err) ;
							     return false;
							 } // end if (ath_string !=null & ath_string.contains(":") )									
									 
						} // end if (bAuthRequired)
							 
						prv.defaultsender =  setbn.getValue("DEFUALT-SENDER-ID");
						
						if("YES".equalsIgnoreCase(setbn.getValue("START-SMTP-SERVICE") ))
						{
						   prv.startMailService();
						}else
						{
						   prv.stopMailService(); 
						}
						
						
						synchronized(cntx)
            {
						    cntx.setAttribute("MAIL-SERVICE-PROVIDER", prv); 
				    }
						 
		    return true ;
		}  //  boolean createService(ServletContext cntx )

    public static java.util.TreeMap<String , com.$WEBAPP.appmail.MailAttachment> attachmentHolder( HttpSession session, boolean bCrt  )
		{
		   String ATH_ID = "ATTACH_"+session.getId();
		   java.util.TreeMap<String , com.$WEBAPP.appmail.MailAttachment> AthMap = null ;
			 // Check if object already exist
       AthMap = (java.util.TreeMap<String , com.$WEBAPP.appmail.MailAttachment>)session.getAttribute(ATH_ID);
       if(AthMap == null && bCrt==true )
       {
            AthMap = new java.util.TreeMap();
		        session.setAttribute(ATH_ID, AthMap);
       }

			  
			 return AthMap ;	
		
		}
		
		

		public com.$WEBAPP.appmail.JavaMailBean initMailBean()
		{
		     if(bMailServiceStarted == false) return null; 
			   com.$WEBAPP.appmail.JavaMailBean mb = new com.$WEBAPP.appmail.JavaMailBean();
			   mb.setSMTPServer(this.smtp_host, this.smtp_port );
			
			   if( this.bAuthRequired ) mb.authenticate(this.user, this.password,  this.bAuthRequired );
			   mb.initSession();
						
			   return mb ;
		
		}
		
		public boolean checkEmailFormat(String email )
		{
       if (email == null) return false ;
       return email.matches("([a-zA-Z0-9_\\-\\.]+)@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,3})") ;
	  }
		
		
		public boolean startBulkMailDispatch(int nJobID)
		{
		    if(bMailServiceStarted == false) return false; 
			  MailDispatchThread th = new MailDispatchThread( this , nJobID);
			  th.start();
		    return true;
		}
		
		public void debugLog(String mailto, String sub, String cnt, String txt)
		{
		    java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis()); 
			  try
			  {
				   DbgLog.MailDebugLogID = 0 ;
					 DbgLog.LogDateTime = now ;
					 DbgLog.MailTo = mailto; 
			     DbgLog.Subject = sub; 
        	 DbgLog.Context = cnt; 
	         DbgLog.LogText = txt; 
           DbgLog.addRecord();
			 
			  }
				catch(Exception e)
			  {
			           String error_log ="Error in logging to H2 database.\n" 
				             + "Dumping to std-error instead. \n"
										 + "Mail To: "+mailto+" \n" 
										 + "Subject: "+sub+" \n"  
										 + "Context: "+cnt+" \n" 
									   + "Error: "+txt+" \n" ;
													 
				          System.err.println(error_log );
			 }
			  
			 
		
		}
	
		
		
		protected String exceptionDump(Exception exception, boolean html)
		{
		      String ret =null;
		      ByteArrayOutputStream bout = new ByteArrayOutputStream();
          exception.printStackTrace(new PrintStream(bout));
			    ret = bout.toString() ;
			    if( html ) ret = ret.replace("\n", "\n<br />") ;
			    return ret ;
		}

		

} // End class definition MailServiceProvider


