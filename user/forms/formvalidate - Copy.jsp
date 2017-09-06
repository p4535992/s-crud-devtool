<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><jsp:useBean id="FieldMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="ManField" scope="session" class="java.util.Vector" />
<% 
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

String JNDIDSN = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String BeanName = request.getParameter("BeanName");
String FormName = request.getParameter("FormName");
String ForeignKey =  request.getParameter("ForeignKey");
String[] FKeys  =  null ;
if(ForeignKey!= null && ForeignKey.length()>0) FKeys =ForeignKey.split(":");
java.util.HashSet KeySet = new java.util.HashSet();
if(FKeys!=null)
{
for (int i=0; i<FKeys.length ; i++)
{
 KeySet.add(FKeys[i]);
}
}
String FormID=request.getParameter("FormID");
if(FormID==null) FormID = "FormID" ;
boolean bUpdate=false;
if("Update".equalsIgnoreCase(request.getParameter("Mode"))) bUpdate=true;
int nManCount = ManField.size();
%>// Form validation code: for validation plugin
<% 
if(nManCount > 0) // mandatory fields are there
{ 
%> $("#<%=FormID %>").validate({ 
   rules: 
   {
 <%  for( int i=0; i < nManCount; i++)
  {
  %>   <%=(String)ManField.get(i) %>:"required"<% if(i <nManCount-1) out.print(","); %>
 <%  
  }
 %>  } 
 }); // End form validation code.
<% 
}
else // No mandatory fields
{ 
%>
  $("#<%=FormID %>").validate(); // Please put class="required" in mandatory fields
<% 
} // End if
%>

