<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="com.webapp.utils.*" %>

<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

String JNDIDSN= request.getParameter("JNDIDSN");
String TableName = request.getParameter("TableName");
String DriverName= request.getParameter("DriverName");
String Pkg  = null ;
String Database=null;
char First  = TableName.charAt(0);
if(First > 96) First-=32 ;
String BeanClass = First+TableName.substring(1)+"Bean" ;

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


Pkg = "com.db."+JNDIDSN.substring(JNDIDSN.indexOf("/",0)+1 );
String PK="?";
try 
{
  java.sql.Statement stmt = conn.createStatement();
  java.sql.ResultSet rslt = null ;
  rslt = stmt.executeQuery(BeanwizHelper.openTableSQL(conn, TableName)); 
  java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
  int count  = rsmd.getColumnCount();
 	for(int n = 1 ; n <= count ; n++ )
  {	
	   if( rsmd.isAutoIncrement(n))PK=rsmd.getColumnName(n) ;; 

  }// end for(int n = 1 ; n <= count ; n++ ) 
  // clean up the lists

%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Generate Java Bean</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
</head>
<body>   
<jsp:include page="/user/assets-user/include-page/header-user.jsp" flush="true" />	
<div class="container-fluid">

    <div class="row page-header11">
    	<div class="col-md-6 col-xs-12">
        <h4 class="page-title11"><i class="fa fa-plug text-primary"></i>&nbsp;&nbsp;<span class="text-muted">Generate Java Bean</span></h4>	
	    </div>
			<div class="col-md-6 col-xs-12"><!--  page-header-actions  -->
            <ol class="breadcrumb text-right">
               <li><a href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg"></i></a></li>
               <li><a href="tablelist.jsp?JNDIDSN=<%=JNDIDSN %>">Table List : <strong><%=Database %></strong></a></li>
							 <li class="active">Java Bean</li>
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
	
<div class="row">
  <div class="col-md-5">
	
<form class="form-horizontal" action="faltu.jsp" method="post"  id="beanform" name="beanform" target="_blank">
<input type="hidden" name="DriverName" value="<%=DriverName %>" />
<input type="hidden" name="JNDIDSN" value="<%=JNDIDSN %>" />
<input type="hidden" name="TableName" value="<%=TableName %>" />

  <div class="form-group">
    <label for="BeanClass" class="col-sm-4 control-label">Bean Class</label>
    <div class="col-sm-8">
		  <input type="text" name="BeanClass" class="form-control" id="BeanClass" value="<%=BeanClass %>" >
    </div>
  </div>
  <div class="form-group">
    <label for="BeanPackage" class="col-sm-4 control-label">Bean Package</label>
    <div class="col-sm-8">
			<input type="text" name="BeanPackage" class="form-control" value="<%=Pkg %>" id="BeanPackage" >
    </div>
  </div>
<!-- 	
  <div class="form-group">
    <label for="JNDIDSN" class="col-sm-4 control-label">JNDI DataSource</label>
    <div class="col-sm-8">
			<input type="text" name="JNDIDSN" class="form-control" id="JNDIDSN" value="<%=JNDIDSN %>" >
    </div>
  </div>
  <div class="form-group">
    <label for="TableName" class="col-sm-4 control-label">Table Name</label>
    <div class="col-sm-8">
			<input type="text" name="TableName" value="<%=TableName %>" class="form-control" id="TableName" >
    </div>
  </div>
 -->	
  <div class="form-group">
    <label for="IDField" class="col-sm-4 control-label">PK - Auto Number ?</label>
	    <div class="col-sm-8">
			<span class="checkbox checkbox-primary">
      <input type="checkbox" name="IsAuto" id="IsAuto" />
      <label for="IsAuto"><input type="text" name="IDField" class="form-control" value="?" id="IDField"></label>
      </span>
			
    </div>
  </div>
  <div class="form-group">
    <label for="IDFieldType" class="col-sm-4 control-label">PK Field Type</label>
    <div class="col-sm-8">
     
			<select name="IDFieldType" id="IDFieldType" class="form-control selectpicker">
    		<option value="INT" selected="selected">Integer</option>
    		<option value="STRING" >Character Data</option> 
  		</select>
    </div>
  </div>
  <div class="form-group">
    <label for="inputEmail3" class="col-sm-4 control-label">Generic Driver Code</label>
    <div class="col-sm-8">
		  <!-- <div class="form-group"></div> -->
			<div class="checkbox checkbox-primary">
      <input type="checkbox" name="GenericDriver" id="GenericDriver" value="true" />
      <label for="GenericDriver"> Code which is independent of particular driver</label>
      </div>
		</div>	 
  </div>
  <div class="form-group">
    <div class="col-sm-offset-4 col-sm-10">
			<button type="button" class="btn btn-primary btn-lg" name="java" onclick='getJavaCode()'>Get Java Bean</button>
    </div>
  </div>
</form>
	
	</div>
  <div class="col-md-7">
	<div id="TABLE_INFO"></div>
	</div>
</div>	



<!-- Modal -->
<div class="modal fade overridecolumntype-modal" id="overridecolumntype" tabindex="-1" role="dialog" aria-labelledby="overridecolumntype">
  <div class="modal-dialog" role="document">
    <div class="modal-content overridecolumntype">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="overridecolumntype">Override Column JDBC Type</h4>
      </div>
      <div class="modal-body overridecolumntype-modal-body">
			
        <!-- <div class="embed-responsive embed-responsive-16by9"></div> -->
				<div class="embed-responsive embed-responsive-16by9">
           <iframe class="embed-responsive-item" frameborder="0" width="100%"></iframe>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>			

</div> <!-- /container -->
<%  
}	 
finally
{
conn.close();
}
%>
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/nakupanda-modal-js.jsp" flush="true" />

<script type="text/javascript">
<!--
//var obBeanPackage = document.getElementById("BeanPackage");
//obBeanPackage.value = "<%=Pkg %>";

var obIDField = document.getElementById("IDField");
obIDField.value="<%=PK %>";
<% 
if(!"?".equals(PK)){ 
%> 
var obIsAuto = document.getElementById("IsAuto");
obIsAuto.checked=true;
<%
}  
%>

function getJavaCode()
{
    document.forms['beanform'].action='<%=appPath %>/makebean' ;
    document.forms['beanform'].target='_blank' ;
    document.forms['beanform'].submit();
}

function ShowOverrideDialog(cname, ckey, ctype)
{
 $('.overridecolumntype-modal').modal('show');
 $('.overridecolumntype-modal').modal({keyboard: false, backdrop: 'static'});
 $('.modal').on('shown.bs.modal', function() {
        $(this).find('iframe').attr('src','<%=appPath %>/user/overridecolumntypes.jsp?Action=New&ColName='+cname+'&ColKey='+ckey+'&colType='+ctype) ;
    })
 $('.overridecolumntype-modal').on('hidden.bs.modal', function (e) {
  ShowTableStruct();
    })
 //$('.overridecolumntype-modal-body').load("<%=appPath %>/user/overridecolumntypes.jsp?Action=New&ColName="+cname+"&ColKey="+ckey+"&colType="+ctype);
}


function ShowTableStruct()
{
  $('#TABLE_INFO').load("showtablestruct.jsp?JNDIDSN=<%=JNDIDSN %>&TableName=<%=TableName %>");
}

$(document).ready(function() {
	
	ShowTableStruct();
	
});
// -->
</script>
<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>
