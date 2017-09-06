<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="com.beanwiz.TableColumn" %><jsp:useBean id="ManField" scope="session" class="java.util.Vector" /><%
int nManCount = ManField.size();String TableName = request.getParameter("TableName");
String NewFormID = TableName+"_Add" ;
String UpdateFormID = TableName+"_Update" ;
 %>/*   Form validation code Start : for validation plugin */
<\% 
if(nAction==NEW_FORM ) 
{
%>
// New Entry Form  
<% 
if(nManCount > 0) // mandatory fields are there
{ 
%> $("#<%=NewFormID %>").validate({ 
   rules: 
   {
 <%  for( int i=0; i < nManCount; i++)
  {
  %>   <%=(String)ManField.get(i) %>:"required"<% if(i <nManCount-1) out.print(","); %>
 <%  
  }
 %>  } 
 });  
<% 
}
else // No mandatory fields
{ 
%>
  $("#<%=NewFormID %>").validate(); // Please put class="required" in mandatory fields
<% 
} // End if
%>
<\%
 }  
else if( nAction==CHANGE_FORM ) 
{
%>
// Update Entry Form  
<% 
if(nManCount > 0) // mandatory fields are there
{ 
%> $("#<%=UpdateFormID %>").validate({ 
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
  $("#<%=UpdateFormID %>").validate(); // Please put class="required" in mandatory fields
<% 
} // End if
%>
<\%
 } 
%>
/* Form validation code End */