<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.appsms.*, com.$WEBAPP.appmail.*, com.db.$DATABASE.*"%> 
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*, org.apache.commons.lang3.* " %>
<%@ page import="com.webapp.jsp.*, com.webapp.utils.*, com.webapp.db.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<jsp:useBean id="SmsLog" scope="page" class="com.db.$DATABASE.Sms_singlelogBean" />
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
//override Action authorization
//bAllowDelete = false ;
//bAllowUpdate = true ;
//bAllowAdd = true ;

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

String Action = RequestHelper.paramValue(request, "Action", "Form");

String Mobile =  request.getParameter("MobileNumber") ;
String Message = request.getParameter("SMSText") ;
%>
<%@include file="/admin/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
	<title>Quick SMS</title>

  <jsp:include page ="/include-page/css/main-css.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>
	
  <jsp:include page ="/include-page/css/bootstrap-select-css.jsp" flush="true" />
	<jsp:include page="/include-page/css/formValidation-css.jsp" flush="true" />
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

<body class="<%=menuTypeClass %> <%=SiMngrBn.LoginRole %>" onload="InitPage()" >

  <jsp:include page ="/admin/include-page/nav-body.jsp" >	
	 	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

  <jsp:include page ="/admin/include-page/menu-body.jsp" >	
	 	 <jsp:param name="menuType" value="<%=menuType %>" />
	 	 <jsp:param name="MenuTitle" value="SMSTitle" />
	 	 <jsp:param name="MenuLink" value="QuickSMSLink" />
  </jsp:include>


  <!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
  	  <div class="row">
        <div class="col-sm-6">
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i>Quick SMS</h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<%=appPath %>/admin/index.jsp"><i aria-hidden="true" class="fa fa-home fa-lg margin-right-5"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active">Quick SMS</li>
          </ol>			
  	    </div>
  		</div>	
		
<%
if("Form".equalsIgnoreCase(Action))
{
if(bSMS)
{
String TemplatePlugin = "onchange='putValue(this.value)' data-plugin='selectpicker' data-container='body' data-live-search='false'" ;
%>

  <form action="<%=thisFile %>" id="quick_sms_form" method="post" class="form-horizontal">
	<input type="hidden" name="Action" value="Update" />
	<input type="hidden" name="M" value="<%=nModuleID %>" />
	
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class='fa fa-bookmark iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Send SMS Quickly 
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	

      <div class="form-group">
        <label for="MobileNumber" class="col-md-4 col-sm-4 col-xs-12 control-label blue-grey-600">Mobile No. :</label>
        <div class="col-md-3 col-sm-4 col-xs-12"><input type="text" name="MobileNumber" id="MobileNumber" class="form-control" value="<%=StrValue(Mobile) %>" /><span class="help-block"><%=SetSms.getValidNumberAdvice() %></span></div>
      </div>	
			
      <div class="form-group">
        <label for="SMSTemplate" class="col-md-4 col-sm-4 col-xs-12 control-label blue-grey-600">Template :</label>
        <div class="col-md-3 col-sm-4 col-xs-12">
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
        <label for="SMSText" class="col-md-4 col-sm-4 col-xs-12 control-label blue-grey-600">SMS Text :</label>
        <div class="col-md-5 col-sm-6 col-xs-12">
				  <textarea rows="2" name="SMSText" id="SMSText" class="form-control" data-plugin="maxlength" maxlength="<%=sms_charater_limit %>" ><%=StrValue(Message) %></textarea>
				</div>
      </div>	
			
      <div class="form-group">
        <label for="AccountID" class="col-md-4 col-sm-4 col-xs-12 control-label blue-grey-600">Account :</label>
        <div class="col-md-3 col-sm-4 col-xs-12"><%=AcAuth.getAuthAccountList("AccountID", 0 ) %>
				  <span class="help-block"><span id="ACT_BAL"></span></span>
				</div>
      </div>	
	
</div>

<div class="panel-form-box-footer">
  <div class="col-md-offset-4 col-sm-offset-4" style="padding-left: 15px;">
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
  SMSService smsServ = (SMSService)application.getAttribute("WEBSMS-SERVICE") ;
	int nAccountID = 0;
	try
	{
	   nAccountID = Integer.parseInt( request.getParameter("AccountID") ) ;
	}catch(NumberFormatException ex){ nAccountID = 0; }
	
	int nBal = smsServ.checkSMSBalance(nAccountID);
	
	try
	{
	   if(nAccountID ==0) throw new Exception("Account not selected.");
		 if(nBal <=0 ) throw new Exception("There is no SMS balance in selected account.");

		 SMSServerResponse rsp = smsServ.sendSMS( nAccountID, Mobile, Message );
		 SmsLog.SmsSingleLogID = 0; 
	   SmsLog.ExecuteBy = SiMngrBn.LoginRole ; 
	   SmsLog.ExecutorID = SiMngrBn.AdminID; 
	   SmsLog.AccountID = nAccountID;
	   SmsLog.DispatchDateTime = new java.sql.Timestamp( System.currentTimeMillis() );  
	   SmsLog.MobileNumber = Mobile ; 
	   SmsLog.SMSText = Message; 
	   SmsLog.SmsSingleLogFlag = rsp.ReturnVal ; 
	   SmsLog.Response = rsp.Response ;
	   SmsLog.addRecord();
%>
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class='fa fa-bookmark iccolor' aria-hidden='true'></i>&nbsp;&nbsp; Dispatch Status</h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	
<div class="row">
  <div class="col-sm-4 col-sm-offset-2">
    <div class="example">
      <div class="ribbon ribbon-bookmark ribbon-info">
      		 <span class="ribbon-inner">Dispatch Status</span>
      </div>
      <p><%=rsp.Response %></p>
    </div>
  </div>
  <div class="col-sm-4">
    <div class="example example-reverse">
      <div class="ribbon ribbon-bookmark ribbon-info">
      		 <span class="ribbon-inner">Server Response</span>
      </div>
      <p><%=SMSDispatchStatus.getLabel(rsp.ReturnVal) %></p>
    </div>
  </div>	
</div>

<div class="row">
	<div class="col-sm-4 col-sm-offset-4">
	
    <div class="well well-sm">
    <ul class="list-group list-group-gap" style="margin-bottom: 0px;">
      <li class="list-group-item">
        <i aria-hidden="true" class="icon fa fa-anchor iccolor"></i><a href="<%=thisFile %>">Next Message</a>
      </li>
      <li class="list-group-item">
        <i aria-hidden="true" class="icon fa fa-anchor iccolor"></i><a href="<%=thisFile %>?MobileNumber=<%=StrValue(Mobile) %>">Same Number</a>
      </li>
      <li class="list-group-item">
        <i aria-hidden="true" class="icon fa fa-anchor iccolor"></i><a href="<%=thisFile %>?SMSText=<%=StrValue(Message) %>">Same Message</a>
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
	<jsp:include page="/include-page/js/bootstrap-maxlength-js.jsp" flush="true" />
  <jsp:include page ="/include-page/js/bootstrap-select-js.jsp" flush="true" />
	<jsp:include page="/include-page/js/formValidation-js.jsp" flush="true" />
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
            MobileNumber: {
						    trigger: 'blur',
                validators: {
                    notEmpty: {
                        message: 'The field is required'
                    },
                    regexp: {
                        regexp: /^[789]\d{9}$/i,
                        message: 'Not a valid Mobile Number'
                    }
                }
            },
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
    });


});  
// end of jQuery Initialize block

</script>
	
<jsp:include page ="/include-page/common/Google-Analytics.jsp" flush="true" />


</body>
</html>

