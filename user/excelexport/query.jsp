<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.sql.*, nu.xom.*" %>
<%@ page import="com.webapp.jsp.*, com.webapp.base64.*, com.webapp.utils.*" %>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

String Method = request.getMethod();

String JNDIDSN = request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String DriverName  = request.getParameter("DriverName");
String Database=null;

Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
Database=conn.getCatalog();
if(Database == null )
{
   // Do some stupid guesswork :
	Database = JNDIDSN.substring(JNDIDSN.indexOf("/",0)+1 );
}
/* 
Some stubborn vendors like Oralce act like stick in mud, 
and do not comply with the standards
*/
%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Export Table data to MS Excel</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
<style type="text/css">
<!-- 
.column_layout
{
   -moz-column-count:3; /* Firefox */
   -webkit-column-count:3; /* Safari and Chrome */
   column-count:3;

   -moz-column-rule:1px solid; /* Firefox */
   -webkit-column-rule:1px solid; /* Safari and Chrome */
   column-rule:1px solid;
}
-->
</style>
</head>
<body>   
<jsp:include page="/user/assets-user/include-page/header-user.jsp" flush="true" />	

<div class="container-fluid">

<div class="row page-header11">
  <div class="col-md-6 col-xs-12">
    <h4 class="page-title11"><i class="fa fa-plug text-primary"></i>&nbsp;&nbsp;<span class="text-muted">Export Excel</span></h4>
  </div>
  <div class="col-md-6 col-xs-12">
    <!--  page-header-actions  -->
    <ol class="breadcrumb text-right">
      <li><a href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg"></i></a></li>
      <li><a href="<%=appPath %>/user/tablelist.jsp?JNDIDSN=<%=JNDIDSN %>">Table List : <strong><%=Database %></strong></a></li>
      <li class="active">Export Excel</li>
    </ol>
  </div>
</div>
<hr class="pageheaderHR" />

<div class="well well-sm row-fluid-text">

  <div class="row">
    <div class="col-md-6">
      <big><i class="fa fa-table fa-lg text-primary"></i>&nbsp;&nbsp;<span class="text-info">Table : </span><span class="text-muted"><%=Database %>.<%=TableName %></span></big>
    </div>
    <div class="col-md-6">
      <big class="pull-right"><i class="fa fa-send-o fa-lg text-primary"></i>&nbsp;&nbsp;<span class="text-info">JNDI: </span><span class="text-muted"><%=JNDIDSN %></span></big>
    </div>
  </div>

</div>		

<% 
if("GET".equalsIgnoreCase(Method))
{ 
  short eng = PortableSQL.getEngineFromDriverName(DriverName); 
  PortableSQL psql = new PortableSQL(eng);
  String SQLEngine = psql.getEngineName();

  String Source = " SELECT * FROM "+TableName;
  String SQL =  new String( com.webapp.base64.UrlBase64.encode(Source.getBytes()) );

%>
<div class="well well-sm">Select columns to be included in <b>Excel</b> file</div>

<form action="<%=appPath %>/getexcelfromquery/" method="post" id="select_column_form">
<input type="hidden" name="DSN" value="<%=JNDIDSN %>" />
<input type="hidden" name="SQL-ENGINE" value="<%=SQLEngine %>" />
<input type="hidden" name="SQL" value="<%=SQL  %>" />
<div class="row">
  <div class="col-md-4">
    <p><button type="submit" class="btn btn-primary btn-block btn-lg">Get M.S. Excel File</button></p>
	</div>
</div>
<div class="row">
  <div class="col-md-6">
    <jsp:include page="/getexcelfromquery/" flush="true">
      <jsp:param name="DSN" value="<%=JNDIDSN %>" />
      <jsp:param name="SQL-ENGINE" value="<%=SQLEngine %>" />
      <jsp:param name="SQL" value="<%=SQL  %>" />
			<jsp:param name="TABLEID" value="columnName_list" />
    </jsp:include>
	</div>
</div>	
</form>

<% 
}
else
{ 
%>
<% 
} 
%>

    </div> <!-- /container -->
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />
<script type="text/javascript">
<!--
$("#chk_tablefeld").click(function () {
   if ($("#chk_tablefeld").is(':checked')) {
        $("#columnName_list input[type=checkbox]").each(function () {
          $(this).prop("checked", true);
      });
   } else {
       $("#columnName_list input[type=checkbox]").each(function () {
        $(this).prop("checked", false);
      });
   }
});
// -->
</script>
<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>
<%  
conn.close();
%>