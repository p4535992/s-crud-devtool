<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="com.webapp.utils.*" %>
<jsp:useBean id="FieldMap" scope="session" class="java.util.TreeMap" />
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
<th>Input Control</th>
</tr>
</thead>
<tbody>
<%
for(int n = 1 ; n <= count ; n++ )
{	
	String ColName = rsmd.getColumnName(n) ;			 
	short InputType = Short.parseShort(request.getParameter(ColName)) ;
	FieldMap.put(ColName, new Short(InputType )) ;	
	
%>
<tr>     
<td><%=n %></td>
<td><%=ColName %></td>
<td><%=FieldInputs.getInputType(InputType) %></td>
</tr>
<%
} // end for
//if( request.getParameter("multipart_form_upload") != null)FieldMap.put("multipart_form_upload", new Boolean(true));
%>
</tbody>
</table>
</div>		 

<%	 
}
else // if("POST".equalsIgnoreCase(request.getMethod()))
{
// show form
FieldMap.clear();
%>
<form action="<%=thisFile %>" method="post">
<input type="hidden" name="JNDIDSN" value="<%=JNDIDSN %>" />
<input type="hidden" name="TableName" value="<%=TableName %>" />

<div class="panel panel-default">
<!-- Default panel contents -->
<div class="panel-heading"><i class="fa fa-tasks fa-lg text-primary"></i>&nbsp;&nbsp;Fields : Form validation</div>
<div class="panel-body"><span class="pull-right"><button type="submit" class="btn btn-primary">Submit</button></span></div>

<!-- Table -->
<div class="table-responsive">
<table class="table table-striped table-bordered table-condensed" id="Form_validation">
<thead>
<tr>
<th>#</th>
<th>Column</th>
<th>Type</th>
<th width="40%">Input Control</th>
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
<td><%=ColName %>  <% if( rsmd.isAutoIncrement(n)) { %>&nbsp;&nbsp;<span class="label label-default">AUTO</span><% } %></td>
<td><%=ColType %></td>
<td>
<select name="<%=ColName %>" class="form-control selectpicker" data-container="body">
 <option value="<%=FieldInputs.NONE %>"><%=FieldInputs.getInputType(FieldInputs.NONE) %></option>
 <option value="<%=FieldInputs.TEXT %>" selected="selected"><%=FieldInputs.getInputType(FieldInputs.TEXT) %></option>
 <option value="<%=FieldInputs.SELECT %>"><%=FieldInputs.getInputType(FieldInputs.SELECT) %></option>
 <option value="<%=FieldInputs.TEXTAREA %>"><%=FieldInputs.getInputType(FieldInputs.TEXTAREA) %></option> 
 <option value="<%=FieldInputs.FILE %>"><%=FieldInputs.getInputType(FieldInputs.FILE) %></option>
 
 <option value="<%=FieldInputs.DATEPICKER %>"><%=FieldInputs.getInputType(FieldInputs.DATEPICKER) %></option>
 <option value="<%=FieldInputs.DATETIMEPICKER %>"><%=FieldInputs.getInputType(FieldInputs.DATETIMEPICKER) %></option>
 <option value="<%=FieldInputs.TIMEPICKER %>"><%=FieldInputs.getInputType(FieldInputs.TIMEPICKER) %></option>
 <option value="<%=FieldInputs.JAVACLASSENTITY %>"><%=FieldInputs.getInputType(FieldInputs.JAVACLASSENTITY) %></option>
 <option value="<%=FieldInputs.GETITEMLIST %>"><%=FieldInputs.getInputType(FieldInputs.GETITEMLIST) %></option>
 <option value="<%=FieldInputs.DBDROPLIST %>"><%=FieldInputs.getInputType(FieldInputs.DBDROPLIST) %></option>
 <option value="<%=FieldInputs.YESNOSELECT %>"><%=FieldInputs.getInputType(FieldInputs.YESNOSELECT) %></option>
 
<!--  
 <option value="<%=FieldInputs.RADIO %>"><%=FieldInputs.getInputType(FieldInputs.RADIO) %></option>
 <option value="<%=FieldInputs.CHECK %>"><%=FieldInputs.getInputType(FieldInputs.CHECK) %></option> 
 <option value="<%=FieldInputs.MFTAG %>"><%=FieldInputs.getInputType(FieldInputs.MFTAG) %></option>
 <option value="<%=FieldInputs.YNTAG %>"><%=FieldInputs.getInputType(FieldInputs.YNTAG) %></option>
 <option value="<%=FieldInputs.DATEPICK %>"><%=FieldInputs.getInputType(FieldInputs.DATEPICK) %></option>
 <option value="<%=FieldInputs.DATETIMEPICK %>"><%=FieldInputs.getInputType(FieldInputs.DATETIMEPICK ) %></option>
 <option value="<%=FieldInputs.DATEINPUT %>"><%=FieldInputs.getInputType(FieldInputs.DATEINPUT) %></option>
 <option value="<%=FieldInputs.TIMEINPUT %>"><%=FieldInputs.getInputType(FieldInputs.TIMEINPUT) %></option>
 <option value="<%=FieldInputs.STATELIST %>"><%=FieldInputs.getInputType(FieldInputs.STATELIST) %></option>
 <option value="<%=FieldInputs.COUNTRYLIST %>"><%=FieldInputs.getInputType(FieldInputs.COUNTRYLIST) %></option>
 --> 
</select>
</td>
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
<script type="text/javascript">
<!--		
$(document).ready(function() {
	$("#trmap").html("<%=FieldMap.size() %>");
});		
// -->
</script>

</body>
</html>
