<%@ page import="java.io.*, java.util.*, javax.servlet.*, javax.servlet.http.*, com.beanwiz.* "%><%@ taglib uri="validation" prefix="chk" %><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%            %> <chk:validate/>  
<% 
String appPath = request.getContextPath() ;

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Bean Wizard Tool</title>
<link rel="stylesheet" type="text/css" href="<%=appPath %>/style.css" />
</head>
<body>
<jsp:include page="/banner.jsp" flush="true" />

<div style="padding:2em;"><!-- Page content begin -->  
<h2>Form Parameters</h2>
<table border="1" cellpadding="4" cellspacing="0" summary="">
<thead>
<tr>
    <th>S.No</th><th>Parameter Name</th><th>Parameter Values</th>
</tr>

</thead>
<tbody>

<% 

    Enumeration eParamNames = request.getParameterNames();
    int no = 0;
    while(eParamNames.hasMoreElements())
    {
		    no++;
        String name = (String)eParamNames.nextElement();
        String[] values = request.getParameterValues(name);
				
        %>
				<tr>
				   <td><%=no %></td>
					 <td><%=name %></td>
				   <td>
					 <% 
					  int i=0;
						for(String str:values)
						{
						    %>[<%=(i+1) %>] <%= str  %>&nbsp;&nbsp;<%
						    i++;
						}
					 
					  %>
					 
					 </td> 
				<tr>
				<%
				 
			 
    }
 %>
</tbody> 
</table> 
  
</div><!-- Page content end -->



</body>
</html>
