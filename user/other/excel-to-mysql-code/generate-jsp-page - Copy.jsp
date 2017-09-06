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
        //  if( !POIHelper.checkExcelMIME(RsUpload) ) throw new Exception("The uploaded file ( "+FileName+" ) is not a valid MS Excel File.");
	     
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

 %><\%@ page import="java.io.*, java.sql.*, java.math.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.poi.*, org.apache.poi.ss.usermodel.*, org.apache.poi.hssf.usermodel.*, org.apache.poi.xssf.usermodel.* " %>
<\%@ page import="<%=WebAppPkg %>.*" %>
<\%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<\%
 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
String Action = RequestHelper.paramValue(request, "Action", "Form" ); // Other action Upload

String[] HEADER = { <%  Iterator<String> it = col_list.iterator() ; int i=0; while(it.hasNext()) {   String st = it.next();  if(i> 0) out.print(", "); out.print("\""+st+"\""); i++; }	 %>  } ;

%><!DOCTYPE HTML >
<html>
<head>
<title>Excel To MySQL</title>
<link rel="stylesheet" href="<\%=appPath %>/style.css" type ="text/css" />
<% 
out.println("<jsp:include page=\"/scripts/jquery/jquery.jsp\" flush=\"true\" />") ;
out.println("<jsp:include page=\"/scripts/jvalidate/jvalidate.jsp\" flush=\"true\" />") ; 
%>
<style type="text/css">
<!-- 
 .row_ok{ color: green ;}
 .row_blank{ color: navy ;} 
 .row_error{ color: red ;} 
-->
</style>
<script type="text/javascript">
$(document).ready(function(){

    $("#file_upload_form").validate({
	    rules: 
      {
          ExcelFile:"required"
      } 
    });

	
});  
</script>

</head>
<body>
<\%-- Page Banner if applicable
<% out.print("<jsp:include page=\"/banner.jsp\" flush=\"true\" />"); %>
 --%>
<table border="0" cellpadding="4" cellspacing="0" summary="" width="100%">
<tr>
    <td width="75%" valign="top"><span class="title">Upload data from M.S. Excel file.</span></td>
    <td width="25%" valign="top" align="right" ><a href="<\%=appPath %>/index.jsp">&#x25C4; Go Back</a>&nbsp;&nbsp;</td>
</tr>
</table> 
<div id="maindiv" style="padding:1em;">
<\% 
if("Form".equalsIgnoreCase(Action))
{ 
%>
<form action="<\%=thisFile %>" id="file_upload_form" method="post" enctype="multipart/form-data">
<input type="hidden" name="Action" value="Upload" />
<table border="1" cellpadding="4" cellspacing="0" summary="">
   <tr>
	      <td><span class="label">Select M.S. Excel File</span></td>
				<td><input type="file"  name="ExcelFile" enctype="multipart/form-data" title="Please select the excel file." /></td></tr>
	 <tr>
	 <% 
	 if(bUpdateOnID )
	 { %>
	 <tr>
	      <td><span class="label">Update On ID Column</span></td>
				<td><input type="checkbox" name="UpdateOnIDColumn"  value="TRUE"/> Excel Col: <\%=HEADER[<%=IDColIndex %>] %></td>
	 </tr>
	 <% 
	 } 
	 %>
	 <tr>
	      <td><span class="label">Submit Form</span></td>
        <td><button type="submit">Ok Upload File</button></td>
	 </tr>
</table>
</form>


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
					 <p>Processing <b>( <\%=nLastIndx %> )</b> rows of data ( excluding header row ) from <b>first sheet</b> of <span class="label">M.S.Excel file</span>: <span class="dataitem"><\%=FileName %></span> ( <\%=ShowSize %> ).</p>
					
					 
					  <table border="1" cellpadding="4" cellspacing="0" summary="">
                <tr><td>Inserted:</td><td><span id="INSERTED"></span> </td></tr>
								<% 
		              if( bUpdateOnID ) 
                   { 
		            %>
		             <tr><td>Updated:</td><td><span id="UPDATED"></span> </td></tr>  
            <% 
		                } 
		        %>
								
								<tr><td>Errors:</td><td><span id="ERRORS"></span></td></tr>
								<tr><td>Blank Rows:</td><td><span id="BLANK"></span></td></tr>
              </table>
	
					 <br/>
					 
					  <table border="1" cellpadding="4" cellspacing="0" summary="">
               <thead>
							 <th valign="top">Excel<br/>Row No.</th>
							 <th valign="top">Data Status</th>
							 <th valign="top">Row Data</th>
							 <th valign="top">Update Status</th>
							 </thead>

					
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
						      %><tr><td  valign="top" ><\%=RowNo %></td><\%
                  Row datarow = sheet.getRow(idx) ;
        					if(datarow==null)
                  {
									   %><td  valign="top" ><span class="row_blank">Blank Row</span></td><td valign="top">&nbsp;</td><td>&nbsp;</td></tr><\%
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
											%><td  valign="top" ><span class="row_ok">Data OK</span></td><td valign="top"><\%=RowData %></td><\%
											<% 
											if( bUpdateOnID )
											{ 
											%>
											   int nRecCount = 0;
											   java.sql.ResultSet rsFind = stmtFind.executeQuery();
												 if(rsFind!=null && rsFind.next()) nRecCount = rsFind.getInt(1);
												 if(bUpdateOnIDCol && nRecCount > 0 ) 
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
									     %><td  valign="top" ><span class="row_error">Error:</span></td> <td valign="top"><\%=row_ex.getMessage() %></td><td>Cancelled.</td></tr><\%
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
						  </table>
							<script type="text/javascript">
                <!--
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
  <hr size="1" />
	<p><a href="<\%=thisFile %>?Action=Form">Try another upload...</a></p>
<\% 
}
else
{
 %>
<span class="error">Error:</span> request parameter:- Action not passed properly in page invocation.<br/>
Please report this error to developers.
<\% 
} 

%>
</div>

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