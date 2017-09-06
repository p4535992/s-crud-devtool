/**
  SMSDispatchThread class handles bulk SMS dispatch
	New dispatch threat of this type will be started 
	by SMS provider derived from WebSMSSerive class  

*/

package com.$WEBAPP.appsms;
import com.db.$DATABASE.* ;

public class SMSDispatchThread extends java.lang.Thread
{
    private int nBatchSize = 0;
    public int nJobID=0;
    public boolean bRetry=false;

    private String whereclause=null;
    private SMSService SMSProvider =null;
		 
		private  Sms_jobsBean job = null;
		private  Sms_joblogBean jbin = null;
		private  Sms_joblogBean jbinUpd=null;
		private  Sms_gatewayaccountsBean ActBn = null;
		
    public SMSDispatchThread( int job, boolean rty ,  SMSService prvd )
    {
         this.nJobID=job;
         this.bRetry=rty;
		     this.SMSProvider = prvd ;
		}

		public boolean init()
		{
		   try
			 {
		        job = new Sms_jobsBean(); 
			      jbin = new Sms_joblogBean();
			      jbinUpd= new Sms_joblogBean();
			      
						//------------------------------//
	 				  job.setDatasource(SMSProvider.getDSN());
	          jbin.setDatasource(SMSProvider.getDSN());
	          jbinUpd.setDatasource(SMSProvider.getDSN());
			      job.locateRecord(this.nJobID);
						this.ActBn = this.SMSProvider.locateAccount(job.AccountID);
						this.nBatchSize=(short)this.ActBn.BatchSize ;
						if(this.ActBn == null) return false;
		   }
			 catch(Exception e)
			 {
			    return false;
			 }
			 return true;
		}
		
    public void run()
    {
         // java bean for table smsjobs 
          // java bean for table smsloblog
        // java bean for table smsjoblog
	
	     
			  
        
        int success=0;
        int failure=0;
	
	      if(bRetry)whereclause=  " WHERE \"JobID\"="+nJobID+" AND \"Flag\"="+SMSErrorCodes.NETWORKERROR+" " ;
	      else whereclause=  " WHERE \"JobID\"="+nJobID+" "  ;
			
				int batchcount = 0;
			  // Check for account specific batch number delimieters
				 String numdelim = "," ; // The default number delimeter 
				 if(this.ActBn.NumberDelimiter!=null && this.ActBn.NumberDelimiter.length()>0) numdelim = this.ActBn.NumberDelimiter ;
					         
				
        int[]  batchids= null ;
				if (nBatchSize > 0) batchids = new int[nBatchSize];
	      for( int n=0 ; n< nBatchSize ; n++ ) batchids[n]=0;
				
        short batchflag = SMSErrorCodes.UNKNOWN ;
				String numstring="";
	      java.sql.Timestamp batchtime=null;
				SMSServerResponse SmsRsp =  null ;
				
	      try
	      {
              job.locateRecord(nJobID);
              job.SmsJobFlag = SMSDispatchStatus.INPROCESS;
              job.updateRecord(nJobID);
              
				      jbin.openTable(whereclause, " ");
				      
	            while(jbin.nextRow())
              {
                  // LOOP BEGIN							
	                /*  
  						         Check for smsjob custom text field ( CustomText)
							         If  CustomText>0 (=1) for every message custom text ( SMSText file) should be loaded 
							         from smsjoblog table.
							        Other wise default job text (SMSText field of smsjob ) should be loaded as SMS message text
						 
	  				       */
                    SmsRsp = null;
                    if(job.CustomText > 0 || nBatchSize==0)
                    {
							           // Send one message per http request as it is custom message or 
									       // SMS service does not handle batch operation 
									 
									        jbinUpd.locateRecord(jbin.SmsJobLogID) ;
									        String Number = jbinUpd.MobileNumber ;
									        // Custom text of log or job's text as message
									        String MsgTxt = (job.CustomText > 0 )? jbinUpd.SMSText : job.SMSText ;
									        SmsRsp =  sendSMS( Number, MsgTxt )	;	 
									        jbinUpd.DispatchDateTime= new java.sql.Timestamp(System.currentTimeMillis());
									        jbinUpd.Response = SmsRsp.Response ;
									        jbinUpd.SmsJobLogFlag = SmsRsp.ReturnVal ;
					                jbinUpd.updateRecord(jbin.SmsJobLogID);
									        if(jbinUpd.SmsJobLogFlag == SMSDispatchStatus.SUCCESS) success++;
									        else failure++;

									  
									 
                    }
                    else  // else of if(job.CustomText > 0 || nBatchSize==0)
                    {
				                 // Same message for all recipients so send it in batches of 
												 // nBatchSize per HTTP request
								 	        batchcount++;
                          if(batchcount < nBatchSize )
                          {
							                   // Keep on building number string and move ahead in loop
                               numstring =  numstring+((batchcount<2)? "": numdelim )+jbin.MobileNumber;
									             batchids[batchcount-1]=jbin.SmsJobLogID;
									
                          }
                          else // of  if(batchcount <BATCHSIZE)
                          { 
							                 // numstring has now BATCHSIZE numbers so send SMS 
                               numstring=numstring+numdelim+jbin.MobileNumber ;
									             batchids[batchcount-1]=jbin.SmsJobLogID;
						                   batchtime =  new java.sql.Timestamp(System.currentTimeMillis()); 
										           SmsRsp = sendSMS( numstring, job.SMSText ); 
										 				   for( int n=0 ; n< batchcount ; n++ )
                    			     {
                    					       jbinUpd.locateRecord(batchids[n]);
                    						     jbinUpd.DispatchDateTime=batchtime;
                    				  	     jbinUpd.SmsJobLogFlag= SmsRsp.ReturnVal;
                    								 if(n < SmsRsp.MsgCount ) jbinUpd.Response = SmsRsp.SendStatus[n] ;
                    								 else jbinUpd.Response = SmsRsp.Response ;
                    				         jbinUpd.updateRecord(batchids[n]);
                                     if(jbinUpd.SmsJobLogFlag == SMSDispatchStatus.SUCCESS) success++;
                                     else failure++;
                                     batchids[n]=0; // zero init

                    			     } // end for( int n=0 ; n< batchcount ; n++ )
										           numstring="";
                               batchcount=0;
                          } // end if  if(batchcount <BATCHSIZE)
                    				 
                    } // end if(job.CustomText > 0 || nBatchSize==0)
	            
							    // LOOP END
	            } // end of while(jbin.nextRow())
	            							
	            jbin.closeTable();
							
	            // Coplete the last batch dispatch in case the while loop has finished
							// before last batch is filled completely. batchcount will be > 0 in that case.
				
	            if(batchcount > 0)
	            {
				           SmsRsp = null;
                   batchtime =  new java.sql.Timestamp(System.currentTimeMillis()); 
								   SmsRsp =  sendSMS( numstring, job.SMSText ); 
                   for( int n=0 ; n< batchcount ; n++ )
								   {
									       jbinUpd.locateRecord(batchids[n]);
										     jbinUpd.DispatchDateTime=batchtime;
										     jbinUpd.SmsJobLogFlag= SmsRsp.ReturnVal;
												 if(n < SmsRsp.MsgCount ) jbinUpd.Response = SmsRsp.SendStatus[n] ;
												 else jbinUpd.Response =  SmsRsp.Response ;
					               jbinUpd.updateRecord(batchids[n]);
												 
                         if(jbinUpd.SmsJobLogFlag == SMSDispatchStatus.SUCCESS) success++;
                         else failure++;
										     batchids[n]=0; // zero init
								   } // end for( int n=0 ; n< batchcount ; n++ )
								   numstring="";
                   batchcount=0;
              } // end if (batchcount > 0)
         
	            job.locateRecord(nJobID);
	            if(bRetry)
	            {
	                // Update Previouse Log
                  job.Success += success ; 
                  job.Failure -= success ; 
                  job.SmsJobFlag=SMSDispatchStatus.SUCCESS;
	            }
	            else
	            {
	                // Create new log
	                job.Success = success ; 
                  job.Failure = failure ; 
                  job.SmsJobFlag = SMSDispatchStatus.SUCCESS;
	            }
	            job.updateRecord(nJobID);

	      }
 	      catch (Exception ex )
 	      {
             String err = "Exception in Dispath: "+SMSProvider.exceptionDump(ex , true);
						 SMSProvider.debuglog("N/A", "Bulk Dispatch Error",  "SMSDispatchThread.run() JobID:"+nJobID, err) ;
 
 	      }
 
    } // end method: run() 
		
		private  SMSServerResponse sendSMS(String Number, String Text )
		{
		    SMSServerResponse SrvRsp = SMSProvider.sendSMS( this.ActBn,  Number, Text );
				return SrvRsp;
		}


} // end class definition

