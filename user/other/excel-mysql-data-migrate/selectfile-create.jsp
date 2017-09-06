<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.io.*,java.text.*, java.sql.*, com.webapp.utils.*, com.webapp.resin.*, com.webapp.jsp.*, com.webapp.poi.*, org.apache.poi.ss.usermodel.*, org.apache.poi.hssf.usermodel.*, org.apache.poi.xssf.usermodel.* " %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
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

String Action = request.getParameter("Action") ;
if(Action ==null ) Action = "Form" ; //   Other action Update

 String JNDIDSN = request.getParameter("JNDIDSN") ;

%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Create Table And Insert Data From Excel</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
</head>
<body>   
<jsp:include page="/user/assets-user/include-page/header-user.jsp" flush="true" />	

<div class="container-fluid">
<div class="row page-header11">
  <div class="col-md-6 col-xs-12">
    <h4 class="page-title11"><i class="fa fa-plug text-primary"></i>&nbsp;&nbsp;<span class="text-muted">Create Table & Insert Data</span></h4>
  </div>
  <div class="col-md-6 col-xs-12">
    <!--  page-header-actions  -->
    <ol class="breadcrumb text-right">
      <li><a href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg"></i></a></li>
      <li class="active">Create T & Insert Data</li>
    </ol>
  </div>
</div>
<hr class="pageheaderHR" />

<div class="row">

<% 
if("Form".equalsIgnoreCase(Action))
{
// Show update form
%>
  <div class="col-md-4">
      <div class="panel panel-primary">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-upload fa-lg"></i>&nbsp;&nbsp;Upload Excel File</h3>
        </div>
        <div class="panel-body">

				
<form  action="<%=thisFile %>" method="post" id="file_upload_form" enctype="multipart/form-data" class="form-horizontal">
  <div class="form-group">
    <label for="ExcelFile" class="col-sm-3 control-label">Excel File</label>
    <div class="col-sm-9">
      <input type="file" enctype="multipart/form-data" name="ExcelFile" class="form-control" id="ExcelFile">
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
    <div class="col-sm-offset-3 col-sm-9">
      <button type="submit" class="btn btn-primary"><i class="fa fa-upload"></i>&nbsp;&nbsp;Upload</button>
    </div>
  </div>
</form>

     </div>		
  </div>			
</div>
<% 

if(JNDIDSN != null)
{ 
%>

  <div class="col-md-8">
      <div class="panel panel-primary">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-cogs fa-lg"></i>&nbsp;&nbsp;Manage & Inport Data</h3>
        </div>
        <div class="panel-body">

<%
	 ResinFileUpload RsUpload = new ResinFileUpload() ;
   RsUpload.load( application,request, "ExcelFile" ) ;

	
   String FileName = RsUpload.getFileName();
   String FileExt = RsUpload.getFileExt();
   String MimeType = RsUpload.getMimeType();
	 int nSize = RsUpload.getFileSize();
	 String ShowSize = NumberHelper.showByteSize((long)nSize);
	 
	 String UPLOAD_DIR  = JSPUtils.jspPageFolder(request)+"/upload" ; 
	 boolean bSaved = RsUpload.saveToFolder(UPLOAD_DIR, false); 
   String SavedFilePath = UPLOAD_DIR+"/"+FileName ;
	 String excel_file_path = application.getRealPath(SavedFilePath);
	     
	 
     try
	   {
	        if( !POIHelper.checkExcelMIME(RsUpload) ) throw new Exception("The uploaded file ( "+FileName+" "+ShowSize+" ) is not a valid MS Excel File.");
	     
			    Workbook wb = WorkbookFactory.create( new FileInputStream(excel_file_path));
          Sheet sheet = wb.getSheetAt(0);
			    int nLastIndx = sheet.getLastRowNum();
			    Row hdr_row = sheet.getRow(0);
			    int nHeaderCount = hdr_row.getLastCellNum() ;
				
				
       
	   %>
<div class="well well-sm row-fluid-text">

  <div class="row">
    <div class="col-md-6">
      <big><i class="fa fa-table fa-lg text-primary"></i>&nbsp;&nbsp;<span class="text-info">No. of header colums : </span><span class="text-muted"><%=nHeaderCount %></span></big>
    </div>
    <div class="col-md-6">
      <big class="pull-right"><i class="fa fa-send-o fa-lg text-primary"></i>&nbsp;&nbsp;<span class="text-info">JNDI: </span><span class="text-muted"><%=JNDIDSN %></span></big>
    </div>
  </div>

</div>		
				 <form action="createtable.jsp" id="sql_form" method="post" onsubmit="return CheckForm();"  class="form-horizontal">
               <input type="hidden" name="ExcelFilePath" value="<%=excel_file_path %>" />
							 <input type="hidden" name="HeaderCount" value="<%=nHeaderCount   %>" />
							 <input type="hidden" name="JNDIDSN" value="<%=JNDIDSN   %>" />
               <div class="table-responsive">
							 <table class="table table-striped table-bordered table-condensed">
							 
							 <thead>
			        	 
							 <tr>
							       <th valign="top" >No</th>
							       <th valign="top" >Mandatory ? | Column Name</th>
							      
							       <th valign="top" >MySQL Type</th>
							       <th valign="top" >Size</th>
							       <th valign="top" >Scale</th>
							       <th valign="top" >PK ?</th>

							 </tr>
					     	 
							 </thead>
                <tbody>
								<tr>
								<td>
                <span class="checkbox checkbox-inline checkbox-primary">
                <input type="checkbox" name="AutoInc" id="AutoInc" onclick="CheckPkVal()" />
                <label for="AutoInc">&nbsp;</label>
                </span>
								</td>
								<td><input type="text" name="AutoColName" value="ID" class="form-control" /></td>
								<td colspan="5">[ Auto Inc ? ] Check this row to create auto increment column.
								</tr>
								 <%  
							 for (int i=0; i< nHeaderCount ; i++)
							 {
							   //
								 String col = POIHelper.getStringFromCell( hdr_row.getCell(i));
								 col = col.trim();
								 col = ReplaceInvalidChar(col);
								 
								 /*
								 col = col.replace(" ", "_" );
								 col = col.replace(".", "_");
								 col = col.replace(",", "_");
								 col = col.replace(":", "_");
								 col = col.replace(";", "_");
								 
								 col = col.replace("-", "_");
								 col = col.replace("+", "_");
								 col = col.replace("=", "_");
								 col = col.replace("'", "_");
								 col = col.replace("\"", "_");
								 col = col.replace("`", "_");	
								 col = col.replace("<", "_");
								 col = col.replace(">", "_");		
								 col = col.replace("\\", "_");		
								 col = col.replace("/", "_");		
								 col = col.replace("%", "_");	
								 col = col.replace("!", "_");	
								 col = col.replace("@", "_");
								 col = col.replace("#", "_");	
								 col = col.replace("$", "_");
								 col = col.replace("^", "_");	
								 col = col.replace("&", "_");	
								 col = col.replace("*", "_");	
								 col = col.replace("(", "_");	
								 col = col.replace(")", "_");	
								 col = col.replace("?", "_");	
								 col = col.replace("~", "_");	
								 col = col.replace("[", "_");	
								 col = col.replace("]", "_");	
								 col = col.replace("{", "_");	
								 col = col.replace("}", "_");	
								 */
								 
								 				 
								 
							 %>	
							  
							 		
								<tr>
                    <td valign="top" ><%=i+1 %></td>
							      <td valign="top" >
                      <span class="checkbox checkbox-inline checkbox-primary">
                      <input type="checkbox" name="CHK<%=i %>" id="CHK<%=i %>" />
                      <label for="CHK<%=i %>"><input type="text" name="ColumnName" class="ColumnName form-control" value="<%=col %>" /></label>
                      </span>
										</td>
							       
							      <td valign="top" >
										
										<select name="SQLType" class="form-control selectpicker"  >
										 
										<option value="<%=java.sql.Types.SMALLINT %>" >Small Integer</option>
										<option value="<%=java.sql.Types.INTEGER %>" >Integer</option>
										<option value="<%=java.sql.Types.BIGINT %>" >Big Integer</option>
										<option value="<%=java.sql.Types.DOUBLE %>" >Double</option>
										<option value="<%=java.sql.Types.NUMERIC %>" >Numeric</option>
										<option value="<%=java.sql.Types.DECIMAL %>" >Decimal</option>
										<option value="<%=java.sql.Types.CHAR %>" >Character</option>
										<option value="<%=java.sql.Types.VARCHAR %>" selected="selected"  >Var Character</option>
										<option value="<%=java.sql.Types.DATE %>" >Date</option>
										<option value="<%=java.sql.Types.TIME %>" >Time</option>
                    <option value="<%=java.sql.Types.TIMESTAMP %>" >Date-Time</option>
										
										<option value="<%=java.sql.Types.LONGVARCHAR %>" >Text (CLOB)</option>
										<option value="<%=java.sql.Types.LONGVARBINARY %>" >Binary (BLOB)</option>
										

										
										</select>
										
										
										</td>
							      <td valign="top" ><input type="text" name="Precision" value="50" size="6" class="form-control" /></td>
							      <td valign="top" ><input type="text" name="Scale" value="0"  size="6"  class="form-control"/></td>
							      <td valign="top" align="center" >
                    <span class="radio radio-primary radio-inline">
                    <input type="radio" name="PriKey" id="<%=(i+1) %>" value="<%=(i+1) %>"/> 
                    <label for="<%=(i+1) %>">&nbsp;</label>
                    </span>
										</td>
							
								</tr>
								<%  
							  } // end - for (int i=0; i< hHeaderCount ; i++)
							 
							   %>	
								</tbody>
                </table>
								</div>
								
    <div class="form-group">
        <label class="col-xs-1 control-label">Table</label>

        <div class="col-xs-4">
            <input type="text" name="TableName" id="TableName" class="form-control"  />
        </div>

        <div class="col-xs-4">
            <jsp:include page="/user/droplist/tables-for-jndi.jsp" flush="true">
                <jsp:param name="ElementName" value="TableList" />
								<jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" />
								<jsp:param name="ElementClass" value="form-control selectpicker" />
            </jsp:include>
        </div>
        <div class="col-xs-3">
                  <span class="checkbox checkbox-inline checkbox-primary">
                  <input type="checkbox" name="DropTable" id="DropTable" value="YES" />
                  <label for="DropTable">Drop existing table</label>
                  </span>
        </div>
    </div>
<p id="FLD_LST" style="display:none">&nbsp;</p>
    <div class="form-group">
        <label class="col-xs-5 control-label">Prevent duplicate records on field number</label>

        <div class="col-xs-4">
            <input type="text"  name="DuplicateField" id="DuplicateField" class="form-control"/>
        </div>

        <div class="col-xs-2">
               <!-- [ <a href="javascript:void(0)" onclick="{  $( '#DuplicateField' ).val(''); }" >clear</a>] -->        
				</div>
    </div>
<div class="well well-sm">
<% 
for( int i=0; i< nHeaderCount ; i++)
{
 if(i>0) out.print(", " );
%>
[<a href="javascript:void(0)" onclick="ChekDupField(<%=i %>)">  <%= i+1 %></a> ]  
<% 
} 
%>
</div>

  <div class="row">
    <div class="col-md-6">
      <button type="submit" class="btn btn-primary btn-lg btn-block">Ok, Create Table</button>
    </div>
    <div class="col-md-6">
      <a href="<%=thisFile %>?Action=Form" class="btn btn-primary btn-lg btn-block">Try another upload...</a>
    </div>
  </div>

</form>
<%
}
catch(Exception ex)
{
%>
	<div style="padding:1em;">
     <p><span class="error">File Upload Error:</span> <span class="dataitem"> <%=ex.getMessage() %></span> <a href="javascript:void(0)" onclick="{ $('#stack_div').slideToggle();}" > [ show / hide ] </a> details...</p>
    
		 <div style="display:none;" id="stack_div"><!-- stack trace div -->
	   <b>Exception stack trace:</b><br />
       <%  
         ByteArrayOutputStream bout = new ByteArrayOutputStream();
         ex.printStackTrace(new PrintStream(bout));
         out.println(bout.toString().replace("\r\n", "\r\n<br />"));
       %>
    </div><!-- End - stack trace div -->
    
 </div><!-- end padding div -->
<%
}
// End try
ResinFileUpload.deleteUploadFile(request, "ExcelFile");
%>

     </div>		
  </div>			
</div>
<% } %>	
<%
}
else
{
// Action parameter error
%>
<span class="error">Error:</span> Invalid request parameter:<b>Action</b> in page invocation.<br/>
<%
}
%>
</div>

</div> <!-- /container -->
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />
<jsp:include page="/scripts/jvalidate/jvalidate.jsp" flush="true" />
<script type="text/javascript">
<!--
function ChekDupField(fid)
{
    var obj= $(".ColumnName").val(function(index, value){
		if(index == fid)   $( '#DuplicateField' ).val(''+(index+1));
		return value ;
		});	 
}
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
  
$("#file_upload_form").validate({
	    rules: 
      {
          ExcelFile:"required",
					JNDIDSN:"required"
      } 
});

$("#TABLE_DROP_LIST").change(function(){
 
   var listval = $("#TABLE_DROP_LIST").val();
	 $("#TableName").val(listval);
	 $("#FLD_LST").show();
	 $("#FLD_LST").load("ajaxfieldlist.jsp?JNDIDSN=<%=JNDIDSN %>&TableName="+listval);
 
});

 // End init
});
// -->
</script>
<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>
