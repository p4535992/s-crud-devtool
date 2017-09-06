<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.TableColumn" %><jsp:useBean id="FieldMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="ManField" scope="session" class="java.util.Vector" /><%

String BeanName = request.getParameter("BeanName");
String IDField = request.getParameter("IDField");
String EntityName = request.getParameter("EntityName");
if(EntityName ==null)  EntityName = "?" ;

java.sql.ResultSetMetaData rsmd = (java.sql.ResultSetMetaData)request.getAttribute("RSMD");
%><!--{{ Showing Single Record Data Start -->
<table summary="" width="100%" border="1px" cellspacing="0">
<tr>
<td width="30%" align="left"><span class="title"><%=EntityName %>'s Record Details [ ID: <\%=<%=BeanName  %>.<%=IDField  %> %> ]</span></td>
<td width="20%" align="center"><a href="<\%=thisFile %>?Action=Change&<%=IDField  %>=<\%=<%=BeanName  %>.<%=IDField  %> %><\%=ForeignKeyParam %><\%=ReturnPathLink %>">Change</a></td>
<td width="20%" align="center"><a href="<\%=thisFile %>?Action=Delete&<%=IDField  %>=<\%=<%=BeanName  %>.<%=IDField  %> %><\%=ForeignKeyParam %><\%=ReturnPathLink %>" onclick='return DeleteConfirm("<\%=DelWarning %>")'>Delete</a></td>
<td width="30%" align="right"><a href="<\%=thisFile %>?<\%=DEFAULT_ACTION %><\%=ForeignKeyParam %><\%=ReturnPathLink %>"><b> &lsaquo;&lsaquo;Back To Record List</b></a></td>
</tr>
</table>
<table border="0" cellpadding="4" cellspacing="0" summary="" width="100%">
<tr>
<td width="30%" valign="top">

<p>Record Related Menu</p>
<!--  uncomment this 
<ul>
<li><a href="#?<%=IDField  %>=<\%=<%=BeanName  %>.<%=IDField  %> %>">Menu Item 1</a></li>
<li><a href="#?<%=IDField  %>=<\%=<%=BeanName  %>.<%=IDField  %> %>">Menu Item 2</a></li>
</ul>
-->
</td>
<td width="70%" valign="top" > 
<!-- Begin Record -->
<div id="show_record_div" class="round_corner">
<table summary="" border="1px"  cellpadding="4" cellspacing="0" align="center">
<tr>
<%
out.print("\r\n");
int n=0;
for (n=1 ;  n<=rsmd.getColumnCount(); n++)
{ 
String ColName = rsmd.getColumnName(n) ;
String ColVarName= BeanName+"."+ColName.replace((char)32, '_' ) ;
int ColType = rsmd.getColumnType(n);
 
%>     <td  valign="top" ><span class="label"><%=ColName %> : </span></td>
<%
switch(ColType)
{
  case java.sql.Types.DATE:
	 %>     <td  valign="top"  ><span class="dataitem"><\%=com.webapp.utils.DateHelper.showDate(<%=ColVarName %>) %></span></td> <% 
	break;
	case java.sql.Types.TIMESTAMP:
	 %>     <td  valign="top" ><span class="dataitem"><\%=com.webapp.utils.DateHelper.showDateTime(<%=ColVarName %>) %></span></td> <%
	break;
	case java.sql.Types.TIME:
	 %>     <td  valign="top" ><span class="dataitem"><\%=com.webapp.utils.DateHelper.showTime(<%=ColVarName %>) %></span></td> <%
	break;

	case java.sql.Types.LONGVARBINARY:
	case java.sql.Types.VARBINARY:
	case java.sql.Types.BINARY:
	case java.sql.Types.BLOB:
	 %>     <td  valign="top" ><span class="dataitem">Binary Data</span></td><%
	break;
	default: %>     <td  valign="top" ><span class="dataitem"><\%=StrValue(<%=ColVarName %>) %></span></td><%
}// end switch case
out.print("\r\n");
if(n%2==0)out.print("</tr>\r\n<tr>\r\n");  
 

} // end for
if(n%2==0)out.print("<td>&nbsp;</td><td>&nbsp;</td>"); 
%>
</tr>
</table>
</div>
<!-- End Record -->

</td>
</tr>
</table>
<!--}} Showing Single Record Data End -->