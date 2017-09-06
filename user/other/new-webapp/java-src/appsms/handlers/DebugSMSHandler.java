package com.$WEBAPP.appsms.handlers;
import com.$WEBAPP.appsms.*;
import com.db.$DATABASE.* ;
import javax.servlet.*;
import com.webapp.httptools.*;

public class DebugSMSHandler implements com.$WEBAPP.appsms.CustomSMSHandler
{
private javax.servlet.ServletContext context = null;
private String dsn = "jdbc/$WEBAPP" ;
private com.$WEBAPP.appsms.SMSService provider = null;

@Override
public void setServletContext(ServletContext cntx )
{
  this.context = cntx;
}

@Override
 public void setDsn(String ds )
 {
   this.dsn = ds;
 }

@Override
 public void setServiceProvider( com.$WEBAPP.appsms.SMSService srv)
 {
   this.provider = srv;
 }


@Override
 public boolean init()
  {
  System.out.println("Init Called From Debug SMS Handler\n");
   return true ;
	
	} 

@Override
 public boolean checkConnectivity(int ActID)
 {
    System.out.println("Check Connectivity Called From Debug SMS Handler - AccountID: "+ActID+"\n");
		return this.provider.defaultCheckConnectivity( ActID);
 
 }

@Override
public int checkSMSBalance(int ActID)
{
   System.out.println("Check SMS Balance Called From Debug SMS Handler -  AccountID: "+ActID+"\n");
   return this.provider.defaultCheckSMSBalance(ActID);
} // end method checkSMSBalance

@Override
public SMSServerResponse sendSMS( Sms_gatewayaccountsBean ActBn, String Number, String Text )
{
    System.out.println("Send SMS Called From Debug SMS Handler -  AccountID: "+ActBn.AccountID+", \nNumber: "+Number+", Message: "+Text+"\n");
    SMSServerResponse rsp = this.provider.defaultSendSMS(ActBn, Number,Text );
  	String[] Nums = Number.split(",");
  	if(Nums!=null)
  	{
    	    rsp.MsgCount = Nums.length;
    			rsp.SendStatus=new String[rsp.MsgCount ];
    			for(int i =0 ; i < rsp.MsgCount ; i++)
    			{
    			   rsp.SendStatus[i] = "OK:"+Nums[i];
          }
  	}
  	
	  return rsp ;
} // End method sendSMS


}// End class definition DebugSMSHandler

 
   
   
   
   
    
    