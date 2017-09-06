<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="javax.servlet.*"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="java.sql.*, nu.xom.*" %>
<%@ page import="com.webapp.jsp.*, com.webapp.utils.*, com.webapp.resin.*" %>
<%@ page import="com.webapp.poi.*, org.apache.poi.ss.usermodel.*, org.apache.poi.hssf.usermodel.*, org.apache.poi.xssf.usermodel.*" %>

<%!
String ChekRegExp =  "[-\\s\\.\\^\\$\\*\\+\\?\\\\\\(\\)\\[\\{\\|\\}\\]~`!@#%&\\=:;\"'<>,/]" ;
String ReplaceInvalidChar(String src)
{
  if(src ==null || src.length()==0) return "";
	return src.replaceAll(ChekRegExp,"_") ;
}
%>

<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

String Action = RequestHelper.paramValue(request, "Action", "Form");

%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Excel to Mysql JSP Page</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
</head>
<body>   
<jsp:include page="/user/assets-user/include-page/header-user.jsp" flush="true" />	

<div class="container-fluid">
<div class="row page-header11">
  <div class="col-md-6 col-xs-12">
    <h4 class="page-title11"><i class="fa fa-plug text-primary"></i>&nbsp;&nbsp;<span class="text-muted">Generate Excel to Mysql JSP Page</span></h4>
  </div>
  <div class="col-md-6 col-xs-12">
    <!--  page-header-actions  -->
    <ol class="breadcrumb text-right">
      <li><a href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg"></i></a></li>
      <li class="active">Excel to Mysql JSP Page</li>
    </ol>
  </div>
</div>
<hr class="pageheaderHR" />	
<%
if("Form".equalsIgnoreCase(Action))
{
%>

<div class="row">
  <div class="col-md-5">
      <div class="panel panel-primary">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-upload fa-lg"></i>&nbsp;&nbsp;Upload Excel File</h3>
        </div>
        <div class="panel-body">

<form action="<%=thisFile %>" id="excel_upload_form" method="post" class="form-horizontal" enctype="multipart/form-data">				
  <div class="form-group">
    <label for="ExcelFile" class="col-sm-3 control-label">Excel File</label>
    <div class="col-sm-9">
      <input type="file" enctype="multipart/form-data" name="ExcelFile" id="ExcelFile" class="form-control">
    </div>
  </div>
  <div class="form-group">
    <label for="WebAppPkg" class="col-sm-3 control-label">WebApp Pkg.</label>
    <div class="col-sm-9">
      <input type="text" name="WebAppPkg" value="com.?" id="WebAppPkg" class="form-control">
    </div>
  </div>
  <div class="form-group">
    <label for="JNDIDSN_DROP_LIST" class="col-sm-3 control-label">JNDI-DSN</label>
    <div class="col-sm-9">
            <jsp:include page="/user/droplist/get-jndi-dsn-list.jsp" flush="true">
                <jsp:param name="ElementName" value="JNDIDSN" />
								<jsp:param name="ElementID" value="JNDIDSN_DROP_LIST" />
								<jsp:param name="ElementClass" value="form-control selectpicker" />
            </jsp:include>
    </div>
  </div>
  <div class="form-group">
    <label for="TABLE_DROP_LIST" class="col-sm-3 control-label">Table List</label>
    <div class="col-sm-9">
      <div id="TBL-LIST"><input type="text" class="form-control" placeholder="Select JNDI DSN First" disabled></div>
    </div>
  </div>
  <div class="form-group">
    <div class="col-sm-offset-3 col-sm-9">
      <button type="submit" class="btn btn-primary"><i class="fa fa-upload"></i>&nbsp;&nbsp;Upload</button>
    </div>
  </div>
</form>		
     </div>		
     
      </div>			
	</div>
				


<% 
String JNDIDSN = request.getParameter("JNDIDSN") ;
if(JNDIDSN != null)
{ 
%>
  <div class="col-md-7">
      <div class="panel panel-primary">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-cogs fa-lg"></i>&nbsp;&nbsp;Generate JSP Page</h3>
        </div>
        <div class="panel-body">

<%
		//String JNDIDSN = request.getParameter("JNDIDSN") ;
    String TableName = request.getParameter("TableName") ;
		String WebAppPkg = request.getParameter("WebAppPkg");;

// Check file existance or redirect
		ResinFileUpload RsUpload = new ResinFileUpload() ;
		try
		{
       RsUpload.load( application,request, "ExcelFile" ) ;
		}
		catch(Exception ex)
		{
		   %><jsp:forward page="done.jsp" /><%
		}	 
    String FileName = RsUpload.getFileName();
    String FileExt = RsUpload.getFileExt();
    String MimeType = RsUpload.getMimeType();
		String UploadedFile  = application.getRealPath(JSPUtils.jspPageFolder( request )+"/upload/"+FileName);

		try
		{
         if( !POIHelper.checkExcelMIME(RsUpload) ) throw new Exception("The uploaded file ( "+FileName+" ) is not a valid MS Excel File.");
	     
			    Workbook wb = WorkbookFactory.create(  RsUpload.getInputStream());
          Sheet sheet = wb.getSheetAt(0);
			    int nLastIndx = sheet.getLastRowNum();
			 
			 // Check for header row
			    Row hdr_row = sheet.getRow(0);
					int nColCount = hdr_row.getLastCellNum();
					ArrayList<String> col_list = new  ArrayList<String>();
					for(int col=0; col < nColCount ; col++)
					{
					    Cell cell = hdr_row.getCell(col, Row.CREATE_NULL_AS_BLANK) ;
					    col_list.add( POIHelper.getStringFromCell(cell) );
					}
          session.setAttribute("EXCEL-FIELD-LIST" ,col_list);
          %>

<form action="generate-jsp-page.jsp" method="post"><!--  target="_blank" -->
<input type="hidden" name="UploadedFile" value="<%=UploadedFile %>" />
<input type="hidden" name="WebAppPkg" value="<%=WebAppPkg %>" />
<input type="hidden" name="JNDIDSN" value="<%=JNDIDSN %>" />
<input type="hidden" name="TableName" value="<%=TableName %>" />

  <div class="row">
    <div class="col-md-6">
      <big><i class="fa fa-table fa-lg text-primary"></i>&nbsp;&nbsp;<span class="text-info">Table : </span><span class="text-muted"><%=TableName %></span></big>
    </div>
    <div class="col-md-6">
      <big class="pull-right"><i class="fa fa-send-o fa-lg text-primary"></i>&nbsp;&nbsp;<span class="text-info">JNDI: </span><span class="text-muted"><%=JNDIDSN %></span></big>
    </div>
  </div>
<div class="row">
  <div class="col-md-12">
	&nbsp;
  </div>			
</div>
	
	<div class="well well-sm"><b>Uploaded File</b> : <%=FileName %></div>

<div class="row">
  <div class="col-md-12">
	<button type="submit" class="btn btn-primary btn-lg btn-block"><i class="fa fa-download"></i>&nbsp;&nbsp;Get It!</button>
  </div>			
</div>
<div class="row">
  <div class="col-md-12">
	&nbsp;
  </div>			
</div>
<div class="table-responsive">	
<table class="table table-striped table-bordered table-condensed">
<tr>
<th valign="top">#</th>
<th valign="top">Excel Column</th>
<th valign="top">Table Field</th>
<th valign="top">
<span class="checkbox checkbox-inline checkbox-primary">
<input type="checkbox" name="UpdateOnIDField" id="UpdateOnIDField" value="TRUE" />
<label for="UpdateOnIDField">Update On ID Field</label>
</span>
</th>
</tr>					
<%
//if(col_list==null || col_list.size()==0) session.getAttribute("EXCEL-FIELD-LIST"); 
Iterator<String> it = col_list.iterator() ; 
int i=0; 
while(it.hasNext()) 
{   
String ExCol = it.next(); 
ExCol =  ExCol.trim();
//String ElmFld = ExCol+".FieldName";
String ChkCol = ReplaceInvalidChar(ExCol);
%>
<tr>
<td valign="top"><%= ( i+1) %></td>
<td valign="top"><%= ExCol %></td>
<td valign="top">
        <jsp:include page="/user/droplist/fields-for-table.jsp" flush="true">
            <jsp:param name="ElementName" value="<%=ChkCol %>" />
            <jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" />
            <jsp:param name="TableName" value="<%=TableName %>" />
            <jsp:param name="Select" value="<%=ChkCol  %>" />
						<jsp:param name="ElementID" value="JNDIDSN_DROP_LIST" />
						<jsp:param name="ElementClass" value="form-control selectpicker" />
				 </jsp:include>		
</td>
<td>
<span class="radio radio-primary radio-inline">
<input type="radio" name="IDField" id="<%=i %>:<%=ChkCol %>" value="<%=i %>:<%=ChkCol %>" /> 
<label for="<%=i %>:<%=ChkCol %>">&nbsp;</label>
</span>

</td>
</tr>									
<% 
	i++;
} 
%>
</table>
</div>
</form>
					
<%
}
  catch(Exception ex)
{
%>

<div style="padding:1em;">
    <span class="error">File Upload Error:</span><br>
		<%=ExceptionHelper.showException(ex, "exception_div") %>
</div><!-- end error block padding div -->

<%
} 
RsUpload.saveToFolder(JSPUtils.jspPageFolder( request )+"/upload", false);
	 
// Delete upload file when done
// ResinFileUpload.deleteUploadFile(request, "ExcelFile"); 
%>
        </div>
      </div>			
	</div>


<%
} 
%>
</div>
<%
}
else
{
%>
	<span class="error"><big>Request parameter error</big></span>
<%
}
%>

</div> <!-- /container -->
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />
<jsp:include page="/scripts/jvalidate/jvalidate.jsp" flush="true" />
<script type="text/javascript">
<!--
$(document).ready(function(){
// override jquery validate plugin defaults
$.validator.setDefaults({
    highlight: function(element) {
        $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
    },
    unhighlight: function(element) {
        $(element).closest('.form-group').removeClass('has-error').addClass('has-success');;
    },
    errorElement: 'span',
    errorClass: 'help-block',
    errorPlacement: function(error, element) {
        if(element.parent('.input-group').length || element.prop('type') === 'checkbox' || element.prop('type') === 'radio') {
            error.insertAfter(element.parent());
        } else if (element.parent('.radio-inline').length || element.parent('.checkbox-inline').length) {
            error.insertAfter(element.parent().parent());
        }else {
            error.insertAfter(element);
        }
    }
});

	$("#excel_upload_form").validate({
	    rules: 
      {
          ExcelFile:"required",
					JNDIDSN:"required",
					TableName:"required"
      } 
	});

	$("#JNDIDSN_DROP_LIST").change(function(){
	  var val = $(this).val();
		$("#TBL-LIST").load("<%=appPath %>/user/droplist/tables-for-jndi.jsp?JNDIDSN="+val);
	}) ;
});
// -->
</script>

<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>
