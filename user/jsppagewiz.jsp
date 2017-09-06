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

response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

String JNDIDSN= request.getParameter("JNDIDSN");
String WebAppName = request.getParameter("WebAppName");
String TableName = request.getParameter("TableName");
String DriverName= request.getParameter("DriverName");

char First  = TableName.charAt(0);
if(First > 96) First-=32 ;

char TFirst  = TableName.charAt(0);
if(TFirst > 96) TFirst-=32 ;
String CTableName = TFirst+TableName.substring(1) ;

String BeanName = First+TableName.substring(1,2)+"Bn" ;
String BeanClass = First+TableName.substring(1)+"Bean" ;
String BeanPackage  = "com.db."+JNDIDSN.substring(JNDIDSN.indexOf("/",0)+1 );

boolean bAuto =( request.getParameter("IsAuto")!=null)? true:false ;
String IDField = request.getParameter("IDField");
String IDFieldType = request.getParameter("IDFieldType") ;

String Database=null;
Context env = (Context) new InitialContext().lookup("java:comp/env");
DataSource source = (DataSource) env.lookup(JNDIDSN);
Connection conn = source.getConnection();
Database=conn.getCatalog();

String PK="?";
boolean bDateSupport = false;
boolean bTimeSupport = false;
boolean bTimestampSupport = false;
String WebApp = "com."+WebAppName ;

String query = BeanwizHelper.openTableSQL(conn, TableName);
try 
{
java.sql.Statement stmt = conn.createStatement();
java.sql.ResultSet rslt = stmt.executeQuery(query);
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
<title>Generate JSP Page</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
<style type="text/css">
.table th {background-color: #f5f5f5}
</style>
</head>
<body>   
<jsp:include page="/user/assets-user/include-page/header-user.jsp" flush="true" />	

<div class="container-fluid">

<div class="row page-header11">
  <div class="col-md-6 col-xs-12">
    <h4 class="page-title11"><i class="fa fa-plug text-primary"></i>&nbsp;&nbsp;<span class="text-muted">Generate JSP Page</span></h4>
  </div>
  <div class="col-md-6 col-xs-12">
    <!--  page-header-actions  -->
    <ol class="breadcrumb text-right">
      <li><a href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg"></i></a></li>
      <li><a href="tablelist.jsp?JNDIDSN=<%=JNDIDSN %>&WebAppName=<%=WebAppName %>">Table List : <strong><%=Database %></strong></a></li>
      <li class="active">JSP Page</li>
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

<form class="form-horizontal" action="<%=appPath %>/getjsp" method="post"  id="beanform" name="beanform" target="_blank" >
<input type="hidden" name="DriverName" value="<%=DriverName %>" />
<input type="hidden" name="HasDate" value="NO" />
<input type="hidden" name="HasTime" value="NO" />
<input type="hidden" name="HasTimestamp" value="NO" />
<input type="hidden" name="JNDIDSN" value="<%=JNDIDSN %>" />
<input type="hidden" name="TableName" value="<%=TableName %>" />

  <div class="form-group">
    <label for="BeanName" class="col-sm-4 control-label">Bean Name</label>
    <div class="col-sm-8">
      <input type="text" name="BeanName" id="BeanName" value="<%=BeanName %>" class="form-control" >
    </div>
  </div>
  <div class="form-group">
    <label for="BeanClass" class="col-sm-4 control-label">Bean Class</label>
    <div class="col-sm-8">
		  <input type="text" name="BeanClass" class="form-control" id="BeanClass" value="<%=BeanClass %>" >
    </div>
  </div>
  <div class="form-group">
    <label for="BeanPackage" class="col-sm-4 control-label">Bean Package</label>
    <div class="col-sm-8">
			<input type="text" name="BeanPackage" class="form-control" value="<%=BeanPackage %>" id="BeanPackage" >
    </div>
  </div>
  <div class="form-group">
    <label for="WebApp" class="col-sm-4 control-label">WebApp Package</label>
    <div class="col-sm-8">
			<input type="text" class="form-control" name="WebApp"  id="WebApp" value="<%=WebApp %>" >
    </div>
  </div>
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
    <label for="PageTitle" class="col-sm-4 control-label">Page Title</label>
    <div class="col-sm-8">
			<input type="text" class="form-control" name="PageTitle"  id="PageTitle" value="Manage <%=CTableName %>" >
    </div>
  </div>
  <div class="form-group">
    <label for="OutputFileName" class="col-sm-4 control-label">Output File Name</label>
    <div class="col-sm-8">
			<input type="text" class="form-control" name="OutputFileName"  id="c" value="manage<%=TableName %>.jsp" >
    </div>
  </div>	
  <div class="form-group">
    <label class="col-sm-4 control-label">Check Boxe ?</label>
    <div class="col-sm-8">
			<span class="checkbox checkbox-primary">
      <input type="checkbox" name="CheckBox" id="CheckBox" value="TRUE" checked="checked" />
      <label for="CheckBox">Check boxes in Table</label>
      </span>
    </div>
  </div>
  <div class="form-group">
    <label class="col-sm-4 control-label">Datatables ?</label>
    <div class="col-sm-8">
			<span class="checkbox checkbox-primary">
      <input type="checkbox" name="DatatablesJSCSS" id="DatatablesJSCSS" />
      <label for="DatatablesJSCSS">Include Datatables</label>
      </span>
    </div>
  </div>	
<%
for(int n = 1 ; n <= count ; n++ )
{	
	int ColSQLType = rsmd.getColumnType(n);
	if(ColSQLType==java.sql.Types.TIMESTAMP)bTimestampSupport=true;
}
%>	
<% if(bTimestampSupport){ %>	
  <div class="form-group">
    <label class="col-sm-4 control-label">DateTime ?</label>
    <div class="col-sm-8">
			<span class="checkbox checkbox-primary">
      <input type="checkbox" name="DateTimeJSCSS" id="DateTimeJSCSS"/>
      <label for="DateTimeJSCSS">DateTime JS/CSS ?</label>
      </span>
    </div>
  </div>
<% } %>	
  <div class="form-group">
    <label class="col-sm-4 control-label">SMS ?</label>
    <div class="col-sm-8">
			<span class="checkbox checkbox-primary">
      <input type="checkbox" name="ConfigSMS" id="ConfigSMS" />
      <label for="ConfigSMS">SMS Patch ?</label>
      </span>
    </div>
  </div>	

  <div class="form-group">
    <label for="EntityName" class="col-sm-4 control-label">Entity Name</label>
    <div class="col-sm-8">
			<input type="text" class="form-control" name="EntityName"  id="EntityName" value="<%=CTableName %>" >
    </div>
  </div>

	
	</div>
  <div class="col-md-7">
<div class="well well-sm">	
<div class="row">
   <div class="col-md-8">
	<div class="row"> 
  <div class="form-group col-md-12">
    <label for="OuputPage" class="col-sm-4 control-label">Output Page Type</label>
    <div class="col-sm-8">
<select class="form-control" name="OuputPage" id="OuputPage" ><!--   -->
    <option value="AllInOne" selected="selected">All In One-SMS Path Available</option>
		<option value="Listpage" >Listpage</option>
		<option value="Listpage-P" >Listpage-P</option>
		<option value="S-R-D-P" >S-R-D-P</option>
		<option value="S-R-D" >S-R-D</option>
		<option value="S-R-D-QryObj" >S-R-D-QryObj</option>
		<option value="R-D" >R-D</option>
		<option value="R-D-P" >R-D-P</option>
		<option value="R-D-POPUP" >R-D-POPUP</option>
		<option value="DataMatrix" >Data Matrix</option>
<!-- 
    <option value="SearchMultipleOld">Old Style - Search ( Multiple Paginated )</option>
    <option value="SearchSingle">Search Page (Single Page)</option>
		<option value="SearchSingleOld">Old  Style - Search  (Single Page )</option>
    <option value="List" >List Page</option>
		<option value="ListOld" >Old Style - List Page</option>
    <option value="SearchPopup" >Popup Search Page</option>  
    <option value="OnlyTableData" >Only Table Data Page</option>  
    <option value="PaginatedTableData" >Paginated Table Data Page</option>
    <option value="SelectionActivity" >Selection Activity Page</option>   
    <option value="QuickFieldUpdate" >Quick Field Update Page</option>  
    <option value="SelectionDataUpdate" >Selection Data Update Page</option> 
 -->		
       
</select>
    </div>
  </div>
	
  <div class="form-group  col-md-12">
    <label for="LoginFolderName" class="col-sm-4 control-label">Login Folder</label>
    <div class="col-sm-8">
			<span class="checkbox checkbox-primary">
      <input type="checkbox" name="AddCMSSetting" id="AddCMSSetting" />
      <label for="AddCMSSetting"><input type="text" class="form-control" name="LoginFolderName"  id="LoginFolderName" value="admin"></label>
      </span>

               
    </div>
  </div>
</div>

	 </div>
   <div class="col-md-3">
  <div class="form-group">
    <div class="col-sm-offset-4 col-sm-10">
			<button type="submit" class="btn btn-primary btn-lg" name="jsp" >Get JSP Page</button>
    </div>
  </div>

	 </div>
	 
</div> 
</div>

<div class="row">
   <div class="col-md-12">
	 
<ul class="nav nav-tabs nav-tabs-drop"><!--  nav-tabs-drop nav-justified  -->
    <li class=""><a href="#SelectFieldforAction" data-toggle="tab"><i class="fa fa-tasks fa-lg text-primary"></i>&nbsp;&nbsp;Fields</a></li>
		<li class="active"><a href="#FormValidate" data-toggle="tab"><i class="fa fa-lock fa-lg text-primary"></i>&nbsp;&nbsp;Form validation</a></li>
		<li class=""><a href="#FieldLabels" data-toggle="tab"><i class="fa fa-lock fa-lg text-primary"></i>&nbsp;&nbsp;Labels</a></li>
		<li class=""><a href="#FormValidation" data-toggle="tab"><i class="fa fa-lock fa-lg text-primary"></i>&nbsp;&nbsp;Input Control</a></li>
</ul>

<div class="tab-content tab-content-drop">

<div id="SelectFieldforAction" class="tab-pane">

      <div class="panel panel-default">
        <!-- Default panel contents -->
        <div class="panel-heading"><i class="fa fa-tasks fa-lg text-primary"></i>&nbsp;&nbsp;Fields for Action</div>
        <div class="panel-body">
            <span class="checkbox checkbox-inline checkbox-primary">
                <input type="checkbox" name="multipart_form_upload" id="multipart_form_upload" >
                <label for="multipart_form_upload">Multipart Form Upload ?</label>
            </span>
        </div>
				
        <div class="table-responsive">
        <table class="table table-bordered table-striped Rslt-Act-tbl" id="empleave_type_Result_tbl">
        <thead>
        <tr>
				  <th></th>
					<th>Field</th>
          <th>
  				<span class="checkbox checkbox-inline checkbox-primary">
              <input type="checkbox" name="Search_checkall" id="Search_checkall" >
              <label for="Search_checkall"><b>Search</b></label>
          </span></th>
          <th>
  				<span class="checkbox checkbox-inline checkbox-primary">
              <input type="checkbox" name="Result_checkall" id="Result_checkall" >
              <label for="Result_checkall"><b>Result</b></label>
          </span></th>
					<th>
  				<span class="checkbox checkbox-inline checkbox-primary">
              <input type="checkbox" name="Foreign_checkall" id="Foreign_checkall" >
              <label for="Foreign_checkall"><b>Foreign Key</b></label>
          </span></th>
					<th>
  				<span class="checkbox checkbox-inline checkbox-primary">
              <input type="checkbox" name="Duplicate_checkall" id="Duplicate_checkall" >
              <label for="Duplicate_checkall"><b>Dupicate</b></label>
          </span></th>
        </tr>
        </thead>
        <tbody>
        <tr>

      <%
      for(int n = 1 ; n <= count ; n++ )
      {	
      	 String ColName = rsmd.getColumnName(n) ;
      	 String ColType = rsmd.getColumnTypeName(n);
      	 int ColSQLType = rsmd.getColumnType(n);
      	 if( rsmd.isAutoIncrement(n))PK=ColName; ;
      	 if(ColSQLType==java.sql.Types.DATE) bDateSupport=true;
				 if(ColSQLType==java.sql.Types.TIME) bTimeSupport=true;
      	 if(ColSQLType==java.sql.Types.TIMESTAMP)bTimestampSupport=true;
      %>
			<td><%=n %></td>
			<td><%=ColName %><% if( ColName.equals(PK)) { %>&nbsp;&nbsp;<span class="label label-default">A</span><% } %></td>
      <td>
      <span class="checkbox checkbox-inline checkbox-primary">
          <input type="checkbox" name="SearchFields" value="<%=ColName %>" id="SEARCH_FIELD_COL_<%=n %>" <% if( rsmd.isAutoIncrement(n)){ %>class="auto_SEARCH_chkbox"<% }else{ %>class="SEARCH_chkbox"<% } %>>
          <label for="SEARCH_FIELD_COL_<%=n %>">&nbsp;</label>
      </span>
      </td> 
      <td>
      <span class="checkbox checkbox-inline checkbox-primary">
          <input type="checkbox" name="ShowFields" value="<%=ColName %>" id="SHOW_FIELD_COL_<%=n %>" <% if( rsmd.isAutoIncrement(n)){ %>class="auto_Result_chkbox"<% }else{ %>class="Result_chkbox"<% } %>>
          <label for="SHOW_FIELD_COL_<%=n %>">&nbsp;</label>
      </span>
      </td> 
      <td>
      <span class="checkbox checkbox-inline checkbox-primary">
          <input type="checkbox" name="ForeignFields" value="<%=ColName %>" id="FOREIGN_FIELD_COL_<%=n %>" <% if( rsmd.isAutoIncrement(n)){ %>class="auto_FOREIGN_chkbox"<% }else{ %>class="FOREIGN_chkbox"<% } %>>
          <label for="FOREIGN_FIELD_COL_<%=n %>">&nbsp;</label>
      </span>
      </td> 
      <td>
      <span class="checkbox checkbox-inline checkbox-primary">
          <input type="checkbox" name="DuplicateFields" value="<%=n %>" id="DUPLICATE_FIELD_COL_<%=n %>" <% if( rsmd.isAutoIncrement(n)){ %>class="auto_DUPLICATE_chkbox"<% }else{ %>class="DUPLICATE_chkbox"<% } %>>
          <label for="DUPLICATE_FIELD_COL_<%=n %>">&nbsp;</label>
      </span>
      </td> 
      <% if(n%1 ==0 ) out.print("</tr><tr>");  %> 
      <%	  
      }// end for(int n = 1 ; n <= count ; n++ ) 
      %>
					
        </tr>
        </tbody>
        </table>
        </div>

			</div>

</div>

</form>	

<div id="FormValidate" class="tab-pane active">

     <iframe src="<%=appPath %>/user/forms/formvalidate.jsp?JNDIDSN=<%=JNDIDSN %>&TableName=<%=TableName %>" frameborder="0" width="100%" scrolling="no" class="iFrame_Resize" ></iframe>		

</div>

<div id="FieldLabels" class="tab-pane">

     <iframe src="<%=appPath %>/user/forms/fieldlabels.jsp?JNDIDSN=<%=JNDIDSN %>&TableName=<%=TableName %>" frameborder="0" width="100%" scrolling="no" class="iFrame_Resize" ></iframe>		

</div>		
		

<div id="FormValidation" class="tab-pane">

     <iframe src="<%=appPath %>/user/forms/fieldinputs.jsp?JNDIDSN=<%=JNDIDSN %>&TableName=<%=TableName %>" frameborder="0" width="100%" scrolling="no" class="iFrame_Resize" ></iframe>		

</div>		
		
</div>
	
	 </div>
	 
</div> 
	


<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />
<script type="text/javascript">
<!--

var obIDField = document.getElementById("IDField");
obIDField.value="<%=PK %>";
<% if(!"?".equals(PK)){ %> 
var obIsAuto = document.getElementById("IsAuto");
obIsAuto.checked=true;
<% } %>


// OLD code document.forms['beanform'].elements['WebApp'].value ="com."+"<%=Database %>" ;
// -->
<% if(bDateSupport)
 { %>
document.forms['beanform'].elements['HasDate'].value ="YES" ;
<%  } 
if(bTimeSupport)
 { %>
document.forms['beanform'].elements['HasTime'].value ="YES" ;
<%  }
if(bTimestampSupport)
 { %>
document.forms['beanform'].elements['HasTimestamp'].value ="YES" ;
<%  } %>

$("#Result_checkall").click(function () {
   if ($("#Result_checkall").is(':checked')) {
        $(".Result_chkbox").each(function () {
          $(this).prop("checked", true);
      });
   } else {
       $(".Result_chkbox").each(function () {
        $(this).prop("checked", false);
      });
   }
});
$("#Search_checkall").click(function () {
   if ($("#Search_checkall").is(':checked')) {
        $(".SEARCH_chkbox").each(function () {
          $(this).prop("checked", true);
      });
   } else {
       $(".SEARCH_chkbox").each(function () {
        $(this).prop("checked", false);
      });
   }
});
$("#Foreign_checkall").click(function () {
   if ($("#Foreign_checkall").is(':checked')) {
        $(".FOREIGN_chkbox").each(function () {
          $(this).prop("checked", true);
      });
   } else {
       $(".FOREIGN_chkbox").each(function () {
        $(this).prop("checked", false);
      });
   }
});	 
$("#Duplicate_checkall").click(function () {
   if ($("#Duplicate_checkall").is(':checked')) {
        $(".DUPLICATE_chkbox").each(function () {
          $(this).prop("checked", true);
      });
   } else {
       $(".DUPLICATE_chkbox").each(function () {
        $(this).prop("checked", false);
      });
   }
});


</script>

	
	
	</div>
</div>				

</div> <!-- /container -->

<% 
rslt.close();
stmt.close();
}	 
finally
{
conn.close();
} 

%>

<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/tabdrop-js.jsp" flush="true" />
<!-- iframeResizer.min.js on host page -->
<jsp:include page="/assets/include-page/js/iframe-resizer/iframeResizer-js.jsp" flush="true" />

<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>
