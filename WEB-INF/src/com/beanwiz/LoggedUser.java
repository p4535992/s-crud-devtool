// package com.webapp.login ;
package com.beanwiz;
import com.webapp.login.*;
import com.webapp.utils.*;
import org.w3c.dom.* ;
import nu.xom.*  ;

import java.sql.* ;
import javax.sql.* ;

public class LoggedUser implements com.webapp.login.UserLoginObject
{
   
	 /* Private Variables */
     private String error = "" ;
     private String RedirectTo = null;
	   public boolean bValid =  false;
	
	   private String LoggedUserName ="" ;
     private String LoggedUserTitle = "" ;
		 private String LoggedUserRole = "";
		 public String UserID = "";
		
	   private String configfile = null;
     private nu.xom.Builder xmlbuild = null;
     private nu.xom.Document xmldoc = null;	  
     private nu.xom.Element rootElm = null ; 
		
		
     public boolean isValid(){ return  bValid ; }
     public void setSQLEngine(String eng ){}
     public short permit(javax.servlet.http.HttpServletRequest req )
     {
         RedirectTo = null;
        /* Implementation guide: 
  
	         String url = req.getRequestURI() ;
           Examine url and do following 
           (1) Return -1 for forbidding the access to url. 
               The user will be redirected to ? error page
               which is default page after user login.
           (2) Return 0  to permit normal access to url.
    
           (3) Return 1 if you want to redirect to another url. 
               Please set the value of  variable RedirectTo .
               If you return 1 than method redirect() is called next by
               authentication filter. redirect() method returns the variable RedirectTo.
       			
               If necessary HTTP Session, Servlet Context and Remote Address 
							 may be obtained  as follows
               HttpSession session = req.getSession();	
               ServletContext cntx = session.getServletContext(); 	
               String client_ip = req.getRemoteAddr() ;
							 Typical code:
							 if(url.contains("/testpath"))
				       {
				           if( not permitted condition )
									 {
									     RedirectTo = req.getContextPath()+"/not-permited-message" ;
											 return (short)1 ;
									 }
							 }
	       */
				 return 0;
     }
     public String redirect()
     {
         return RedirectTo ;
     }
		 
		 public void extSetUser(String name, String role, String title )
		 {
		     this.LoggedUserName = name ;
				 this.LoggedUserTitle = title ;
				 this.LoggedUserRole  = role ;
				 this.bValid=true; 
				 setupRoleAccess();
		 }
		 
     public boolean authenticate(javax.servlet.http.HttpServletRequest req, javax.servlet.http.HttpSession ses, javax.servlet.ServletContext cntx )
     {
		     this.bValid = false ;
		     try
				 {
	           error="Unknown Error" ;
	           this.configfile =cntx.getInitParameter("XML-AUTH-FILE");
				     java.io.InputStream is =  cntx.getResourceAsStream(this.configfile);
				
				     if(is==null) return false ;
		         this.xmlbuild =  new nu.xom.Builder();
		         this.xmldoc = xmlbuild.build(is);
						 this.rootElm = xmldoc.getRootElement();
						
						 String LoginID = req.getParameter("LoginID") ;
						 String Password = req.getParameter("Password") ;
             Nodes nds = rootElm.query("/userlist/user[@id='"+LoginID+"']");
						 if(nds!=null && nds.size() > 0 )
						 {
						       // record found
						       nu.xom.Node nd = nds.get(0);
									 String id = ((nu.xom.Element)nd).getAttribute("id").getValue();
									 if(id==null || !id.equals(LoginID)) // Extra check for Login Id
									 {
									    // record not found
						          error="Invalid Login ID : "+LoginID ;
					            this.bValid=false;
									 }
							     String pwd = ((nu.xom.Element)nd).getAttribute("password").getValue();
							     if(Password !=null && Password.equals(pwd) )
							     {
									      // password matches
							          this.LoggedUserName = ((nu.xom.Element)nd).getAttribute("name").getValue();
							          this.LoggedUserTitle = ((nu.xom.Element)nd).getAttribute("title").getValue();
							          this.LoggedUserRole  = ((nu.xom.Element)nd).getAttribute("role").getValue();
							          this.bValid=true; 
												this.UserID = id;
									      setupRoleAccess();
							     }
							     else
							     {    // password does not matches
							          error="Invalid Password Entered " ;
					              this.bValid=false;
							     }
						 }
						 else
						 {
						      // record not found
						      error="Invalid Login ID : "+LoginID ;
					        this.bValid=false;
					   }
				}
				catch(Exception ex )
				{
				     error="Internal System Error: "+ex.getMessage();
					    this.bValid=false;
				}
			  return this.bValid ;
    }
	
	 public void invalidate()
	 {
	   this.bValid = false;
	 }
	 public String getUserName()
	 { 
	    return this.LoggedUserName;
	 }
	 public String getTitle()
	 { 
	     return this.LoggedUserTitle;
	 }

	 public String lastError(){ return error ; }

	
	 // NON Interface method
	 void setupRoleAccess()
	 {
	 
	 }
	
	
	
	
	 
}