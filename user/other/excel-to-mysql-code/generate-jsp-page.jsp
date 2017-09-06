<%@ page import="java.io.*,java.util.*, javax.servlet.*, javax.servlet.http.*, java.sql.*, javax.sql.*, javax.naming.* " %><%@ page import="com.webapp.jsp.*, com.webapp.utils.*, com.webapp.resin.*, com.beanwiz.* " %><% 
 %><%@ page import="com.webapp.poi.*, org.apache.poi.ss.usermodel.*, org.apache.poi.hssf.usermodel.*, org.apache.poi.xssf.usermodel.*" %><%!
 
 String ChekRegExp =  "[-\\s\\.\\^\\$\\*\\+\\?\\\\\\(\\)\\[\\{\\|\\}\\]~`!@#%&\\=:;\"'<>,/]" ;
 String ReplaceInvalidChar(String src)
 {
   if(src ==null || src.length()==0) return "";
	 return src.replaceAll(ChekRegExp,"_") ;
 }

 
 %><% 

String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath();

 
 
String ContentType =  "application/x-download" ;
String ContentDisp = "attachment; filename=excel-to-mysql.jsp";	
response.setContentType(ContentType);
response.setHeader("Content-Disposition", ContentDisp);
 

// response.setContentType("text/plain");

String WebAppPkg = request.getParameter("WebAppPkg");
String JNDIDSN = request.getParameter("JNDIDSN") ;
String TableName = request.getParameter("TableName");
String BeanPackage  = "com.db."+JNDIDSN.substring(JNDIDSN.indexOf("/",0)+1 );

char TFirst  = TableName.charAt(0);
if(TFirst > 96) TFirst-=32 ;
String CTableName = TFirst+TableName.substring(1) ;


boolean bUpdateOnID = false;
String UpdateOnIDField = request.getParameter("UpdateOnIDField") ; 
if( UpdateOnIDField !=null && "TRUE".equalsIgnoreCase(UpdateOnIDField))  bUpdateOnID  = true ;
String IDField =  request.getParameter("IDField");
int IDColIndex = 0;
String IDTableCol = "";
if( bUpdateOnID )
{
  String[] parts = IDField.split(":") ;
	if(parts!=null && parts.length ==2)
	{
	  IDColIndex = Integer.parseInt(parts[0]);
		IDTableCol = request.getParameter(parts[1]);
	}
	
	

}
 


   /*
    ResinFileUpload RsUpload = new ResinFileUpload() ;
    RsUpload.load( application,request, "ExcelFile" ) ;
    String FileName = RsUpload.getFileName();
    String FileExt = RsUpload.getFileExt();
    String MimeType = RsUpload.getMimeType();
	 */
		
		TreeMap<String, Integer> FldMap = new TreeMap<String, Integer>();
		Context env = (Context) new InitialContext().lookup("java:comp/env");
    DataSource source = (DataSource) env.lookup(JNDIDSN);
    Connection conn = source.getConnection();
    com.webapp.utils.PortableSQL psql = new com.webapp.utils.PortableSQL(conn);
    
    try
		{
		   String query =  BeanwizHelper.openTableSQL(conn, TableName);
			 java.sql.Statement stmt = conn.createStatement();
       java.sql.ResultSet rslt = stmt.executeQuery(query);
       java.sql.ResultSetMetaData rsmd = rslt.getMetaData();
       int colcnt  = rsmd.getColumnCount();	
      
      for(int n = 1 ; n <= colcnt  ; n++ )
      {
			   int sqltype = rsmd.getColumnType(n);
				 String ColName = rsmd.getColumnName(n) ;
			   FldMap.put(ColName, new Integer(sqltype));
			
		  }
		
		}
		finally
		{
		   conn.close();
		}
		
		
		
		
		String UploadedFile = request.getParameter("UploadedFile");
		FileInputStream fis = new  FileInputStream(UploadedFile);


		
    try
		{
        
	     
			    Workbook wb = WorkbookFactory.create(fis);
          Sheet sheet = wb.getSheetAt(0);
			    int nLastIndx = sheet.getLastRowNum();
			 
			    // Check for header row
			    Row hdr_row = sheet.getRow(0);
					int nColCount = hdr_row.getLastCellNum();
					ArrayList<String> col_list = (ArrayList<String>)session.getAttribute("EXCEL-FIELD-LIST");
					 
					/*
					ArrayList<String> col_list = new  ArrayList<String>();
					for(int col=0; col < nColCount ; col++)
					{
					    Cell cell = hdr_row.getCell(col, Row.CREATE_NULL_AS_BLANK) ;
					    col_list.add( POIHelper.getStringFromCell(cell) );
					}
					*/ 

%><\%@ page errorPage = "/errorpage.jsp" %>
<\%@ page import="<%=WebAppPkg %>.*" %>
<\%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*, javax.servlet.*, javax.servlet.http.*" %> 
<\%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*" %>
<\%@ page import="com.webapp.poi.*, org.apache.poi.ss.usermodel.*, org.apache.poi.hssf.usermodel.*, org.apache.poi.xssf.usermodel.* " %>
<\%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<% out.print("<jsp:useBean id=\"SiMngrBn\" scope=\"page\" class=\""+BeanPackage+".SitemanagerBean\" />\r\n"); %>
<\%
 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);

<%=WebAppPkg %>.LoggedSitemanager LogUsr =  (<%=WebAppPkg %>.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);

String Action = RequestHelper.paramValue(request, "Action", "Form" ); // Other action Upload
String MessageText = null ;
MessageText = request.getParameter("Message");

String[] HEADER = { <%  Iterator<String> it = col_list.iterator() ; int i=0; while(it.hasNext()) {   String st = it.next();  if(i> 0) out.print(", "); out.print("\""+st+"\""); i++; }	 %>  } ;

String PageTitle = "Excel Import : <%=CTableName %>";
%>
<\%@include file="/admin/nav_menu.inc"%>
<!DOCTYPE HTML >
<html class="no-js css-menubar" lang="en">
<head>
  <% out.print("<jsp:include page =\"/include-page/common/meta-tag.jsp\" flush=\"true\" />"); %>
	<title><\%=PageTitle  %></title>

  <% out.print("<jsp:include page =\"/include-page/css/main-css.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
	<% out.print("<jsp:include page =\"/include-page/css/formValidation-css.jsp\" flush=\"true\" />"); %>
	<% out.print("<jsp:include page =\"/include-page/css/bootstrap-select-css.jsp\" flush=\"true\" />"); %>
  <% out.print("<jsp:include page =\"/include-page/css/bootstrap-datepicker-css.jsp\" flush=\"true\" />"); %>

<style type="text/css">
<!-- 
 .row_ok{ color: green ;}
 .row_blank{ color: navy ;} 
 .row_error{ color: red ;} 
-->
</style>	
	<% out.println("<jsp:include page=\"/include-page/js/jquery-js.jsp\" flush=\"true\" />"); %>
  <% out.print("<jsp:include page =\"/include-page/common/main-head-js.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
</head>
<body class="<\%=menuTypeClass %> <\%=SiMngrBn.LoginRole %>" onload="InitPage()" >

  <% out.print("<jsp:include page =\"/admin/include-page/nav-body.jsp\" >"); %>	
	 	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
  <% out.print("<jsp:include page =\"/admin/include-page/menu-body.jsp\" >"); %>	
	 	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
	 	 <% out.print("<jsp:param name=\"MenuTitle\" value=\"???\" />"); %>
	 	 <% out.print("<jsp:param name=\"MenuLink\" value=\"???\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>	
  <!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
  	  <div class="row">
        <div class="col-sm-6">
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i><\%=PageTitle  %></h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<\%=appPath %>/admin/index.jsp"><i aria-hidden="true" class="icon fa fa-home fa-lg"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active">Excel Import<!-- <\%=PageTitle  %> --></li>
          </ol>			
  	    </div>
  		</div>	

<\% 
if("Form".equalsIgnoreCase(Action))
{ 
%>
<form action="<\%=thisFile %>" method="POST" class="form-horizontal" id="<%=TableName%>_Upload_Form" enctype="multipart/form-data" accept-charset="UTF-8" >
<input type="hidden" name="Action" value="Upload" id="formActionID" />

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class="icon fa fa-upload iccolor" aria-hidden="true"></i>Upload File
		<!-- onclick="NavigateTo('<%=appPath %>/admin/index.jsp')" -->
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	

      <div class="form-group">
        <label for="ExcelFile" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600">Excel File :</label>
        <div class="col-md-4 col-sm-4 col-xs-12"><input type="file" accept=".xls,.xlsx" name="ExcelFile" id="ExcelFile" class="form-control filestyle" data-buttonName="btn-primary" data-iconName="icon fa fa-inbox" data-placeholder="None Selected" enctype="multipart/form-data" title="Please select the excel file."/></div>
      </div>	
	 		<% 
	 		if(bUpdateOnID )
	 		{ 
			%>
      <div class="form-group">
        <label for="UpdateOnIDColumn" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600">Update On Column :</label>
        <div class="col-md-3 col-sm-3 col-xs-12">			
          <span class="checkbox-custom checkbox-inline checkbox-primary">
          <input type="checkbox" name="UpdateOnIDColumn" id="UpdateOnIDColumn" value="TRUE">
          <label for="UpdateOnIDColumn">Excel Col: <\%=HEADER[<%=IDColIndex %>] %></label></span>
				</div>
      </div>	
	 		<% 
	 		} 
	 		%>
			
</div>

<div class="panel-form-box-footer">
		 <div class="col-md-offset-3 col-sm-offset-4" style="padding-left: 15px;">
      <button type="submit" class="btn btn-primary" title="Submit" onclick="{ $('#formActionID').val('Process'); }"><i class="fa fa-check-square-o" aria-hidden="true"></i>&nbsp;Process</button>
      <button type="submit" class="btn btn-primary" title="Submit"><i class="fa fa-upload" aria-hidden="true"></i>&nbsp;Upload</button>
		 </div>	
</div>

<br />
		
    <div class="well well-sm">
    <ul class="list-group list-group-gap" style="margin-bottom: 0px;">
      <li class="list-group-item">
			  <p>			
          <span class="drop-cap"><i aria-hidden="true" class="icon fa fa-download iccolor"></i></span>
  				The easiest and hassle free way would be to download this <a href="???.xlsx"><big><big><b>Sample Excelsheet</b></big></big></a>.
					<br />
					Edit it and upload back to server.
  				<br />
  			  Leave the column header in first row unchanged and from row no 2 onwards fill up your data in column.
			  </p>				
      </li>
    </ul>		
    </div>			


</div>
</form>

<\% 
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
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="NavigateTo('<\%=thisFile %>?Action=Form')"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

<div class="well well-sm well-success">
<big><i class="icon fa fa-check" aria-hidden="true"></i>&nbsp;( <\%=nLastIndx %> ) rows ( excluding header row )</big>
<br />
<big><i class="icon fa fa-check" aria-hidden="true"></i>&nbsp;<\%=FileName %>  ( <\%=ShowSize %> )</big>
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
    <\% for(String headername : HEADER) {%>
    <th><\%=headername %></th>
    <\% } %>
    </thead>
    <tbody>

<\%
  int nErrorP=0, nBlankP=0;
	// for all rows in spread-sheet
	for(int idx=1; idx <= nLastIndx ; idx++ )
	{
    int RowNo = idx+1;
%>
    <tr>
    <td><\%=RowNo %></td>
<\%
Row datarow = sheet.getRow(idx) ;
if(datarow==null)
{
%>
    <td><span class="row_blank">Blank Row</span></td>
    <td>&nbsp;</td>
    </tr>
<\%
nBlankP++;
continue ;	
}					
// Local try catch for individual rows
try
{
%>
    <td><span class="row_ok"><i class="fa fa-check-square-o fa-lg" aria-hidden="true"></i></span></td>
<\%
<% 
Iterator<String> itr_fld1 = col_list.iterator() ; 
int n3=0;
while(itr_fld1.hasNext())
{
String st = itr_fld1.next();
String varname = st.trim();
varname = ReplaceInvalidChar(varname);
String dbField2 = request.getParameter(varname);
int nSQLtype =  ((Integer)FldMap.get(dbField2)).intValue();
													 
													 switch(nSQLtype)
													 {
													   case java.sql.Types.TINYINT:
%>  byte bt<%=varname %> = (byte)POIHelper.getNumberFromCell(datarow.getCell(<%=n3 %>, Row.CREATE_NULL_AS_BLANK));
														 <%
														 break;
													    
													   case java.sql.Types.SMALLINT :
%>  short n<%=varname %> = (short)POIHelper.getNumberFromCell(datarow.getCell(<%=n3 %>, Row.CREATE_NULL_AS_BLANK));
														 <%
														 break;
													   
														 case java.sql.Types.INTEGER:
%>  int n<%=varname %> = (int)POIHelper.getNumberFromCell(datarow.getCell(<%=n3 %>, Row.CREATE_NULL_AS_BLANK));
														 <%
														 break;
													   
														 case java.sql.Types.BIGINT :
%>  long n<%=varname %> = (long)POIHelper.getNumberFromCell(datarow.getCell(<%=n3 %>, Row.CREATE_NULL_AS_BLANK));
														 <%
														 break;
													   
														 case java.sql.Types.FLOAT :
%>  float n<%=varname %> = (float)POIHelper.getNumberFromCell(datarow.getCell(<%=n3 %>, Row.CREATE_NULL_AS_BLANK));
														 <%
														 break;												 
														 
														 case java.sql.Types.DOUBLE :
														 case java.sql.Types.REAL:
%>  double n<%=varname %> = POIHelper.getNumberFromCell(datarow.getCell(<%=n3 %>, Row.CREATE_NULL_AS_BLANK));
														 <%
														 break;
													   
														 case java.sql.Types.DECIMAL :
														 case java.sql.Types.NUMERIC :
%>  BigDecimal bd<%=varname %> = new BigDecimal( POIHelper.getNumberFromCell(datarow.getCell(<%=n3 %>, Row.CREATE_NULL_AS_BLANK)));
														 <%
														 break;
													   
														 case java.sql.Types.CHAR:
														 case java.sql.Types.VARCHAR :
														 case java.sql.Types.LONGVARCHAR:
														 case java.sql.Types.CLOB:
%>  String str<%=varname %> = POIHelper.getStringFromCell(datarow.getCell(<%=n3 %>, Row.CREATE_NULL_AS_BLANK));
														 <%
														 break;
													   
														 case java.sql.Types.DATE :
%>  java.sql.Date dt<%=varname %> = POIHelper.getDateFromCell(datarow.getCell(<%=n3 %>, Row.CREATE_NULL_AS_BLANK));
														 <%
														 break;
													   
														 case java.sql.Types.TIME :
%>  java.sql.Time tm<%=varname %> = POIHelper.getDateFromCell(datarow.getCell(<%=n3 %>, Row.CREATE_NULL_AS_BLANK));
														 <%
														 break;
													   
														 case java.sql.Types.TIMESTAMP :													   
%>  Cell ts_cell = datarow.getCell(<%=n3 %>, Row.CREATE_NULL_AS_BLANK) ;
														 <%
														 break;
														 
														 case java.sql.Types.BINARY :
														 case java.sql.Types.VARBINARY:
														 case java.sql.Types.LONGVARBINARY:
														 case java.sql.Types.BLOB:
														 %>

														 <%
														 break;
														 
														 default:
%>  String str<%=varname %> = POIHelper.getStringFromCell(datarow.getCell(<%=n3 %>, Row.CREATE_NULL_AS_BLANK));
														 <%
														 break;
													 
													 } // end case
													 
													 n3++;
												}
											 %>						
							%>
	
											<% 
											  Iterator<String> itr_fld2 = col_list.iterator() ; 
												int n4=0;
							          while(itr_fld2.hasNext())
												{
												   String st = itr_fld2.next();
													 String varname = st.trim();
													 varname = ReplaceInvalidChar(varname);
													 String dbField2 = request.getParameter(varname);
													 int nSQLtype =  ((Integer)FldMap.get(dbField2)).intValue();
													 
													 switch(nSQLtype)
													 {
													   case java.sql.Types.TINYINT:
														 %><td><\%=bt<%=varname %> %></td>
														 <%
														 break;
													    
													   case java.sql.Types.SMALLINT :
														 %><td><\%=n<%=varname %> %></td>
														 <%
														 break;
													   
														 case java.sql.Types.INTEGER:
														 %><td><\%=n<%=varname %> %></td>
														 <%
														 break;
													   
														 case java.sql.Types.BIGINT :
														 %><td><\%=n<%=varname %> %></td>
														 <%
														 break;
													   
														 case java.sql.Types.FLOAT :
														 %><td><\%=n<%=varname %> %></td>
														 <%
														 break;												 
														 
														 case java.sql.Types.DOUBLE :
														 case java.sql.Types.REAL:
														 %><td><\%=n<%=varname %> %></td>
														 <%
														 break;
													   
														 case java.sql.Types.DECIMAL :
														 case java.sql.Types.NUMERIC :
														 %><td><\%=bd<%=varname %> %></td>
														 <%
														 break;
													   
														 case java.sql.Types.CHAR:
														 case java.sql.Types.VARCHAR :
														 case java.sql.Types.LONGVARCHAR:
														 case java.sql.Types.CLOB:
														 %><td><\%=str<%=varname %> %></td>
														 <%
														 break;
													   
														 case java.sql.Types.DATE :
														 %><td><\%=dt<%=varname %> %></td>
														 <%
														 break;
													   
														 case java.sql.Types.TIME :
														 %><td><\%=tm<%=varname %> %></td>
														 <%
														 break;
													   
														 case java.sql.Types.TIMESTAMP :													   
														 %><td><\%=ts_cell %></td>
														 <%
														 break;
														 
														 case java.sql.Types.BINARY :
														 case java.sql.Types.VARBINARY:
														 case java.sql.Types.LONGVARBINARY:
														 case java.sql.Types.BLOB:
														 %>

														 <%
														 break;
														 
														 default:
														 %><td><\%=str<%=varname %> %></td>
														 <%
														 break;
													 
													 } // end case
													 n4++;
												}
											 %>		
    </tr>
<\%
}
catch(Exception row_ex)
{
%>
    <td><span class="row_error">Error :</span></td>
    <td><\%=row_ex.getMessage() %></td>
    <td>Cancelled.</td>
    </tr>
<\%
nErrorP++;
}						   				
}// end main for loop (int idx=1; idx <= nLastIndx ; idx++ )
%>
<script type="text/javascript">
<!--
//Process Action
								 $("#ERRORSP").html("<\%=nErrorP %>");
								 $("#BLANKP").html("<\%=nBlankP %>");



// -->
</script>
</tbody>
</table>
<\%
   } 
   catch(Exception ex)
   {
 %>
   <div style="padding:1em;">
    <span class="error">File Upload Error:</span><br>
		<\%=ExceptionHelper.showException(ex, "exception_div") %>
   </div><!-- end error block padding div -->
  
<\% 
   } // end main outer try catch block
%>

</div>

<div class="panel-form-box-footer">
<a href="<\%=thisFile %>?Action=Form">Try another upload...</a>
</div>

</div>
<\% 
}
else if("Upload".equalsIgnoreCase(Action))
{ 
%>
<\% 
// Main outer try catch block
    ResinFileUpload RsUpload = new ResinFileUpload() ;
    RsUpload.load( application,request, "ExcelFile" ) ;
    String FileName = RsUpload.getFileName();
    String FileExt = RsUpload.getFileExt();
    String MimeType = RsUpload.getMimeType();
    int nSize = RsUpload.getFileSize();
    String ShowSize = NumberHelper.showByteSize((long)nSize);
		boolean bUpdateOnIDCol = false; 
		<% 
		if( bUpdateOnID ) 
    { 
		%>
		String UpdateOnIDColumn = request.getParameter("UpdateOnIDColumn");
		bUpdateOnIDCol = ( UpdateOnIDColumn!=null && "TRUE".equalsIgnoreCase(UpdateOnIDColumn))? true : false;
    <% 
		} 
		%>
		
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
					
					// DEBUG IDField : <%=IDTableCol %> IDColIndex: <%=IDColIndex  %>
					
				  %>

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class="icon fa fa-file-excel-o iccolor" aria-hidden="true"></i>&nbsp;&nbsp;Upload Result
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="NavigateTo('<\%=thisFile %>?Action=Form')"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	

<div class="well well-sm well-success">
<big><i class="icon fa fa-check" aria-hidden="true"></i>&nbsp;( <\%=nLastIndx %> ) rows ( excluding header row )</big>
<br />
<big><i class="icon fa fa-check" aria-hidden="true"></i>&nbsp;<\%=FileName %>  ( <\%=ShowSize %> )</big>
</div>

<table class="table table-bordered table-striped Rslt-Act-tbl">
  <tr><td class="col-sm-2">Inserted:</td><td><span id="INSERTED"></span></td></tr>
<% 
if( bUpdateOnID ) 
{ 
%>
  <tr><td class="col-sm-2">Updated:</td><td><span id="UPDATED"></span> </td></tr>  
<% 
} 
%>
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

					
					<\%
					  int nInsert=0, nUpdate=0, nError=0, nBlank=0;
	          GenericQuery genqry = new GenericQuery(ApplicationResource.database, application);
						// Alternate: genqry = new GenericQuery("<% out.print(JNDIDSN); %>", application); 
	          java.sql.Connection conn = genqry.Connect();
						com.webapp.utils.PortableSQL psql = new com.webapp.utils.PortableSQL(conn);
						 <%
						  
						 
						  StringBuilder sbQry1 =  new StringBuilder(" INSERT INTO `"+TableName+"` ( ") ;
							StringBuilder sbQry2 =  new StringBuilder(" VALUES ( ") ;
							StringBuilder sbUpd  =  new StringBuilder(" UPDATE `"+TableName+"` SET ") ;
						  Iterator<String> itr_sql = col_list.iterator() ; 
							int n1=0; 
							while(itr_sql.hasNext()) 
							{   
							   String st = itr_sql.next(); 
								 String elm= st.trim();
								 elm = ReplaceInvalidChar(elm);
								 
								 if(n1>0)
								 {
								   sbQry1.append(", ");
									 sbQry2.append(", ");
									 sbUpd.append(", "); 
								 }
								 String dbField = request.getParameter(elm);
								 
								 sbQry1.append("`"+dbField+"`");
								 sbQry2.append("?");
								 sbUpd.append("`"+dbField+"` = ? ");
								 n1++;
							}	 
							
							   sbQry1.append(" ) ");
								 sbQry2.append(" ) ");
								 
								  sbUpd.append(" WHERE `"+IDTableCol+"` = ? ");
								  
							%>  
 						   String InsQry = " <%=sbQry1.toString() %>  <%=sbQry2.toString() %>  " ;
						   PreparedStatement stmtIns = conn.prepareStatement(psql.SQL(InsQry));
							<% 
		          if( bUpdateOnID ) 
              { 
		          %>
							String UpdQry = " <%=sbUpd.toString() %> ";		
							PreparedStatement stmtUpd = conn.prepareStatement(psql.SQL(UpdQry));
							
							String FindQry = " SELECT COUNT(*) FROM `<%=TableName %>` WHERE `<%=IDTableCol %>` = ? ";
							PreparedStatement stmtFind = conn.prepareStatement(psql.SQL(FindQry));
		          <% 
		          } 
		         %>
						 
						 
						 
						 
            // for all rows in spread-sheet
						for(int idx=1; idx <= nLastIndx ; idx++ )
            {
						      int RowNo = idx+1;
						      %><tr><td><\%=RowNo %></td><\%
                  Row datarow = sheet.getRow(idx) ;
        					if(datarow==null)
                  {
									   %><td><span class="row_blank">Blank Row</span></td><td valign="top">&nbsp;</td><td>&nbsp;</td></tr><\%
                      nBlank++;
        							continue ;	
                  }					
                  // Local try catch for individual rows
                  try
                  {
									    //Enter excel row data into table here...
											String RowData = POIHelper.getStringFromCell(datarow.getCell(0, Row.CREATE_NULL_AS_BLANK)) ;
											
											<% 
											  Iterator<String> itr_fld = col_list.iterator() ; 
												int WhrIdx = col_list.size()+1;
												int n2=0;
							          while(itr_fld.hasNext())
												{
												   String st = itr_fld.next();
													 
													 String varname = st.trim();
													 varname = ReplaceInvalidChar(varname);
													 String dbField2 = request.getParameter(varname);
													 
													   
													 // Old Code int nSQLtype = Integer.parseInt(request.getParameter(st+".FieldType"));
													// String sql_col = 
													 int nSQLtype =  ((Integer)FldMap.get(dbField2)).intValue();
													 
													 %>
													 
													 <%
													 
													 switch(nSQLtype)
													 {
													 
													   case java.sql.Types.TINYINT:
														 %>byte bt<%=varname %> = (byte)POIHelper.getNumberFromCell(datarow.getCell(<%=n2 %>, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setByte( <%=n2+1 %> , bt<%=varname %> ) ; 
															  <% 
															  if( bUpdateOnID ) { 
															  %> 
															  if( bUpdateOnIDCol )
																{
															  <%  
																} 
																%>
															 <% if( bUpdateOnID ) { %>   stmtUpd.setByte( <%=n2+1 %> , bt<%=varname %> ) ;  <%  } %> 
															 <% if( bUpdateOnID == true && n2 == IDColIndex ) { %>   stmtUpd.setByte( <%=WhrIdx %> , bt<%=varname %> ) ;  stmtFind.setByte(1 , bt<%=varname %> );        <% } %> 
															  <% 
																if( bUpdateOnID ) 
																{ 
																%> 
																} 
																<%  
																} 
																%>
															 
														 <%
														 break;
													    
													   case java.sql.Types.SMALLINT :
														 %>short n<%=varname %> = (short)POIHelper.getNumberFromCell(datarow.getCell(<%=n2 %>, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setShort( <%=n2+1 %> , n<%=varname %> ) ; 
															  <% 
																if( bUpdateOnID ) 
																{ 
																%> 
															  if( bUpdateOnIDCol )
																{
															  <%  
																} 
																%>
															 <% if( bUpdateOnID ) { %> stmtUpd.setShort( <%=n2+1 %> , n<%=varname %> ) ;   <%  } %> 
															 <% if( bUpdateOnID == true && n2 == IDColIndex ) { %> stmtUpd.setShort( <%=WhrIdx %> , n<%=varname %> ) ; stmtFind.setShort(1 , n<%=varname %> ) ;  <% } %> 
														    <% 
																if( bUpdateOnID ) 
																{ 
																%> 
																} 
																<%  
																} 
																%>
														 <%
														 break;
													   
														 case java.sql.Types.INTEGER:
														 %>int n<%=varname %> = (int)POIHelper.getNumberFromCell(datarow.getCell(<%=n2 %>, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setInt( <%=n2+1 %> , n<%=varname %> ) ; 
															  <% 
																if( bUpdateOnID ) 
																{ 
																%> 
															  if( bUpdateOnIDCol )
																{
															  <%  
																} 
																%>
															 <% if( bUpdateOnID ) { %> stmtUpd.setInt( <%=n2+1 %> , n<%=varname %> ) ;   <%  } %> 
															 <% if( bUpdateOnID == true && n2 == IDColIndex ) { %> stmtUpd.setInt( <%=WhrIdx %> , n<%=varname %> ) ; stmtFind.setInt(1 , n<%=varname %> ) ; <% } %> 
															  <% 
																if( bUpdateOnID ) 
																{ 
																%> 
																} 
																<%  
																} 
																%>
														 <%
														 break;
													   
														 case java.sql.Types.BIGINT :
														 %>long n<%=varname %> = (long)POIHelper.getNumberFromCell(datarow.getCell(<%=n2 %>, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setLong( <%=n2+1 %> , n<%=varname %> ) ;
															<% 
																if( bUpdateOnID ) 
																{ 
																%> 
															  if( bUpdateOnIDCol )
																{
															  <%  
																} 
																%>
															 <% if( bUpdateOnID ) { %> stmtUpd.setLong( <%=n2+1 %> , n<%=varname %> ) ;  <%  } %> 
															 <% if( bUpdateOnID == true && n2 == IDColIndex ) { %> stmtUpd.setLong( <%=WhrIdx %> , n<%=varname %> ) ; stmtFind.setLong( 1 , n<%=varname %> ) ;  <% } %> 
														    <% 
																if( bUpdateOnID ) 
																{ 
																%> 
																} 
																<%  
																} 
																%>
														 <%
														 break;
													   
														 case java.sql.Types.FLOAT :
														 %>float n<%=varname %> = (float)POIHelper.getNumberFromCell(datarow.getCell(<%=n2 %>, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setFloat( <%=n2+1 %> , n<%=varname %> ) ; 
															 <% 
																if( bUpdateOnID ) 
																{ 
																%> 
															  if( bUpdateOnIDCol )
																{
															  <%  
																} 
																%>
															 <% if( bUpdateOnID ) { %>  stmtUpd.setFloat( <%=n2+1 %> , n<%=varname %> ) ;   <%  } %> 
															 <% if( bUpdateOnID == true && n2 == IDColIndex ) { %>  stmtUpd.setFloat( <%=WhrIdx %> , n<%=varname %> ) ; stmtFind.setFloat( 1 , n<%=varname %> ) ;  <% } %> 
														   <% 
																if( bUpdateOnID ) 
																{ 
																%> 
																} 
																<%  
																} 
																%>
														 <%
														 break;
														 
														 
														 case java.sql.Types.DOUBLE :
														 case java.sql.Types.REAL:
														 %>double n<%=varname %> = POIHelper.getNumberFromCell(datarow.getCell(<%=n2 %>, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setDouble( <%=n2+1 %> , n<%=varname %> ) ; 
															  <% 
																if( bUpdateOnID ) 
																{ 
																%> 
															  if( bUpdateOnIDCol )
																{
															  <%  
																} 
																%>
															 <% if( bUpdateOnID ) { %> stmtUpd.setDouble( <%=n2+1 %> , n<%=varname %> ) ;   <%  } %> 
															 <% if( bUpdateOnID == true && n2 == IDColIndex ) { %> stmtUpd.setDouble( <%=WhrIdx %> , n<%=varname %> ) ; stmtFind.setDouble(1 , n<%=varname %> ) ;  <% } %> 
	                              <% 
																if( bUpdateOnID ) 
																{ 
																%> 
																} 
																<%  
																} 
																%>
														 <%
														 break;
													   
														 case java.sql.Types.DECIMAL :
														 case java.sql.Types.NUMERIC :
														 %>BigDecimal bd<%=varname %> = new BigDecimal( POIHelper.getNumberFromCell(datarow.getCell(<%=n2 %>, Row.CREATE_NULL_AS_BLANK)));
															 stmtIns.setBigDecimal( <%=n2+1 %> , bd<%=varname %> ) ; 
															 <% 
																if( bUpdateOnID ) 
																{ 
																%> 
															  if( bUpdateOnIDCol )
																{
															  <%  
																} 
																%>
															 <% if( bUpdateOnID ) { %> stmtUpd.setBigDecimal( <%=n2+1 %> , bd<%=varname %> ) ;   <%  } %> 
															 <% if( bUpdateOnID == true && n2 == IDColIndex ) { %>  stmtUpd.setBigDecimal( <%=WhrIdx %> , bd<%=varname %> ) ; stmtFind.setBigDecimal(1 , bd<%=varname %> ) ; <% } %> 
														    <% 
																if( bUpdateOnID ) 
																{ 
																%> 
																} 
																<%  
																} 
																%>
														 <%
														 break;

													   
														 case java.sql.Types.CHAR:
														 case java.sql.Types.VARCHAR :
														 case java.sql.Types.LONGVARCHAR:
														 case java.sql.Types.CLOB:
														 
														 %>String str<%=varname %> = POIHelper.getStringFromCell(datarow.getCell(<%=n2 %>, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setString( <%=n2+1 %> , str<%=varname %> ) ; 
															  <% 
																if( bUpdateOnID ) 
																{ 
																%> 
															  if( bUpdateOnIDCol )
																{
															  <%  
																} 
																%>
															 <% if( bUpdateOnID ) { %>  stmtUpd.setString( <%=n2+1 %> , str<%=varname %> ) ;   <%  } %> 
															 <% if( bUpdateOnID == true && n2 == IDColIndex ) { %>  stmtUpd.setString( <%=WhrIdx %> , str<%=varname %> ) ; stmtFind.setString(1 , str<%=varname %> ) ;  <% } %> 
														    <% 
																if( bUpdateOnID ) 
																{ 
																%> 
																} 
																<%  
																} 
																%>
														 <%
														 break;
													   
														 case java.sql.Types.DATE :
														 %>java.sql.Date dt<%=varname %> = POIHelper.getDateFromCell(datarow.getCell(<%=n2 %>, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setDate( <%=n2+1 %> , dt<%=varname %> ) ; 
															 <% 
																if( bUpdateOnID ) 
																{ 
																%> 
															  if( bUpdateOnIDCol )
																{
															  <%  
																} 
																%>
															 <% if( bUpdateOnID ) { %> stmtUpd.setDate( <%=n2+1 %> , dt<%=varname %> ) ;   <%  } %>
															 <% if( bUpdateOnID == true && n2 == IDColIndex ) { %> stmtUpd.setDate( <%=WhrIdx %> , dt<%=varname %> ) ;  stmtFind.setDate(1 , dt<%=varname %> ) ;   <% } %> 
														    <% 
																if( bUpdateOnID ) 
																{ 
																%> 
																} 
																<%  
																} 
																%>
														
														 <%
														 break;
													   
														 case java.sql.Types.TIME :
														 %>java.sql.Time tm<%=varname %> = POIHelper.getDateFromCell(datarow.getCell(<%=n2 %>, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setTime( <%=n2+1 %> , tm<%=varname %> ) ;
															 <% 
																if( bUpdateOnID ) 
																{ 
																%> 
															  if( bUpdateOnIDCol )
																{
															  <%  
																} 
																%>
															 <% if( bUpdateOnID ) { %> stmtUpd.setTime( <%=n2+1 %> , tm<%=varname %> ) ;  <%  } %>  
															 <% if( bUpdateOnID == true && n2 == IDColIndex ) { %> stmtUpd.setTime( <%=WhrIdx %> , tm<%=varname %> ) ; stmtFind.setTime( 1 , tm<%=varname %> ) ;  <% } %> 
														   <% 
																if( bUpdateOnID ) 
																{ 
																%> 
																} 
																<%  
																} 
																%>
														 <%
														 break;
													   
														 case java.sql.Types.TIMESTAMP :
														   
														 %>  Cell ts_cell = datarow.getCell(<%=n2 %>, Row.CREATE_NULL_AS_BLANK) ;
																 if(ts_cell.getCellType()==Cell.CELL_TYPE_NUMERIC && DateUtil.isCellDateFormatted(ts_cell) )
		                             {
		                                 java.util.Date dt = ts_cell.getDateCellValue() ;
																		 java.sql.Timestamp ts = new java.sql.Timestamp(dt.getTime);
																		 stmtIns.setTimestamp( <%=n2+1 %> , ts ) ; 
																		   <% 
																            if( bUpdateOnID ) 
																            { 
																       %> 
															               if( bUpdateOnIDCol )
																             {
															         <%  
																            } 
																       %>
																		 
																		 <% if( bUpdateOnID ) { %> stmtUpd.setTimestamp( <%=n2+1 %> , ts ) ;   <%  } %> 
																		 <% if( bUpdateOnID == true && n2 == IDColIndex ) { %> stmtUpd.setTimestamp( <%=WhrIdx %> , ts ) ; stmtFind.setTimestamp(1 , ts );  <% } %> 
		                            
																     <% 
																      if( bUpdateOnID ) 
																      { 
																         %> 
																       } 
																      <%  
																      } 
																     %>
														
																 } 
																 else
																 {
																    stmtIns.setNull(<%=n2+1 %>, java.sql.Types.TIMESTAMP);
																		 <% 
																            if( bUpdateOnID ) 
																            { 
																       %> 
															               if( bUpdateOnIDCol )
																             {
															         <%  
																            } 
																       %>
																		<% if( bUpdateOnID ) { %> stmtUpd.setNull(<%=n2+1 %>, java.sql.Types.TIMESTAMP);  <%  } %> 
																		<% if( bUpdateOnID == true && n2 == IDColIndex  ) { %> stmtUpd.setNull(<%=WhrIdx %>, java.sql.Types.TIMESTAMP);  stmtUpd.setNull(1, java.sql.Types.TIMESTAMP);  <%  } %> 

																		<% 
																      if( bUpdateOnID ) 
																      { 
																         %> 
																       } 
																      <%  
																      } 
																     %>
																 }
														 <%
														 break;
														 
														 case java.sql.Types.BINARY :
														 case java.sql.Types.VARBINARY:
														 case java.sql.Types.LONGVARBINARY:
														 case java.sql.Types.BLOB:
														 
														 %>
														    stmtIns.setNull(<%=n2+1 %>, java.sql.Types.BLOB);
																 <% 
																 if( bUpdateOnID ) 
																 { 
																 %> 
															    if( bUpdateOnIDCol )
																  {
															   <%  
																 } 
																 %>
																<% if( bUpdateOnID ) { %> stmtUpd.setNull(<%=n2+1 %>, java.sql.Types.BLOB);  <%  } %> 
																<% if( bUpdateOnID == true && n2 == IDColIndex  ) { %> stmtUpd.setNull(<%=WhrIdx %>, java.sql.Types.BLOB); stmtFind.setNull(1, java.sql.Types.BLOB);  <% } %> 
														    <% 
																if( bUpdateOnID ) 
																{ 
																%> 
																   } 
																<%  
																} 
																%>
														 <%
														 break;
														 
														 default:
														 %>String str<%=varname %> = POIHelper.getStringFromCell(datarow.getCell(<%=n2 %>, Row.CREATE_NULL_AS_BLANK));
															 stmtIns.setString( <%=n2+1 %> , str<%=varname %> ) ; 
															  <% 
																 if( bUpdateOnID ) 
																 { 
																 %> 
															    if( bUpdateOnIDCol )
																  {
															   <%  
																 } 
																 %>
															 <% if( bUpdateOnID ) { %> stmtUpd.setString( <%=n2+1 %> , str<%=varname %> ) ;   <%  } %> 
															 <% if( bUpdateOnID == true && n2 == IDColIndex  ) { %> stmtUpd.setString( <%=WhrIdx %> , str<%=varname %> ) ; stmtFind.setString( 1 , str<%=varname %> ) ; <% } %> 
														    <% 
																if( bUpdateOnID ) 
																{ 
																%> 
																   } 
																<%  
																} 
																%>
														 <%
														 break;
													 
													 } // end case
													 
													 n2++;
												}
											
											 %>
											%><td><span class="row_ok"><i class="fa fa-check-square-o fa-lg" aria-hidden="true"></i></span></td>
											<td valign="top"><\%=RowData %></td>
											<\%
											<% 
											if( bUpdateOnID )
											{ 
											%>
											   int nRecCount = 0;
												 if(bUpdateOnIDCol) 
												 {
  												 java.sql.ResultSet rsFind = stmtFind.executeQuery();
  												 if(rsFind!=null && rsFind.next()) nRecCount = rsFind.getInt(1);
												   if(nRecCount > 0 ) 
												   {												   
												    stmtUpd.executeUpdate();
													  nUpdate++;
														%><td>Record Updated</td><\%
													 }
  												 else 
  												 {
  												    stmtIns.executeUpdate();
  													  nInsert++;
  														%><td>Record Inserted</td><\%
  											   }
													 
												 }
												 else 
												 {
												    stmtIns.executeUpdate();
													  nInsert++;
														%><td>Record Inserted</td><\%
											   }
											
											<% 
											}
											else
											{ 
											%>
											  stmtIns.executeUpdate();
												%><td>Record Inserted</td><\%
												nInsert++;
											<% 
											} 
											 %>
									    %>
											</tr>
											<\%
                  }
                  catch(Exception row_ex)
                  {
									     %><td><span class="row_error">Error:</span></td> <td valign="top"><\%=row_ex.getMessage() %></td><td>Cancelled.</td></tr><\%
        					     nError++;
                  }						   
						
					  }// end main for loop (int idx=1; idx <= nLastIndx ; idx++ )
						stmtIns.close();
						<% 
		        if( bUpdateOnID ) 
            { 
		        %>
		           stmtFind.close();
							 stmtUpd.close();
            <% 
		        } 
		        %>
						genqry.Disconnect(conn);
						%>

<script type="text/javascript">
<!--
//upload Action

                 $("#INSERTED").html("<\%=nInsert %>");
								 <% 
		              if( bUpdateOnID ) 
                   { 
		            %>
		              $("#UPDATED").html("<\%=nUpdate %>");
                  <% 
		                } 
		              %>
								 $("#ERRORS").html("<\%=nError %>");
								 $("#BLANK").html("<\%=nBlank %>");

// -->
</script>
              </tbody>
						  </table>
							
							
<\%
   } 
   catch(Exception ex)
   {
 %>
   <div style="padding:1em;">
    <span class="error">File Upload Error:</span><br>
		<\%=ExceptionHelper.showException(ex, "exception_div") %>
   </div><!-- end error block padding div -->
  
<\% 
   } // end main outer try catch block
	 // Delete the upload file when done
	 ResinFileUpload.deleteUploadFile(request, "ExcelFile");
 %>
</div>

<div class="panel-form-box-footer">
<a href="<\%=thisFile %>?Action=Form">Try another upload...</a>
</div>

</div>

<\% 
}
else
{
%>
<div class="well well-sm well-danger">
  Error: The page is invoked with invalid action parameter.
</div>
<\% 
} 
%>

</div><!-- main div end #maindiv -->

</div><!--   div end .page_container -->

	<% out.print("<jsp:include page =\"/admin/include-page/footer.jsp\" flush=\"true\" />"); %>
	 
  <% out.print("<jsp:include page =\"/include-page/js/main-js.jsp\" >"); %>	
  	 <% out.print("<jsp:param name=\"menuType\" value=\"<"+"%=menuType %"+">\" />"); %>
  <% out.print("</jsp:include>\r\n"); %>
  <% out.print("<jsp:include page =\"/include-page/js/bootstrap-select-js.jsp\" flush=\"true\" />"); %>
  <% out.print("<jsp:include page =\"/include-page/js/bootstrap-datepicker-js.jsp\" flush=\"true\" />"); %>
	<% out.println("<jsp:include page=\"/include-page/js/formValidation-js.jsp\" flush=\"true\" />"); %>
	<% out.println("<jsp:include page=\"/include-page/js/bootstrap-filestyle-js.jsp\" flush=\"true\" />"); %>
<script>
<\% 
if(MessageText!=null)
{ 
	String Notify = MessageText.replace("\n","<br/>").replace("\r","");
%>
	toastr.success('<\%= Notify %>');
<\% 
} 
%> 

function InitPage()
{
// Do something on page init
}

$(document).ready(function(){

    $('#<%=TableName%>_Upload_Form').formValidation({
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
<% 
}
catch(Exception ex)
{
 %>

<%
} 
// Delete upload file when done
// ResinFileUpload.deleteUploadFile(request, "ExcelFile"); 
File file_obj = new File(UploadedFile);
file_obj.delete();
%>