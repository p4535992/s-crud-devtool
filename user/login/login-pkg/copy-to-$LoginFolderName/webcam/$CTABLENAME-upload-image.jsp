<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="$WEBAPP.*, $WEBAPP.apputil.*, $BeanPackage.*"%> 
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*,javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.base64.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="$BeanName" scope="page" class="$BeanPackage.$BeanClass" />
<% 
ResponseHelper.nocache(response);

String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

int nID = RequestHelper.getInteger(request, "ID");
boolean blocate = $BeanName.locateRecord(nID);

String DataURL = request.getParameter("DataURL");
String MimeType = "image/html" ;

try
{
     if(DataURL==null) throw new Exception("Image data not posted!");
		 DataUrlHelper DuHlp = new DataUrlHelper(DataURL);
		 if(  DuHlp.bValid==false) throw new Exception ("Data URL Error: "+DuHlp.Error);

		 // {{ ### Applicatin Specific Code Start  
		 
		 if(nID <= 0 ) throw new  Exception("Invalid "+$BeanName.LoginRole+" ID:"+nID);
		 if( !blocate ) throw new Exception(""+$BeanName.LoginRole+" with ID:"+nID+" not located in database."); 
		 Update$CTABLENAMEPhoto PhotoBean = new Update$CTABLENAMEPhoto(request);
		 if ( ! PhotoBean.update$CTABLENAMEPhotographFromByteArray($BeanName.$IDField, DuHlp.ImageBytes, DuHlp.MimeType  )	) throw new Exception("Error in updating "+$BeanName.LoginRole+"'s photograph table ( ID:"+nID+" )."); 

	   // }}  Applicatin Specific Code End
		  
   %>
	 <b>Photograph Updated:</b>
	 <br />
   <%=ShowItem.show$CTABLENAMEName($BeanName.$IDField, 3) %>
	 
   <%

}
catch(Exception ex)
{
  %> <%= ExceptionHelper.showException(ex , "error_div") %> <%
}

%>
 
