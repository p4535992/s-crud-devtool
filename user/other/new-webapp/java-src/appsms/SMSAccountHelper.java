package com.$WEBAPP.appsms;
import com.db.$DATABASE.* ;
import javax.servlet.* ;
import javax.servlet.http.* ;
import java.io.*;
import org.w3c.dom.*;
import nu.xom.* ;

public class SMSAccountHelper
{
    private static String stringDump(Object ob)
		{
		   return    ob!=null ?  ob.toString() : "";
		}
		 

    public static String exportToXml(Sms_gatewayaccountsBean ActBn)
    {
    		    nu.xom.Element rootElm = new nu.xom.Element("SMSAccount");
    			  nu.xom.Attribute[] atrs = new nu.xom.Attribute[33] ;
    			
    			  atrs[0] = new 	nu.xom.Attribute("Title", ActBn.Title );
    			  atrs[1] = new 	nu.xom.Attribute("AccountType", ""+ActBn.AccountType );
    				atrs[2] = new 	nu.xom.Attribute("StartDate",  stringDump(ActBn.StartDate) );
    			  atrs[3] = new 	nu.xom.Attribute("EndDate", stringDump(ActBn.EndDate)   );
    				atrs[4] = new 	nu.xom.Attribute("ProviderName", ActBn.ProviderName );
    			  atrs[5] = new 	nu.xom.Attribute("Website", ActBn.Website );
    			  atrs[6] = new 	nu.xom.Attribute("ContactPerson", ActBn.ContactPerson );
    				atrs[7] = new 	nu.xom.Attribute("HelpNumbers", ActBn.HelpNumbers );
    			  atrs[8] = new 	nu.xom.Attribute("UserID", ActBn.UserID );
    			  atrs[9] = new 	nu.xom.Attribute("Password", ActBn.Password );
    			  atrs[10] = new 	nu.xom.Attribute("BalanceCheckURL", ActBn.BalanceCheckURL );
    				atrs[11] = new 	nu.xom.Attribute("BalanceCheckFormat", ActBn.BalanceCheckFormat );
    			  atrs[12] = new 	nu.xom.Attribute("BalanceCheckUserIDParam", ActBn.BalanceCheckUserIDParam );
    			  atrs[13] = new 	nu.xom.Attribute("BalanceCheckPasswordParam", ActBn.BalanceCheckPasswordParam );
    			  atrs[14] = new 	nu.xom.Attribute("BalanceCheckOtherParam", ActBn.BalanceCheckOtherParam );
    			  atrs[15] = new 	nu.xom.Attribute("BalanceCheckOtherValue", ActBn.BalanceCheckOtherValue );
    			  atrs[16] = new 	nu.xom.Attribute("PingURL", ActBn.PingURL );
    			  atrs[17] = new 	nu.xom.Attribute("PingResponse", ActBn.PingResponse );
    				atrs[18] = new 	nu.xom.Attribute("SMSSendURL", ActBn.SMSSendURL );
    				atrs[19] = new 	nu.xom.Attribute("SMSSendResponse", ActBn.SMSSendResponse );
    				atrs[20] = new 	nu.xom.Attribute("BatchSize", ""+ActBn.BatchSize );
    				atrs[21] = new 	nu.xom.Attribute("NumberDelimiter", ActBn.NumberDelimiter );
    				atrs[22] = new 	nu.xom.Attribute("ResponseDelimiter", ActBn.ResponseDelimiter );
    				atrs[23] = new 	nu.xom.Attribute("MobileNumberParam", ActBn.MobileNumberParam );
    				atrs[24] = new 	nu.xom.Attribute("SMSTextParam", ActBn.SMSTextParam  );
    				atrs[25] = new 	nu.xom.Attribute("SendSMSUserIDParam", ActBn.SendSMSUserIDParam );
    				atrs[26] = new 	nu.xom.Attribute("SendSMSPasswordParam", ActBn.SendSMSPasswordParam );
    				atrs[27] = new 	nu.xom.Attribute("SenderIDParam", ActBn.SenderIDParam );
    				atrs[28] = new 	nu.xom.Attribute("SenderIDValue", ActBn.SenderIDValue );
    				atrs[29] = new 	nu.xom.Attribute("OtherParam1", ActBn.OtherParam1 );
    				atrs[30] = new 	nu.xom.Attribute("OtherValue1", ActBn.OtherValue1  );
    				atrs[31] = new 	nu.xom.Attribute("OtherParam2", ActBn.OtherParam2 );
    				atrs[32] = new 	nu.xom.Attribute("OtherValue2", ActBn.OtherValue2);
						for(int i=0; i < atrs.length ; i ++ ) rootElm.addAttribute(atrs[i]);
	          nu.xom.Document doc = new nu.xom.Document(rootElm);
						
						return doc.toXML(); 

						
						
						
						

		}  // End method exportToXml
		
		public static boolean ImportFromXml(Sms_gatewayaccountsBean ActBn , String xml)
		throws IOException, ParsingException
		{
		      if(ActBn==null) return false;
					nu.xom.Builder builder = new nu.xom.Builder();
          StringReader sr = new StringReader(xml);
		      nu.xom.Document doc = builder.build(sr);
          nu.xom.Element rootElm = doc.getRootElement();
					if(rootElm !=null && rootElm.getLocalName().equals("SMSAccount"))
					{
					
					        ActBn.Title = rootElm.getAttributeValue("Title"); 
									try
									{
                	  ActBn.AccountType = Short.parseShort( rootElm.getAttributeValue("AccountType") ) ;
                	}catch(NumberFormatException e)
									{
									   ActBn.AccountType= SMSAccountType.UNKNOWN ;
									}
									String strStartDate = rootElm.getAttributeValue("StartDate");
									if(strStartDate !=null && strStartDate.length()>0 )
									{
									    try
										  {
									         ActBn.StartDate = java.sql.Date.valueOf(strStartDate);
										  }catch(IllegalArgumentException e){ ActBn.StartDate=null ; }
									}
									else 
									{ 
									     ActBn.StartDate=null ; 
									}
									
									String strEndDate =  rootElm.getAttributeValue("EndDate");
									if(strEndDate !=null && strEndDate.length()>0 )
									{
									    try
										  {
									       ActBn.EndDate = java.sql.Date.valueOf(strEndDate) ;
										  }catch(IllegalArgumentException e){ ActBn.EndDate=null ; }
									}
									else 
									{ 
									    ActBn.EndDate=null ; 
                  }
                	ActBn.ProviderName = rootElm.getAttributeValue("ProviderName")  ; 
                	ActBn.Website = rootElm.getAttributeValue("Website")  ; 
                	ActBn.ContactPerson = rootElm.getAttributeValue("ContactPerson")  ; 
                	ActBn.HelpNumbers = rootElm.getAttributeValue("HelpNumbers")  ; 
                	ActBn.UserID = rootElm.getAttributeValue("UserID")  ; 
                	ActBn.Password = rootElm.getAttributeValue("Password")  ; 
                	ActBn.BalanceCheckURL = rootElm.getAttributeValue("BalanceCheckURL")  ; 
                	ActBn.BalanceCheckFormat = rootElm.getAttributeValue("BalanceCheckFormat")  ; 
                	ActBn.BalanceCheckUserIDParam = rootElm.getAttributeValue("BalanceCheckUserIDParam")  ; 
                	ActBn.BalanceCheckPasswordParam = rootElm.getAttributeValue("BalanceCheckPasswordParam")  ; 
                	ActBn.BalanceCheckOtherParam = rootElm.getAttributeValue("BalanceCheckOtherParam")  ; 
                	ActBn.BalanceCheckOtherValue = rootElm.getAttributeValue("BalanceCheckOtherValue")  ; 
                	ActBn.PingURL = rootElm.getAttributeValue("PingURL")  ; 
                	ActBn.PingResponse = rootElm.getAttributeValue("PingResponse")  ; 
                	ActBn.SMSSendURL = rootElm.getAttributeValue("SMSSendURL")  ; 
                	ActBn.SMSSendResponse = rootElm.getAttributeValue("SMSSendResponse")  ; 
									try
									{
                	    ActBn.BatchSize = Short.parseShort(rootElm.getAttributeValue("BatchSize") );
									}
									catch(NumberFormatException ex)
									{
									    ActBn.BatchSize = 0;
									}
									 
                	ActBn.NumberDelimiter = rootElm.getAttributeValue("NumberDelimiter")  ; 
                	ActBn.ResponseDelimiter = rootElm.getAttributeValue("ResponseDelimiter")  ; 
                	ActBn.MobileNumberParam = rootElm.getAttributeValue("MobileNumberParam")  ; 
                	ActBn.SMSTextParam = rootElm.getAttributeValue("SMSTextParam")  ; 
                	ActBn.SendSMSUserIDParam = rootElm.getAttributeValue("SendSMSUserIDParam")  ; 
                	ActBn.SendSMSPasswordParam = rootElm.getAttributeValue("SendSMSPasswordParam")  ; 
                	ActBn.SenderIDParam = rootElm.getAttributeValue("SenderIDParam")  ; 
                	ActBn.SenderIDValue = rootElm.getAttributeValue("SenderIDValue")  ; 
                	ActBn.OtherParam1 = rootElm.getAttributeValue("OtherParam1")  ; 
                	ActBn.OtherValue1 = rootElm.getAttributeValue("OtherValue1")  ; 
                	ActBn.OtherParam2 = rootElm.getAttributeValue("OtherParam2")  ; 
                	ActBn.OtherValue2 = rootElm.getAttributeValue("OtherValue2")  ; 
		
					        return true ;
					}
					else
					{
					    return false;
					
					}
		
		}  // End method ImportFromXml

}  // End class definition