<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="$WEBAPP.*, $WEBAPP.apputil.*, $BeanPackage.*"%>
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, javax.servlet.*, javax.servlet.http.* " %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.base64.* " %>
<%@ page import="com.webapp.poi.*, org.apache.poi.ss.usermodel.*, org.apache.poi.hssf.usermodel.*, org.apache.poi.xssf.usermodel.* " %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiMngrBn" scope="page" class="$BeanPackage.SitemanagerBean" />
<%
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);

$WEBAPP.LoggedSitemanager LogUsr =  ($WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);

String Action = RequestHelper.paramValue(request, "Action", "Form" ); // Other action Upload, Process

String[] HEADER = { "FirstName", "MiddleName", "LastName", "Gender", "BirthDate", "MaritalStatus", "EmpCode", "JoiningDate", "Address", "City", "State", "PIN", "Landline", "Mobile", "Email"  } ;

String PageTitle = "Excel Import : $CTABLENAME";
%>
<%@include file="/admin/nav_menu.inc"%>
<!DOCTYPE HTML >
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
	<title><%=PageTitle  %></title>

  <jsp:include page ="/include-page/css/main-css.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

	<jsp:include page ="/include-page/css/formValidation-css.jsp" flush="true" />
	<jsp:include page ="/include-page/css/bootstrap-select-css.jsp" flush="true" />
  <jsp:include page ="/include-page/css/bootstrap-datepicker-css.jsp" flush="true" />

<style type="text/css">
<!-- 
 .row_ok{ color: green ;}
 .row_blank{ color: navy ;} 
 .row_error{ color: red ;} 
-->
</style>	
	<jsp:include page="/include-page/js/jquery-js.jsp" flush="true" />

  <jsp:include page ="/include-page/common/main-head-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

</head>
<body class="<%=menuTypeClass %> <%=SiMngrBn.LoginRole %>" onload="InitPage()" >

  <jsp:include page ="/admin/include-page/nav-body.jsp" >	
	 	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

  <jsp:include page ="/admin/include-page/menu-body.jsp" >	
	 	 <jsp:param name="menuType" value="<%=menuType %>" />
	 	 <jsp:param name="MenuTitle" value="???" />
	 	 <jsp:param name="MenuLink" value="???" />
  </jsp:include>
	
  <!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
  	  <div class="row">
        <div class="col-sm-6">
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i><%=PageTitle  %></h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<%=appPath %>/admin/index.jsp"><i aria-hidden="true" class="icon fa fa-home fa-lg"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active">Excel Import</li>
          </ol>			
  	    </div>
  		</div>	
			<hr class="hr-res" />

<% 
if("Form".equalsIgnoreCase(Action))
{ 
%>
<form action="<%=thisFile %>" method="POST" class="form-horizontal" id="$TABLENAME_Upload_Form" enctype="multipart/form-data" accept-charset="UTF-8" >
<input type="hidden" name="Action" value="Upload" id="formActionID" />

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class="icon fa fa-upload iccolor" aria-hidden="true"></i><span class="hidden-xs">Upload File</span>
		<!-- onclick="NavigateTo('<%=appPath %>/admin/index.jsp')" -->
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">
      <div class="form-group">
        <label for="ExcelFile" class="col-sm-3 control-label blue-grey-600">Excel File :</label>
        <div class="col-sm-4"><input type="file" accept=".xls,.xlsx" name="ExcelFile" id="ExcelFile" class="form-control filestyle" data-buttonBefore="false" data-buttonName="btn-primary" data-iconName="icon fa fa-inbox" data-placeholder="None Selected" enctype="multipart/form-data" title="Please select the excel file."/></div>
      </div>	
	 		
      <div class="form-group">
        <label for="UpdateOnIDColumn" class="col-sm-3 control-label blue-grey-600">Update On Column :</label>
        <div class="col-sm-4">			
          <span class="checkbox-custom checkbox-inline checkbox-primary">
          <input type="checkbox" name="UpdateOnIDColumn" id="UpdateOnIDColumn" value="TRUE">
          <label for="UpdateOnIDColumn">Excel Col: <%=HEADER[6] %></label></span>
				</div>
      </div>	

      <div class="form-group">
        <label for="ExcelFile" class="col-sm-3 control-label blue-grey-600">Password :</label>
        <div class="col-sm-4"><input type="password" name="Password" id="Password" class="form-control" ></div>
      </div>	

			
      <div class="form-group">
    	  <label for="MultiLogin" class="col-sm-3 control-label blue-grey-600" >Multi Login :</label>
    	  <div class="col-sm-4">	
    			 <select name="MultiLogin" id="MultiLogin" class="form-control show-tick" data-plugin="selectpicker">
    			   <!-- <option value="">--None--</option> -->
             <!-- <option value="">--ALL--</option> -->
          	 <option value="0" >&nbsp;No&nbsp;</option>
          	 <option value="1" selected="selected" >&nbsp;Yes&nbsp;</option>
    			 </select>
    	  </div>
    	</div>
			
      <div class="form-group">
    	  <label for="Menutype" class="col-sm-3 control-label blue-grey-600" >Menu type :</label>
    	  <div class="col-sm-4">	
    			 <select name="Menutype" id="Menutype" class="form-control show-tick" data-plugin="selectpicker">
    			   <!-- <option value="">--None--</option> -->
             <!-- <option value="">--ALL--</option> -->
						 <option value="Topbar" selected="selected" >&nbsp;Topbar&nbsp;</option>
          	 <option value="Base">&nbsp;Base&nbsp;</option>
          	 <option value="Center">&nbsp;Center&nbsp;</option>
    			 </select>
    	  </div>
    	</div>
	 		
			
</div>

<div class="panel-form-box-footer">
			  <div class="col-md-offset-3 col-sm-offset-4" style="padding-left: 15px;">
				  <button type="submit" class="btn btn-primary" title="Submit" onclick="{ $('#formActionID').val('Process'); }"><i class="fa fa-check-square-o" aria-hidden="true"></i>&nbsp;Process</button>
          <button type="submit" class="btn btn-primary" title="Submit"><i class="fa fa-upload" aria-hidden="true"></i>&nbsp;Upload</button>
          <!-- <button type="button" class="btn btn-default btn-outline" title="Cancel Search" onclick="history.go(-1);"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button> -->
					<!-- <button type="button" class="btn btn-default btn-outline" title="Cancel Search" onclick="NavigateTo('<%=appPath %>/admin/index.jsp')"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button> -->
				</div>
      </div>	

<p>&nbsp;</p>			
    <div class="well well-sm">
    <ul class="list-group list-group-gap" style="margin-bottom: 0px;">
      <li class="list-group-item">
			  <p>			
          <span class="drop-cap"><i aria-hidden="true" class="icon fa fa-download iccolor"></i></span>
  				The easiest and hassle free way would be to download this <a href="User-$CTABLENAME.xlsx"><big><big><b>Sample Excelsheet</b></big></big></a>, edit it and upload back to server.
  				<br />
  			  Leave the column header in first row unchanged and from row no 2 onwards fill up your data in column.
			  </p>				
      </li>
    </ul>		
    </div>			
			
			
</div>
</div>

</form>

<% 
}
else if("Process".equalsIgnoreCase(Action))
{ 
// Main outer try catch block

    ResinFileUpload RsUpload = new ResinFileUpload() ;
    RsUpload.load( application,request, "ExcelFile" ) ;
    String FileName = RsUpload.getFileName();
    //String FileExt = RsUpload.getFileExt();
    //String MimeType = RsUpload.getMimeType();
    int nSize = RsUpload.getFileSize();
    String ShowSize = NumberHelper.showByteSize((long)nSize);
		
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
				  %>
					
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class="icon fa fa-file-excel-o iccolor" aria-hidden="true"></i>&nbsp;&nbsp;Processed File
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="NavigateTo('<%=thisFile %>?Action=Form')"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">
<div class="well well-sm well-success">
<big><i class="icon fa fa-check" aria-hidden="true"></i>&nbsp;( <%=nLastIndx %> ) rows ( excluding header row )</big>
<br />
<big><i class="icon fa fa-check" aria-hidden="true"></i>&nbsp;<%=FileName %>  ( <%=ShowSize %> )</big>
</div>

<table class="table table-bordered table-striped Rslt-Act-tbl">
  <tr><td class="col-sm-2">Errors :</td><td><span id="ERRORSP"></span></td></tr>
  <tr><td class="col-sm-2">Blank Rows :</td><td><span id="BLANKP"></span></td></tr>
</table>

</div>
</div>


<div class="panel" style="width:200%">
<div class="panel-body container-fluid">	

    <table class="table table-bordered table-striped Rslt-Act-tbl">											
    <thead>
    <th>Row No.</th>
    <th>Status</th>
    <% for(String headername : HEADER) {%>
    <th><%=headername %></th>
    <% } %>
    </thead>
    <tbody>

<%
  int nErrorP=0, nBlankP=0;
	// for all rows in spread-sheet
	for(int idx=1; idx <= nLastIndx ; idx++ )
	{
    int RowNo = idx+1;
%>
    <tr>
    <td><%=RowNo %></td>
<%
Row datarow = sheet.getRow(idx) ;
if(datarow==null)
{
%>
    <td><span class="row_blank">Blank Row</span></td>
    <td>&nbsp;</td>
    </tr>
<%
nBlankP++;
continue ;	
}					
// Local try catch for individual rows
try
{
%>
    <td><span class="row_ok"><i class="fa fa-check-square-o fa-lg" aria-hidden="true"></i></span></td>
<%
  String strFirstName = POIHelper.getStringFromCell(datarow.getCell(0, Row.CREATE_NULL_AS_BLANK));
														   String strMiddleName = POIHelper.getStringFromCell(datarow.getCell(1, Row.CREATE_NULL_AS_BLANK));
														   String strLastName = POIHelper.getStringFromCell(datarow.getCell(2, Row.CREATE_NULL_AS_BLANK));
														   String strGender = POIHelper.getStringFromCell(datarow.getCell(3, Row.CREATE_NULL_AS_BLANK));
														   java.sql.Date dtBirthDate = POIHelper.getDateFromCell(datarow.getCell(4, Row.CREATE_NULL_AS_BLANK));
														   String strMaritalStatus = POIHelper.getStringFromCell(datarow.getCell(5, Row.CREATE_NULL_AS_BLANK));
														   String strEmpCode = POIHelper.getStringFromCell(datarow.getCell(6, Row.CREATE_NULL_AS_BLANK));
														   java.sql.Date dtJoiningDate = POIHelper.getDateFromCell(datarow.getCell(7, Row.CREATE_NULL_AS_BLANK));
														   String strAddress = POIHelper.getStringFromCell(datarow.getCell(8, Row.CREATE_NULL_AS_BLANK));
														   String strCity = POIHelper.getStringFromCell(datarow.getCell(9, Row.CREATE_NULL_AS_BLANK));
														   String strState = POIHelper.getStringFromCell(datarow.getCell(10, Row.CREATE_NULL_AS_BLANK));
														   String strPIN = POIHelper.getStringFromCell(datarow.getCell(11, Row.CREATE_NULL_AS_BLANK));
														   String strLandline = POIHelper.getStringFromCell(datarow.getCell(12, Row.CREATE_NULL_AS_BLANK));
														   String strMobile = POIHelper.getStringFromCell(datarow.getCell(13, Row.CREATE_NULL_AS_BLANK));
														   String strEmail = POIHelper.getStringFromCell(datarow.getCell(14, Row.CREATE_NULL_AS_BLANK));
														 						
							%>
	
											<td><%=strFirstName %></td>
														 <td><%=strMiddleName %></td>
														 <td><%=strLastName %></td>
														 <td><%=strGender %></td>
														 <td><%=dtBirthDate %></td>
														 <td><%=strMaritalStatus %></td>
														 <td><%=strEmpCode %></td>
														 <td><%=dtJoiningDate %></td>
														 <td><%=strAddress %></td>
														 <td><%=strCity %></td>
														 <td><%=strState %></td>
														 <td><%=strPIN %></td>
														 <td><%=strLandline %></td>
														 <td><%=strMobile %></td>
														 <td><%=strEmail %></td>
														 		
    </tr>
<%
}
catch(Exception row_ex)
{
%>
    <td><span class="row_error">Error :</span></td>
    <td><%=row_ex.getMessage() %></td>
    <td>Cancelled.</td>
    </tr>
<%
nErrorP++;
}						   				
}// end main for loop (int idx=1; idx <= nLastIndx ; idx++ )
%>
<script type="text/javascript">
<!--
//Process Action
								 $("#ERRORSP").html("<%=nErrorP %>");
								 $("#BLANKP").html("<%=nBlankP %>");



// -->
</script>
</tbody>
</table>
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
   } // end main outer try catch block
%>
  <hr size="1" />
	<p><a href="<%=thisFile %>?Action=Form">Try another upload...</a></p>
	
	
</div>
</div>
<% 
}
else if("Upload".equalsIgnoreCase(Action))
{ 
%>
<% 
// Main outer try catch block
    ResinFileUpload RsUpload = new ResinFileUpload() ;
    RsUpload.load( application,request, "ExcelFile" ) ;
    String FileName = RsUpload.getFileName();
    String FileExt = RsUpload.getFileExt();
    String MimeType = RsUpload.getMimeType();
    int nSize = RsUpload.getFileSize();
    String ShowSize = NumberHelper.showByteSize((long)nSize);
		boolean bUpdateOnIDCol = false; 
		
		String UpdateOnIDColumn = request.getParameter("UpdateOnIDColumn");
		bUpdateOnIDCol = ( UpdateOnIDColumn!=null && "TRUE".equalsIgnoreCase(UpdateOnIDColumn))? true : false;
    
		
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
					
					// DEBUG IDField : EmpCode IDColIndex: 6
					
				  %>

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class="icon fa fa-file-excel-o iccolor" aria-hidden="true"></i>&nbsp;&nbsp;Upload Result
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="NavigateTo('<%=thisFile %>?Action=Form')"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">
<div class="well well-sm well-success">
<big><i class="icon fa fa-check" aria-hidden="true"></i>&nbsp;( <%=nLastIndx %> ) rows ( excluding header row )</big>
<br />
<big><i class="icon fa fa-check" aria-hidden="true"></i>&nbsp;<%=FileName %>  ( <%=ShowSize %> )</big>
</div>

<table class="table table-bordered table-striped Rslt-Act-tbl">
  <tr><td class="col-sm-2">Inserted:</td><td><span id="INSERTED"></span></td></tr>

  <tr><td class="col-sm-2">Updated:</td><td><span id="UPDATED"></span> </td></tr>  

  <tr><td class="col-sm-2">Errors :</td><td><span id="ERRORS"></span></td></tr>
  <tr><td class="col-sm-2">Blank Rows :</td><td><span id="BLANK"></span></td></tr>
</table>

</div>
</div>


<div class="panel"><!-- style="width:200%" -->
<div class="panel-body container-fluid">	

					  <table class="table table-bordered table-striped Rslt-Act-tbl">
               <thead>
							 <th>Row No.</th>
							 <th>Status</th>
							 <th>Row Data</th>
							 <th>Update Status</th>
							 </thead>
							 <tbody>

					
					<%
					  int nInsert=0, nUpdate=0, nError=0, nBlank=0;
	          GenericQuery genqry = new GenericQuery(ApplicationResource.database, application);
						// Alternate: genqry = new GenericQuery("jdbc/$DATABASE", application); 
	          java.sql.Connection conn = genqry.Connect();
						com.webapp.utils.PortableSQL psql = new com.webapp.utils.PortableSQL(conn);
						   
 						   String InsQry = "INSERT INTO `$TABLENAME` ( `FirstName`, `MiddleName`, `LastName`, `Gender`, `BirthDate`, `MaritalStatus`, `EmpCode`, `JoiningDate`, `Address`, `City`, `State`, `PIN`, `Landline`, `Mobile`, `Email`, `Password`, `PasswordType`,  `LoginRole`, `CurrentStatus`, `LoginStatus`, `MultiLogin`, `MenuType`, `UpdateDateTime` ) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ) " ;
						   PreparedStatement stmtIns = conn.prepareStatement(psql.SQL(InsQry));
							
							String UpdQry = "UPDATE `$TABLENAME` SET `FirstName` = ? , `MiddleName` = ? , `LastName` = ? , `Gender` = ? , `BirthDate` = ? , `MaritalStatus` = ? , `EmpCode` = ? , `JoiningDate` = ? , `Address` = ? , `City` = ? , `State` = ? , `PIN` = ? , `Landline` = ? , `Mobile` = ? , `Email` = ?, `Password` = ?, `PasswordType` = ?, `LoginRole` = ?, `CurrentStatus` = ?, `LoginStatus` = ?, `MultiLogin` = ?, `MenuType` = ?, `UpdateDateTime` = ?  WHERE `EmpCode` = ?  ";		
							PreparedStatement stmtUpd = conn.prepareStatement(psql.SQL(UpdQry));
							
							String FindQry = "SELECT COUNT(*) FROM `$TABLENAME` WHERE `EmpCode` = ? ";
							PreparedStatement stmtFind = conn.prepareStatement(psql.SQL(FindQry));
		          
						 
						 
						 
						 
            // for all rows in spread-sheet
						for(int idx=1; idx <= nLastIndx ; idx++ )
            {
						      int RowNo = idx+1;
						      %><tr><td><%=RowNo %></td><%
                  Row datarow = sheet.getRow(idx) ;
        					if(datarow==null)
                  {
									   %><td><span class="row_blank">Blank Row</span></td><td valign="top">&nbsp;</td><td>&nbsp;</td></tr><%
                      nBlank++;
        							continue ;	
                  }					
                  // Local try catch for individual rows
                  try
                  {
									    //Enter excel row data into table here...
											String RowData = POIHelper.getStringFromCell(datarow.getCell(0, Row.CREATE_NULL_AS_BLANK)) ;
											
											
													 
													 String strFirstName = POIHelper.getStringFromCell(datarow.getCell(0, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setString( 1 , strFirstName ) ; 
															   
															  if( bUpdateOnIDCol )
																{
															  
															   stmtUpd.setString( 1 , strFirstName ) ;    
															  
														     
																} 
																
														 
													 
													 String strMiddleName = POIHelper.getStringFromCell(datarow.getCell(1, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setString( 2 , strMiddleName ) ; 
															   
															  if( bUpdateOnIDCol )
																{
															  
															   stmtUpd.setString( 2 , strMiddleName ) ;    
															  
														     
																} 
																
														 
													 
													 String strLastName = POIHelper.getStringFromCell(datarow.getCell(2, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setString( 3 , strLastName ) ; 
															   
															  if( bUpdateOnIDCol )
																{
															  
															   stmtUpd.setString( 3 , strLastName ) ;    
															  
														     
																} 
																
														 
													 
													 String strGender = POIHelper.getStringFromCell(datarow.getCell(3, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setString( 4 , strGender ) ; 
															   
															  if( bUpdateOnIDCol )
																{
															  
															   stmtUpd.setString( 4 , strGender ) ;    
															  
														     
																} 
																
														 
													 
													 java.sql.Date dtBirthDate = POIHelper.getDateFromCell(datarow.getCell(4, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setDate( 5 , dtBirthDate ) ; 
															  
															  if( bUpdateOnIDCol )
																{
															  
															  stmtUpd.setDate( 5 , dtBirthDate ) ;   
															  
														     
																} 
																
														
														 
													 
													 String strMaritalStatus = POIHelper.getStringFromCell(datarow.getCell(5, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setString( 6 , strMaritalStatus ) ; 
															   
															  if( bUpdateOnIDCol )
																{
															  
															   stmtUpd.setString( 6 , strMaritalStatus ) ;    
															  
														     
																} 
																
														 
													 
													 String strEmpCode = POIHelper.getStringFromCell(datarow.getCell(6, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setString( 7 , strEmpCode ) ; 
															   
															  if( bUpdateOnIDCol )
																{
															  
															   stmtUpd.setString( 7 , strEmpCode ) ;    
															   stmtUpd.setString( 24 , strEmpCode ) ; 
																 stmtFind.setString(1 , strEmpCode ) ;   
														     
																} 
																
														 
													 
													 java.sql.Date dtJoiningDate = POIHelper.getDateFromCell(datarow.getCell(7, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setDate( 8 , dtJoiningDate ) ; 
															  
															  if( bUpdateOnIDCol )
																{
															  
															  stmtUpd.setDate( 8 , dtJoiningDate ) ;   
															  
														     
																} 
																
														
														 
													 
													 String strAddress = POIHelper.getStringFromCell(datarow.getCell(8, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setString( 9 , strAddress ) ; 
															   
															  if( bUpdateOnIDCol )
																{
															  
															   stmtUpd.setString( 9 , strAddress ) ;    
															  
														     
																} 
																
														 
													 
													 String strCity = POIHelper.getStringFromCell(datarow.getCell(9, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setString( 10 , strCity ) ; 
															   
															  if( bUpdateOnIDCol )
																{
															  
															   stmtUpd.setString( 10 , strCity ) ;    
															  
														     
																} 
																
														 
													 
													 String strState = POIHelper.getStringFromCell(datarow.getCell(10, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setString( 11 , strState ) ; 
															   
															  if( bUpdateOnIDCol )
																{
															  
															   stmtUpd.setString( 11 , strState ) ;    
															  
														     
																} 
																
														 
													 
													 String strPIN = POIHelper.getStringFromCell(datarow.getCell(11, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setString( 12 , strPIN ) ; 
															   
															  if( bUpdateOnIDCol )
																{
															  
															   stmtUpd.setString( 12 , strPIN ) ;    
															  
														     
																} 
																
														 
													 
													 String strLandline = POIHelper.getStringFromCell(datarow.getCell(12, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setString( 13 , strLandline ) ; 
															   
															  if( bUpdateOnIDCol )
																{
															  
															   stmtUpd.setString( 13 , strLandline ) ;    
															  
														     
																} 
																
														 
													 
													 String strMobile = POIHelper.getStringFromCell(datarow.getCell(13, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setString( 14 , strMobile ) ; 
															   
															  if( bUpdateOnIDCol )
																{
															  
															   stmtUpd.setString( 14 , strMobile ) ;    
															  
														     
																} 
																
														 
													 
													 String strEmail = POIHelper.getStringFromCell(datarow.getCell(14, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setString( 15 , strEmail ) ; 
															   
															  if( bUpdateOnIDCol )
																{
															  
															   stmtUpd.setString( 15 , strEmail ) ;    
															  
														     
																} 
													 String Password = request.getParameter("Password");	
														  stmtIns.setString( 16 , Password ) ; 
															if( bUpdateOnIDCol )
																{
															  stmtUpd.setString( 16 , Password ) ;
																}

													  stmtIns.setShort( 17 , PasswordType.SERVICE ) ;
															if( bUpdateOnIDCol )
																{
															  stmtUpd.setShort( 17 , PasswordType.SERVICE ) ;
																}
																 
														stmtIns.setString( 18 , "$CTABLENAME" ) ; 
															if( bUpdateOnIDCol )
																{
															  stmtUpd.setString( 18 , "$CTABLENAME" ) ;
																} 
																
														stmtIns.setShort( 19 , CurrentStatusFlag.OK ) ; 
														if( bUpdateOnIDCol )
																{
															  stmtUpd.setShort( 19 , CurrentStatusFlag.OK ) ;
																} 
													  
														stmtIns.setShort( 20 , LoginStatusFlag.NOT_LOGGED ) ;
														if( bUpdateOnIDCol )
																{
															  stmtUpd.setShort( 20 , LoginStatusFlag.NOT_LOGGED ) ;
																} 
																
                            Short MultiLogin = 0 ;
                                try 
                                 { 
                                      MultiLogin = Short.parseShort(request.getParameter("MultiLogin")) ;
                                } catch( NumberFormatException ex)
                                 {     
                                     MultiLogin = 0 ;
                                }																
														stmtIns.setShort( 21 , MultiLogin ) ;
														if( bUpdateOnIDCol )
																{
															  stmtUpd.setShort( 21 , MultiLogin ) ;
																} 
																
												String Menutype = request.getParameter("Menutype");			
																
														stmtIns.setString( 22 , Menutype ) ;
														if( bUpdateOnIDCol )
																{
															  stmtUpd.setString( 22 , Menutype ) ;
																} 
																
													  stmtIns.setTimestamp( 23 , new java.sql.Timestamp(System.currentTimeMillis()) ) ;
													if( bUpdateOnIDCol )
																{
															  stmtUpd.setTimestamp( 23 , new java.sql.Timestamp(System.currentTimeMillis()) ) ;
																}  
																
														 
											%><td><span class="row_ok"><i class="fa fa-check-square-o fa-lg" aria-hidden="true"></i></span></td>
											<td valign="top"><%=RowData %></td>
											<%
											
											   int nRecCount = 0;
												 if(bUpdateOnIDCol) 
												 {
  												 java.sql.ResultSet rsFind = stmtFind.executeQuery();
  												 if(rsFind!=null && rsFind.next()) nRecCount = rsFind.getInt(1);
												   if(nRecCount > 0 ) 
												   {												   
												    stmtUpd.executeUpdate();
													  nUpdate++;
														%><td>Record Updated</td><%
													 }
												 }
												 else 
												 {
												    stmtIns.executeUpdate();
													  nInsert++;
														%><td>Record Inserted</td><%
											   }
											
											
									    %>
											</tr>
											<%
                  }
                  catch(Exception row_ex)
                  {
									     %><td><span class="row_error">Error:</span></td> <td valign="top"><%=row_ex.getMessage() %></td><td>Cancelled.</td></tr><%
        					     nError++;
                  }						   
						
					  }// end main for loop (int idx=1; idx <= nLastIndx ; idx++ )
						stmtIns.close();
						
		           stmtFind.close();
							 stmtUpd.close();
            
						genqry.Disconnect(conn);
						%>

<script type="text/javascript">
<!--
//upload Action

                 $("#INSERTED").html("<%=nInsert %>");
								 
		              $("#UPDATED").html("<%=nUpdate %>");
                  
								 $("#ERRORS").html("<%=nError %>");
								 $("#BLANK").html("<%=nBlank %>");

// -->
</script>
              </tbody>
						  </table>
							
							
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
   } // end main outer try catch block
	 // Delete the upload file when done
	 ResinFileUpload.deleteUploadFile(request, "ExcelFile");
 %>
  <hr size="1" />
	<p><a href="<%=thisFile %>?Action=Form">Try another upload...</a></p>
	
	
</div>
</div>
	

<% 
}
else
{
 %>
<span class="error">Error:</span> request parameter:- Action not passed properly in page invocation.<br/>
Please report this error to developers.
<% 
} 

%>

</div><!-- main div end #maindiv -->

</div><!--   div end .page_container -->

	<jsp:include page ="/admin/include-page/footer.jsp" flush="true" />
	 
  <jsp:include page ="/include-page/js/main-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

  <jsp:include page ="/include-page/js/bootstrap-select-js.jsp" flush="true" />
  <jsp:include page ="/include-page/js/bootstrap-datepicker-js.jsp" flush="true" />
	<jsp:include page="/include-page/js/formValidation-js.jsp" flush="true" />

	<jsp:include page="/include-page/js/bootstrap-filestyle-js.jsp" flush="true" />

<script>
function InitPage()
{
// Do something on page init
}

$(document).ready(function(){

    $('#$TABLENAME_Upload_Form').formValidation({
        framework: 'bootstrap',
        fields: {
            ExcelFile: {
                validators: {
                    notEmpty: {
                        message: 'The field is required'
                    },
                    file: {
                        extension: 'xls,xlsx',
												type: 'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                        message: 'Please choose a Excel file'
                    }
                }
            }
        }
    });
}); 
</script>

</body>
</html>
