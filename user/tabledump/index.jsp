<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="com.webapp.utils.*, com.webapp.jsp.*" %>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

String JNDIDSN= request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String DriverName= request.getParameter("DriverName");
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

String fwd="";

short sqlEng = PortableSQL.getEngineFromDriverName(DriverName);
PortableSQL _psql=new PortableSQL(sqlEng);
%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Table Dump</title>	
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
    <h4 class="page-title11"><i class="fa fa-plug text-primary"></i>&nbsp;&nbsp;<span class="text-muted">Table Data Dump</span></h4>
  </div>
  <div class="col-md-6 col-xs-12">
    <!--  page-header-actions  -->
    <ol class="breadcrumb text-right">
      <li><a href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg"></i></a></li>
      <li><a href="<%=appPath %>/user/tablelist.jsp?JNDIDSN=<%=JNDIDSN %>">Table List : <strong><%=Database %></strong></a></li>
      <li class="active">Table Dump</li>
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

<form action="table-data-dump.jsp" method="post">
<input type="hidden" name="DriverName" value="<%= DriverName %>" />
<input type="hidden" name="JNDIDSN" value="<%= JNDIDSN %>" />
<input type="hidden" name="TableName" value="<%= TableName %>" />

<div class="row">
  <div class="col-md-12">
    <p><button type="submit" class="btn btn-primary btn-block btn-lg">Get Dump</button></p>
	</div>
</div>
			
<div class="row">
  <div class="col-md-4">

<table class="table table-striped table-bordered table-condensed">
<tr>
<td>Driver Name</td>
<td><%=DriverName %></td>
</tr>
<tr>
<td>JNDI Data Source</td>
<td><%=JNDIDSN %></td>
</tr>
<tr>
<td>Table</td>
<td><%= TableName %></td>
</tr>
<tr>
<td>SQL Engine</td>
<td><%=_psql.getEngineName() %></td>
</tr>
<tr>
<td>Output For Engine</td>
<td> 
      <div class="table-responsive">
      <table class="table table-striped table-bordered table-condensed">
           <tr><td><span class="radio radio-primary radio-inline"><input type="radio" name="SQLEngine" id="<%=PortableSQL.UNKNOWN %>" value="<%=PortableSQL.UNKNOWN %>" <% if( sqlEng== PortableSQL.UNKNOWN ){ %>  checked="checked" <%  }  %>  /><label for="<%=PortableSQL.UNKNOWN %>">Unknown</label></span></td></tr>
					 <tr><td><span class="radio radio-primary radio-inline"><input type="radio" name="SQLEngine" id="<%=PortableSQL.MYSQL %>" value="<%=PortableSQL.MYSQL %>" <% if( sqlEng== PortableSQL.MYSQL ){ %>  checked="checked" <%  }  %> /><label for="<%=PortableSQL.MYSQL %>">MySQL</label></span></td></tr>
           <tr><td><span class="radio radio-primary radio-inline"><input type="radio" name="SQLEngine" id="<%=PortableSQL.POSTGRE %>" value="<%=PortableSQL.POSTGRE %>" <% if( sqlEng== PortableSQL.POSTGRE ){ %>  checked="checked" <%  }  %> /><label for="<%=PortableSQL.POSTGRE %>">Postgre SQL</label></span></td></tr>
					 <tr><td><span class="radio radio-primary radio-inline"><input type="radio" name="SQLEngine" id="<%=PortableSQL.DB2 %>" value="<%=PortableSQL.DB2 %>" <% if( sqlEng== PortableSQL.DB2 ){ %>  checked="checked" <%  }  %> /><label for="<%=PortableSQL.DB2 %>">IBM DB2</label></span></td></tr>
           <tr><td><span class="radio radio-primary radio-inline"><input type="radio" name="SQLEngine" id="<%=PortableSQL.MSSQL %>" value="<%=PortableSQL.MSSQL %>" <% if( sqlEng== PortableSQL.MSSQL ){ %>  checked="checked" <%  }  %> /><label for="<%=PortableSQL.MSSQL %>">Microsoft SQL Server</label></span></td></tr>
					 <tr><td><span class="radio radio-primary radio-inline"><input type="radio" name="SQLEngine" id="<%=PortableSQL.ORACLE %>" value="<%=PortableSQL.ORACLE %>" <% if( sqlEng== PortableSQL.ORACLE ){ %>  checked="checked" <%  }  %> /><label for="<%=PortableSQL.ORACLE %>">Oracle Server</label></span></td></tr>
           <tr><td><span class="radio radio-primary radio-inline"><input type="radio" name="SQLEngine" id="<%=PortableSQL.H2 %>" value="<%=PortableSQL.H2 %>" <% if( sqlEng== PortableSQL.H2  ){ %>  checked="checked" <%  }  %> /><label for="<%=PortableSQL.H2 %>">H2 Database</label></span></td></tr>
					 <tr><td><span class="radio radio-primary radio-inline"><input type="radio" name="SQLEngine" id="<%=PortableSQL.SQLITE %>" value="<%=PortableSQL.SQLITE %>" <% if( sqlEng== PortableSQL.SQLITE ){ %>  checked="checked" <%  }  %> /><label for="<%=PortableSQL.SQLITE %>">SQLite</label></span></td></tr>
       </table>	
			 </div> 
</td>
</tr>
</table>
	
	
	</div>
  <div class="col-md-8">

<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title">Select Table Fields</h3>
  </div>
  <div class="panel-body">
	
<div class="column_layout well well-sm">


<%      
		int n=0;
		int nAutoPos = 0;
    int count = 0;
    String query = _psql.SQL(" SELECT * FROM `"+TableName+"` " ) ; 
    try 
    {

          java.sql.Statement stmt = conn.createStatement();
          java.sql.ResultSet rslt = stmt.executeQuery(query);
          java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
          count  = rsmd.getColumnCount();
	        for( n = 1 ; n <= count ; n++ )
          {
					    String colname = rsmd.getColumnName(n);
              if( rsmd.isAutoIncrement(n))
              {
                 nAutoPos=n;
              }
 %>
<table class="table table-condensed borderless" style="margin-bottom: 0px;">
<tr>
<td width="10%"><%=n %></td>
<td>
<span class="checkbox checkbox-inline checkbox-primary">
<input type="checkbox" name="ColNo" id="<%=n %>_col" value="<%=n %>" <% if(n!=nAutoPos){ %>checked<%  } %> >
<label for="<%=n %>_col"><%=colname %><% if(n==nAutoPos){ %>&nbsp;<span class="label label-default">AUTO</span><%  } %></label>
</span>
</td>
</tr>
</table>

<%          
          } // end - for( n = 1 ; n <= count ; n++ )
	  rslt.close();
    stmt.close();
    }
    catch(Exception e)
    {

    }
    finally
    {
    conn.close();
    }		
%>
 </div>

  </div>
</div>	

	
	</div>
</div>	

</form>			

    </div> <!-- /container -->
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />

<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>