package com.$WEBAPP.appsms;
import com.db.$DATABASE.* ;
import com.webapp.httptools.*;
import javax.servlet.* ;
import java.io.*;
import java.util.*;
import java.util.regex.*;
import java.sql.* ;
import org.apache.http.* ; 
import org.apache.http.client.* ;
import org.apache.http.client.utils.* ;
import org.apache.http.client.fluent.* ;
import org.apache.http.util.* ;


public class SMSService implements javax.servlet.ServletContextListener
{
		
		private final int MILISEC = 1000 ;
		private String version = "1.0";
		private String updated = "Feb. 2013" ;
		private String NumerCheckRegExp = "[789]\\d{9}";  // /^[789]\\d{9}$/i
		private String ValidNumberAdvise = "10 digit number starting with 7,8, or 9" ;
    private int ConnectionTimeOut = 10;
		private boolean bSMSServiceStatus;
		private boolean bScheduleSMSStatus;
		
		private String dsn = null;
		private ServletContext context = null;
		private boolean bUseProxy=false;
		private String proxyhost=null;
		private short proxyport=(short)0;
		private TreeMap<Integer, CustomSMSHandler> mapHanders = null;
		
						    
								
		
    
		private ProxySetting proxy = null;
		private Sms_debuglogBean DbgLog = new Sms_debuglogBean();
		
		
		
		/* Implementation for Interface Methods */
		 /* Mehods below are implementation of Interface:ServletContextListener */
		@Override 
	  public void contextInitialized(ServletContextEvent sce)
    {
				initSMSService(sce.getServletContext()); 
	  }
	 
	  @Override
		public void contextDestroyed(ServletContextEvent sce)
    {
       // Empty facade just required to complete the interfact implementation
    }  // contextDestroyed(ServletContextEvent sce)
		
		
		/* Other non-Interface methods */
		
	
		
		public void initSMSService(ServletContext cntx )
		{
		     boolean bInitOK =true;
			   this.context = cntx;
			   this.dsn = this.context.getInitParameter("WEBSMS-DATASOURCE");
			   if( this.dsn==null ) this.dsn="jdbc/$WEBAPP" ; // Assume defualt value if not set
			   proxy = new  ProxySetting();
			   proxy.init(this.dsn);
				 this.bUseProxy = proxy.UseProxy;
				 
				 this.DbgLog.setDatasource(this.dsn);
				 
			   SMSSetting si = new SMSSetting(dsn);
			   if(si.lookup("NUMBER-CHECK-REGEXP")) 
    	   {
				      this.NumerCheckRegExp = si.Value ;
					    this.ValidNumberAdvise = si.URL ;
		     }
				 if("YES".equalsIgnoreCase(si.getValue("START-SMS-SERVICE")))  
  			 {
								startSMSService();	
				 }
				 if("YES".equalsIgnoreCase(si.getValue("START-SCHEDULED-SMS-DISPATCH"))) 
			   {
				       startScheduleSMS();  
				 }
				 try
				 {
				       this.ConnectionTimeOut =Integer.parseInt( si.getValue("CONNECTION-TIMEOUT") );
				 }
				 catch(NumberFormatException e)
				 {
				       this.ConnectionTimeOut = 10;
				 }
				 
				 
				 // Load custom SMS Handlers Start
				 mapHanders = new TreeMap<Integer, CustomSMSHandler>();
				 Sms_handlerBean handbn = new Sms_handlerBean();
    		 handbn.setDatasource(this.dsn);
				 try
				 {
				      handbn.openTable(" ", " ");
				      while(handbn.nextRow())
				      {
								 if(handbn.HandlerClass !=null && handbn.HandlerClass.length()>0 )  
      				   {
								       try
										   {
										         CustomSMSHandler handler = (CustomSMSHandler)Class.forName(handbn.HandlerClass).newInstance();
											       if(handler!=null && handler instanceof CustomSMSHandler)
											       {
											         handler.setServletContext(this.context);
													     handler.setDsn(this.dsn);
    										       handler.setServiceProvider(this);
															 if( handler.init() ) mapHanders.put( new Integer(handbn.AccountID), handler);
															 else 	debuglog("Custom SMS  Handler", "Load Custom Handler" , "SMSService.initSMSService Account ID: "+handbn.AccountID, "Init Method of Handler: "+handbn.HandlerClass+" failed." );
											       }
														 else
														 {
													     debuglog("Custom SMS  Handler", "Load Custom Handler" , "SMSService.initSMSService Account ID: "+handbn.AccountID, "Class Type Error, Handler Class:"+handbn.HandlerClass+" does not implement  CustomSMSHandler interface" );
														 }
										  }
										  catch(Exception ex)
										  {
										     	debuglog("Custom SMS  Handler", "Load Custom Handler" , "SMSService.initSMSService Account ID: "+handbn.AccountID, "Line 130: Exception thrown: "+ex.getMessage() );
										  }
								 } // end if(handbn.HandlerClass !=null && handbn.HandlerClass.length()>0 )  
				 
				      }// end while(handbn.nextRow())
							handbn.closeTable();
				 
				 }catch(java.sql.SQLException ex)
				 {
				    debuglog("Custom SMS  Handler", "Load Custom Handler" , "SMSService.initSMSService", "Line 139: SQL Exception thrown, Table:  "+handbn._tablename+" Details: "+ex.getMessage() );
				 }
				 // Load custom SMS Handlers End

			   if(bInitOK) this.context.setAttribute("WEBSMS-SERVICE", this );
		}
		
		public ApacheHCHelper getHttpHelper()
		{
		
		    ApacheHCHelper hlp = new  ApacheHCHelper();
				hlp.setTimeout(MILISEC * this.ConnectionTimeOut);
				 
				 if(this.bUseProxy == true )
				 {
				      // setup proxy
						  hlp.useProxy(proxy.ProxyHost, proxy.ProxyPort);
						  if("NTLM".equalsIgnoreCase(proxy.ProxyType))
						  {
						     hlp.proxyAuthNT(proxy.ProxyUser, proxy.UserPassword , proxy.UserDomain, proxy.ProxyDomain);
						  }
              else
              {
						     hlp.proxyAuthOther(proxy.ProxyUser, proxy.UserPassword);
						  }						 
				 
         }			
		     return hlp;
		} // end method getHttpHelper()
		
		public String getVersion(){ return this.version ;} ;
		public String lastUpdated(){ return this.updated ;} ;
		
		public boolean getSMSServiceStatus(){return bSMSServiceStatus ;} 
		public boolean getScheduleSMSStatus(){return bScheduleSMSStatus ;}
		public void startSMSService()
		{
		   this.bSMSServiceStatus = true;
		}
		public void stopSMSService()
		{
		   this.bSMSServiceStatus = false;
		}
    public void startScheduleSMS()
		{
		   this.bScheduleSMSStatus = true;
		}
		public void stopScheduleSMS()
		{
		   this.bScheduleSMSStatus = false;
		}
		
		public void setDSN(String ds){ this.dsn =ds ;} 
		public String getDSN(){ return this.dsn ;}

		public String getNumberCheckRegExp(){ return this.NumerCheckRegExp ;}
    public String getValidNumberAdvice(){ return this.ValidNumberAdvise ;}

		protected Sms_gatewayaccountsBean locateAccount(int nActID)
		{
		    try
				{
				     Sms_gatewayaccountsBean ActBn = new Sms_gatewayaccountsBean();
						 ActBn.setDatasource(this.dsn);
						 if(! ActBn.locateRecord( nActID) ) 
				     {
     					     debuglog("SMS Account", "Account Locate Failure", "Service.locateAccount() Account ID: "+nActID, "Error in locating SMS Gateway Account: "+nActID  );
								   return null;
			       }
				     return ActBn ;
				}
				catch(SQLException exSQL)
				{
				   debuglog("SMS Account", "SMS Gateway Account Location Failure", "Service.locateAccount() Account ID: "+nActID, exceptionDump(exSQL, true) );
				  return null ;
				}
		}
		
		public synchronized  boolean checkConnectivity(int ActID)
		{
		   	 
				 
				  Integer it =new Integer(ActID);
				  if( mapHanders.containsKey(it))
					{
					   CustomSMSHandler handler = mapHanders.get(it);
						 if(handler!=null) return handler.checkConnectivity(ActID);
						 else return this.defaultCheckConnectivity( ActID);
					}
					else
					{
					  return this.defaultCheckConnectivity( ActID);
					}
				
		} // end method checkConnectivity(int ActID)
		
		
		public synchronized  boolean defaultCheckConnectivity(int ActID)
		{
				  Sms_gatewayaccountsBean ActBn = locateAccount( ActID);
					if(ActBn==null) return false ;
					if(ActBn.PingURL==null || ActBn.PingURL.length()==0)
					{
					   // If ActBn.PingURL not specified than use Balance Check 
					   int nBal = checkSMSBalance(ActID);
						 if(nBal >= 0) return true ;
						 else return false;
					}

					ApacheHCHelper hc = getHttpHelper();
					try
					{     
					       hc.clearParams();
   				       hc.setUrl(ActBn.PingURL);
								 HttpResp  HcResp  = hc.get();
					       String RspTxt = HcResp.ResponseText ; 
				         if( ActBn.PingResponse != null ||  ActBn.PingResponse.length()> 0)
								 {
            					return  ( ActBn.PingResponse.equalsIgnoreCase(RspTxt) )? true : false;
								 }
								 else
								 {
									    return  ( HcResp.StatusCode >=200 && HcResp.StatusCode  <= 300 ) ?  true : false ;
								 }
					}catch(Exception ex)
					{
					       String dump = exceptionDump(ex, true);
                 debuglog("Connection", "Check Connectivity With Server", "SMSService.checkConnectivity() AccountID:"+ActID   , dump );
					       return false;
					}
			 //return false;
		} // end method defaultCheckConnectivity(int ActID)
		
		
		private String findRegExp( String regexp, String source )
		{
		    Pattern pat = Pattern.compile(regexp); // ,  Pattern.DOTALL
		    Matcher mth = pat.matcher(source);
				String found = null;
				if (mth.find()) 
				{
				   found=mth.group();
				}
        return found ;
		}
		
		public synchronized  int checkSMSBalance(int ActID)
		{
		
				  Integer it =new Integer(ActID);
				  if( mapHanders.containsKey(it))
					{
					   CustomSMSHandler handler = mapHanders.get(it);
						 if(handler!=null) return handler.checkSMSBalance(ActID);
						 else return this.defaultCheckSMSBalance(ActID);
					}
					else
          {
					   return this.defaultCheckSMSBalance(ActID);
					}
		
		} // end method checkSMSBalance(int ActID)
		
    public synchronized  int defaultCheckSMSBalance(int ActID)
		{
					Sms_gatewayaccountsBean ActBn = locateAccount(ActID);
					if(ActBn==null)  return -1;
					String RspTxt = "";
					ApacheHCHelper hc = getHttpHelper();
		 		  try
					{
					       hc.clearParams();
   				       hc.setUrl(ActBn.BalanceCheckURL );
					       hc.addParam(ActBn.BalanceCheckUserIDParam, ActBn.UserID);
					       hc.addParam(ActBn.BalanceCheckPasswordParam, ActBn.Password );
	               if(ActBn.BalanceCheckOtherParam!=null &&  ActBn.BalanceCheckOtherParam.length() > 0)
					       {
					          hc.addParam(ActBn.BalanceCheckOtherParam, ActBn.BalanceCheckOtherValue );
					       }
	               HttpResp  HcResp  = hc.get();
								 RspTxt =  HcResp.ResponseText ;
					}	
					catch(Exception exGen)
					{
					      debuglog("Balance", "Error in balance checking" , "Service.checkSMSBalance; Account ID: "+ActID, exceptionDump(exGen, true)   );
							  return -1;
					
					}						 
												 
         String balString = "0" ;
				 int nBal=0;
				 if(ActBn.BalanceCheckFormat !=null && ActBn.BalanceCheckFormat.length()>0)
				 {
				     // RegExp present for balance check response
				       balString = findRegExp( ActBn.BalanceCheckFormat, RspTxt);
							 if(balString == null)
							 {
							     debuglog("Balance", "Response Text: "+RspTxt , "Service.checkSMSBalance; Account ID: "+ActID, "Error in finding match for RegEx: "+ActBn.BalanceCheckFormat+"  "  );
							  return -1;
							 }
				 }
				 else
				 {
				      // RegExp not present for balance check response
							// Assume response as plan string representation of balance.
				      balString = RspTxt ;
				 }
				 try
				 {
				      nBal = Integer.parseInt(balString);
				 }catch(NumberFormatException ex)
				 { 
				      debuglog("Balance", balString , "Service.checkSMSBalance; Account ID: "+ActID, "Error in reading response: [ "+balString+" ] as balance value."  );
				      nBal =-1 ;
				 } 
				 return nBal ;
		} // end method defaultCheckSMSBalance(int ActID)
		
		
	  public SMSServerResponse sendSMS( int ActID, String Number, String Text )
		{
		       Sms_gatewayaccountsBean ActBn = locateAccount(ActID);
					 SMSServerResponse SrvRsp = null ;
					 if(ActBn == null )
					 {
					     SrvRsp = new SMSServerResponse();
					     SrvRsp.Response="Account Error:( ID: "+ActID+" ) Not Found." ;
					     SrvRsp.ReturnVal = SMSErrorCodes.ABORTED;
							 return SrvRsp ;
					 }
					 SrvRsp = this.sendSMS(ActBn, Number,Text );
					 return SrvRsp;
		}
		
		public  synchronized  SMSServerResponse sendSMS( Sms_gatewayaccountsBean ActBn, String Number, String Text )
		{
		    	// if Custom handler is defined than hand over to that)
			    Integer it =new Integer(ActBn.AccountID);
				  if( mapHanders.containsKey(it))
					{
					   CustomSMSHandler handler = mapHanders.get(it);
						 if(handler!=null) return  handler.sendSMS( ActBn,Number,Text );
						 else return this.defaultSendSMS( ActBn,Number,Text );
					}
					else
					{
					   return this.defaultSendSMS( ActBn,Number,Text );
					}
		
		} // end method ( Sms_gatewayaccountsBean ActBn, String Number, String Text )
		
		
    public  synchronized  SMSServerResponse defaultSendSMS( Sms_gatewayaccountsBean ActBn, String Number, String Text )
		{
				  SMSServerResponse SrvRsp = new SMSServerResponse();
			    SrvRsp.protocol= SMSServerResponse.HTTP ;
					// Check for Blank 
					if(Number==null || Number.length()==0 || Text==null || Text.length()==0)
					{
					   // Do not send SMS to blank numbers or with blank text
						    debuglog(Number, Text,"SMSService.SendSMS- Blank Num?"  , "Either the mobile number  or the message is blank !( Account ID: "+ActBn.AccountID+" )" );
						    SrvRsp.Response ="SMS Check Error: Number / Message is blank. ( Account ID: "+ActBn.AccountID+" )" ;
						    SrvRsp.ReturnVal = SMSErrorCodes.BLANK ;
						    return SrvRsp ;		
					}
					
					// Check for invalid number
					/*
					if(!this.checkNumber(Number))
					{
					  		debuglog(Number, Text,"SMSService.SendSMS- Invalid Number."  , "The mobile number is invalid ( Account ID: "+ActBn.AccountID+" )" );
						    SrvRsp.Response ="SMS Check Error: Invalid Number. ( Account ID: "+ActBn.AccountID+" )" ;
						    SrvRsp.ReturnVal = SMSErrorCodes.BADFORMAT ;
						    return SrvRsp ;		
					}
          
							// Check for too long text
					if(Number.length() > 160)
					{
					  		debuglog(Number, Text,"SMSService.SendSMS- Very long text"  , "SMS text is too long ( Account ID: "+ActBn.AccountID+" )" );
						    SrvRsp.Response ="SMS Check Error: Very Long SMS Text ( Account ID: "+ActBn.AccountID+" )" ;
						    SrvRsp.ReturnVal = SMSErrorCodes.SMS_TOO_LONG ;
						    return SrvRsp ;		
					}
			
	        */
					
					 ApacheHCHelper hc = getHttpHelper();
           try
           {			    
					      hc.clearParams();
   					    hc.setUrl(ActBn.SMSSendURL);
								// User ID and Password
								hc.addParam(ActBn.SendSMSUserIDParam, ActBn.UserID);
						    hc.addParam(ActBn.SendSMSPasswordParam, ActBn.Password );
								// GSM Sender ID
								hc.addParam(ActBn.SenderIDParam, ActBn.SenderIDValue);
								// Number and Text Message
								hc.addParam(ActBn.MobileNumberParam , Number);
								hc.addParam(ActBn.SMSTextParam, Text);
								
								// Other Parameters if relevent
								if(ActBn.OtherParam1!=null &&  ActBn.OtherParam1.length() > 0)
					      {
					          hc.addParam(ActBn.OtherParam1, ActBn.OtherValue1 );
					      }
	              if(ActBn.OtherParam2!=null &&  ActBn.OtherParam2.length() > 0)
					      {
					          hc.addParam(ActBn.OtherParam2, ActBn.OtherValue2 );
					      }
								HttpResp  HcResp  = hc.get();
								
								SrvRsp.StatusCode = HcResp.StatusCode ;
						    if(HcResp.StatusCode>300 )SrvRsp.ReturnVal = SMSErrorCodes.SMSCERROR ;
								else SrvRsp.ReturnVal = SMSDispatchStatus.SUCCESS ;
						    SrvRsp.Response = HcResp.ResponseText ;
					 }	
					 catch(Exception exGen)
					 {
					      String dump = exceptionDump(exGen, true);
					      String cntx = "SMSService.sendSMS; Line 322 ; Account ID: "+ ActBn.AccountID ; 
                debuglog(Number, Text,cntx , dump );
						    SrvRsp.Response ="Http Protocol Exception: "+exGen.getMessage()+" ( Account ID: "+ActBn.AccountID+" )" ;
						    SrvRsp.ReturnVal = SMSErrorCodes.NETWORKERROR;
						    return SrvRsp ;		
					 }		
					 // Calculate Message Count
					     if(SrvRsp.ReturnVal == SMSDispatchStatus.SUCCESS)
					     {
					          SrvRsp.MsgCount = 1; // the default value
					          SrvRsp.SendStatus = new String[1] ; // the default value
					          SrvRsp.SendStatus[0]= SrvRsp.Response ; // the default value
					          String numdelim = "," ; // The default number delimeter 
					          if(ActBn.NumberDelimiter!=null && ActBn.NumberDelimiter.length()>0) numdelim = ActBn.NumberDelimiter ;
					          if(Number.contains(numdelim) &&  ActBn.ResponseDelimiter !=null && ActBn.ResponseDelimiter.length() > 0 )
					          {
   					             String[] nums = Number.split(numdelim);
		                     if(nums.length > 0 )
							           {				 
												     SrvRsp.MsgCount = nums.length ;
					                   SrvRsp.SendStatus =  new String[ nums.length ] ;
														 String[] rsps = SrvRsp.Response.split(ActBn.ResponseDelimiter);
														 if(rsps!=null && rsps.length == nums.length )
														 {
														      for(int x=0; x< nums.length ; x++) SrvRsp.SendStatus[x] = rsps[x] ;
														 } //
					               }
					          } // end if  if(Number.contains(numdelim))
					     }// end if 
					 
		     return SrvRsp ;
		} // end method defaultSendSMS( SmsgatewayaccountsBean ActBn, String Number, String Text )
		
    public boolean startBulkSMSDispatch(int JobID , boolean bRetry )
		{
		    if(!this.bSMSServiceStatus) return false;
		    SMSDispatchThread th = new SMSDispatchThread(JobID, bRetry, this ) ;
				if( th.init())
				{
				   th.start();
			     return true;
				}
				else
				{
				  return false;
				}
			  
		}
		
		public boolean checkNumber(String number )
		{ 
         if (number==null) return false ;
         return number.matches(NumerCheckRegExp) ;
		}
		
		
		
		
		public void debuglog(String num, String msg, String cnt, String txt)
		{
		     java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis()); 
		     try
			   {     
			         DbgLog.SmsDebugLogID = 0 ;
				       DbgLog.LogDateTime = now;
               DbgLog.Number = num ;
               DbgLog.Message = msg ;
               DbgLog.Context = cnt ;
				       DbgLog.LogText = txt ;
               DbgLog.addRecord();
			   }catch(Exception e)
				 { 
				          String error_log ="Error in logging to H2 database.\n" 
				                   + "Dumping to std-error instead. \n"
													 + "Time: "+now+" \n"  
													 + "Number: "+num+" \n"  
													 + "Message: "+msg+" \n"  
													 + "Context: "+cnt+" \n" 
													 + "Error: "+txt+" \n" ;
													 
				          System.err.println(error_log );
									System.err.println("\nException:\n"+exceptionDump(e, false));
				 }
		} // End Method debuglog

		
		protected String exceptionDump(Exception exception, boolean html)
		{
		      String ret =null;
		      ByteArrayOutputStream bout = new ByteArrayOutputStream();
          exception.printStackTrace(new PrintStream(bout));
			    ret = bout.toString() ;
			    if( html ) ret = ret.replace("\n", "\n<br />") ;
			    return ret ;
		} // End method exceptionDump
		
		// STATIC functions
		
		public static void removeService(ServletContext cntx)
		{
				synchronized(cntx)
        {
						   cntx.removeAttribute("WEBSMS-SERVICE"); 
				}		 
		}
		
		public static void setupService(ServletContext cntx)
		{
		    synchronized(cntx)
        {
		          SMSService srv = new SMSService();
			        srv.initSMSService(cntx);
			  }	 
		}
		
		public static void resetService(ServletContext cntx)
		{
		    removeService(cntx);
				setupService(cntx);
				
		}
		
		
		
} // End clas definition SMSService



