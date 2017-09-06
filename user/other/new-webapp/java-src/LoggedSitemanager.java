package com.$WEBAPP ;
import com.db.$DATABASE.* ;
import com.webapp.login.* ;
import com.webapp.utils.* ;
import java.io.* ;
import java.sql.* ;
import javax.naming.* ;
import javax.sql.* ;	
import javax.servlet.*;
import javax.servlet.http.*;

public class LoggedSitemanager implements com.webapp.login.UserLoginObject, javax.servlet.http.HttpSessionBindingListener
{
/*  optional declaration
    public static final String LoginRole = Administrator ;
*/
    private boolean bValid=false;
    public String Error="none" ;

//  ID Filed ( Integer Type )
    public int AdminID=0 ; 
	public byte SuperAdminRight = 0 ;
	public String ClientAddress = null;
	public short PasswordType = 0;
	public short CurrentStatus = 0;
	public short LoginStatus = 0;
	public short MultiLogin = 0;
	
	private SitemanagerBean SimngrBn = new SitemanagerBean();
	private AccesslogofsitemanagerBean AlogSmBn = new AccesslogofsitemanagerBean();
    private String LoggedUserName ="" ;
    private String LoggedUserTitle = "Site Manager" ;
    private String RedirectTo = null;

//  Object for Portable SQL implementation
	private com.webapp.utils.PortableSQL psql = null;
//  Servlet context reference
	private ServletContext context = null;
		
/* TO DO: Declare other variables related to login
    private int $1
    private String $2
*/
/*
	Implementation of interface com.webapp.login.UserLoginObject
*/	
    @Override
    public boolean isValid()
    {
		return bValid ;
    } // end method isValid()
 
     @Override
    public void setSQLEngine(String eng )
    {
	 // construct the Portable SQL engine
		psql = new com.webapp.utils.PortableSQL(eng) ;
    } 
    @Override
    public short permit(javax.servlet.http.HttpServletRequest req )
    {
        RedirectTo = null;
		String url = req.getRequestURI() ;
		if( SuperAdminRight==1)
		{
			return 0 ;
        }
		else
		{
			
			if(url.contains("/admin/superadmin"))
			{
				RedirectTo = req.getContextPath()+"/admin/forbidden.jsp" ;
				return 1 ;
			}	
		}				
				if(url.contains("/admin/setregularpassword.jsp")) return 0;
				if(this.PasswordType == com.$WEBAPP.PasswordType.SERVICE ) 
				{
				  RedirectTo =  req.getContextPath()+"/admin/setregularpassword.jsp" ;
					return 1;
				}
        return 0;
        /*  Implementation guide: 
  
	        String url = req.getRequestURI() ;
            Examine url and do following 
            (1) Return -1 for forbidding the access to url. 
                The user will be redirected to /admin/index.jsp 
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
	}   // end method permit(javax.servlet.http.HttpServletRequest req )
		
	@Override
    public String redirect()
    {
       return RedirectTo ;
    }   // end method redirect()
		
    @Override
    public boolean authenticate(javax.servlet.http.HttpServletRequest req, javax.servlet.http.HttpSession ses, javax.servlet.ServletContext cntx )
    {
        this.context = cntx;
		String chk_ID = req.getParameter("Username") ;
        String chk_Pass = req.getParameter("Password") ;
		ClientAddress = req.getRemoteAddr() ;
        bValid = check(chk_ID , chk_Pass) ;
        return bValid ;
    } // end method authenticate
	 
	  // Non-Interface method
    public boolean check(String id , String pwd )
    {
        boolean bSuccess = false ;
		
		// Create the portable query which should work for diverse SQL servers
					
        try   // Outer try block
        {
            Context env = (Context) new InitialContext().lookup("java:comp/env") ;
            DataSource source = (DataSource) env.lookup("jdbc/$DATABASE") ;
            java.sql.Connection conn = source.getConnection() ;
            /*   
                Handle worst case scenario of having no idea about SQL engine.
                This will happen when SQL Engine is set as UNKNOWN by login servlet.
                SQL-ENGINE init parameter is not set for servert and for web-app.
            */ 
            if(conn !=null && psql!=null && psql.getEngine()==PortableSQL.UNKNOWN )
            {
                psql.setEngineFromConnection(conn);
            }

                
    //  Allow changing the Login ID field by run time setting:
	/*
		Read the application setting value TEACHER-LOGIN
		1 = AdminID, 2 = EmpCode, 3 = Mobile, 4 = Email, 5 = Username
	*/
														
        com.$WEBAPP.AppSetting si = new com.$WEBAPP.AppSetting(this.context);
        int admin_login_type =0;
        try
        {
            admin_login_type = Integer.parseInt(si.getValue("ADMIN-LOGIN-TYPE"));
        }
        catch(NumberFormatException ex)
        {
            admin_login_type = 5;
        }
		
		String Query = "" ;
		switch(admin_login_type)
		{
			case 1:  // AdminID
				Query = psql.SQL("SELECT * FROM `sitemanager` WHERE  `AdminID`="+id+" " ) ;
			break;
					 
			case 2:  // EmpCode
				Query = psql.SQL("SELECT * FROM `sitemanager` WHERE  `EmpCode`= '"+id+"' " ) ;
			break;
				
			case 3:  // Mobile
				Query = psql.SQL("SELECT * FROM `sitemanager` WHERE  `Mobile`= '"+id+"' " ) ;
			break;  

			case 4:  // Email
				Query = psql.SQL("SELECT * FROM `sitemanager` WHERE  `Email`='"+id+"' " ) ;
			break;

			case 5:  // Username
				Query = psql.SQL("SELECT * FROM `sitemanager` WHERE  `Username`='"+id+"' " ) ;
			break;
		} //end switch(admin_login_type)
													 
        try  // Inner try block
        {
            java.sql.Statement stmt = conn.createStatement() ;
            java.sql.ResultSet rslt = stmt.executeQuery(Query) ; 
            if(rslt.next())
            {
            //  Login ID Found, so check password           
                String db_pass = rslt.getString("Password") ;
				boolean pw_sens = false ;
				if( "YES".equals(si.getValue("PASSWORD-CASE-SENSITIVE")) )
				{
					pw_sens = db_pass.equals(pwd) ? true : false ;
				}
				else
				{
					pw_sens = db_pass.equalsIgnoreCase(pwd) ? true : false ;
				}
                if(pw_sens)
                {

                // ID Filed ( Integer Type )
                    AdminID = rslt.getInt("AdminID") ;
					SuperAdminRight = rslt.getByte("SuperAdminRight");
					PasswordType = rslt.getShort("PasswordType");
					CurrentStatus = rslt.getShort("CurrentStatus");
					LoginStatus = rslt.getShort("LoginStatus");
					MultiLogin = rslt.getShort("MultiLogin");
                    LoggedUserName = rslt.getString(2)+" "+rslt.getString(3)+" "+rslt.getString(4)+" " ;
                /*
                    Set other variables related to login if declared ;
                    $var = rslt.get?($field );
                */
					if(this.LoginStatus==com.$WEBAPP.LoginStatusFlag.LOGGED && this.MultiLogin ==0)
					{ 
					//Multiple simultaneous logins with same AdminID is not permitted.
						bSuccess=false;
						Error="Simultaneous Multiple Login Error" ;
					}
					else
					{
					
							if(this.CurrentStatus==com.$WEBAPP.CurrentStatusFlag.BARRED || this.CurrentStatus==com.$WEBAPP.CurrentStatusFlag.LEFT)
									 {
						           //Login is barred by the administrator.
					             bSuccess=false;
					             Error="Login Is Barred By Administrator" ;
						         
									 }
					         else
					         {
				 	
					
								//  Password matches
									bSuccess=true ;
									
									//  LoginStatus Update
										SimngrBn.locateRecord(this.AdminID);
										SimngrBn.LoginStatus = com.$WEBAPP.LoginStatusFlag.LOGGED;
										SimngrBn.updateRecord(this.AdminID);
								
								//  On successful login create access log entry																			 
									AlogSmBn.RecordID = 0; 
									AlogSmBn.AdminID = this.AdminID ;
									AlogSmBn.LoginTime = new java.sql.Timestamp(System.currentTimeMillis()) ;
									AlogSmBn.LogoutTime = null ;
									AlogSmBn.IPAddress = this.ClientAddress ;
									AlogSmBn.Flag = 0 ;
									AlogSmBn.addRecord();
							 }
					}
                }
                else // else if(db_pass.equals(pwd))
                {
                //  Password does not match
                    Error="Invalid Password Entered" ;
                    bSuccess=false ;
                } // end if(db_pass.equals(pwd))
            }
            else // else if(rslt.next())
            {
            //  Login ID Not Found.
                bSuccess=false ;
                Error= "Invalid Login ID" ;				
            }// end if(rslt.next())
     
			rslt.close() ;
			stmt.close() ;
        }  // end inner try
        finally
        {
			conn.close() ;
        }
    
        } // end outer try
        catch(javax.naming.NamingException Ex1)
        {
		    Error = Ex1.toString() ;
        }
        catch(java.sql.SQLException Ex2)
        {
		    Error = Ex2.toString() ;
        }	
        return bSuccess ;
    } // End fuction check()
	 
	@Override 
    public void invalidate()
    {
	    bValid=false;
    } // end method invalidate()
    
    @Override		
	public String getUserName()
    {
	    return LoggedUserName ;
    } // end method getUserName()
		
    @Override
	public String getTitle()
	{
	    return LoggedUserTitle ;
    } // end method getTitle()
		
    @Override
	public String lastError()
	{
	    return Error ;
	} // end method lastError()
		
    /*
		Non-Interface method:
        TO DO:- sessionCleanup Method
        Write session clean up code here. This method will be called when
	    session expires due to user inactivity or session explicitely destroyed
	    by logout code. Free any resource used by active session object.
    */
		
    
    public void sessionCleanup(javax.servlet.http.HttpSession session )
    {
    //  session := session which is just about geeting destroyed 
       	try
        {
	        AlogSmBn.LogoutTime = new java.sql.Timestamp(System.currentTimeMillis());
            AlogSmBn.updateRecord(AlogSmBn._autonumber );
		}
		catch(Exception e)
		{
			
		}	 		
    }	// end method  sessionCleanup()
 
 
    /*
		Below two methods are implementation of javax.servlet.http.HttpSessionBindingListener
	*/
 
    @Override
    public void valueBound(javax.servlet.http.HttpSessionBindingEvent event)
    {
 
    } // end method void valueBound()

    @Override
		public void valueUnbound(javax.servlet.http.HttpSessionBindingEvent event)
    { 
		javax.servlet.http.HttpSession session = event.getSession();
	    sessionCleanup(session) ;
 
    } // end method valueUnbound()
 
} // End of class definition: LoggedSitemanager


