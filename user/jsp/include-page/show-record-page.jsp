<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="java.sql.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="javax.naming.*" %><%@ page import="javax.sql.*" %><%@ page import="com.beanwiz.TableColumn" %><jsp:useBean id="FieldMap" scope="session" class="java.util.TreeMap" /><jsp:useBean id="ManField" scope="session" class="java.util.Vector" /><%

String BeanName = request.getParameter("BeanName");
String IDField = request.getParameter("IDField");
String EntityName = request.getParameter("EntityName");
if(EntityName ==null)  EntityName = "?" ;

java.sql.ResultSetMetaData rsmd = (java.sql.ResultSetMetaData)request.getAttribute("RSMD");
int count  = rsmd.getColumnCount();
%><!-- Start Showing Single Record Data  -->
<div class="row">
  <div class="col-sm-3">
    <h4>ID : <\%=<%=BeanName  %>.<%=IDField  %> %></h4>
    <!--  uncomment this 
    <div class="well well-sm">
    <ul class="list-group list-group-gap" style="margin-bottom: 0px;">
      <li class="list-group-item">
        <i aria-hidden="true" class="icon fa fa-anchor iccolor"></i><a href="#?<%=IDField  %>=<\%=<%=BeanName  %>.<%=IDField  %> %>">Menu Link 1</a>
      </li>
      <li class="list-group-item">
        <i aria-hidden="true" class="icon fa fa-anchor iccolor"></i><a href="#?<%=IDField  %>=<\%=<%=BeanName  %>.<%=IDField  %> %>">Menu Link 2</a>
      </li>
    </ul>		
    </div>		
    -->
  </div>
  <div class="col-sm-9">
    <div class="table-responsive">
    <table class="table table-bordered table-condensed table-striped">
    <tr><%
    out.print("\r\n");
    int n=0;
    for (n=1 ;  n<=count; n++)
    { 
    String ColName = rsmd.getColumnName(n) ;
    String ColVarName= BeanName+"."+ColName.replace((char)32, '_' ) ;
    int ColType = rsmd.getColumnType(n);
     
    %>       <td><span class="blue-grey-700"><%out.print("<"+"%=FieldLabel["+BeanName+"_"+ColName+"] %"+">" ) ;%></span></td>
    <%
    switch(ColType)
    {
      case java.sql.Types.DATE:
    	 %>   <td><\%=DateTimeHelper.showDatePicker(<%=ColVarName %>) %></td><% 
    	break;
    	case java.sql.Types.TIMESTAMP:
    	 %>   <td><\%=DateTimeHelper.showDateTimePicker(<%=ColVarName %>) %></td><%
    	break;
    	case java.sql.Types.TIME:
    	 %>   <td><\%=DateTimeHelper.showTimeClockPicker(<%=ColVarName %>, "Show") %></td><%
    	break;
    	case java.sql.Types.LONGVARBINARY:
    	case java.sql.Types.VARBINARY:
    	case java.sql.Types.BINARY:
    	case java.sql.Types.BLOB:
    	 %>   <td>Binary Data</td><!-- /include-page/js/bootstrap-filestyle-js.jsp --><%
    	break;
    	default: %>   <td><\%=StrValue(<%=ColVarName %>) %></td><%
    }// end switch case
    out.print("\r\n");
    if(n%1==0)out.print("    </tr>\r\n");
		if(n%1==0 && n!=count)out.print("    <tr>\r\n");		
    } // end for
    if(n%1==0)out.print(""); 
    %>    </table>
    </div>
  </div>
</div>
<!-- End Showing Single Record Data  -->