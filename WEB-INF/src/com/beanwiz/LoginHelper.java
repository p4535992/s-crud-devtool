package   com.beanwiz ;

import java.io.*;
import java.util.*;
import javax.servlet.http.*;
import javax.servlet.*;
import org.w3c.dom.* ;
import nu.xom.*  ;
public class LoginHelper
{

public static com.beanwiz.LoggedUser  autoLoginCheck(ServletContext context, HttpSession session, HttpServletRequest request )
throws nu.xom.ParsingException, java.io.IOException
{
     String configfile = context.getInitParameter("XML-AUTH-FILE");
		 
		 
		 
		 java.io.InputStream is =  context.getResourceAsStream(configfile);
		 
		 
		 
		  if(is==null) return null ;
		  nu.xom.Builder bld =  new nu.xom.Builder();
		  nu.xom.Document doc = bld.build(is);
			nu.xom.Element rtelm = doc.getRootElement();
			nu.xom.Nodes nds = rtelm.query("/userlist/alwayspermit");
			if(nds==null) return null;
			String usr =((nu.xom.Element)nds.get(0)).getAttributeValue("defaultuser");
			if(usr==null) return null;
			Nodes ndulist = rtelm.query("/userlist/user[@id='"+usr+"']");
			if(ndulist == null ) return null ;
			nu.xom.Element elmuser = (nu.xom.Element)ndulist.get(0);
			if(elmuser == null) return null;
			
			String name =  elmuser.getAttributeValue("name");
			String role =  elmuser.getAttributeValue("role");
			String title = elmuser.getAttributeValue("title");
			
			nu.xom.Nodes iplist = rtelm.query("/userlist/alwayspermit/ip");
			if(iplist == null)return null;
			
			boolean bPermit = false;
			String userip = request.getRemoteAddr();
			for(int i=0; i < iplist.size(); i++)
			{
			      String ip=  ((nu.xom.Element)iplist.get(i)).getValue();
			      if(userip.equals(ip))
				    {
				       bPermit = true ;
						   break;
				    }
			} // end for
			
			if(bPermit == false) return null;
			com.beanwiz.LoggedUser LogUsr = new com.beanwiz.LoggedUser();
			LogUsr.UserID=usr;
			LogUsr.extSetUser(name, role, title );
			session.setAttribute("theWizardUser", LogUsr);
			return LogUsr ;

}






}  // End class definition

