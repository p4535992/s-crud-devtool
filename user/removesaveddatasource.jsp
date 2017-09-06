<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="java.sql.*, nu.xom.*" %><%@ page import="com.beanwiz.*, com.webapp.jsp.*, com.webapp.utils.*" %><% 
 %><%@ page import="com.caucho.naming.*, oracle.sql.*, oracle.jdbc.* oracle.jdbc.driver.*, oracle.jdbc.pool.*"%><%@ page import="com.microsoft.sqlserver.jdbc.*"%><% 
 %><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><% 
 
 String appPath = request.getContextPath() ;
 
 String datasource = request.getParameter("datasource");
 String[] parts = datasource.split(":");
 
 String xpathqry = "/dslist/datasource[@wizuser='"+parts[0]+"' and @webappname='"+parts[1]+"' and @jndi='"+parts[2]+"' ]" ;
 
  String xmlfilepath = application.getRealPath("/WEB-INF/saved-jndi-ds.xml");
  File xmlfile = new File(xmlfilepath);
	Element item = null;
	
	 
	
	 
	 
	
	
	
  if(xmlfile.exists())
	{
	  
	     Builder builder = new Builder();
	     Document doc =  builder.build(xmlfile);
			 Nodes list = doc.query(xpathqry);
			 if(list!=null && list.size() > 0 )
			 {
			     
					  doc.getRootElement().removeChild(list.get(0));
			  
			 }
			 FileOutputStream os = new  FileOutputStream(xmlfile);
			 nu.xom.Serializer serializer = new nu.xom.Serializer(os, "UTF-8");
       serializer.setIndent(4);
       serializer.write(doc); 
			 os.close();
  }
  
  String redirect = appPath+"/user/index.jsp" ;
  response.sendRedirect(response.encodeRedirectURL(redirect));
 
 %>
 
