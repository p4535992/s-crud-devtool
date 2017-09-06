<%@ page import="java.io.*"%><%@ page import="java.util.*"%><%@ page import="javax.servlet.*"%><%@ page import="javax.servlet.http.*"%><%@ page import="java.sql.*, nu.xom.*" %><%@ page import="com.beanwiz.*, com.webapp.jsp.*, com.webapp.utils.*, com.webapp.resin.* " %>
<%@ page import="com.webapp.poi.*, org.apache.poi.ss.usermodel.*, org.apache.poi.hssf.usermodel.*, org.apache.poi.xssf.usermodel.*" %><%!

String ChekRegExp =  "[-\\s\\.\\^\\$\\*\\+\\?\\\\\\(\\)\\[\\{\\|\\}\\]~`!@#%&\\=:;\"'<>,/]" ;
 String ReplaceInvalidChar(String src)
 {
   if(src ==null || src.length()==0) return "";
	 return src.replaceAll(ChekRegExp,"_") ;
 }



%>

<% 

String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath();
    
		String JNDIDSN = request.getParameter("JNDIDSN") ;
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

		
		

 %>
<!DOCTYPE HTML >
<html>
<head>
<title>The Bean Wizard</title>
<link rel="stylesheet" type="text/css" href="<%=appPath %>/style.css" />
<jsp:include page="/scripts/jquery/jquery.jsp" flush="true" />

</head>
<body>
<jsp:include page="/banner.jsp" flush="true" />
<div style="padding:em;">
<% 
    
		
 		
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
					
					
					<table border="1" cellpadding="4" cellspacing="0" summary="" width="100%">
              <tr>
							  <td width="75%"><span class="label">The Uploaded File</span> <span class="item"><%=FileName %></span> </td> 
							 <td width="25%" align="right"><a href="index.jsp">Go Back</a>&nbsp;&nbsp;</td>
							 </tr>
           </table>
					
					<form action="generate-jsp-page.jsp" method="post" target="_blank">
					<input type="hidden" name="UploadedFile" value="<%=UploadedFile %>" />
					<input type="hidden" name="WebAppPkg" value="<%=WebAppPkg %>" />
					<input type="hidden" name="JNDIDSN" value="<%=JNDIDSN %>" />
					<input type="hidden" name="TableName" value="<%=TableName %>" />
					
					
					
          <table  border="1" cellpadding="6" cellspacing="0"  >
          <tr><td>DSN / Table Name</td><td><%=JNDIDSN %> :- <%=TableName %></td></tr>
					<tr><td>Submit</td><td> <button type="submit">Ok Submit</button></td></tr>
          </table>
					Set Table Fields For Column
          <table border="1" cellpadding="6" cellspacing="0" summary="">
					<tr>
					<th valign="top" >Col No.</th>
					<th valign="top" >Excel Column</th>
					<th valign="top" >Table Field</th>
					<th valign="top" ><input type="checkbox"  name="UpdateOnIDField" value="TRUE"/> Update On ID Field</th>
					 
					</tr>
					<%  
					   Iterator<String> it = col_list.iterator() ; 
						 int i=0; 
						 while(it.hasNext()) 
						 {   
						    
						      String ExCol = it.next(); 
									String ElmFld = ExCol+".FieldName";
									String ChkCol = ReplaceInvalidChar(ExCol);
									
									%>
									<tr>
									  <td valign="top" ><%= ( i+1) %></td>
										<td valign="top" ><%= ExCol %></td>
										<td valign="top" >
										<jsp:include page="/user/droplist/fields-for-table.jsp" flush="true">
                           <jsp:param name="ElementName" value="<%=ElmFld %>" />
													 <jsp:param name="JNDIDSN" value="<%=JNDIDSN %>" />
													 <jsp:param name="TableName" value="<%=TableName %>" />
													 <jsp:param name="Select" value="<%=ChkCol  %>" />
													 
                     </jsp:include>
										</td>
										<td>
										  <input type="radio" name="IDField" value="<%=i %>:<%=ElmFld %>" />
										</td>
										
									
									</tr>
									
								 <% 
								 i++;
						 } 
           %>
 
          </table>
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
</body>
</html>
