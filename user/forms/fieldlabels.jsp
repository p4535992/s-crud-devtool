<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="com.webapp.utils.*" %>
<jsp:useBean id="FieldLabelMap" scope="session" class="java.util.TreeMap" />
<% 
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

String JNDIDSN = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");

%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>For Form validation</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
</head>
<body style="margin-bottom: 0px;padding-top: 10px;">   
<div class="container-fluid">
<% 
Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
String query = BeanwizHelper.openTableSQL(conn, TableName);

try 
{
java.sql.Statement stmt = conn.createStatement();
java.sql.ResultSet rslt = stmt.executeQuery(query);
java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
int count  = rsmd.getColumnCount() ;

if("POST".equalsIgnoreCase(request.getMethod()))
{ 
// Process submitted form
%>
<ul class="list-group">
  <li class="list-group-item list-group-item-success">Input Items in Tree Map: <span id="trmap"></span></li>
</ul>

<br />

<div class="table-responsive">
<table class="table table-striped table-bordered table-condensed">
<thead>
<tr>
<th>#</th>
<th>Column</th>
<th>New Label</th>
</tr>
</thead>
<tbody>
<%
for(int n = 1 ; n <= count ; n++ )
{	
	String ColName = rsmd.getColumnName(n) ;	
	String InputType = request.getParameter(ColName) ;
	FieldLabelMap.put(ColName, InputType) ;
%>
<tr>     
<td><%=n %></td>
<td><%=ColName %></td>
<td><%=FieldLabelMap.get(ColName)%></td>		
</tr>
<%
} // end for
%>
</tbody>
</table>
</div>		 

<%	 
}
else
{
// show form
FieldLabelMap.clear();  
for(int n = 1 ; n <= count ; n++ )
{	
	String ColName = rsmd.getColumnName(n) ;	
	FieldLabelMap.put(ColName, ColName) ; 
} // end for
%>
<form action="<%=thisFile %>" method="post">
<input type="hidden" name="JNDIDSN" value="<%=JNDIDSN %>" />
<input type="hidden" name="TableName" value="<%=TableName %>" />

<div class="panel panel-default">
<!-- Default panel contents -->
<div class="panel-heading"><i class="fa fa-tasks fa-lg text-primary"></i>&nbsp;&nbsp;Fields : Form Label</div>
<div class="panel-body"><span class="pull-right"><button type="submit" class="btn btn-primary">Submit</button></span></div>

<!-- Table -->
<div class="table-responsive">
<table class="table table-striped table-bordered table-condensed" id="Form_validation">
<thead>
<tr>
<th></th>
<th>Column</th>
<th>New Label</th>
<th>Type</th>
</tr>
</thead>
<tbody>
<%
for(int n = 1 ; n <= count ; n++ )
{	
	 String ColName = rsmd.getColumnName(n) ;
	 String ColType = rsmd.getColumnTypeName(n);
%>
<tr>
<td><%=n %></td>
<td><%=ColName %><% if( rsmd.isAutoIncrement(n)) { %>&nbsp;&nbsp;<span class="label label-default">A</span><% } %></td>
<td><input type="text" class="form-control" name="<%=ColName %>"  id="<%=ColName %>" value="<%=ColName %>" ></td>
<td><%=ColType %></td>
</tr>
<%	  
}// end for(int n = 1 ; n <= count ; n++ ) 
%>
</tbody>
</table>
</div>
</div>
</form>
<% 
} // end of if("POST".equalsIgnoreCase(request.getMethod()))
rslt.close();
stmt.close();
}		 
finally
{
conn.close();
} 
%>


</div> <!-- /container -->
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />
<!-- iframeResizer.contentWindow.min.js to be loaded into the target frame -->
<jsp:include page="/assets/include-page/js/iframe-resizer/iframeResizer-contentWindow-js.jsp" flush="true" />
<script>
		
$(document).ready(function() {
	$("#trmap").html("<%=FieldLabelMap.size() %>");
});		

</script>

</body>
</html>
