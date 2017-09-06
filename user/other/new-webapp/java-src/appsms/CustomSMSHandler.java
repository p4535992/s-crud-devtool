package com.$WEBAPP.appsms;
import com.db.$DATABASE.* ;
import javax.servlet.* ;
import com.webapp.httptools.*;

public interface CustomSMSHandler
{
    public void setServletContext(ServletContext cntx );
    public void setDsn(String ds );
    public void setServiceProvider( SMSService srv);
    public boolean init();
    public boolean checkConnectivity(int ActID);
    public int checkSMSBalance(int ActID);
    public SMSServerResponse sendSMS( Sms_gatewayaccountsBean ActBn, String Number, String Text );
}