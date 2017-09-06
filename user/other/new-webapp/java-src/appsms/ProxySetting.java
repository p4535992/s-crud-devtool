package com.$WEBAPP.appsms;
import com.db.$DATABASE.* ;
public class ProxySetting
{
    public boolean UseProxy = false ;
    public String ProxyHost=null ;
    public int ProxyPort=0;
    public String ProxyType= null;
    public String ProxyUser = null ;
    public String UserPassword = null ;
    public String ProxyRealm = null;
    public String ProxyDomain = null;
    public String UserDomain = null;
		
    public void init(String dsn)
    {
      detectProxy(dsn);
	    setupProxy();
    }		
		
   public void detectProxy(String dsn)
	 {
	      UseProxy=false;
	      SMSSetting si = new SMSSetting(dsn);
				if("YES".equalsIgnoreCase(si.getValue("PROXY-SERVER")))
		    {      
		           UseProxy=true ;
		           String[] proxyurl = si.URL.split(":");
						   if(proxyurl.length==2)
               {
                    ProxyPort=0;
			              try  
						        {
		                     ProxyPort=java.lang.Integer.parseInt(proxyurl[1]);
                    } catch(NumberFormatException ex ){  ProxyPort=0; }
               }		
               ProxyHost = proxyurl[0]; 		
               ProxyType = si.getValue("PROXY-AUTH");
               if("NTLM".equalsIgnoreCase(ProxyType))
						   {
						         // MS Proxy
						 	       String ntlm_auth[]=si.URL.split(":"); 
								     // URL := ProxyDomain:ProxyHost:UserDomain:UserName:Password
								     // 5 items are expected in url.
					           if(ntlm_auth.length==5) 
								     {
								           ProxyDomain = ntlm_auth[0]  ;
								           ProxyHost = ntlm_auth[1] ;
								           UserDomain  =  ntlm_auth[2] ;
									         ProxyUser   =  ntlm_auth[4] ;
									         UserPassword =  ntlm_auth[4];
								     }
						   }
						   else
						   {
						         // Non MS Proxy
							       String other_auth[]=si.URL.split(":"); 
							      // URL := realm:user:password ( 3 Items are expected )
							       if(other_auth.length==3)
								     {
								          ProxyRealm = other_auth[0] ;
										      ProxyUser   =  other_auth[1] ;
									        UserPassword =  other_auth[2] ;
								     }
						   } // end if if("NTLM".equalsIgnoreCase(ProxyType)
						
				} // end if("YES".equalsIgnoreCase(si.getValue("PROXY-SERVER")))
				else
				{
				   UseProxy=false;
				}
	 } // End method - detectProxy

      public void setupProxy()
      {
            if(UseProxy == true) 
	          {
	            // Disable system-wide proxy setting
	          }
				    else
				    {
             // Enable system-wide proxy setting
				    }
      } // end function setupProxy()

	 
	 
	 
}