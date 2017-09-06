<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="java.io.*, java.sql.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.poi.*, org.apache.poi.ss.usermodel.*, org.apache.poi.hssf.usermodel.*, org.apache.poi.xssf.usermodel.* " %>
<%@ page import="com.javaweb.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%
 
String AppURL = request.getContextPath() ;
String thisFile = AppURL+request.getServletPath() ;
/* Logged user reference if relevent
com.isvea.LoggedSitemanager LogUsr =  (com.isvea.LoggedSitemanager)session.getAttribute("theAdmin") ;
*/

String Action = request.getParameter("Action") ;
if(Action ==null ) Action = "Form" ; //   Other action Update
String[] HEADER = null ; // Enter Value { "One" , "Two", "Three" } if you want to check the header

%>
<!DOCTYPE HTML >
<html>
<head>
<title><%=ApplicationResource.pagetitle %></title>
<link rel="stylesheet" href="<%=AppURL %><%=ApplicationResource.stylesheet %>" type ="text/css" />

 
<jsp:include page="/scripts/jquery/jquery.jsp" flush="true" />
<jsp:include page="/scripts/jvalidate/jvalidate.jsp" flush="true" />

 

<script type="text/javascript">
 
function NavigateTo(url)
{ 
  document.location.href = url ;
}

 
$(document).ready(function(){
 // Init jQuery 
 // Access objects  $("#ID").$func()
  
	$("#file_upload_form").validate({
	    rules: 
      {
          ExcelFile:"required"
      } 
	});

 // End init
});
 
 
</script>
</head>
<body  class="admin">
<jsp:include page="/banner.jsp" flush="true" />
 

<div class="block">
<table width="100%">
<tr>
	<td valign="top" align="left" width="70%" ><span class="title">Upload and process MS Excel file.</span></td>
	<!-- <td valign="top" align="center" width="30%" >?? </td> -->
	<td valign="top"  align="right" width="30%" > <a href="<%=AppURL %>/index.jsp"> &#x25C4; Go Back</a>&nbsp;&nbsp;</td>
</tr>
</table>
</div>

<div style="margin: 1em">
<% 
if("Form".equalsIgnoreCase(Action))
{
// Show update form
%>
<!-- Begin From -->
<form action="<%=thisFile %>" method="post" id="file_upload_form" enctype="multipart/form-data"  >  <!-- For file upload:  -->
<table border="0" cellpadding="4" cellspacing="0" summary="">
<input type="hidden" name="Action" value="Update" />
    <tr>
    <td valign="top"><span class="label">Select M.S. Excel File XLS/XLSX</span></td>
    <td valign="top"><span class="dataitem"><input type="file" enctype="multipart/form-data" name="ExcelFile" /></span></td>		
   </tr>
   
 
 

<tr>
    <td valign="top"><span class="label">Submit</span></td>
    <td valign="top"><span class="dataitem">
    <button type="submit">Ok, Submit Form</button></span>
     <button type="button" value="" onclick="NavigateTo('<%=AppURL %>/index.jsp')">Cancel Upload</button>  
    </td>		
</tr>

</table>

</form>



<!-- End From -->
<% 
}
else if("Update".equalsIgnoreCase(Action))
{
 
	  
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
				
       
	   %>
	    <p>Processing <b>( <%=nLastIndx %> )</b> rows of data ( excluding header row ) from <b>first sheet</b> of <span class="label">M.S.Excel file</span>: <span class="dataitem"><%=FileName %></span> ( <%=ShowSize %> ).</p>
			<table border="1" cellpadding="4" cellspacing="0" summary="">
      <thead>
			    <th>Row No</th>
			    <th>Data</th>
			
			</thead>

			
			 <%
		 
		   int nDone=0, nError=0, nBlank=0;
			 StringBuilder sbError = new StringBuilder("<span class=\"error\">Error details:<br/></span>");
			 
			 // $Bean.beginInsert();
			 //  GenericQuery genqry = new GenericQuery(ApplicationResource.database, application);
			 //  genqry.beginExecute();
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
												 
												  String varS = POIHelper.getStringFromCell(row.getCell(?n, Row.CREATE_NULL_AS_BLANK));
												  java.sql.Date varDt = POIHelper.getDateFromCell( row.getCell(?n, Row.CREATE_NULL_AS_BLANK) );
													double varDb = POIHelper.getNumberFromCell( row.getCell(?n, Row.CREATE_NULL_AS_BLANK) )
												  $Bean.? = ? 
													$Bean.? = ? 
													$Bean.continueInsert() 
												 
												  genqry.continueExecute(" ");
        							*/
        							
											// DEBUG BEGIN
													%>
													<tr>
													 <td><b>Row: [ <%=rowno %>]</b> </td>
													 <td>
											    <%
											// DEBUG END
											
											// For all columns of the row
											for(int col=0; col < nColCount ; col++)
											{
											    Cell cell = row.getCell(col, Row.CREATE_NULL_AS_BLANK) ;
													
													// DEBUG BEGIN
													%>
													 <%=POIHelper.getStringFromCell(cell) %> | 
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
											
											%>
											 </td>
											</tr>
											<%
											
        							 nDone++; // Success
        							 
        							 
        					// ####  }} END
        							 
        							
        					    
                  }
                  catch(Exception e)          					
                  {
        					     sbError.append("Row No.["+rowno+"] "+e.getMessage()+"<br/>");
        					     nError++;
                  }								
        					
        					
        					
        			 
			 } // end main for(int idx=1; idx <= nLastIndx ; idx++ )
			 // $Bean.endInsert(); 
			 //  genqry.endExecute();
		   %>
			 <div style="padding:1em; margin:1em; width:50%; border:1px outset #330066; background-color: #f1ffdf;">
			 ( <%=nDone %> ) records processed successfully.<br/>
			 <% if(nBlank > 0) { %> ( <%=nBlank %> ) blank records were skipped.<br/><% } %>
			 <%
			 if( nError > 0) 
			 { 
			 
			 %> <div style="background-color:#ffe1e1">( <%=nError %> ) processing errors occured. <a href="javascript:void(0)" onclick="{  $('#error_div').slideToggle(); }">Show /Hide</a> details.<br/>
			 <div id="error_div" style="display:none;">
			 <%=sbError.toString() %>
			 </div>
			 <br/>
			 </div>
			 <% 
			 } 
			 %>
			 
			 </div>
			 <%
		 
		 
		 
     }
     catch(Exception ex)
     {
	  %>
	</table>	
	<div style="padding:1em;">
    <span class="error">File Upload Error:</span> <%=ExceptionHelper.showException(ex, "exception_div") %>
  </div><!-- end padding div -->
	<%
     }
		 // End try
	   ResinFileUpload.deleteUploadFile(request, "ExcelFile");
    	%>
	<hr size="1" />
	<p><a href="<%=thisFile %>?Action=Form">Try another upload...</a></p>
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
</body>
</html>

