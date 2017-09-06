<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="com.webapp.utils.*" %>
<jsp:useBean id="OverrideMap" scope="session" class="java.util.TreeMap" />
<jsp:useBean id="FieldMap" scope="session" class="java.util.TreeMap" />
<jsp:useBean id="ManField" scope="session" class="java.util.Vector" />

<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

String WebAppName = request.getParameter("WebAppName");
String JNDIDSN = request.getParameter("JNDIDSN");
 

String Database=null; 
String DriverName=null;
String[] exld = null ;

%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Tables in <%=JNDIDSN %></title>
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />

<style type="text/css">
.clickablePanel{cursor: pointer;}
.clickablePanel .glyphicon{background: rgba(0, 0, 0, 0.15);display: inline-block;padding: 6px 12px;border-radius: 4px}
.clickablePanel  span{margin-top: -23px;font-size: 15px;margin-right: -9px;}
</style>

</head>
<body>   
<jsp:include page="/user/assets-user/include-page/header-user.jsp" flush="true" />	

<div class="container-fluid">
<% 
Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
com.webapp.utils.PortableSQL psql = new com.webapp.utils.PortableSQL(conn) ;
try
{

DatabaseMetaData md=conn.getMetaData();
Database=conn.getCatalog();
DriverName=md.getDriverName(); 

switch(psql.getEngine())
{
  case PortableSQL.ORACLE:
  exld =  new String[]  { "DR$", 	"WWV_" , "BIN$", "OGIS_" , "SDO_", "AUDIT_ACTIONS", "ODCI_",	"OL$" , 
	"XDB$", "DUAL", "IMPDP_STATS", "KU$NOEXP_TAB", "PLAN_TABLE$", "PSTUBTBL",  "STMT_AUDIT_OPTION_MAP", 
	"SYSTEM_PRIVILEGE_MAP", "TABLE_PRIVILEGE_MAP", "WRI$_ADV_ASA_RECO_DATA" , "DEF$_TEMP$LOB", "HELP"  } ;
	
  break ;
}
%>

    <div class="row page-header11">
    	<div class="col-md-6 col-xs-12">
        <h4 class="page-title11"><i class="fa fa-send-o"></i>&nbsp;&nbsp;<span class="text-info">JNDI: <span class="text-muted"><%=JNDIDSN %></span></span></h4>	
	    </div>
			<div class="col-md-6 col-xs-12">
            <ol class="breadcrumb text-right">
               <li><a href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg"></i></a></li>
               <li class="active">Table List : <strong><%=Database %></strong></li>
            </ol>
	    </div>
    </div>
<hr class="pageheaderHR" />
			
<div class="row">
  <div class="col-md-12">

      <div class="panel panel-default">
        <div class="panel-heading clickablePanel">
          <h4 class="panel-title">
					<i class="fa fa-database text-primary"></i>&nbsp;&nbsp;Detected DB Engine : <strong><%=psql.getEngineName() %></strong></span>
					</h4>
					<span class="pull-right p1"><i class="glyphicon glyphicon-minus"></i></span>
        </div>
        <div class="panel-body">
				
					<div class="row">
					<div class="col-md-6">
<div class="panel panel-primary">
  <!-- Default panel contents -->
  <div class="panel-heading">
	<h3 class="panel-title"><i class="fa fa-cogs fa-lg"></i>&nbsp;&nbsp;Info</h3>
	</div>


  <!-- List group -->
  <ul class="list-group">
    <li class="list-group-item"><strong>Driver : </strong><span class="text-muted"><%=DriverName %></span></li>
<!-- 		  			
<% 
// See if database struct definition is available ( driver specific )
if(DriverName.equalsIgnoreCase("MySQL-AB JDBC Driver") || DriverName.equalsIgnoreCase("MySQL Connector Java"))
{
 // MySQL is supported.
%>
<li class="list-group-item"><a href="<%=appPath %>/user/dbstruct/mysql-db-struct.jsp?JNDIDSN=<%=JNDIDSN %>" target="_blank"> SQL Script</a> to create database  structure  ( MySQL )</li>
<%
}
%>
-->


  </ul>
</div>		

<div class="panel panel-primary">
  <!-- Default panel contents -->
  <div class="panel-heading">
	<h3 class="panel-title"><i class="fa fa-cogs fa-lg"></i>&nbsp;&nbsp;SQL Script : MySQL</h3>
	</div>
  <!-- List group -->
  <ul class="list-group">
    <li class="list-group-item"><a href="<%=appPath %>/user/dbstruct/mysql-db-struct.jsp?JNDIDSN=<%=JNDIDSN %>" target="_blank">Create Database Structure</a></li>
  </ul>
</div>					
			
					</div>
					<div class="col-md-6">
<div class="panel panel-primary">
  <!-- Default panel contents -->
  <div class="panel-heading">
	<h3 class="panel-title"><i class="fa fa-cogs fa-lg"></i>&nbsp;&nbsp;Database Creation Script</h3>
	</div>
  <div class="panel-body">
    <p>Generate SQL Script for creating tables for various database engines</p>
  </div>

<!-- Table -->
<div class="table-responsive">
<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Database Engine</th>
<th>Table SQL</th>
<th>Indexes</th>
</tr>
</thead>
<tbody>	
<tr>
    <td>MySQL</td>
		<td><a href="<%=appPath %>/user/createdatabasescripts/createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.MYSQL %>" target="_blank" >Tables</a></td>
		<td><a href="<%=appPath %>/user/createdatabasescripts/createindexscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.MYSQL %>" target="_blank" >Indexes</a></td>
</tr>
<tr>
    <td>Postgre SQL</td>
		<td><a href="<%=appPath %>/user/createdatabasescripts/createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.POSTGRE %>" target="_blank">Tables</a></td>
		<td><a href="<%=appPath %>/user/createdatabasescripts/createindexscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.POSTGRE %>" target="_blank">Indexes</a></td>
</tr>
<tr>
    <td>IBM DB2</td>
		<td><a href="<%=appPath %>/user/createdatabasescripts/createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.DB2 %>" target="_blank" >Tables</a></td>
		<td><a href="<%=appPath %>/user/createdatabasescripts/createindexscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.DB2 %>" target="_blank" >Indexes</a></td>
</tr>
<tr>
    <td>MS SQL</td>
		<td><a href="<%=appPath %>/user/createdatabasescripts/createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.MSSQL %>" target="_blank">Tables</a></td>
		<td><a href="<%=appPath %>/user/createdatabasescripts/createindexscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.MSSQL %>" target="_blank">Indexes</a></td>
</tr>
<tr>
    <td>Oracle</td>
		<td><a href="<%=appPath %>/user/createdatabasescripts/createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.ORACLE %>" target="_blank" >Tables</a></td>
		<td><a href="<%=appPath %>/user/createdatabasescripts/createindexscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.ORACLE %>" target="_blank" >Indexes</a></td>
</tr>
<tr>
    <td>H2 Database</td>
		<td><a href="<%=appPath %>/user/createdatabasescripts/createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.H2 %>" target="_blank" >Tables</a></td>
		<td><a href="<%=appPath %>/user/createdatabasescripts/createindexscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.H2 %>" target="_blank" >Indexes</a></td>
</tr>
<tr>
    <td>SQLite</td>
		<td><a href="<%=appPath %>/user/createdatabasescripts/createsqlscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.SQLITE %>">Tables</a></td>
		<td><a href="<%=appPath %>/user/createdatabasescripts/createindexscript.jsp?JNDIDSN=<%=JNDIDSN %>&SQLEngine=<%=PortableSQL.SQLITE %>">Indexes</a></td>
</tr>
</tbody>
</table>

</div>		
</div> 					
					</div>
					</div>

        </div>
      </div>			
	</div>
</div>

	

<div class="panel  panel-primary">
  <!-- Default panel contents -->
  <div class="panel-heading"><big><i class="fa fa-table fa-lg"></i>&nbsp;&nbsp;Table List : <%=Database %>&nbsp;&nbsp;|&nbsp;&nbsp;WebApp : <%=WebAppName %></big></div>
  <div class="panel-body">
    <div class="well well-sm text-center row-fluid-text" id="ANCH" style="margin-bottom: 0px;"></div>	
  


<div class="table-responsive">	
<table class="table table-striped table-bordered">
<%  
ArrayList<String> AlphaList = new ArrayList<String>();

String[] tbl_types = {"TABLE"} ;
java.sql.ResultSet rsltList = md.getTables(null,null,null,tbl_types );
int no=0;
StringBuilder sbAn = new StringBuilder("Go To : ");
String OldChar = "";
while(rsltList.next())
{ 
		String TableName = rsltList.getString("TABLE_NAME");	
		// Check in exlusion list
		boolean bNotThere = true ;
  
			if(exld != null)
			{
		           for(int i=0 ; i< exld.length ; i++) 
			         {
			            if( TableName.startsWith(exld[i]) ) bNotThere = false ;
			         }
		  }
		
		
	     if(bNotThere)
		   {	
			   no++;
			 	
				boolean bLink = false;
				String Chk = TableName.substring(0,1).toUpperCase();
			  if(!OldChar.equalsIgnoreCase(Chk))	
				{
				  sbAn.append("&nbsp;<a href=\"#"+Chk+"\"><big>"+Chk+"</big></a>&nbsp;");
					bLink=true;
				 
				%>
				</table>
<a id="<%=Chk %>" ></a>

<table class="table table-striped table-bordered" >
<thead>
<tr>
<th width="5%">#</th>
<th width="23%">Database Tables</th>
<th colspan="4">Code Generation Tools</th>
</tr>
</thead>
<tbody>
				<% 
				} 
				OldChar=Chk;
				%>
<tr id="<%=TableName %>" >
<td width="5%"><%=no %></td>
<td width="23%"><%=TableName %></td>
<td><a href="newbeanwiz.jsp?JNDIDSN=<%=JNDIDSN %>&WebAppName=<%=WebAppName %>&TableName=<%=TableName %>&DriverName=<%=DriverName %>">Bean</a></td>
<td><a href="jsppagewiz.jsp?JNDIDSN=<%=JNDIDSN %>&WebAppName=<%=WebAppName %>&TableName=<%=TableName %>&DriverName=<%=DriverName %>">JSP</a></td>
<td><a href="jsploginwiz.jsp?JNDIDSN=<%=JNDIDSN %>&WebAppName=<%=WebAppName %>&TableName=<%=TableName %>&DriverName=<%=DriverName %>">Login</a></td>
<td class="dropdown">
  <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><i class="fa fa-gear fa-lg text-primary"></i>&nbsp;<span class="caret"></span></a>
  <ul class="dropdown-menu">
    <li><a href="params/tableparam.jsp?JNDIDSN=<%=JNDIDSN %>&TableName=<%=TableName %>" target="_blank"><samp><i class="fa fa-hand-o-right fa-lg"></i>&nbsp;Request Parameter</samp></a></li>
    <li><a href="forms/tableform.jsp?JNDIDSN=<%=JNDIDSN %>&TableName=<%=TableName %>" target="_blank"><samp><i class="fa fa-hand-o-right fa-lg"></i>&nbsp;Form Field</samp></a></li>
    <li><a href="tablefields.jsp?JNDIDSN=<%=JNDIDSN %>&TableName=<%=TableName %>" target="_blank"><samp><i class="fa fa-hand-o-right fa-lg"></i>&nbsp;Field List</samp></a></li>
    <li><a href="<%=appPath %>/user/tabledef/showcreatetable.jsp?JNDIDSN=<%=JNDIDSN %>&TableName=<%=TableName %>" target="_blank"><samp><i class="fa fa-hand-o-right fa-lg"></i>&nbsp;old for mysql</samp></a></li>
    <li><a href="createtablescript/index.jsp?DriverName=<%=DriverName %>&JNDIDSN=<%=JNDIDSN %>&TableName=<%=TableName %>" target="_blank"><samp><i class="fa fa-hand-o-right fa-lg"></i>&nbsp;Table Script</samp></a></li>
    <li><a href="tabledump/index.jsp?DriverName=<%=DriverName %>&JNDIDSN=<%=JNDIDSN %>&TableName=<%=TableName %>" target="_blank"><samp><i class="fa fa-hand-o-right fa-lg"></i>&nbsp;Table Data Dump</samp></a></li>
    <li><a href="excelexport/query.jsp?DriverName=<%=DriverName %>&JNDIDSN=<%=JNDIDSN %>&TableName=<%=TableName %>" target="_blank"><samp><i class="fa fa-hand-o-right fa-lg"></i>&nbsp;Excel Export</samp></a></li>
  </ul>
</td>
</tr>
<%  
       } // end if (bNotThere)
    } // end while while(rsltList.next())
rsltList.close();		
%>
</tbody>
</table>

</div>	
</div>
</div>
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />

<script type="text/javascript">

$('#ANCH').html('<%=sbAn.toString() %>');

$(document).on('click', '.panel div.clickablePanel', function (e) {
    var $this = $(this);
    if (!$this.hasClass('panel-collapsed')) {
        $this.parents('.panel').find('.panel-body').slideUp();
        $this.addClass('panel-collapsed');
        $this.find('.p1 i').removeClass('glyphicon-minus').addClass('glyphicon-plus');
    } else {
        $this.parents('.panel').find('.panel-body').slideDown();
        $this.removeClass('panel-collapsed');
        $this.find('.p1 i').removeClass('glyphicon-plus').addClass('glyphicon-minus');
    }
});
$(document).ready(function () {
    $('.panel div.clickablePanel').click();
});

</script>
<%
}
finally
{
conn.close();
FieldMap.clear();
ManField.clear();
OverrideMap.clear();
}%>

<% 
if(exld != null)
{ 
%>
<br />
<br />

<b>Excluded Tables</b> ( System tables ):&nbsp;&nbsp; <% for(int i=0 ; i< exld.length ; i++) out.print( exld[i]+( (i< exld.length-1)? ", " : " ") ) ; %> </p>
<% 
} 
%>
	
</div> <!-- /container -->
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>
