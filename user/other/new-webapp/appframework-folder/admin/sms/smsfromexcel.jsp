<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.appsms.*, com.$WEBAPP.appmail.*, com.db.$DATABASE.*"%> 
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*, org.apache.commons.lang3.* " %>
<%@ page import="com.webapp.jsp.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.resin.*" %>
<%@ page import="com.webapp.poi.*, org.apache.poi.ss.usermodel.*, org.apache.poi.hssf.usermodel.*, org.apache.poi.xssf.usermodel.* " %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<jsp:useBean id="SmsJobBn" scope="page" class="com.db.$DATABASE.Sms_jobsBean" />
<jsp:useBean id="SmsJobLogBn" scope="page" class="com.db.$DATABASE.Sms_joblogBean" />

<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);

com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);

// Create - SMSAccountAuth object in session
SMSAccountAuth AcAuth = SMSAccountAuth.GetOrCreateAccountAuth(application, session );
// List of authorized account(s) as CSV string
String  csvauth= SMSUserAuth.getAccountAuth(AcAuth.getDSN(), "Administrator", LogUsr.AdminID  );
// Set the authorized account SMSAccountAuth object in session.
AcAuth.setFromCSVString(csvauth);

%><!-- CHECK MAIL/SMS SERVICE -->
<%@ include file="/include-page/master/mail-sms-check.inc" %>
<%

StringBuffer ForeignKeyParam = new StringBuffer("");

// Action authorization || Enable : true & Disable : false
boolean bAllowAdd = false ;
boolean bAllowUpdate = false ;
boolean bAllowDelete = false;
%>
<%@include file="/admin/authorization.inc"%>
<%
//override Action authorization
//bAllowDelete = false ;
//bAllowUpdate = true ;
//bAllowAdd = true ;

String Action = RequestHelper.paramValue(request, "Action", "Form");
%>
<%@include file="/admin/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
	<title>SMS from Excel</title>

  <jsp:include page ="/include-page/css/main-css.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>
	
  <jsp:include page ="/include-page/css/bootstrap-select-css.jsp" flush="true" />
	<jsp:include page="/include-page/css/formValidation-css.jsp" flush="true" />
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
	 	 <jsp:param name="MenuTitle" value="SMSTitle" />
	 	 <jsp:param name="MenuLink" value="ExcelSMSLink" />
  </jsp:include>

  <!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
  	  <div class="row">
        <div class="col-sm-6">
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i>SMS from Excel</h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<%=appPath %>/admin/index.jsp"><i aria-hidden="true" class="fa fa-home fa-lg margin-right-5"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active">Excel SMS</li>
          </ol>			
  	    </div>
  		</div>
			
<%
if("Form".equalsIgnoreCase(Action))
{
if(bSMS)
{
%>
  <form action="<%=thisFile %>" id="quick_sms_form" method="post" class="form-horizontal" enctype="multipart/form-data">
	<input type="hidden" name="Action" value="Update" />
	<input type="hidden" name="M" value="<%=nModuleID %>" />
	
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class='fa fa-bookmark iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Excel Upload 
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	
		 
      <div class="form-group">
        <label for="ExcelFile" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600">Excel File :</label>
        <div class="col-md-4 col-sm-4 col-xs-12"><input type="file" accept=".xls,.xlsx" name="ExcelFile" id="ExcelFile" class="form-control filestyle" data-buttonName="btn-primary" data-iconName="icon fa fa-inbox" data-placeholder="None Selected" enctype="multipart/form-data" title="Please select the excel file."/></div>
      </div>	
			
      <div class="form-group">
        <label for="AccountID" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600">Account :</label>
        <div class="col-md-3 col-sm-4 col-xs-12"><%=AcAuth.getAuthAccountList("AccountID", 0 ) %>
				<span class="help-block"><span id="ACT_BAL"></span></span>
				</div>
      </div>	
	
</div>

<div class="panel-form-box-footer">
		 <div class="col-md-offset-3 col-sm-offset-4" style="padding-left: 15px;">
      <button type="submit" class="btn btn-primary" title="Submit"><i class="fa fa-upload" aria-hidden="true"></i>&nbsp;Upload</button>
		 </div>	
</div>

<br />
		
    <div class="well well-sm">
    <ul class="list-group list-group-dividered" style="margin-bottom: 0px;">

<li class="list-group-item"><i class="icon fa fa-mail-forward iccolor" aria-hidden="true"></i>The <b>first column (A)</b> in the spreadsheet should contain <b>10</b> digit mobile number as <b>9XXXXXXXXX</b> or <b>8XXXXXXXXX</b> or <b>7XXXXXXXXX</b></li>
<li class="list-group-item"><i class="icon fa fa-mail-forward iccolor" aria-hidden="true"></i><b><span style="color: red;">DO NOT</span></b> prepend number with<b> +91</b> or <b>0</b>, just write <b>10 digit number</b> only</li>
<li class="list-group-item"><i class="icon fa fa-mail-forward iccolor" aria-hidden="true"></i><b>The second column (B)</b> should contain SMS text not exceeding 160 characters, for each respective number. </li>
<li class="list-group-item"><i class="icon fa fa-mail-forward iccolor" aria-hidden="true"></i>If the message field for <b>n</b><sup>th</sup> row  ( Bn) is left blank than SMS text of prior row will be used.</li>
<li class="list-group-item"><i class="icon fa fa-mail-forward iccolor" aria-hidden="true"></i>For sending <b>one common SMS to all</b>, write message text in columm <b>B1 </b>( first row, second column ) and leave column <b>B2</b> to <b>Bn</b> blank .</li>
    </ul>		
				
    </div>			

</div>

	</form>
<% 
}
else
{
%>
<div class="well well-sm well-danger">
  SMS Service Turned Off
</div>
<% 
} 
}
else if("Update".equalsIgnoreCase(Action))
{
  SMSService smsServ = (SMSService)application.getAttribute("WEBSMS-SERVICE") ;
	int nAccountID = 0;
	try
	{
	   nAccountID = Integer.parseInt( request.getParameter("AccountID") ) ;
	}catch(NumberFormatException ex){ nAccountID = 0; }
	
	int nBal = smsServ.checkSMSBalance(nAccountID);
	
	ResinFileUpload RsUpload = new ResinFileUpload() ;
	
	try
	{
	   if(nAccountID ==0) throw new Exception("Account not selected.");
		 if(nBal <=0 ) throw new Exception("There is no SMS balance in selected account.");
		 
    RsUpload.load( application,request, "ExcelFile" ) ;
    String FileName = RsUpload.getFileName();
    int nSize = RsUpload.getFileSize();
    String ShowSize = NumberHelper.showByteSize((long)nSize);
		
		if( !POIHelper.checkExcelMIME(RsUpload) ) throw new Exception("The uploaded file ( "+FileName+" "+ShowSize+" ) is not a valid MS Excel File.");
		 
			    Workbook wb = WorkbookFactory.create( RsUpload.getInputStream());
          Sheet sheet = wb.getSheetAt(0);
          int nRowCount = sheet.getLastRowNum();
					
		if(nRowCount <= 0) throw new Exception("The uploaded file: <b>"+FileName+"</b> is  blank. ( contains no data )");			
		if( nBal < nRowCount ) throw new Exception("Insufficient SMS balance ( "+nBal+" ) in selected account to send ( "+nRowCount+" ) SMS(s).") ;	
				
  		   int nBlankRows = 0;
  			 int nInvalidNumbers=0;
  			 int nDataOk =0;
  			 int nJobID=0;
				 
     SmsJobBn.SmsJobID= 0;
     SmsJobBn.ExecuteBy = SiMngrBn.LoginRole ; 
     SmsJobBn.ExecutorID = LogUsr.AdminID ;
     SmsJobBn.JobDateTime = new java.sql.Timestamp(System.currentTimeMillis());
     SmsJobBn.AccountID = nAccountID ;
     SmsJobBn.Target = "Excel File" ;
     SmsJobBn.SqlQuery = "Rows from excel file: "+FileName ;
     SmsJobBn.WhereClause = "";
     SmsJobBn.OrderByClause = "";
     SmsJobBn.CustomText = (short)1 ; 
     SmsJobBn.SMSText = "Text from spreadsheet" ;
     SmsJobBn.JobCount = 0 ;
     SmsJobBn.Success = 0 ;
     SmsJobBn.Failure = 0 ;
     SmsJobBn.Invalid = 0 ;
     SmsJobBn.Blank = 0 ;
     SmsJobBn.SmsJobFlag = com.$WEBAPP.appsms.SMSDispatchStatus.PENDING ;
     SmsJobBn.addRecord();
		 nJobID = SmsJobBn._autonumber ;

			   int n = 0;
				 String LastMessage=null;
				 SmsJobLogBn.beginInsert();
			     for(n=0 ; n <= nRowCount ; n++)
			     {
				         Row datarow  = sheet.getRow(n);
								 String Number = POIHelper.getStringFromCell(datarow.getCell(0, Row.CREATE_NULL_AS_BLANK));
								 String Message = POIHelper.getStringFromCell(datarow.getCell(1, Row.CREATE_NULL_AS_BLANK));

							   if(Message!=null && Message.length()>0) LastMessage=Message;
							   else Message=LastMessage ;
								 
							   if(Number!=null && Number.length()>0 && Message==null && Message.length()==0)
								 {
    							   if(smsServ.checkNumber(Number))
    							   {
        							   nDataOk++;
                         SmsJobLogBn.SmsJobLogID = 0;
                    		 SmsJobLogBn.SmsJobID = nJobID ;
                         SmsJobLogBn.DispatchDateTime = SmsJobBn.JobDateTime ;
                    		 SmsJobLogBn.RefNo = "RowNumber : "+n ;
    										 SmsJobLogBn.Target = "Excel File" ;
                         SmsJobLogBn.MobileNumber = Number;
                         SmsJobLogBn.SMSText = Message;
    										 SmsJobLogBn.MobileNumberStatus = MobileNumberStatus.OK ;
                    		 SmsJobLogBn.SmsJobLogFlag = SMSDispatchStatus.PENDING ; 
                         SmsJobLogBn.Response = "";
                         SmsJobLogBn.continueInsert();
    							   }
    							   else
    							   {
    							       nInvalidNumbers++;
                         SmsJobLogBn.SmsJobLogID = 0;
                    		 SmsJobLogBn.SmsJobID = nJobID ;
                         SmsJobLogBn.DispatchDateTime = SmsJobBn.JobDateTime ;
                    		 SmsJobLogBn.RefNo = "RowNumber : "+n ;
    										 SmsJobLogBn.Target = "Excel File" ;
                         SmsJobLogBn.MobileNumber = Number;
                         SmsJobLogBn.SMSText = Message;
    										 SmsJobLogBn.MobileNumberStatus = MobileNumberStatus.INVALID ;
                    		 SmsJobLogBn.SmsJobLogFlag = SMSDispatchStatus.PENDING ; 
                         SmsJobLogBn.Response = "";
                         SmsJobLogBn.continueInsert();
    							   }						 
								 }
								 else
								 {
							       nBlankRows++;
                     SmsJobLogBn.SmsJobLogID = 0;
                		 SmsJobLogBn.SmsJobID = nJobID ;
                     SmsJobLogBn.DispatchDateTime = SmsJobBn.JobDateTime ;
                		 SmsJobLogBn.RefNo = "RowNumber : "+n ;
										 SmsJobLogBn.Target = "Excel File" ;
                     SmsJobLogBn.MobileNumber = "";
                     SmsJobLogBn.SMSText = "";
										 SmsJobLogBn.MobileNumberStatus = MobileNumberStatus.BLANK ;
                		 SmsJobLogBn.SmsJobLogFlag = SMSDispatchStatus.PENDING ; 
                     SmsJobLogBn.Response = "";
                     SmsJobLogBn.continueInsert();								 
								 }
								 
			     }// end - for(n=0 ; n < nRowCount ; n++)
				   SmsJobLogBn.endInsert();
			    
					 SmsJobBn.locateRecord(nJobID);
           SmsJobBn.JobCount = nDataOk ;
           SmsJobBn.Invalid = nInvalidNumbers ;
           SmsJobBn.Blank = nBlankRows ;
					 SmsJobBn.updateRecord(nJobID); 
					 smsServ.startBulkSMSDispatch(nJobID , false) ;
					 
				%>
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class="icon fa fa-file-excel-o iccolor" aria-hidden="true"></i>&nbsp;&nbsp;Upload Result
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="NavigateTo('<%=thisFile %>?Action=Form')"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	
<div class="well well-sm well-success">
<big><i class="icon fa fa-check" aria-hidden="true"></i>&nbsp;( <%=nRowCount+1 %> ) rows</big>
<br />
<big><i class="icon fa fa-check" aria-hidden="true"></i>&nbsp;<%=FileName %>  ( <%=ShowSize %> )</big>
</div>
				
            <div align="center">
        				<p><span class="blue-grey-700">Bulk SMS JobID:</span> <span class=""><%=nJobID %></span> <br/>
        				( Dispatch status should be checked with this JobID )</p>
								<div class="row">
            			<div class="col-sm-4 col-sm-offset-4">
														
                    <ul class="list-group list-group-full list-group-dividered">
                      <li class="list-group-item">
                        <span class="badge badge-radius badge-info" style="font-size: 13px;"><%=nRowCount+1 %></span> <span class="blue-grey-700">Total Rows</span>
                      </li>
                      <li class="list-group-item">
                        <span class="badge badge-radius badge-success" style="font-size: 13px;"><%=nDataOk %></span> <span class="blue-grey-700">Valid Numbers</span>
                      </li>
                      <li class="list-group-item">
                        <span class="badge badge-radius badge-danger" style="font-size: 13px;"><%=nInvalidNumbers %></span> <span class="blue-grey-700">Invalid Numbers</span>
                      </li>
                      <li class="list-group-item">
                        <span class="badge badge-radius badge-default" style="font-size: 13px;"><%=nBlankRows %></span> <span class="blue-grey-700">Blanks</span>
                      </li>
                    </ul>
								
								</div>
							</div>

    				</div>
</div>
</div>
						
<%
   }
	 catch(Exception ex)
	 {
 %>
	  <p><b> <span class="error">Error in sending SMS.</span> </b></p>
		<p><%=ex.getMessage() %> [ <a href="javascript:void(0)" onclick="{ $('#ex_stack').show();   }">Details</a> ]</p>
		<p id="ex_stack" style="display:none"><small> 
		<% 
		      ByteArrayOutputStream bout = new ByteArrayOutputStream();
          ex.printStackTrace(new PrintStream(bout));
          out.println(bout.toString().replace("\r\n", "\r\n<br />"));
		 %><br/>[ <a href="javascript:void(0)" onclick="{ $('#ex_stack').hide();   }">Hide Details</a> ]
		</small></p>
		<p><a href="<%=thisFile %>">Try again !</a></p>
<%
	 }
}
else
{
%>
<div class="well well-sm well-danger">
  Error: The page is invoked with invalid action parameter.
</div>
<%
}
%>				
	
    </div>
  </div>
  <!-- End Page -->
	<jsp:include page ="/admin/include-page/footer.jsp" flush="true" />
	 
	<jsp:include page ="/include-page/js/main-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>
  <jsp:include page ="/include-page/js/bootstrap-select-js.jsp" flush="true" />
	<jsp:include page="/include-page/js/formValidation-js.jsp" flush="true" />
	<jsp:include page="/include-page/js/bootstrap-filestyle-js.jsp" flush="true" />
<script>

function InitPage()
{
  var act_id = $("[name='AccountID']").val();
	if(act_id != null && act_id.length>0 )
		{
		    $.ajax({ url:"chkbalancejson.jsp", data:{'AccountID': act_id}, dataType:"json", success: function(data){
		              sel_act_bal=data.balance ;
						     }, async: false  
							});
			 $('#ACT_BAL').css("color", "navy");
       $('#ACT_BAL').html(""+sel_act_bal);				
		}					     
		//else{sel_act_bal=0;}
}
function putValue(tval)
{
 $('#SMSText').val(tval);
}

// Initialize jQuery 
$(document).ready(function() {
$("select[name='AccountID']").change(function() {
  var act_id = $("[name='AccountID']").val();
	if(act_id != null && act_id.length>0 )
		{
		    $.ajax({ url:"chkbalancejson.jsp", data:{'AccountID': act_id}, dataType:"json", success: function(data){
		              sel_act_bal=data.balance ;
						     }, async: false  
							});
			 $('#ACT_BAL').css("color", "navy");
       $('#ACT_BAL').html(""+sel_act_bal);				
		}					     
		//else{sel_act_bal=0;}
});

    $('#quick_sms_form').formValidation({
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
            },
            AccountID: {
                validators: {
                    notEmpty: {
                        message: 'The field is required'
                    }
                }
            }
						
        }
    });


});  
// end of jQuery Initialize block

</script>
	
<jsp:include page ="/include-page/common/Google-Analytics.jsp" flush="true" />

</body>
</html>

