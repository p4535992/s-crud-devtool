<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.TableColumn" %><%
String  DriverName= request.getParameter("DriverName");
String  BeanName = request.getParameter("BeanName");
String  BeanClass = request.getParameter("BeanClass");
String  BeanPackage = request.getParameter("BeanPackage");
String  JNDIDSN   = request.getParameter("JNDIDSN");
String  TableName = request.getParameter("TableName");
String  IDField = request.getParameter("IDField");
String  IDFieldType = request.getParameter("IDFieldType") ;
String  WebApp = request.getParameter("WebApp") ;
String  Title = request.getParameter("Title") ;
String  LoginClass = request.getParameter("LoginClass") ;
String  LoginObjectID = request.getParameter("LoginObjectID") ;
String  LoginIDField =  request.getParameter("LoginIDField") ;
String  LoginIDFieldType = request.getParameter("LoginIDFieldType") ;
String  PasswordField = request.getParameter("PasswordField") ;
String  DisplayFields = request.getParameter("DisplayFields") ;
String  LoginForm  = request.getParameter("LoginForm")  ;
String  LogoutPage = request.getParameter("LogoutPage") ;
String  LoginServlet = request.getParameter("LoginServlet") ;
String  LoginServletPath = request.getParameter("LoginServletPath");
String  LoginFilter = request.getParameter("LoginFilter") ;
String  AccessPath = request.getParameter("AccessPath") ;
String  LoginSuccesPath = request.getParameter("LoginSuccesPath") ;
String  LoginFailurePath = request.getParameter("LoginFailurePath") ;
String  LoginRole = request.getParameter("LoginRole") ;
String  Database = request.getParameter("Database") ;

String LoginFolderName = request.getParameter("LoginFolderName") ;

boolean   bIntegerIDField=true;
boolean   bIntegerLoginField=true ;
String	 Quotes="";

String[] disp = DisplayFields.split(",");


String ContentType =  "application/x-download" ;
String ContentDisp = "attachment; filename="+LoginClass+".java";	
response.setContentType(ContentType);
response.setHeader("Content-Disposition", ContentDisp);

//response.setContentType("text/plain");

String tmp = IDField.replace("ID", "");
String IDFieldL = tmp.toLowerCase().trim();
String IDFieldU = tmp.toUpperCase().trim();

// Check Record ID Field Type
if("INT".equalsIgnoreCase(IDFieldType))
{
   // ID field is Integer quotes not needed in SQL expression.
   bIntegerIDField=true;
	 
}
else
{
   // ID field is Character type, quotes needed in SQL expression
 		bIntegerIDField=false;
}

// Check Login ID Field Type

if("INT".equalsIgnoreCase(LoginIDFieldType))
{
   // ID field is Integer quotes not needed in SQL expression.
    bIntegerLoginField=true;
	 Quotes="";
}
else
{
   // ID field is Character type, quotes needed in SQL expression
 		 bIntegerLoginField=false;
	  Quotes="'";
}%>package <%=WebApp %> ;
import com.db.<%=Database %>.* ;
import com.webapp.login.* ;
import com.webapp.utils.* ;
import java.io.* ;
import java.sql.* ;
import javax.naming.* ;
import javax.sql.* ;	
import javax.servlet.*;
import javax.servlet.http.*;

public class <%=LoginClass %> implements com.webapp.login.UserLoginObject, javax.servlet.http.HttpSessionBindingListener
{
/*  optional declaration
    public static final String LoginRole = <%=LoginRole %> ;
*/
    private boolean bValid=false;
    public String Error="none" ;
    public String ClientAddress = null;
    public short PasswordType = 0;
  	public short LoginStatus = 0;
  	public short CurrentStatus = 0;
  	public short MultiLogin = 0;
		
    private <%=BeanClass %> <%=BeanName %> = new <%=BeanClass %>();		
    private Accesslogof<%=TableName %>Bean Aclog<%=BeanName %> = new Accesslogof<%=TableName %>Bean();
    <%=WebApp %>.AppSetting si = new <%=WebApp %>.AppSetting(this.context);				
<%
if(bIntegerIDField)
{
%>     
//  ID Filed ( Integer Type )
    public int <%=IDField %> = 0 ;<%
}
else
{ 
%>
//  ID Filed ( String Type )
    public String <%=IDField %> = null ;
<%
} 
%>
    private String LoggedUserName = "" ;
    private String LoggedUserTitle = "<%=Title %>" ;
    private String RedirectTo = null;
//  Object for Portable SQL implementation
    private com.webapp.utils.PortableSQL psql = null;
//  Servlet context reference
    private ServletContext context = null;
		
/*  TO DO: Declare other variables related to login
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
    } // end :- isValid()
 
    @Override
    public void setSQLEngine(String eng )
    {
		//  construct the Portable SQL engine
      psql = new com.webapp.utils.PortableSQL(eng) ;
    } // end :- setSQLEngine(String eng )
		 
    @Override
    public short permit(javax.servlet.http.HttpServletRequest req )
    {
        RedirectTo = null;
        String url = req.getRequestURI() ;
				if(url.contains("/<%=LoginFolderName %>/setregularpassword.jsp")) return 0;
				if(this.PasswordType == <%=WebApp %>.PasswordType.SERVICE ) 
				{
				  RedirectTo =  req.getContextPath()+"/<%=LoginFolderName %>/setregularpassword.jsp" ;
					return 1;
				}
        return 0;
				
				
        /* Implementation guide: 
  
	         String url = req.getRequestURI() ;
           Examine url and do following 
           (1) Return -1 for forbidding the access to url. 
               The user will be redirected to <%=LoginSuccesPath %> 
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
	  } // end :- permit(javax.servlet.http.HttpServletRequest req )
		
    @Override
    public String redirect()
    {
        return RedirectTo ;
    } // end :- redirect()
		
    @Override
    public boolean authenticate(javax.servlet.http.HttpServletRequest req, javax.servlet.http.HttpSession ses, javax.servlet.ServletContext cntx )
    {
        this.context = cntx;
        String chk_ID = req.getParameter("<%=TableName %>_<%=LoginIDField %>") ;
        String chk_Pass = req.getParameter("<%=TableName %>_<%=PasswordField %>") ;
        ClientAddress = req.getRemoteAddr() ;
        bValid = check(chk_ID , chk_Pass) ;
        return bValid ;
    } // end :- authenticate
	 
//  Non-Interface method
    public boolean check(String id , String pwd )
    {
        boolean bSuccess = false ;
		//  Create the portable query which should work for diverse SQL servers
					
        try   // Outer try block
        {
            Context env = (Context) new InitialContext().lookup("java:comp/env") ;
            DataSource source = (DataSource) env.lookup("<%=JNDIDSN %>") ;
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

        String Query = psql.SQL(" SELECT * FROM `<%=TableName %>` WHERE  `<%=LoginIDField %>`=<%=Quotes %>"+id+"<%=Quotes %> " ) ;

                /* 
                   // Allow changing the Login ID field by run time setting:
                  	
                  		// Read the application setting value <%=IDFieldU %>-LOGIN
                  		// 1 = <%=IDField %>, 2 = EmpCode, 3 = Mobile, 4 = EmailID, 5 = Username
                  	
                   
                   int <%=IDFieldL %>_login_type = 0;
                   try
                   {
                         <%=IDFieldL %>_login_type = Integer.parseInt(si.getValue("<%=IDFieldU %>-LOGIN-TYPE"));
                   }
                   catch(NumberFormatException ex)
                   {
                         <%=IDFieldL %>_login_type = 1;
                   }
                  		String Query = "" ;
                  		switch(<%=IDFieldL %>_login_type)
                  		{
                  			case 1:  // <%=IDField %>
                  				Query = psql.SQL("SELECT * FROM `<%=TableName %>` WHERE  `<%=IDField %>`="+id+" " ) ;
                  			break;
                  					 
                  			case 2:  // EmpCode
                  				Query = psql.SQL("SELECT * FROM `<%=TableName %>` WHERE  `EmpCode`= '"+id+"' " ) ;
                  			break;
                  				
                  			case 3:  // Mobile
                  				Query = psql.SQL("SELECT * FROM `<%=TableName %>` WHERE  `Mobile`= '"+id+"' " ) ;
                  			break;  
                  
                  			case 4:  // EmailID
                  				Query = psql.SQL("SELECT * FROM `<%=TableName %>` WHERE  `EmailID`='"+id+"' " ) ;
                  			break;
                  
                  			case 5:  // Username
                  				Query = psql.SQL("SELECT * FROM `<%=TableName %>` WHERE  `Username`='"+id+"' " ) ;
                  			break;
                  		} //end switch(<%=IDFieldL %>_login_type)
                */
													 
                 try  // Inner try block
                 {
                      java.sql.Statement stmt = conn.createStatement() ;
                      java.sql.ResultSet rslt = stmt.executeQuery(Query) ; 
                      if(rslt.next())
                      {
                            // Login ID Found, so check password           
                            String db_pass = rslt.getString("<%=PasswordField %>") ;
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
														

                                 // Password matches
                                 bSuccess=true ;
                 <%
                 if(bIntegerIDField)
                 {
                 %>                                 // ID Filed ( Integer Type )
                                 <%=IDField %>=rslt.getInt("<%=IDField %>") ;
                <%
                 }
                 else
                 { 
                %>                                 //  ID Filed ( String Type )
                                 <%=IDField %>=rslt.getString("<%=IDField %>") ;
                <%
                 } 
                 %>
<% 						 
               if(disp.length >0 )
							 {
 %>				PasswordType = rslt.getShort("PasswordType");
					LoginStatus = rslt.getShort("LoginStatus");
					CurrentStatus = rslt.getShort("CurrentStatus");
					MultiLogin = rslt.getShort("MultiLogin");
 LoggedUserName = <% for(int i=0; i<disp.length ; i++)out.print("rslt.getString("+disp[i]+")+\" \""+( (i<disp.length-1)?"+":"") ) ; %> ;
<%             
               } 
%>                               /*
                                Set other variables related to login if declared ;
                                $var = rslt.get?($field );
                                */

					if(this.LoginStatus==<%=WebApp %>.LoginStatusFlag.LOGGED && this.MultiLogin ==0)
					{ 
					//Multiple simultaneous logins with same AdminID is not permitted.
						bSuccess=false;
						Error="Simultaneous Multiple Login Error" ;
					}
					else
					{

						if(this.CurrentStatus==<%=WebApp %>.CurrentStatusFlag.BARRED || this.CurrentStatus==<%=WebApp %>.CurrentStatusFlag.LEFT)
								{
									   //Login is barred by the administrator.
									 bSuccess=false;
									 Error="Login Is Barred By Administrator" ;
									 
								}
								 else
								 {

									//  LoginStatus Update
										bSuccess=true ;
										<%=BeanName %>.locateRecord(this.<%=IDField %>);
										<%=BeanName %>.LoginStatus = <%=WebApp %>.LoginStatusFlag.LOGGED;
										<%=BeanName %>.updateRecord(this.<%=IDField %>);
								 
                    			    //  On successful login create access log entry																			 
                    					Aclog<%=BeanName %>.RecordID = 0; 
                    					Aclog<%=BeanName %>.<%=IDField %> = this.<%=IDField %> ;
                    					Aclog<%=BeanName %>.LoginTime = new java.sql.Timestamp(System.currentTimeMillis()) ;
                              Aclog<%=BeanName %>.LogoutTime = null ;
                              Aclog<%=BeanName %>.IPAddress = this.ClientAddress ;
                              Aclog<%=BeanName %>.Flag = 0 ;
                              Aclog<%=BeanName %>.addRecord();
									}						
															
           }                

                            }
                            else // else if(db_pass.equals(pwd))
                            {
                                 // Password does not match
                                 Error="Invalid Password Entered" ;
                                 bSuccess=false ;
                            } // end if(db_pass.equals(pwd))
                      }
                      else // else if(rslt.next())
                      {
                          // Login ID Not Found.
                          bSuccess=false ;
                          Error= "Invalid Login ID" ;				
                      }   // end if(rslt.next())
     
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
         catch(  java.sql.SQLException Ex2)
         {
		        Error = Ex2.toString() ;
         }	
         return bSuccess ;
     } // End fuction check()
	 
	  @Override 
    public void invalidate()
    {
	       bValid=false;
    }   // end method invalidate()
    
    @Override		
		public String getUserName()
    {
	       return LoggedUserName ;
    }   // end method getUserName()
		
    @Override
		public String getTitle()
	  {
	       return LoggedUserTitle ;
    }   // end method getTitle()
		
    @Override
		public String lastError()
	  {
	       return Error ;
	  }   // end method lastError()
		
    /*
		  Non-Interface method:
      TO DO:- sessionCleanup Method
      Write session clean up code here. This method will be called when
	    session expires due to user inactivity or session explicitely destroyed
	    by logout code. Free any resource used by active session object.
    */
		
    
    public void sessionCleanup(javax.servlet.http.HttpSession session )
    {
        // session := session which is just about geeting destroyed 
       	try
        {
	          Aclog<%=BeanName %>.LogoutTime = new java.sql.Timestamp(System.currentTimeMillis());
            Aclog<%=BeanName %>.updateRecord(Aclog<%=BeanName %>._autonumber );
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
 
    }	// end method valueUnbound()
 
} // End of class definition: <%=LoginClass %>


