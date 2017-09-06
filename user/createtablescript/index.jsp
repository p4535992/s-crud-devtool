<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="com.webapp.utils.*" %>
<jsp:useBean id="OverrideMap" scope="session" class="java.util.TreeMap" />

<%
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 
 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

String JNDIDSN= request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String DriverName= request.getParameter("DriverName");

String IsAuto = request.getParameter("IsAuto") ;
String IDField = request.getParameter("IDField");
String IDFieldType = request.getParameter("IDFieldType") ;

String PK="?";
String Database = null ;
Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();

try 
{
   Database=conn.getCatalog();
	 if(Database == null )
   {
   // Do some stupid guesswork :
	    Database = JNDIDSN.substring(JNDIDSN.indexOf("/",0)+1 );
   }
	 //if(Database ==null) 
   java.sql.Statement stmt = conn.createStatement();
   java.sql.ResultSet rslt = null ;
   String OpenTableQry = BeanwizHelper.openTableSQL(conn, TableName);
   rslt = stmt.executeQuery(OpenTableQry); 
   java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
   int count  = rsmd.getColumnCount();
	 
for(int n = 1 ; n <= count ; n++ )
{	
	if( rsmd.isAutoIncrement(n)) PK=rsmd.getColumnName(n) ;
}// end for() 

%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Get SQL Script</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
</head>
<body>   
<jsp:include page="/user/assets-user/include-page/header-user.jsp" flush="true" />	

<div class="container-fluid">
<div class="row page-header11">
  <div class="col-md-6 col-xs-12">
    <h4 class="page-title11"><i class="fa fa-plug text-primary"></i>&nbsp;&nbsp;<span class="text-muted">Get SQL Script</span></h4>
  </div>
  <div class="col-md-6 col-xs-12">
    <!--  page-header-actions  -->
    <ol class="breadcrumb text-right">
      <li><a href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg"></i></a></li>
      <li><a href="<%=appPath %>/user/tablelist.jsp?JNDIDSN=<%=JNDIDSN %>">Table List : <strong><%=Database %></strong></a></li>
      <li class="active">SQL Script</li>
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

<div class="well well-sm">	
<form class="form-inline" action="generatescript.jsp" method="post" id="script_form" target="_blank">
<input type="hidden" name="JNDIDSN" value="<%=JNDIDSN %>" />
<input type="hidden" name="TableName" value="<%=TableName %>" />
<input type="hidden" name="DriverName" value="<%=DriverName %>" />
<input type="hidden" name="SQLEngine" value="<%=PortableSQL.UNKNOWN%>" id="SQLEngine" />
<div class="row">
  <div class="col-md-4">

  <div class="form-group">
    <label for="IDField">PK - Auto Number ?</label>
			<span class="checkbox checkbox-primary">
      <input type="checkbox" name="IsAuto" id="IsAuto" <% if(!"".equals(PK)){ %> checked <% } %> />
      <label for="IsAuto"><input type="text" name="IDField" class="form-control" value="<%=PK %>" id="IDField"></label>
      </span>
  </div>
	
	</div>
	<div class="col-md-6">
  <div class="form-group">
    <label for="IDFieldType">PK Field Type</label>
   
			<select name="IDFieldType" id="IDFieldType" class="form-control">
    		<option value="INT" selected="selected">Integer</option>
    		<option value="STRING" >Character Data</option> 
  		</select>
    
  </div>
	</div>
</div>
</form>
</div>		
	

			
<div class="row">
  <div class="col-md-3">
	
<div class="list-group">
<a class="list-group-item" href="javascript:CreateScript('<%=PortableSQL.MYSQL %>')">MySQL</a>
<a class="list-group-item" href="javascript:CreateScript('<%=PortableSQL.POSTGRE %>')">Postgre SQL</a>
<a class="list-group-item" href="javascript:CreateScript('<%=PortableSQL.DB2 %>')">IBM DB2</a>
<a class="list-group-item" href="javascript:CreateScript('<%=PortableSQL.MSSQL %>')">MS SQL</a>
<a class="list-group-item" href="javascript:CreateScript('<%=PortableSQL.ORACLE %>')">Oracle</a>
<a class="list-group-item" href="javascript:CreateScript('<%=PortableSQL.H2 %>')">H2 Database</a>
<a class="list-group-item" href="javascript:CreateScript('<%=PortableSQL.SQLITE %>')">SQLite</a>
</div>

	</div>
  <div class="col-md-6">
<div class="table-responsive">
<table class="table table-striped table-bordered table-condensed">
<thead>
<th>#</th>
<th>Column Name</th>
<th>Data Type</th>
<th>Size</th>
<th>JDBC Type</th>
</thead>
<tbody>
<%
for(int n = 1 ; n <= count ; n++ )
{	
	 String ColName = rsmd.getColumnName(n) ;
	 String ColSQLType = rsmd.getColumnTypeName(n);
	 int nJdbcType =  rsmd.getColumnType(n);
	 int Pr = rsmd.getPrecision(n);
	 int Sc = rsmd.getScale(n);
	 String Auto =  ( rsmd.isAutoIncrement(n)) ? "<span class='label label-default'>AUTO</span>" : " " ;
   boolean bOverride = false;
	 String col_key = Database+"."+TableName+"."+ColName ;
	 if( OverrideMap !=null && OverrideMap.containsKey(col_key))
	 {
	    bOverride=true;
			try
			{
			    nJdbcType = Integer.parseInt( (String)OverrideMap.get(col_key) );
			}catch(NumberFormatException ex)
			{
			  // revert back to original type
			   nJdbcType = rsmd.getColumnType(n);
			}
			ColSQLType=ColTypeOverride.typeLabel(nJdbcType) ;
	 }  
%>

<tr <% if(bOverride){ %> style="background-color: #eaffd5;"  <%}%> >
<td><%=n %></td>
<td><%=ColName %>&nbsp;<%=Auto %></td>
<td><%=ColSQLType %></td>
<td><% if(bOverride){ %> <small>Overridden</small> <% }else{ %> <%=Pr %> , <%=Sc %> <% } %></td>
<td><%=nJdbcType %></td>
</tr>
<%	  
}// end for(int n = 1 ; n <= count ; n++ ) 
%>
</tbody>
</table>
</div>
	
	</div>
</div>				

    </div> <!-- /container -->
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />
<script type="text/javascript">
<!--
function CreateScript(eng)
{ 
 		$("#SQLEngine").val(eng);
		$("#script_form").submit();
}
// -->
</script>
<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>
<%
rslt.close();
stmt.close();  
}	 
finally
{
conn.close();
}
%>