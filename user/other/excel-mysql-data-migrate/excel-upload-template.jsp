<%@ page import="com.beanwiz.* "%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*, java.sql.*, com.webapp.utils.*, com.webapp.resin.*, com.webapp.poi.*, org.apache.poi.ss.usermodel.*, org.apache.poi.hssf.usermodel.*, org.apache.poi.xssf.usermodel.* " %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

String Action = request.getParameter("Action") ;
if(Action ==null ) Action = "Form" ; //   Other action Update

String[] HEADER = null ; // Enter Value { "One" , "Two", "Three" } if you want to check the header

%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Process Excel Upload File</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
</head>
<body>   
<jsp:include page="/user/assets-user/include-page/header-user.jsp" flush="true" />	

<div class="container-fluid">
<div class="row page-header11">
  <div class="col-md-6 col-xs-12">
    <h4 class="page-title11"><i class="fa fa-plug text-primary"></i>&nbsp;&nbsp;<span class="text-muted">Process Excel Upload File</span></h4>
  </div>
  <div class="col-md-6 col-xs-12">
    <!--  page-header-actions  -->
    <ol class="breadcrumb text-right">
      <li><a href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg"></i></a></li>
      <li class="active">Process Excel File</li>
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
 <div class="col-md-12">
      <div class="panel panel-primary">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-upload fa-lg"></i>&nbsp;&nbsp;Upload Excel File</h3>
        </div>
        <div class="panel-body">

				
<form  action="<%=thisFile %>" method="post" id="file_upload_form" enctype="multipart/form-data" class="form-horizontal">
<input type="hidden" name="ifcon" value="1" />

	<div class="form-group">
	<div class="col-md-12">
    <div class="input-group">
		  <input type="file" enctype="multipart/form-data" name="ExcelFile" class="form-control" id="ExcelFile" placeholder="Select File">
      <span class="input-group-btn">
			  <button type="submit" class="btn btn-default"><i class="fa fa-upload fa-lg text-primary"></i>&nbsp;&nbsp;Upload</button>
      </span>	
    </div><!-- /input-group -->
	</div>
  </div>
</form>

     </div>		
  </div>			
</div>
		
<% 
String ifcon = request.getParameter("ifcon") ;
if(ifcon != null)
{ 
%>
<div class="col-md-12">
		
<%
	 ResinFileUpload RsUpload = new ResinFileUpload() ;
   RsUpload.load( application,request, "ExcelFile" ) ;

   String FileName = RsUpload.getFileName();
   String FileExt = RsUpload.getFileExt();
   String MimeType = RsUpload.getMimeType();
	 int nSize = RsUpload.getFileSize();
	 String ShowSize = NumberHelper.showByteSize((long)nSize);
 
//HEADER    
     try
	   {
	        if( !POIHelper.checkExcelMIME(RsUpload) ) throw new Exception("The uploaded file ( "+FileName+" "+ShowSize+" ) is not a valid MS Excel File.");
	     
			    Workbook wb = WorkbookFactory.create( RsUpload.getInputStream());
          Sheet sheet = wb.getSheetAt(0);
			    int nLastIndx = sheet.getLastRowNum();
			 
			    // Check for header row
			    Row hdr_row = sheet.getRow(0);
					if(HEADER!=null)
					{
			          if( !POIHelper.checkExcelHeaderRow( hdr_row, HEADER ) )
			          {
			          throw new Exception("The MS Excel file has invalid header row ( first row )." );
							 
			          }
			    }
				  int nColCount = hdr_row.getLastCellNum();
					ArrayList<String> col_list = new  ArrayList<String>();
					for(int col=0; col < nColCount ; col++)
					{
					    Cell cell = hdr_row.getCell(col, Row.CREATE_NULL_AS_BLANK) ;
					    col_list.add( POIHelper.getStringFromCell(cell) );
					}
				
       
	   %>
<div class="well well-sm">
<b>( <%=nLastIndx %> )</b> rows of data ( excluding header row ) processed from file : <b><%=FileName %> [ <%=ShowSize %> ]</b>
</div> 
<div class="table-responsive">
<table class="table table-striped table-bordered table-condensed">
<thead>
<tr>
<th valign="top" >No</th>
<% 
Iterator<String> it = col_list.iterator() ; 
while(it.hasNext()) 
{   
String ExCol = it.next(); 
ExCol =  ExCol.trim();
%>
<th valign="top" ><%=ExCol %></th>
<%  
}
%>
</tr>
</thead>
<tbody>
			 <%
		 
		   int nDone=0, nError=0, nBlank=0;
			 StringBuilder sbError = new StringBuilder("<span class=\"error\">Error details:<br/></span>");
			 
			 // $Bean.beginInsert();
			 
		   for(int idx=1; idx <= nLastIndx ; idx++ )
			 {
			       // For every row of sheet
						 
        			    int rowno=idx+1;
        					Row row = sheet.getRow(idx) ;
        					if(row==null)
                  {
                      nBlank++;
        							continue ;					
                  }					
                  
									
									try
                  {
        					    // #### {{ BEGIN
        							/* 
        							   Typical code: Cell cell = row.getCell(?n, Row.CREATE_NULL_AS_BLANK) ;
        							   POIHelper methods:
        							   String: POIHelper.getStringFromCell(cell) 
        								 Double: POIHelper.getNumberFromCell(cell )
        								 java.sql.Date: POIHelper.getDateFromCell( cell )
        							*/
        							
											// DEBUG BEGIN
													%>
													<tr>
								          <td><b>Row: [ <%=rowno %>]</b></td> 
											    <%
											// DEBUG END
											
											// For all columns of the row
											for(int col=0; col < nColCount ; col++)
											{
											    Cell cell = row.getCell(col, Row.CREATE_NULL_AS_BLANK) ;
													
													// DEBUG BEGIN
													%>
													 <td><%=POIHelper.getStringFromCell(cell) %></td>
											    <%
											// DEBUG END
											
											
													
													
        							     /* Fatch Data From Cell ###TODO
        							      String: POIHelper.getStringFromCell(cell) 
        								    Double: POIHelper.getNumberFromCell(cell )
        								    java.sql.Date: POIHelper.getDateFromCell( cell )
											      ---
														  $Bean.IDField=0;
        									    $Bean.Foo=Bar;
        							        $Bean.continueInsert(); 
        							 
													 
													 */
											
											} // end inner loop for(int col=0; col < nColCount ; col++)
        							 nDone++; // Success
        							 
        							 
        					// ####  }} END
        							 
        							
        					    
                  }
                  catch(Exception e)          					
                  {
        					     sbError.append("Row No.["+rowno+"] "+e.getMessage()+"<br/>");
        					     nError++;
                  }								
        					
        			%>	
							</tr>	
        			<%  		
        			 
			 } // end main for(int idx=1; idx <= nLastIndx ; idx++ )
			 // $Bean.endInsert(); 
		   %>
</tbody>
</table>
</div>

<ul class="list-group">
  <li class="list-group-item list-group-item-success"><b><%=nDone %></b> records processed successfully.</li>
	<% if(nBlank > 0) { %>
  <li class="list-group-item list-group-item-info"><b><%=nBlank %></b> blank records were skipped.</li>
	<% } %>
	<% if(nBlank > 0) { %>
  <li class="list-group-item list-group-item-danger"><b><%=nError %></b> processing errors occured. <a href="javascript:void(0)" onclick="{  $('#error_div').slideToggle(); }">Show /Hide</a> details.</li>
	<% } %>
</ul>

<div class="well well-sm" id="error_div" style="display:none;">
<%=sbError.toString() %>
</div> 

<%
}
catch(Exception ex)
{
%>
	<div style="padding:1em;">
    <span class="error">File Upload Error:</span> <%=ExceptionHelper.showException(ex, "exception_div") %>
  </div><!-- end padding div -->
<%
}
// End try
ResinFileUpload.deleteUploadFile(request, "ExcelFile");
%>

<!-- <p><a href="<%=thisFile %>?Action=Form">Try another upload...</a></p> -->
</div>
<%  
}
%>
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

<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>
