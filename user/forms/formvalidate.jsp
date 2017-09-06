
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.lang.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="com.webapp.utils.*" %>
<jsp:useBean id="ManFieldMap" scope="session" class="java.util.TreeMap" />
<jsp:useBean id="ManField" scope="session" class="java.util.Vector" />
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

  <!-- The follwing are the files that must be added for using SHJS-Extended -->
  <!-- Common Styles -->
  <link rel="stylesheet" href="<%=appPath %>/assets/vendor/shjs-highlight-code/shx_main.min.css" />
  <!-- Theme file. There are many more themes in the css folder -->
  <link rel="stylesheet" href="<%=appPath %>/assets/vendor/shjs-highlight-code/css/sh_acid.min.css" />
  <!-- Main JS file -->
  <script type="text/javascript" src="<%=appPath %>/assets/vendor/shjs-highlight-code/sh_main.js"></script>
	
  <script type="text/javascript">
	function init() { //body onload
		var start=new Date();
		sh_highlightDocument('<%=appPath %>/assets/vendor/shjs-highlight-code/', '.min.js');		
		var stop=new Date();
		document.getElementById('processTime').appendChild(document.createTextNode('Time taken to complete process: '+(stop-start)+' ms'));
	}
  </script>

<style type="text/css">
.clickablePanel{cursor: pointer;}
.clickablePanel .glyphicon{background: rgba(0, 0, 0, 0.15);display: inline-block;padding: 6px 12px;border-radius: 4px}
.clickablePanel  span{margin-top: -23px;font-size: 15px;margin-right: -9px;}
</style>
</head>
<body onload="init();" style="margin-bottom: 0px;padding-top: 10px;">   
<div class="container-fluid">

      <div class="panel panel-default">
        <div class="panel-heading clickablePanel">
          <h4 class="panel-title">
					<i class="fa fa-database text-primary"></i>&nbsp;&nbsp;Sample Code for regexp</span>
					</h4>
					<span class="pull-right p1"><i class="glyphicon glyphicon-minus"></i></span>
        </div>
        <div class="panel-body">
					<div id="processTime" class="well well-sm"></div>
          <pre class="sh_javascript" title="sample code">
regexp: {
    regexp: /^[a-zA-Z]+$/,
    message: 'The name can only consist of alphabetical'
}

regexp: {
    regexp: /^[a-zA-Z0-9_]+$/,
    message: 'The name can only consist of alphabetical, number and underscore'
}

regexp: {
    regexp: /^[a-zA-Z\s]+$/,
    message: 'The name can only consist of alphabetical and space'
}

regexp: {
    regexp: /^[a-zA-Z0-9_\.]+$/,
    message: 'The name can only consist of alphabetical, number, dot and underscore'
}
          </pre>

        </div>
      </div>			


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
	<li class="list-group-item list-group-item-success">Mandatory Fileds: <span id="vlmap"></span></li>
</ul>

<br />

<div class="table-responsive">
<table class="table table-striped table-bordered table-condensed">
<thead>
<tr>
<th>#</th>
<th>Column</th>
<th>Type</th>
<th>Mandatory</th>
</tr>
</thead>
<tbody>
<%
for(int n = 1 ; n <= count ; n++ )
{	
	String ColName = rsmd.getColumnName(n) ;	
	if( request.getParameter("CHECK_"+ColName)!=null ) if(!ManField.contains(ColName)) ManField.add(ColName);
	String[] InputType = request.getParameterValues(ColName);
			 int j1 =0;
			 StringBuilder sb1 = new StringBuilder();
			 for(String s1:InputType)
       {
			   if(j1>0)sb1.append(",");
				 sb1.append(s1); 
			   j1++;
			 }
	ManFieldMap.put(ColName, sb1) ;		 	
		
%>
<tr>     
<td><%=n %></td>
<td><%=ColName %></td>
<td><%=ManFieldMap.get(ColName)%></td>
<td><%if(ManField.contains(ColName)){%>yes<%}else{%>No<%}%></td>			
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
ManField.clear();
ManFieldMap.clear();
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
<th>
<span class="checkbox checkbox-inline checkbox-primary">
    <input type="checkbox" name="checkall" id="checkall" >
    <label for="checkall"><b>Mandatory ?</b></label>
</span>
</th>
<th>Column</th>
<th>Type</th>
<th width="30%">Validation Type</th>
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
<td>
<span class="checkbox checkbox-inline checkbox-primary">
    <input type="checkbox" name="CHECK_<%=ColName %>" id="CHECK_<%=ColName %>" <% if(ManField.contains(ColName))  out.print("checked=\"checked\"") ; %> >
    <label for="CHECK_<%=ColName %>"><%=n %></label>
</span>
</td>
<td><%=ColName %><% if( rsmd.isAutoIncrement(n)) { %>&nbsp;&nbsp;<span class="label label-default">A</span><% } %></td>
<td><%=ColType %></td>
<td><%=ValidationType.getDropList(ColName, ColName, (short)1, false, false, "form-control selectpicker show-tick", "data-container='body' data-live-search='false' multiple data-selected-text-format='count > 1' data-actions-box='true'") %></td>
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

$("#Form_validation #checkall").click(function () {
        if ($("#Form_validation #checkall").is(':checked')) {
            $("#Form_validation input[type=checkbox]").each(function () {
                $(this).prop("checked", true);
            });

        } else {
            $("#Form_validation input[type=checkbox]").each(function () {
                $(this).prop("checked", false);
            });
        }
    });
		
$(document).ready(function() {
	$("#trmap").html("<%=ManFieldMap.size() %>");
	$('#vlmap').html("<%=ManField.size() %>");
	
	$('.panel div.clickablePanel').click();
});		

</script>

</body>
</html>
