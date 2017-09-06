<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.beanwiz.* "%>
<%@ page import="java.io.*,  java.util.*,  java.text.*, java.sql.*, javax.sql.*, javax.naming.* , com.webapp.utils.*, com.webapp.resin.*, com.webapp.jsp.*, com.webapp.poi.*, org.apache.poi.ss.usermodel.*, org.apache.poi.hssf.usermodel.*, org.apache.poi.xssf.usermodel.* " %>
<%@ page import="org.apache.commons.io.*" %>
<%@ taglib uri="mytag" prefix="dtag" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%!
java.text.DecimalFormat dft = new DecimalFormat("###############");

String IntFromCell(Cell cell)
{
    String ret="";
	  if ( cell.getCellType() == cell.CELL_TYPE_NUMERIC )
	  {
	     ret = dft.format(cell.getNumericCellValue());
	  }
	  else if( cell.getCellType() == cell.CELL_TYPE_STRING )
	  {
	     ret = cell.getStringCellValue();
	  }
    return ret.trim() ;
}
%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;

com.beanwiz.LoggedUser LogUsr  = (com.beanwiz.LoggedUser)session.getAttribute("theWizardUser");
if(LogUsr == null ) LogUsr =  LoginHelper.autoLoginCheck(application,session,request );

String Action = RequestHelper.paramValue(request, "Action" , "Form" );
%>
<!DOCTYPE HTML>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
<jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />	
<title>Insert Data From Excel Into Existing Table</title>	
<jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />		
<jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
</head>
<body>   
<jsp:include page="/user/assets-user/include-page/header-user.jsp" flush="true" />	

<div class="container-fluid">
<div class="row page-header11">
  <div class="col-md-6 col-xs-12">
    <h4 class="page-title11"><i class="fa fa-plug text-primary"></i>&nbsp;&nbsp;<span class="text-muted">Insert Data In Existing T</span></h4>
  </div>
  <div class="col-md-6 col-xs-12">
    <!--  page-header-actions  -->
    <ol class="breadcrumb text-right">
      <li><a href="<%=appPath %>/user/index.jsp"><i class="fa fa-home fa-lg"></i></a></li>
      <li class="active">Insert Data : Existing T</li>
    </ol>
  </div>
</div>
<hr class="pageheaderHR" />	

<div class="row">
<%
if("Form".equalsIgnoreCase(Action))
{
%>

  <div class="col-md-4">
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
  <div class="col-md-8">
      <div class="panel panel-primary">
        <div class="panel-heading">
          <h3 class="panel-title"><i class="fa fa-cogs fa-lg"></i>&nbsp;&nbsp;Manage Insert Data</h3>
        </div>
        <div class="panel-body">

<%
  String TableName = request.getParameter("TableName") ;

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
	 

	  Context env = (Context) new InitialContext().lookup("java:comp/env");
    DataSource source = (DataSource) env.lookup(JNDIDSN);
    Connection conn = source.getConnection();
    com.webapp.utils.PortableSQL psql = new com.webapp.utils.PortableSQL(conn);

    
		Statement stmt = conn.createStatement();
		ResultSet rslt = stmt.executeQuery("SELECT * FROM `"+TableName+"` LIMIT 10");
		ResultSetMetaData rsmd = rslt.getMetaData();
		
		int nCount =  rsmd.getColumnCount();
%>
  <form action="<%=thisFile %>" method="post" id="final_submit" >
  <input type="hidden" name="Action" value="InsertData" />
	<input type="hidden" name="JNDIDSN" value="<%=JNDIDSN %>" />
	<input type="hidden" name="TableName" value="<%=TableName %>" />
	<input type="hidden" name="FILEPATH" value="<%=excel_file_path %>" />

<button type="button" class="btn btn-primary btn-lg btn-block" onclick="checkSubmit()">Ok, Insert Data</button>
<br />

	
<div class="table-responsive">
<table class="table table-striped table-bordered table-condensed">	
<thead>
<tr> 
<th>#</th>
<th>
<span class="checkbox checkbox-inline checkbox-primary">
<input type="checkbox" name="fieldchkth" id="fieldchkth"/>
<label for="fieldchkth">&nbsp;Database Column</label>
</span>

</th>
<th>Type / Size</th>
<th>Excel Column</th>
</tr>
</thead>
<tbody>
<% 
	        Workbook wb = WorkbookFactory.create( new FileInputStream(excel_file_path));
          Sheet sheet = wb.getSheetAt(0);
					Row hrd = sheet.getRow(0);
					int cell_count = hrd.getLastCellNum();
					
					ArrayList<String > ary = new ArrayList<String>() ;
					
					for(int i=0; i< cell_count ; i++)
					{
					    ary.add( POIHelper.getStringFromCell( hrd.getCell(i, Row.CREATE_NULL_AS_BLANK)  ));
					
					}
			   
	        String[] exelfields = ary.toArray(new String[ary.size()]);
	 
	
	 for (int n=0 ; n< nCount ; n++)
	 {
	   String ColName =  rsmd.getColumnName( n+1);
		 int nScale = rsmd.getScale(n+1);
		 int nPres  = rsmd.getPrecision(n+1);
     String ColType =  rsmd.getColumnTypeName(n+1);
     
		 String clsname = "chkbox";
		 
		 boolean bAutoNum =  (rsmd.isAutoIncrement(n+1))? true:false; ;
		 if(bAutoNum ) clsname = "auto_chkbox" ;
		 

	 %>
<tr>
<td ><%=n+1 %> </td>
<td >
<span class="checkbox checkbox-inline checkbox-primary">
<input type="checkbox" class="<%=clsname %>" name="Column[]" value="<%=ColName %>" id="<%=ColName %>_1"/>
<label for="<%=ColName %>_1">&nbsp;<%=ColName %></label>
</span>
<% if(bAutoNum ){ %>&nbsp;&nbsp;<span class="label label-default">AUTO</span> <% } %>
</td>
<td ><%=ColType %> [ <%=nPres  %>, <%=nScale %>   ]</td>
<td >
<select name="<%=ColName %>" id="<%=ColName %>" class="form-control selectpicker">
		   <option value="">-- Not Selected --</option>
		   <% 
			 for(int i =0 ;i < cell_count ; i++)
			 { 
			 
			   String SelStr = "";
				 if(exelfields[i]!=null && exelfields[i].equalsIgnoreCase(ColName)) SelStr = "selected=\"selected\"";
			   
			 
			 
			 
			 %>
			 <option value="<%=i %>" <%=SelStr %>  ><%=exelfields[i] %></option>
			 <% 
			 } 
			 %>
		 
</select> 
</td>
</tr>
<%
}
%>

</tbody>
</table>
</div> 
</form>

        </div>
      </div>			
	</div>
	 
<%
  rslt.close();
	stmt.close();
  conn.close();

} // end /if(JNDIDSN != null)
%>
<% 
}
else if("InsertData".equalsIgnoreCase(Action))
{

  boolean bRepeat = false;
	String Repeat = request.getParameter("Repeat");
	if(Repeat != null && "TRUE".equalsIgnoreCase(Repeat)) bRepeat = true ;
	
	String JNDIDSN = request.getParameter("JNDIDSN");
  String TableName = request.getParameter("TableName") ;
	String FilePath  =  request.getParameter("FILEPATH");
	
	String FlName = "" ;
	if(FilePath != null ) FlName = FilenameUtils.getName(FilePath);
  
	String[] Columns= null;
	if(bRepeat) Columns= RequestHelper.getCsvStringArray(request, "ColumnCSV");
	else Columns = request.getParameterValues("Column[]") ;
	
	
	
	  Context env = (Context) new InitialContext().lookup("java:comp/env");
    DataSource source = (DataSource) env.lookup(JNDIDSN);
    Connection conn = source.getConnection();
    com.webapp.utils.PortableSQL psql = new com.webapp.utils.PortableSQL(conn);

    Statement stmt = conn.createStatement();
		ResultSet rslt = stmt.executeQuery("SELECT * FROM `"+TableName+"` LIMIT 10");
		ResultSetMetaData rsmd = rslt.getMetaData();
		
		TreeMap<String, Integer> mapSqlType = new 	TreeMap<String, Integer>();
		TreeMap<String, Integer> mapColIdx = new 	TreeMap<String, Integer>();
		
		int nRsColCount = rsmd.getColumnCount();
		for(int i = 0; i < nRsColCount ; i++)
		{
		   String nm = rsmd.getColumnName(i+1);
			 int typ = rsmd.getColumnType(i+1);
		   mapSqlType.put(nm, new Integer( typ) );
		}
				 
				  Workbook wb = null;
					if(bRepeat)
					{
					   ResinFileUpload RsUpload = new ResinFileUpload() ;
             RsUpload.load( application,request, "ExcelFile" ) ; 
						 FlName =  RsUpload.getFileName();
					   wb = WorkbookFactory.create(RsUpload.getInputStream());
					}
					else
					{
					  wb = WorkbookFactory.create( new FileInputStream(FilePath));
          }
				 
				  Sheet sheet = wb.getSheetAt(0);
					Row hrd = sheet.getRow(0);
					int cell_count = hrd.getLastCellNum();
					
					ArrayList<String > ary = new ArrayList<String>() ;
					
					for(int i=0; i< cell_count ; i++)
					{
					    ary.add( POIHelper.getStringFromCell( hrd.getCell(i, Row.CREATE_NULL_AS_BLANK)  ));
					
					}
			   
	        String[] exelfields = ary.toArray(new String[ary.size()]);
	
	       StringBuilder insQry = new StringBuilder(" INSERT INTO `"+TableName+"` ( " );
				 
				 StringBuilder SelCols = new StringBuilder();

         if(Columns!=null)
         { 
             int i=0;
             for (String col : Columns)
          	 {
          	    int  exIndex = Integer.parseInt(request.getParameter(col));
          		  mapColIdx.put(col, new Integer(exIndex));
          		        		 
          		  if(i>0)
          		  {
          		    insQry.append(",");
									SelCols.append(",");
          			 
          		  }
          		   insQry.append(" `"+col+"` ");
								 SelCols.append(col);
                 i++;
                    
             } // end inner for
						 
         }  // end  if(Columns!=null)

    insQry.append(") VALUES ( ");
 
  
 int lastRow = sheet.getLastRowNum();
 int nSuccess  =0;
 int nBlank  = 0;
 int nError = 0;


 
 Statement stmtData = conn.createStatement();
 
 %>
 
<div class="col-md-8">
 
<div class="well well-sm">
<b><%=lastRow %></b> data rows ( excluding header row ) processed from file : <b><%=FlName %></b>
</div> 
 
<div class="table-responsive">			
<table class="table table-striped table-bordered table-condensed">
 <thead>
 <tr>
 <th width="6%">Row</th>
 <th width="47%">Error Details</th>
 <th width="47%">Insert Query</th>
 </tr>
 </thead>
 <tbody>
 <%
 
 
 for(int rowno=1 ; rowno <= lastRow ; rowno++)
 {
   // For All Row Begin 
	 
	  
		Row datarow = sheet.getRow(rowno);
		
	  if(datarow ==null || datarow.getLastCellNum()==0)
		{
		   nBlank++;
			 continue ;
		}
		 
	 
	   StringBuilder qry  =  new StringBuilder(insQry.toString()) ;
		 int j=0;
	   if(Columns!=null)
     {
		      for(String col:  Columns )
			    {
			           if(j>0)
          		  {
          		    qry.append(",");
          			 
          		  }
			          int sql_type = mapSqlType.get(col).intValue();
								int col_ind  = mapColIdx.get(col).intValue();
				        
								 Cell cell = datarow.getCell(col_ind, Row.CREATE_NULL_AS_BLANK);
				 
				        switch(sql_type)
				        {
				              case java.sql.Types.BIT:
								      case java.sql.Types.TINYINT:
								      case java.sql.Types.SMALLINT:
								      case java.sql.Types.INTEGER:
								      case java.sql.Types.BIGINT:
											    qry.append(" "+IntFromCell(cell)+" ");
				             
										  break;
											
											case java.sql.Types.FLOAT:
								      case java.sql.Types.REAL:
								      case java.sql.Types.DOUBLE:
								      case java.sql.Types.NUMERIC:
								      case java.sql.Types.DECIMAL:
											     qry.append(" "+POIHelper.getNumberFromCell(cell)+" ");
											break;
											
											case java.sql.Types.CHAR:
								      case java.sql.Types.VARCHAR:
								      case java.sql.Types.NCHAR:
								      case java.sql.Types.NVARCHAR:
											case java.sql.Types.CLOB:
								      case java.sql.Types.NCLOB:
											case java.sql.Types.LONGVARCHAR:
								      case java.sql.Types.LONGNVARCHAR:
											    String val =  POIHelper.getStringFromCell(cell) ;
													val = val.replace("'", "''");
											    qry.append(" '"+val+"' ");
											break;
											
											case java.sql.Types.DATE:
											 java.sql.Date dt = POIHelper.getDateFromCell(cell );
											 if( dt!=null ) qry.append("  '"+dt.toString()+"' ");
											 else  qry.append("  '0000-00-00' ");
											
											break;
											
											case java.sql.Types.TIME:
											
											     java.util.Date tm =null;
	                         if(cell.getCellType()==Cell.CELL_TYPE_NUMERIC && DateUtil.isCellDateFormatted(cell) )
		                       {
		                             tm = cell.getDateCellValue() ;
		                       } 
													 if(tm != null)
													 {
													     qry.append(" '"+( new java.sql.Time(tm.getTime()).toString() )+"' ");
													 }
													 else
													 {
													     qry.append(" '' ");
													 }
											
											
											break;
											
											case java.sql.Types.TIMESTAMP:
											     java.util.Date ts =null;
	                         if(cell.getCellType()==Cell.CELL_TYPE_NUMERIC && DateUtil.isCellDateFormatted(cell) )
		                       {
		                             ts = cell.getDateCellValue() ;
		                       } 
													 if(ts != null)
													 {
													     qry.append(" '"+( new java.sql.Timestamp(ts.getTime()).toString() )+"' ");
													 }
													 else
													 {
													     qry.append(" '' ");
													 }

											break;
											
											case java.sql.Types.BINARY:
								      case java.sql.Types.VARBINARY:								 
								      case java.sql.Types.LONGVARBINARY:		
								      case java.sql.Types.BLOB:	
											   qry.append(" '' ");
											break;
				 
				 
				        } // switch(sql_type)
								
			          j++;
			 
			   } // end inner for
		 
		    qry.append(" ) ");
				
				try
				{
				   stmtData.executeUpdate(qry.toString());
					 nSuccess++;
				}
				catch(Exception e)
				{
				  //out.println("<b>Error: Row:["+rowno+"]: </b> <span style=\"color:red; \" >"+e.getMessage()+"</span><br/>");
					//out.println("<b>Query: Row:["+rowno+"]: </b> "+qry.toString()+"<br/>");
					%>
					<tr>
					   <td><%=rowno+1 %></td>
					   <td><%=e.getMessage() %></td>
						 <td><%=qry.toString() %></td>
					</tr>
					
					<%
					nError++;
				}
				
				// out.println("[ "+rowno+" ] "+qry.toString()+"<br/><br/>");
		
		
		
		 } // end if
	 
   
	 
	 // For All Row End
 
 } // end for(int rowno=1 ; rowno <= lastRow ; rowno++)
 
 %>
 </tbody>
 
</table>
</div> 
<%
 conn.close();
 if(!bRepeat)
 {
    File delFile = new File(FilePath);
    delFile.delete();
 }
  	 String  ColumnCSV = SelCols.toString();
 %>
 
<ul class="list-group">
  <li class="list-group-item"><b>Success : </b><%=nSuccess %></li>
  <li class="list-group-item"><b>Blank Row : </b><%=nBlank %></li>
  <li class="list-group-item"><b>Errors : </b><%=nError %></li>
</ul>

    </div>
    <div class="col-md-4">

<p><a href="<%=thisFile %>?Action=Form" class="btn btn-primary btn-lg btn-block">Try another upload...</a></p>

<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title"><i class="fa fa-cogs fa-lg text-primary"></i>&nbsp;&nbsp;Upload same file in same table as before</h3>
  </div>
  <div class="panel-body">

	<form action="<%=thisFile %>" method="post" enctype="multipart/form-data" id="repeat_form" class="form-horizontal">
	<input type="hidden" name="Action" value="InsertData" />
	<input type="hidden" name="JNDIDSN" value="<%=JNDIDSN %>" />
	<input type="hidden" name="TableName" value="<%=TableName %>" />
	<input type="hidden" name="ColumnCSV" value="<%=ColumnCSV %>" />
	<input type="hidden" name="Repeat" value="TRUE" />
	<% 
	for( Map.Entry<String, Integer> entry : mapColIdx.entrySet() )
  {
     String Ky = (String)entry.getKey();
     Integer Vl = (Integer)entry.getValue();
  %>
	<input type="hidden" name="<%=Ky %>" value="<%=Vl %>" />
	<%	 
  } 
	%>
	
<ul class="list-group">
  <li class="list-group-item"><b>JNDI-DSN : </b><%=JNDIDSN %></li>
  <li class="list-group-item"><b>Table : </b><%=TableName %></li>
</ul>


  <div class="form-group">
    <label for="ExcelFile" class="col-sm-3 control-label">Next File</label>
    <div class="col-sm-9">
      <input type="file" enctype="multipart/form-data" name="ExcelFile" id="ExcelFile" class="form-control"/>
    </div>
  </div>
  <div class="form-group">
    <div class="col-sm-offset-3 col-sm-9">
      <button type="submit" class="btn btn-primary"><i class="fa fa-upload"></i>&nbsp;&nbsp;Upload</button>
    </div>
  </div>
 
<div class="panel panel-default">
  <div class="panel-heading">
    <h3 class="panel-title"><i class="fa fa-cogs fa-lg text-primary"></i>&nbsp;&nbsp;Table Fields</h3>
  </div>
  <div class="panel-body">
    <%=ColumnCSV %>
  </div>
</div> 

  </form>
	
  </div>
</div>

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
</div>
</div> <!-- /container -->
<jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />
<jsp:include page="/scripts/jvalidate/jvalidate.jsp" flush="true" />
<jsp:include page="/assets/include-page/js/nakupanda-modal-js.jsp" flush="true" />
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
	
	$("#repeat_form").validate({
	    rules: 
      {
					ExcelFile:"required" 
      } 
	});

	$("#JNDIDSN_DROP_LIST").change(function(){
	  var val = $(this).val();
		$("#TBL-LIST").load("<%=appPath %>/user/droplist/tables-for-jndi.jsp?JNDIDSN="+val);
	}) ;
});

$("#fieldchkth").click(function () {
        if ($("#fieldchkth").is(':checked')) {
            $(".chkbox").each(function () {
                $(this).prop("checked", true);
            });

        } else {
            $(".chkbox").each(function () {
                $(this).prop("checked", false);
            });
        }
    });


function checkSubmit()
{
   
	 //chkbx
	 var len = $(".chkbox:checked").length ;
 
	 
	 if(len==0)
	 {
	   //alert("Please check some table colums!");
		 swal({title: "<h4>Please check some table colums !</h4>"});
		 return false;
	 }
	 
	 
	  var ok_cnt =0;
		var err_fld = "";
		var dbg = "";
	  $(".chkbox:checked").each(function(index){
		
		   var fld = $(this).val();
			 var vl = $("#"+fld).val();
			// dbg = dbg+"Field:"+fld+" | Value: "+vl;
			 if(vl!=null && vl.length>0)
			 {
			   ok_cnt++;
				 
			 }
			  else
			 {
			   err_fld= err_fld+" "+fld;
			 
			 }
		});
	 
	 if(ok_cnt ==len)
	 {

  swal({
    title: "Are you sure?",
    text: "Insert data in "+len+" selected table fields ?",
    type: "question",
    showCancelButton: true,
    closeOnConfirm: false	
  }).then(function(isConfirm) {
    if (isConfirm === true) {
      $("#final_submit").submit();	
    }
    else if (isConfirm === false) {
      toastr.info('Insert Cancel !');
    }
    else {
      //swal('Any fool can use a computer');
    }
  });

	 }
	 else
	 {
	   //alert("Your have not selected excel colums for \nTable fields: "+err_fld);
		 swal({title: "<h4>Your have not selected excel colums for \nTable fields: "+err_fld+"</h4>"});
	 }
	 
	 //
}

// -->
</script>

<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>
