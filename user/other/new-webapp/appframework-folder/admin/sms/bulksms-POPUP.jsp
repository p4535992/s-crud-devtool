<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.$WEBAPP.appsms.*, com.$WEBAPP.appmail.*, com.db.$DATABASE.*"%> 
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*, org.apache.commons.lang3.* " %>
<%@ page import="com.webapp.jsp.*, com.webapp.utils.*, com.webapp.db.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<jsp:useBean id="SmsJobBn" scope="page" class="com.db.$DATABASE.Sms_jobsBean" />
<jsp:useBean id="SmsJobLogBn" scope="page" class="com.db.$DATABASE.Sms_joblogBean" />
<%!  
String StrValue(Object ob )
{
  return (ob==null)? "":ob.toString() ;
}
%>

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


        com.$WEBAPP.appsms.SMSSetting si = new com.$WEBAPP.appsms.SMSSetting(application);
        int sms_charater_limit =0;
        try
        {
            sms_charater_limit = Integer.parseInt(si.getValue("SMS-CHARACTER-LIMIT"));
        }
        catch(NumberFormatException ex)
        {
            sms_charater_limit = 0;
        }

String ParamClause = request.getParameter("sql");
String ChkQuery = new String( com.webapp.base64.UrlBase64.decode(ParamClause));
int nCount=0;
try
{
  nCount = Integer.parseInt( request.getParameter("Count") ) ;

}catch(NumberFormatException ex)
{ 
  nCount=0 ;
}
	
  String[] chk_Target = request.getParameterValues("Target");
  String Target = CSVHelper.csvFromStringArray(chk_Target);
  int nFieldCount = chk_Target.length ;
	int nSMSRequired = nFieldCount * nCount;

String Refno = request.getParameter("Refno");

String Action = RequestHelper.paramValue(request, "Action", "Form");
String menuType = "topbar";

%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
	<title>Send Bulk SMS</title>

  <jsp:include page ="/include-page/css/main-css.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>
  <jsp:include page ="/include-page/css/bootstrap-select-css.jsp" flush="true" />
	<jsp:include page="/include-page/css/formValidation-css.jsp" flush="true" />
	<jsp:include page="/include-page/css/bootstrap-datetimepicker-css.jsp" flush="true" />
	
  <jsp:include page ="/include-page/common/main-head-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>
	
<style type="text/css">
.example {
    background-color: #f3f7fa;
    border: 1px solid #eee;
    padding: 50px 15px 15px 50px;
    position: relative;
}
</style>	

</head>

<body class="<%=SiMngrBn.LoginRole %>" onload="InitPage()" style="padding-top: 0px;" >

  <!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
		
<%
if("Form".equalsIgnoreCase(Action))
{
if(bSMS)
{
String TemplatePlugin = "onchange='putValue(this.value)' data-plugin='selectpicker' data-container='body' data-live-search='false'" ;
%>

  <form action="<%=thisFile %>" id="Bulk_sms_form" method="post" class="form-horizontal">
	<input type="hidden" name="Action" value="Update" />
	<input type="hidden" name="Count" value="<%=nCount %>" />
	<input type="hidden" name="sql" value="<%=ParamClause %>" />
	<input type="hidden" name="Target" value="<%=CSVHelper.csvFromStringArray(chk_Target) %>" />
	<input type="hidden" name="Refno" value="<%=Refno %>" />
	
	
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class='fa fa-bookmark iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Send Bulk SMS : <span class="blue-grey-800">[ <%=nCount %> ]</span> recipients 
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">
			
      <div class="form-group">
        <label for="SMSTemplate" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600">Template :</label>
        <div class="col-md-6 col-sm-6 col-xs-12">
				<jsp:include page ="/templatelist/" >
			     <jsp:param name="ElementName" value="TemplateID" />
					 <jsp:param name="ElementID" value="TemplateID" />
					 <jsp:param name="All" value="false" />
					 <jsp:param name="None" value="true" />
					 <jsp:param name="WhereClause" value="" />
					 <jsp:param name="OrderBy" value="" />
					 <jsp:param name="ClassName" value="form-control show-tick" />
					 <jsp:param name="Plugin" value="<%=TemplatePlugin %>" />
					 <jsp:param name="Multiple" value="false" />
				</jsp:include>		
				</div>
      </div>	
		 
      <div class="form-group">
        <label for="SMSText" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600">SMS Text :</label>
        <div class="col-md-6 col-sm-6 col-xs-12">
				  <textarea rows="3" cols="40" name="SMSText" id="SMSText" class="form-control" data-plugin="maxlength" maxlength="<%=sms_charater_limit %>" ></textarea>
				</div>
      </div>	
			
      <div class="form-group">
        <label for="AccountID" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600">Account :</label>
        <div class="col-md-6 col-sm-6 col-xs-12"><%=AcAuth.getAuthAccountList("AccountID", 0 ) %>
				<span class="help-block"><span id="ACT_BAL"></span></span>
				</div>
      </div>	
      <div class="form-group">
        <label for="Schedule" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600">Schedule Later :</label>
				<div class="col-md-6 col-sm-6 col-xs-12">
				  <div class="checkbox-custom checkbox-inline checkbox-primary">
            <input type="checkbox" name="Schedule" id="Schedule" onchange="OnScheduleChanged()">
            <label for="Schedule">
								<span id="TIME_INPUT" style="display:none" >
									<div class="input-group input-group-icon" >
                    <input type="text" name="JobTime" id="JobTime" class="form-control datetimepicker" value="<%=DateTimeHelper.showDateTimePicker(DateTimeHelper.now()) %>"/>
                    <span class="input-group-addon">
                        <span class="icon fa fa-calendar" aria-hidden="true"></span>
                    </span>
                  </div>
							 </span>
					</label>
					</div>
				</div>	
      </div>	
	
</div>

<div class="panel-form-box-footer">
  <div class="col-md-offset-3 col-sm-offset-4" style="padding-left: 15px;">
    <button type="submit" class="btn btn-primary" title="Submit"><i class="fa fa-check" aria-hidden="true"></i>&nbsp;Send</button>
    <!-- <button type="button" class="btn btn-default btn-outline" title="Cancel" onclick="history.go(-1);"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button> -->
    <!-- onclick="NavigateTo('<%=appPath %>/admin/index.jsp')" -->	
	</div>	
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
  GenericQuery genqry = new GenericQuery(ApplicationResource.database, application);	

	String Message = request.getParameter("SMSText") ;
	
	int nAccountID = 0;
	try
	{
	   nAccountID = Integer.parseInt( request.getParameter("AccountID") ) ;
	}catch(NumberFormatException ex){ nAccountID = 0; }

	boolean bShedule = false ;
	if( request.getParameter("Schedule") !=null ) bShedule = true  ;
	
	SMSService smsServ = (SMSService)application.getAttribute("WEBSMS-SERVICE") ;

     int nBlankRows = 0;
     int nInvalidNumbers=0;
     int nDataOk =0;
     int nJobID=0;
				 
     SmsJobBn.SmsJobID= 0;
     SmsJobBn.ExecuteBy = SiMngrBn.LoginRole ; 
     SmsJobBn.ExecutorID = LogUsr.AdminID ;
	   if( bShedule ) SmsJobBn.JobDateTime = DateTimeHelper.requestDateTimePicker( request, "JobTime" ) ;
	   else SmsJobBn.JobDateTime = new java.sql.Timestamp(System.currentTimeMillis()); 
     SmsJobBn.AccountID = nAccountID ;
     SmsJobBn.Target = Target ;
     SmsJobBn.SqlQuery = ChkQuery ;
     SmsJobBn.WhereClause = "";
     SmsJobBn.OrderByClause = "";
     SmsJobBn.CustomText = (short)0 ; 
     SmsJobBn.SMSText = Message ;
     SmsJobBn.JobCount = nCount ;
     SmsJobBn.Success = 0 ;
     SmsJobBn.Failure = 0 ;
     SmsJobBn.Invalid = 0 ;
     SmsJobBn.Blank = 0 ;
	   if( bShedule ) SmsJobBn.SmsJobFlag = com.$WEBAPP.appsms.SMSDispatchStatus.SCHEDULED ;
	   else SmsJobBn.SmsJobFlag = com.$WEBAPP.appsms.SMSDispatchStatus.PENDING ; 
     SmsJobBn.addRecord();
		 nJobID = SmsJobBn._autonumber ;
		 
			 SmsJobLogBn.beginInsert();
	     java.sql.ResultSet rslt = genqry.openQuery(ChkQuery);
	     while(rslt.next())
	     {
		      String Number = null;
			     for(int n=0 ; n < nFieldCount ; n++)
			     {
								 if( chk_Target[n].length() >0) Number = rslt.getString(chk_Target[n]) ;
								 int refno = rslt.getInt(Refno) ;
								 
							   if(Number==null || Number.length()==0)
								 {
							       nBlankRows++;
                     SmsJobLogBn.SmsJobLogID = 0;
                		 SmsJobLogBn.SmsJobID = nJobID ;
                     SmsJobLogBn.DispatchDateTime = SmsJobBn.JobDateTime ;
                		 SmsJobLogBn.RefNo = Refno+" : "+refno ;
										 SmsJobLogBn.Target = chk_Target[n] ;
                     SmsJobLogBn.MobileNumber = "";
                     SmsJobLogBn.SMSText = "";
										 SmsJobLogBn.MobileNumberStatus = MobileNumberStatus.BLANK ;
                		 SmsJobLogBn.SmsJobLogFlag = SMSDispatchStatus.PENDING ; 
                     SmsJobLogBn.Response = "";
                     SmsJobLogBn.continueInsert();								 
								 }
								 else
							   {
    							   if(smsServ.checkNumber(Number))
    							   {
        							   nDataOk++;
                         SmsJobLogBn.SmsJobLogID = 0;
                    		 SmsJobLogBn.SmsJobID = nJobID ;
                         SmsJobLogBn.DispatchDateTime = SmsJobBn.JobDateTime ;
                    		 SmsJobLogBn.RefNo = Refno+" : "+refno ;
    										 SmsJobLogBn.Target = chk_Target[n] ;
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
                    		 SmsJobLogBn.RefNo = Refno+" : "+refno ;
    										 SmsJobLogBn.Target = chk_Target[n] ;
                         SmsJobLogBn.MobileNumber = Number;
                         SmsJobLogBn.SMSText = Message;
    										 SmsJobLogBn.MobileNumberStatus = MobileNumberStatus.INVALID ;
                    		 SmsJobLogBn.SmsJobLogFlag = SMSDispatchStatus.PENDING ; 
                         SmsJobLogBn.Response = "";
                         SmsJobLogBn.continueInsert();
    							   }
							   }
								 
			     } // end - for(n=0 ; n < nFieldCount ; n++)
					 } // End - While loop - while(rslt.next()) 
					 genqry.closeQuery();
				   SmsJobLogBn.endInsert();
			    
					 SmsJobBn.locateRecord(nJobID);
           SmsJobBn.JobCount = nDataOk ;
           SmsJobBn.Invalid = nInvalidNumbers ;
           SmsJobBn.Blank = nBlankRows ;
					 SmsJobBn.updateRecord(nJobID); 
					 if(!bShedule) smsServ.startBulkSMSDispatch(nJobID , false) ;

%>
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class='fa fa-bookmark iccolor' aria-hidden='true'></i>&nbsp;&nbsp; Dispatch Status</h3>
	</div>
<div class="panel-body panel-form-box-body container-fluid">	
<% 
if(bShedule)
{ 
%>
<div role="alert" class="alert dark alert-success alert-dismissible">
<button aria-label="Close" data-dismiss="alert" class="close" type="button"><span aria-hidden="true">&times;</span></button>
It is <span class="blue-grey-700">Sheduled</span> for dipatch at : <span class="blue-grey-700"> <%=DateTimeHelper.showDateTimePicker(SmsJobBn.JobDateTime) %></span>
</div>
<% 
}
else
{
%>
<div role="alert" class="alert dark alert-info alert-dismissible">
<button aria-label="Close" data-dismiss="alert" class="close" type="button"><span aria-hidden="true">&times;</span></button>
Your bulk SMS job is queued for dispatch.
</div>
<%  
}
%>
            <div align="center">
						<br />
        				<p><span class="blue-grey-700">Bulk SMS JobID:</span> <span class=""><%=nJobID %></span> <br/>
        				( Dispatch status should be checked with this JobID )</p>
								<div class="row">
            			<div class="col-sm-4 col-sm-offset-4">
														
                    <ul class="list-group list-group-full list-group-dividered">
                      <li class="list-group-item">
                        <span class="badge badge-radius badge-info" style="font-size: 13px;"><%=nCount %></span> <span class="blue-grey-700">Total Rows</span>
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
	<jsp:include page="/include-page/js/bootstrap-maxlength-js.jsp" flush="true" />
  <jsp:include page ="/include-page/js/bootstrap-select-js.jsp" flush="true" />
	<jsp:include page="/include-page/js/formValidation-js.jsp" flush="true" />
	<jsp:include page="/include-page/js/bootstrap-datetimepicker-js.jsp" flush="true" />
<script>

function InitPage()
{
  var act_id = $("[name='AccountID']").val();
	if(act_id != null && act_id.length>0 )
		{
		    $.ajax({ url:"../chkbalancejson.jsp", data:{'AccountID': act_id}, dataType:"json", success: function(data){
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
var sel_act_bal = 0;
function OnAccountSelect()
{
    $('#ACT_BAL').html("Wait... Checking balance");
	  $('#ACT_BAL').css("color", "maroon");
		var actid = $("select[name='AccountID']").val() ;
		if(actid != null && actid.length>0 )
		{
		   $.ajax({ url:"chkbalancejson.jsp", data:{'AccountID': actid}, dataType:"json", success: function(data){
		         sel_act_bal=data.balance ;
		          }, async: false  
							});
		}					     
		//else{sel_act_bal=0;}
	   
	 $('#ACT_BAL').css("color", "navy");
   $('#ACT_BAL').html(""+sel_act_bal);
}
var sms_required =  <%=nSMSRequired %> ;
function  CheckAccountBalance()
{
		 
	 if( sel_act_bal < sms_required)
	 {
	   alert("You do not have enough account balance to send ( "+sms_required+" ) sms.");
     return false; 
	 }
	 else
	 {
	 	 return true;
	 }	 
}
function OnScheduleChanged()
{
  
  var chk = $("#Schedule").prop("checked", true);
	if(chk)
	{
	  if(!confirm("Do you want to  schedule SMS sending at some later date and time ?\n\nDispatch of Sheduled SMS is attempted on best possible effort basis. Dispatch exactly at the reqested time can not be guaranteed. Success depends on network  connectivity at the time of dispatch, which can not be predicated beforehand.\nYou are taking chance, the dispatch job may fail.\n\nAre you sure ? ") ) 
		{
		 		 $("#Schedule").prop("checked", false);
		}
	
	}
	if( $("#Schedule").is(':checked') ) $("#TIME_INPUT").show();
	else  $("#TIME_INPUT").hide(); 
	
}

// Initialize jQuery 
$(document).ready(function() {
	
<% 
if(Action.equalsIgnoreCase("Form")) 
{
%>
	$("select[name='AccountID']").change( OnAccountSelect );
	
    $('#Bulk_sms_form').formValidation({
        framework: 'bootstrap',
        fields: {
            SMSText: {
                validators: {
                    notEmpty: {
                        message: 'The field is required'
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
    })
		.on('success.form.fv', function(e) {
			 e.preventDefault();
			 var fv = $(e.target).data('formValidation');
		   if( CheckAccountBalance()) fv.defaultSubmit(); //$('#Bulk_sms_form').submit();
		});
<%
 }  
%>

});  
// end of jQuery Initialize block

</script>
	
<jsp:include page ="/include-page/common/Google-Analytics.jsp" flush="true" />


</body>
</html>

