<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.*"%>
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, javax.servlet.*, javax.servlet.http.* " %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.* com.webapp.base64.* " %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<%! 
boolean CheckDuplicateEntry(com.db.$DATABASE.SitemanagerBean dbBean )
{
 /* 
   Enable this in case you do not want duplicate entried.
   Just set appropriate SQL WHERE condition, to avoid creating duplicate
	 entries in add or update
 	    
 try
 {
  return  ( dbBean.recordCount(" WHERE ? ")> 0) ? false : true ;
 }  catch( java.sql.SQLException exSQL ) {  return false ; }
 */
 return true ; // remove this line to enable

}
%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);
com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);

   final int DEFAULT = 0 ;
   final int SEARCH_RECORDS = 1 ;
   final int SEARCH_RESULT = 2;
   final int SHOW_RECORD = 3 ;
   final int NEW_FORM = 4 ;
   final int CHANGE_FORM = 5 ;
   final int ADD_RECORD = 6 ;
   final int UPDATE_RECORD = 7;
   final int DELETE_RECORD = 8 ;
   final int PROCESS_CHECKED = 9;
	 final int RESET_FORM = 10;

final String DEFAULT_ACTION ="Action=Default";
final String QUERY_OBJECT_ID = "sitemanagerQuery" ;

int  default_cmd = DEFAULT ;
// Show data flag
com.webapp.utils.MakeQueryString qStr =  null ;


int nAction = DEFAULT ;
String DelWarning = "" ;
String PageTitle = null ;
String MessageText = null ;
MessageText = request.getParameter("Message");

String ParamAction = request.getParameter("Action");
if(ParamAction==null)ParamAction = "Search" ;
StringBuffer ForeignKeyParam = new StringBuffer("");

if(ParamAction != null)
{
    if(ParamAction.equalsIgnoreCase("Default")) nAction = DEFAULT  ;
    else if (ParamAction.equalsIgnoreCase("Search")) nAction = SEARCH_RECORDS ;
    else if (ParamAction.equalsIgnoreCase("Result")) nAction = SEARCH_RESULT ;
    else if (ParamAction.equalsIgnoreCase("Show")) nAction = SHOW_RECORD ;
    else if (ParamAction.equalsIgnoreCase("New")) nAction = NEW_FORM ;
    else if (ParamAction.equalsIgnoreCase("Change")) nAction = CHANGE_FORM ;
    else if (ParamAction.equalsIgnoreCase("Add")) nAction = ADD_RECORD ;
    else if (ParamAction.equalsIgnoreCase("Update")) nAction = UPDATE_RECORD ;
    else if (ParamAction.equalsIgnoreCase("Delete")) nAction = DELETE_RECORD ;
    else if (ParamAction.equalsIgnoreCase("ProcessChecked")) nAction = PROCESS_CHECKED ;
		else if (ParamAction.equalsIgnoreCase("ResetForm")) nAction = RESET_FORM ;
}

// Action authorization || Enable : true & Disable : false
boolean bAllowAdd = false ;
boolean bAllowUpdate = false;
boolean bAllowDelete = false;

//footer Page Navigation
boolean bAllowFooterPageNavigation = true;

//Result-Action Checkbox Visibility
boolean bResultActionCheckbox = true;


com.webapp.login.SearchQuery QryObj = (com.webapp.login.SearchQuery) session.getAttribute(QUERY_OBJECT_ID) ;
if(QryObj!=null) default_cmd=SEARCH_RESULT ;
else default_cmd = SEARCH_RECORDS ;
if(nAction==DEFAULT) nAction = default_cmd ;


// ID field is Integer ( number ) type
int nAdminID = 0;
try
{
   nAdminID = Integer.parseInt(request.getParameter("AdminID"));
}
catch(NumberFormatException ex)
{ 
   nAdminID = 0;
}

if(("ResetPassword").equalsIgnoreCase(ParamAction))
{
int nCount = RequestHelper.getInteger(request, "Count");
String ParamWhr = request.getParameter("WhereClause");
String WhereClause = new String( com.webapp.base64.UrlBase64.decode( ParamWhr ));

String ResetPassword = request.getParameter("ResetPassword");

SiMngrBn.executeUpdate("UPDATE `sitemanager` SET `Password`='"+ResetPassword+"' "+WhereClause+" ");

MessageText = "Reset Password Successfully ! "+nCount ;


	
response.sendRedirect(response.encodeRedirectURL(thisFile+"?"+DEFAULT_ACTION+ForeignKeyParam+"&Message="+MessageText));
}

if(("ClearSession").equalsIgnoreCase(ParamAction))
{
	SiMngrBn.LoginStatus = LoginStatusFlag.NOT_LOGGED ;
  SiMngrBn.updateRecord(nAdminID);
	
	MessageText = "Clear Current Login Status Successfully ! AdminID = "+nAdminID ;
	
response.sendRedirect(response.encodeRedirectURL(thisFile+"?"+DEFAULT_ACTION+ForeignKeyParam+"&Message="+MessageText));
}



if(("UpdatePhoto").equalsIgnoreCase(ParamAction))
{
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

UpdateAdminPhoto AdminPhoto = new UpdateAdminPhoto(request) ;

AdminPhoto.updateAdminPhotograph(nAdminID, "AdminPhotograph" );

MessageText = "Photograph Updated Successfully ! AdminID = "+nAdminID ;

response.sendRedirect(response.encodeRedirectURL(thisFile+"?Action=Show&AdminID="+nAdminID+"&Message="+MessageText));

}

 

if(nAction==ADD_RECORD)
{

     SiMngrBn.AdminID= 0;

/* Auto increment column: 
     try  
      {
           SiMngrBn.AdminID = Integer.parseInt(request.getParameter("AdminID")) ;
      } catch( NumberFormatException ex)
     { 
         SiMngrBn.AdminID = 0 ;
     }
*/
     SiMngrBn.FirstName = request.getParameter("FirstName");
     SiMngrBn.MiddleName = request.getParameter("MiddleName");
     SiMngrBn.LastName = request.getParameter("LastName");
     SiMngrBn.Gender = request.getParameter("Gender");
      SiMngrBn.BirthDate = DateTimeHelper.requestDatePicker( request, "BirthDate" );
     SiMngrBn.MaritalStatus = request.getParameter("MaritalStatus");
     SiMngrBn.EmpCode = request.getParameter("EmpCode");
      SiMngrBn.JoiningDate = DateTimeHelper.requestDatePicker( request, "JoiningDate" );
      SiMngrBn.LeavingDate = DateTimeHelper.requestDatePicker( request, "LeavingDate" );
     SiMngrBn.Address = request.getParameter("Address");
     SiMngrBn.City = request.getParameter("City");
     SiMngrBn.State = request.getParameter("State");
     SiMngrBn.PIN = request.getParameter("PIN");
     SiMngrBn.Landline = request.getParameter("Landline");
     SiMngrBn.Mobile = request.getParameter("Mobile");
     SiMngrBn.Email = request.getParameter("Email");
      SiMngrBn.Username = request.getParameter("Username");
			SiMngrBn.Password = request.getParameter("Password");
      SiMngrBn.PasswordType = PasswordType.SERVICE ;
     SiMngrBn.AccessModule = request.getParameter("AccessModule");
    try 
     { 
          SiMngrBn.SuperAdminRight = Short.parseShort(request.getParameter("SuperAdminRight")) ;
    } catch( NumberFormatException ex)
     {     
         SiMngrBn.SuperAdminRight = 0 ;
    }
      SiMngrBn.LoginRole = "Administrator";
    try 
     { 
          SiMngrBn.CurrentStatus = Short.parseShort(request.getParameter("CurrentStatus")) ;
    } catch( NumberFormatException ex)
     {     
         SiMngrBn.CurrentStatus = 0 ;
    }

          SiMngrBn.LoginStatus = LoginStatusFlag.NOT_LOGGED ;
    try 
     { 
          SiMngrBn.MultiLogin = Short.parseShort(request.getParameter("MultiLogin")) ;
    } catch( NumberFormatException ex)
     {     
         SiMngrBn.MultiLogin = 0 ;
    }
     SiMngrBn.MenuType = "topbar";
    SiMngrBn.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()); 
 

		if( bAllowAdd == true )
		{
		    if(CheckDuplicateEntry( SiMngrBn ))
        {
           SiMngrBn.addRecord();
           MessageText = "One record added. New ID = "+SiMngrBn._autonumber ;
           // Page redirection code begin {{
        	 java.lang.StringBuffer rd = request.getRequestURL();
           rd.append("?"+DEFAULT_ACTION+ForeignKeyParam+"&Message="+MessageText);
           response.sendRedirect(response.encodeRedirectURL(rd.toString()));
        	 // }} Page redirection code end
        }
        else
        {
          MessageText = "<span class=\"error\">Duplicate Entry Found!</span><br>No new record created." ;
        }
    }
		else
		{
		     MessageText="Record addition not permitted."; 
		} // if( bAllowAdd == true )

     // Revert nAction to default value
	  nAction=default_cmd ;

} // End if (nAction==ADD_RECORD )

if(nAction==UPDATE_RECORD )
{
         SiMngrBn.locateRecord(nAdminID);
    //  $CHECK SiMngrBn.AdminID= nAdminID ;
    /* Auto increment column: 
     try  
      {
           SiMngrBn.AdminID = Integer.parseInt(request.getParameter("AdminID")) ;
      } catch( NumberFormatException ex)
     { 
         SiMngrBn.AdminID = 0 ;
     }
*/
     SiMngrBn.FirstName = request.getParameter("FirstName");
     SiMngrBn.MiddleName = request.getParameter("MiddleName");
     SiMngrBn.LastName = request.getParameter("LastName");
     SiMngrBn.Gender = request.getParameter("Gender");
      SiMngrBn.BirthDate = DateTimeHelper.requestDatePicker( request, "BirthDate" );
     SiMngrBn.MaritalStatus = request.getParameter("MaritalStatus");
     SiMngrBn.EmpCode = request.getParameter("EmpCode");
      SiMngrBn.JoiningDate = DateTimeHelper.requestDatePicker( request, "JoiningDate" );
      SiMngrBn.LeavingDate = DateTimeHelper.requestDatePicker( request, "LeavingDate" );
     SiMngrBn.Address = request.getParameter("Address");
     SiMngrBn.City = request.getParameter("City");
     SiMngrBn.State = request.getParameter("State");
     SiMngrBn.PIN = request.getParameter("PIN");
     SiMngrBn.Landline = request.getParameter("Landline");
     SiMngrBn.Mobile = request.getParameter("Mobile");
     SiMngrBn.Email = request.getParameter("Email");
      SiMngrBn.Username = request.getParameter("Username");
			SiMngrBn.Password = request.getParameter("Password");
     SiMngrBn.AccessModule = request.getParameter("AccessModule");
    try 
     { 
          SiMngrBn.SuperAdminRight = Short.parseShort(request.getParameter("SuperAdminRight")) ;
    } catch( NumberFormatException ex)
     {     
         SiMngrBn.SuperAdminRight = 0 ;
    }
      SiMngrBn.LoginRole = "Administrator";
    try 
     { 
          SiMngrBn.CurrentStatus = Short.parseShort(request.getParameter("CurrentStatus")) ;
    } catch( NumberFormatException ex)
     {     
         SiMngrBn.CurrentStatus = 0 ;
    }
    try 
     { 
          SiMngrBn.MultiLogin = Short.parseShort(request.getParameter("MultiLogin")) ;
    } catch( NumberFormatException ex)
     {     
         SiMngrBn.MultiLogin = 0 ;
    }
    SiMngrBn.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()); 
 
   
	  if(bAllowUpdate == true)
		{
	      SiMngrBn.updateRecord(nAdminID);
        MessageText = "One record updated. Updated ID = "+nAdminID ;
		}
		else
		{
		    MessageText="Record update not permitted."; 
		}		
    // Revert nAction to default value
    nAction=default_cmd ;
		
}  // End if (nAction==UPDATE_RECORD)

if(nAction==DELETE_RECORD )
{
    // Get more information about record to deleted (optional) .
    SiMngrBn.locateRecord(nAdminID);
    // $CHECK
		if(bAllowDelete == true)
		{
       SiMngrBn.deleteRecord(nAdminID);
		    MessageText = "Record Deleted. ID = "+nAdminID ;
				// Delete dependences in other related tables.
        // String DelRef = "DELETE FROM <table> WHERE <table>.<REF>="+nAdminID ;
        // SiMngrBn.executeUpdate(DelRef);

				
		}
		else
    {
         MessageText="Record deletion not permitted."; 
	       nAction=default_cmd ;
    }

      // Revert nAction to default value
      nAction=default_cmd ;
}  // End  if(nAction==DELETE_RECORD )





 if(nAction == PROCESS_CHECKED)
 {
    qStr  = new com.webapp.utils.MakeQueryString( request, application );
		//  qStr  = new com.webapp.utils.MakeQueryString( request, "MYSQL" );
	  qStr.addMultiSelectParam("AdminID", false  );
	  String CheckedAction = request.getParameter("CheckedAction");
		
		String chk_items[] = request.getParameterValues("AdminID");
	  int chk_count = 0;
	  chk_count  = (chk_items != null ) ? chk_items.length : 0 ;
	  String WhrCls =qStr.getWhereClause() ;
	  String ChkQuery = qStr.SQL( " SELECT * FROM  `sitemanager` "+ WhrCls + " ORDER BY `AdminID` " );
	  
		if("Delete".equalsIgnoreCase(CheckedAction) && chk_count > 0  )
		{
		    /* Poll through records to be deleted in case values are there in dependent table 
				
				   SiMngrBn.openTable(WhrCls, " ORDER BY `AdminID` ");
           while(SiMngrBn.nextRow())
           {
					   
           }
					 SiMngrBn.closeTable();
				*/
				if(bAllowDelete == true)
				{
				 int del_cnt = SiMngrBn.executeUpdate( qStr.SQL( "DELETE FROM `sitemanager` "+WhrCls+" ") );
				 MessageText = " ( "+del_cnt+" ) records are deleted." ;
				}
				else
				{
				  MessageText = "Record deletion not permitted." ;
				}
		}
	
		if("ClearStatus".equalsIgnoreCase(CheckedAction) && chk_count > 0  )
		{

				 int st_cnt = SiMngrBn.executeUpdate( qStr.SQL( "UPDATE `sitemanager` SET `LoginStatus`="+LoginStatusFlag.NOT_LOGGED+" "+WhrCls+" ") );
				 MessageText = "Clear Current Login Status : [ "+st_cnt+" ]" ;
		}

		if("Reset".equalsIgnoreCase(CheckedAction) && chk_count > 0 )
		{
		      String WhereParam  = RequestHelper.encodeBase64( WhrCls.getBytes()) ;
          String ReturnPath = new String( com.webapp.base64.UrlBase64.encode( ( thisFile+"?Action=Default" ).getBytes() ) );
          String redirect  = thisFile+"?Action=ResetForm&Count="+chk_count+"&WhereClause="+WhereParam+"&ReturnPath="+ReturnPath; 
          response.sendRedirect(response.encodeRedirectURL(redirect)); 
		}
		
		if("Activity".equalsIgnoreCase(CheckedAction) && chk_count > 0 )
		{
		      String WhereParam  = RequestHelper.encodeBase64( WhrCls.getBytes()) ;
          String ReturnPath = new String( com.webapp.base64.UrlBase64.encode( ( thisFile+"?Action=Default" ).getBytes() ) );
          String redirect  = "sitemanager-selection-activity.jsp?Count="+chk_count+"&WhereClause="+WhereParam+"&ReturnPath="+ReturnPath; 
          response.sendRedirect(response.encodeRedirectURL(redirect)); 
		}

		/* 
		  // Forwared Base64 encoded sql to other page if relevent
		   String SQLPARAM = new String( com.webapp.base64.UrlBase64.encode(ChkQuery.getBytes() ) );
       String ReturnPath = new String( com.webapp.base64.UrlBase64.encode( ( thisFile ).getBytes() ) );
       String redirect  = appPath+"/$PATH.jsp?Count="+chk_count+"&SQL="+SQLPARAM+"&ReturnPath="+ReturnPath; //  &Target=Target&MobileField=Mobile&EmailField=Email  
       response.sendRedirect(response.encodeRedirectURL(redirect)); 
		
		*/
     nAction=default_cmd ;
 }



 

// Redirect if not authorized for add or update activity.

if(nAction==NEW_FORM && bAllowAdd==false)
{
   MessageText="Record addition is not permitted.";
   java.lang.StringBuffer rdAdd = request.getRequestURL();
   rdAdd.append("?"+DEFAULT_ACTION+ForeignKeyParam+"&Message="+MessageText);
   response.sendRedirect(response.encodeRedirectURL(rdAdd.toString()));
}
if(nAction==CHANGE_FORM && bAllowUpdate==false)
{
   MessageText="Record update is not permitted.";
   java.lang.StringBuffer rdUpd = request.getRequestURL();
   rdUpd.append("?"+DEFAULT_ACTION+ForeignKeyParam+"&Message="+MessageText);
   response.sendRedirect(response.encodeRedirectURL(rdUpd.toString()));
}




// Set the correct page title according to Action Flag
if(nAction==NEW_FORM)  PageTitle="<i class='fa fa-plus iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Add Record";
else if (nAction==CHANGE_FORM) PageTitle="<i class='fa fa-edit iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Update Record" ;
else if (nAction==SEARCH_RECORDS) PageTitle="<i class='fa fa-search iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Search Record" ;
else if (nAction==SEARCH_RESULT) PageTitle= "<i class='fa fa-th-list iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Search Result" ;
else if(nAction==SHOW_RECORD) PageTitle= "<i class='fa fa-bookmark iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Record Detail " ;
else PageTitle="" ;

boolean bRetPath=false;
String ReturnPath = "";
String ReturnPathLink = "";
String ParamReturnPath = request.getParameter("ReturnPath");
if(ParamReturnPath !=null && ParamReturnPath.length()>0)
{
   ReturnPath = new String( UrlBase64.decode( ParamReturnPath ));
	 ReturnPathLink="&ReturnPath="+ParamReturnPath;
	 bRetPath=true;
}
else  // Default return path
{
   ReturnPath = appPath+"/admin/index.jsp" ;
}

String resettooltiptext = "The new password set here will be treated as service password [temporary password].\n  After login with service password, the student will be asked to set his/her  regular password. Untill the regular password is set, the student will not be able to access all parts of application.";
String clearstatustooltiptext = "Clear Currently Logged status of checked User. If the User has accidently closed the browser without formal logout than his/her record reflect logged status which does not allow next login. By clicking this link you can get rid of logged status of the User, thereafter the User can login again.";

%>
<%@include file="/admin/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
	<title>Reset Admin Password</title>

  <jsp:include page ="/include-page/css/main-css.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>
	<jsp:include page ="/include-page/css/bootstrap-select-css.jsp" flush="true" />
  
  <jsp:include page ="/include-page/css/bootstrap-datepicker-css.jsp" flush="true" />
  <style type="text/css">
  <!-- 
  .page-profile .widget-header{padding:40px 15px;background-color:#fff}.page-profile .widget-footer{padding:10px;background-color:#f6f9fd}.page-profile .widget .avatar{width:130px;margin-bottom:10px}.page-profile .profile-user{margin-bottom:10px;color:#263238}.page-profile .profile-job{margin-bottom:20px;color:#a3afb7}.page-profile .profile-social{margin:25px 0}.page-profile .profile-social .icon{margin:0 10px;color:rgba(55,71,79,.4)}.page-profile .profile-stat-count{display:block;margin-bottom:3px;color:#526069;font-size:20px;font-weight:100}.page-profile .profile-stat-count+span{color:#a3afb7}.page-profile .page-content .list-group-item{padding:15px 15px;border-top-color:#e4eaec}.page-profile .page-content .list-group-item:first-child{border-top:transparent}.page-profile .page-content .list-group-item:last-child{border-bottom-color:#e4eaec}.page-profile .page-content .list-group-item .media .avatar{width:50px}.page-profile .page-content .list-group-item .media small{color:#a3afb7}.page-profile .page-content .list-group-item .media-heading{font-size:16px}.page-profile .page-content .list-group-item .media-heading span{margin-left:5px;color:#76838f;font-size:14px}.page-profile .page-content .list-group-item .media .media:first-child{border-top:none}.page-profile .profile-readMore{margin:40px 0}.page-profile .profile-brief{margin-top:20px}.page-profile .profile-uploaded{max-width:220px;width:100%;max-height:150px;padding-right:20px;margin-bottom:5px} 
  -->
  </style>   
  <jsp:include page ="/include-page/common/main-head-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

</head>
<body class="<%=menuTypeClass %> <%=SiMngrBn.LoginRole %>" >

  <jsp:include page ="/admin/include-page/nav-body.jsp" >	
	 	 <jsp:param name="menuType" value="<%=menuType %>" />
		 <jsp:param name="MenuTitle" value="SuperAdmin" />
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
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i>Reset Admin Password</h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<%=appPath %>/admin/index.jsp"><i aria-hidden="true" class="icon fa fa-home fa-lg"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active">Reset Admin Password</li>
          </ol>			
  	    </div>
  		</div>	

<% 
if(("ResetForm").equalsIgnoreCase(ParamAction))
{
int nCount = RequestHelper.getInteger(request, "Count");
String ParamWhr = request.getParameter("WhereClause");
%>
<form action="<%=thisFile %>" method="POST"  accept-charset="UTF-8" name="sitemanager_Add" id="sitemanager_Add"   >
<input type="hidden" name="Action" value="ResetPassword" />
<input type="hidden" name="Count" value="<%=nCount %>" />
<input type="hidden" name="WhereClause" value="<%=ParamWhr %>" />

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action">Reset Password : <%=nCount %> Record
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

<div class="row" > 
  <div class="form-group col-sm-6 col-sm-offset-3">
	  <label for="ResetPassword" class="control-label blue-grey-600">Reset Password As</label>
	  <input type="text" name="ResetPassword" id="ResetPassword" class="form-control" />
	</div>
</div>

</div>

<div class="panel-form-box-footer text-center">
      <button type="submit" class="btn btn-primary" title="Reset"><i class="fa fa-check" aria-hidden="true"></i>&nbsp;Reset</button>
	    <button type="button" class="btn btn-default btn-outline" title="Cancel" onclick="history.go(-1);"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
		</div>
</div>


</div>
</div>

</form>

<% 
}
%>			
			
<% if(nAction==NEW_FORM)
{
 
// Uncoment for New Date: java.sql.Date Now = new java.sql.Date(System.currentTimeMillis() );

/* 
Hint: Use this to get form values in case new form is called from serach result.
Place value of form field as item before each field
String item=null;
if(QryObj!=null)item=QryObj.getKey("$Field") ; 
else item="";

*/


%>			
<form action="<%=thisFile %>" method="POST"  accept-charset="UTF-8" name="sitemanager_Add" id="sitemanager_Add"   >
<input type="hidden" name="Action" value="Add" />
<%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<%=ParamReturnPath %>" />
<% 
} 
%>



<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	

<!-- $CHECK Look for chain --> 
<!-- INSERT ADD FROM -->

<!-- Personal Information -->            
<h4><i class="icon wb-user iccolor" aria-hidden="true"></i> Personal Information</h4>
<hr class="hr-res" />


<div class="row">
  <div class="form-group col-sm-4 req">
	  <label for="FirstName" class="control-label blue-grey-600" >First Name</label>
	  <input type="text" name="FirstName" id="FirstName" class="form-control" />
	</div>
 
  <div class="form-group col-sm-4">
	  <label for="MiddleName" class="control-label blue-grey-600" >Middle Name</label>
	  <input type="text" name="MiddleName" id="MiddleName" class="form-control" />
	</div>
  <div class="form-group col-sm-4">
	  <label for="LastName" class="control-label blue-grey-600" >Last Name</label>
	  <input type="text" name="LastName" id="LastName" class="form-control" />
	</div>
 </div>
<div class="row" >

 
  <div class="form-group col-sm-6">
	  <label for="Gender" class="control-label blue-grey-600" >Gender</label>
	  
			 <select name="Gender" id="Gender" class="form-control show-tick" data-plugin="selectpicker" data-container="body" data-live-search="false">
			 <jsp:include page ="/include-page/master/getlistitems.jsp" >
			     <jsp:param name="Attribute" value="Gender" />
					 <jsp:param name="All" value="false" />
					 <jsp:param name="None" value="true" />
					 <jsp:param name="OrderBy" value="" />
				</jsp:include>

			 </select>
	
	</div>
  <div class="form-group col-sm-6">
	  <label for="MaritalStatus" class="control-label blue-grey-600" >Marital Status</label>
	  
			 <select name="MaritalStatus" id="MaritalStatus" class="form-control show-tick" data-plugin="selectpicker" data-container="body" data-live-search="false">
			 <jsp:include page ="/include-page/master/getlistitems.jsp" >
			     <jsp:param name="Attribute" value="MaritalStatus" />
					 
					 <jsp:param name="All" value="false" />
					 <jsp:param name="None" value="true" />
					 <jsp:param name="OrderBy" value="" />
				</jsp:include>

			 </select>
	
	</div>
 </div>
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="BirthDate" class="control-label blue-grey-600" >Birth Date</label>
	  
		  <div class="input-group input-group-icon">	
			  <input type="text" name="BirthDate" id="BirthDate" class="form-control readonlybg" data-plugin="datepicker">
				  <span class="input-group-addon">
					  <span class="icon fa fa-calendar" aria-hidden="true"></span>
					</span>
			</div>	
	</div>
  <div class="form-group col-sm-6">
	  <label for="EmpCode" class="control-label blue-grey-600" >Employment Code</label>
	  <input type="text" name="EmpCode" id="EmpCode" class="form-control" />
	</div>
 
 </div>
<div class="row" >

 
  <div class="form-group col-sm-6">
	  <label for="JoiningDate" class="control-label blue-grey-600" >Joining Date</label>
	  
		  <div class="input-group input-group-icon">	
			  <input type="text" name="JoiningDate" id="JoiningDate" class="form-control readonlybg" data-plugin="datepicker">
				  <span class="input-group-addon">
					  <span class="icon fa fa-calendar" aria-hidden="true"></span>
					</span>
			</div>	
	
	</div>
  <div class="form-group col-sm-6">
	  <label for="LeavingDate" class="control-label blue-grey-600" >Leaving Date</label>
	  
		  <div class="input-group input-group-icon">	
			  <input type="text" name="LeavingDate" id="LeavingDate" class="form-control readonlybg" data-plugin="datepicker" placeholder="Not Now" readonly="readonly">
				  <span class="input-group-addon">
					  <span class="icon fa fa-calendar" aria-hidden="true"></span>
					</span>
			</div>	
	
	</div>
 </div>

                <p>&nbsp;</p>
                <h4><i class="icon fa fa-mobile-phone fa-lg iccolor" aria-hidden="true"></i> Contact Information</h4>
								<hr class="hr-res" />

<div class="row" >

 
  <div class="form-group col-sm-6">
	  <label for="Address" class="control-label blue-grey-600" >Address</label>
		<textarea rows="2" name="Address" id="Address" class="form-control" ></textarea>
	</div>
 </div>
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="City" class="control-label blue-grey-600" >City</label>
	  <input type="text" name="City" id="City" class="form-control" />
	</div>
 
  <div class="form-group col-sm-6">
	  <label for="State" class="control-label blue-grey-600" >State</label>
	  
			 <select name="State" id="State" class="form-control show-tick" data-plugin="selectpicker" data-container="body" data-live-search="true">
			 <jsp:include page ="/include-page/master/getlistitems.jsp" >
			     <jsp:param name="Attribute" value="State" />
					 <jsp:param name="All" value="false" />
					 <jsp:param name="None" value="true" />
					 <jsp:param name="OrderBy" value="" />
				</jsp:include>

			 </select>
	
	</div>
 </div>
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="PIN" class="control-label blue-grey-600" >PIN</label>
	  <input type="text" name="PIN" id="PIN" class="form-control" />
	</div>
 
  <div class="form-group col-sm-6">
	  <label for="Landline" class="control-label blue-grey-600" >Landline</label>
	  <input type="text" name="Landline" id="Landline" class="form-control" />
	</div>
 </div>
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="Mobile" class="control-label blue-grey-600" >Mobile</label>
	  <input type="text" name="Mobile" id="Mobile" class="form-control" />
	</div>
 
  <div class="form-group col-sm-6">
	  <label for="Email" class="control-label blue-grey-600" >Email</label>
	  <input type="text" name="Email" id="Email" class="form-control" />
	</div>
 </div>
 
              <!-- Example Basic Form -->
                <p>&nbsp;</p>
                <h4><i class="icon fa fa-bookmark iccolor" aria-hidden="true"></i> Other Information</h4>
								<hr class="hr-res" />
 
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="Username" class="control-label blue-grey-600" >Username</label>
	  <input type="text" name="Username" id="Username" class="form-control" />
	</div>
 
  <div class="form-group col-sm-6">
	  <label for="Password" class="control-label blue-grey-600" >Password</label>
	  <input type="text" name="Password" id="Password" class="form-control" />
	</div>
 </div>

<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="CurrentStatus" class="control-label blue-grey-600" >Login Status</label>
		<%=CurrentStatusFlag.getDropList("CurrentStatus", "CurrentStatus", CurrentStatusFlag.OK, false, false, "form-control show-tick", "data-plugin='selectpicker' data-container='body' data-live-search='false'") %>
	</div>

  <div class="form-group col-sm-6">
	  <label for="MultiLogin" class="control-label blue-grey-600" >Multi Login</label>
	  
			 <select name="MultiLogin" id="MultiLogin" class="form-control show-tick" data-plugin="selectpicker">
			   <!-- <option value="">--None--</option> -->
         <!-- <option value="">--ALL--</option> -->
      	 <option value="0"  >&nbsp;No&nbsp;</option>
      	 <option value="1" selected="selected" >&nbsp;Yes&nbsp;</option>
			 </select>
	
	</div>
 </div> 

<div class="row" > 
  <div class="form-group col-sm-6">
	  <label for="SuperAdminRight" class="control-label blue-grey-600" >Super AdminRight</label>
	  
			 <select name="SuperAdminRight" id="SuperAdminRight" class="form-control show-tick" data-plugin="selectpicker">
			   <!-- <option value="">--None--</option> -->
         <!-- <option value="">--ALL--</option> -->
      	 <option value="0" selected="selected" >&nbsp;No&nbsp;</option>
      	 <option value="1" >&nbsp;Yes&nbsp;</option>
			 </select>
	</div>
  <div class="form-group col-sm-6">
	  <label for="AccessModule" class="control-label blue-grey-600" >Access Module</label>
	  <input type="text" name="AccessModule" id="AccessModule" class="form-control" />
	</div>
	
</div>

</div>

<div class="panel-form-box-footer text-center">
      <button type="submit" class="btn btn-primary" title="Submit for Addition"><i class="fa fa-plus" aria-hidden="true"></i>&nbsp;Add</button>
      <button type="button" class="btn btn-default btn-outline" title="Cancel Addition" onclick="history.go(-1);"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
</div>

</div>

</form>

<%
 } 
%>

<% if(nAction==CHANGE_FORM)
{

SiMngrBn.locateRecord(nAdminID);
%>
<form action="<%=thisFile %>" method="POST"  accept-charset="UTF-8" name="sitemanager_Update" id="sitemanager_Update"    >
<input type="hidden" name="Action" value="Update" />
<input type="hidden" name="AdminID" value="<%=nAdminID %>" />
<%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<%=ParamReturnPath %>" />
<% 
} 
%>



 
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	
 
<!-- $CHECK Look for chain --> 
<!-- INSERT UPDATE FORM  --> 

<!-- Personal Information -->            
<h4><i class="icon wb-user iccolor" aria-hidden="true"></i> Personal Information</h4>
<hr class="hr-res" />


<div class="row">
  <div class="form-group col-sm-4">
	  <label for="FirstName" class="control-label blue-grey-600" >First Name</label>
	  <input type="text" name="FirstName" id="FirstName" class="form-control" value="<%=SiMngrBn.FirstName %>"  />
	</div>
 
  <div class="form-group col-sm-4">
	  <label for="MiddleName" class="control-label blue-grey-600" >Middle Name</label>
	  <input type="text" name="MiddleName" id="MiddleName" class="form-control" value="<%=SiMngrBn.MiddleName %>"  />
	</div>
	
  <div class="form-group col-sm-4">
	  <label for="LastName" class="control-label blue-grey-600" >Last Name</label>
	  <input type="text" name="LastName" id="LastName" class="form-control" value="<%=SiMngrBn.LastName %>"  />
	</div>
</div>
<div class="row" >
  <div class="form-group col-sm-6">
	  <label for="Gender" class="control-label blue-grey-600" >Gender</label>
	  
			 <select name="Gender" id="Gender" class="form-control show-tick" data-plugin="selectpicker" data-container="body" data-live-search="false">
			 <jsp:include page ="/include-page/master/getlistitems.jsp" >
			     <jsp:param name="Attribute" value="Gender" />
					 <jsp:param name="Select" value="<%=SiMngrBn.Gender %>" />
					 <jsp:param name="None" value="true" />
					 <jsp:param name="OrderBy" value="" />
				</jsp:include>
			 </select>
			 
	</div>
  <div class="form-group col-sm-6">
	  <label for="MaritalStatus" class="control-label blue-grey-600" >Marital Status</label>
	  
			 <select name="MaritalStatus" id="MaritalStatus" class="form-control show-tick" data-plugin="selectpicker" data-container="body" data-live-search="false">
			 <jsp:include page ="/include-page/master/getlistitems.jsp" >
			     <jsp:param name="Attribute" value="MaritalStatus" />
					 <jsp:param name="Select" value="<%=SiMngrBn.MaritalStatus %>" />
					 
					 <jsp:param name="None" value="true" />
					 <jsp:param name="OrderBy" value="" />
				</jsp:include>

			 </select>
	
	</div>
</div>
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="BirthDate" class="control-label blue-grey-600" >Birth Date</label>
	  
		  <div class="input-group input-group-icon">	
			  <input type="text" name="BirthDate" id="BirthDate" class="form-control readonlybg"  value="<%=DateTimeHelper.showDatePicker(SiMngrBn.BirthDate) %>" data-plugin="datepicker">
				  <span class="input-group-addon">
					  <span class="icon fa fa-calendar" aria-hidden="true"></span>
					</span>
			</div>	
	
	</div>
  <div class="form-group col-sm-6">
	  <label for="EmpCode" class="control-label blue-grey-600" >Employment Code</label>
	  <input type="text" name="EmpCode" id="EmpCode" class="form-control" value="<%=SiMngrBn.EmpCode %>"  />
	</div>

</div>
<div class="row" >

 
  <div class="form-group col-sm-6">
	  <label for="JoiningDate" class="control-label blue-grey-600" >Joining Date</label>
	  
		  <div class="input-group input-group-icon">	
			  <input type="text" name="JoiningDate" id="JoiningDate" class="form-control readonlybg"  value="<%=DateTimeHelper.showDatePicker(SiMngrBn.JoiningDate) %>" data-plugin="datepicker">
				  <span class="input-group-addon">
					  <span class="icon fa fa-calendar" aria-hidden="true"></span>
					</span>
			</div>	
	
	</div>
  <div class="form-group col-sm-6">
	  <label for="LeavingDate" class="control-label blue-grey-600" >Leaving Date</label>
	  
		  <div class="input-group input-group-icon">	
			  <input type="text" name="LeavingDate" id="LeavingDate" class="form-control readonlybg"  value="<%=DateTimeHelper.showDatePicker(SiMngrBn.LeavingDate) %>" data-plugin="datepicker">
				  <span class="input-group-addon">
					  <span class="icon fa fa-calendar" aria-hidden="true"></span>
					</span>
			</div>	
	
	</div>
</div>

                <p>&nbsp;</p>
                <h4><i class="icon fa fa-mobile-phone fa-lg iccolor" aria-hidden="true"></i> Contact Information</h4>
								<hr class="hr-res" />

<div class="row" >
 
  <div class="form-group col-sm-6">
	  <label for="Address" class="control-label blue-grey-600" >Address</label>
		<textarea rows="2" name="Address" id="Address" class="form-control" ><%=SiMngrBn.Address %></textarea>
	</div>
 </div>
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="City" class="control-label blue-grey-600" >City</label>
	  <input type="text" name="City" id="City" class="form-control" value="<%=SiMngrBn.City %>"  />
	</div>
 
  <div class="form-group col-sm-6">
	  <label for="State" class="control-label blue-grey-600" >State</label>
	  
			 <select name="State" id="State" class="form-control show-tick" data-plugin="selectpicker" data-container="body" data-live-search="false">
			 <jsp:include page ="/include-page/master/getlistitems.jsp" >
			     <jsp:param name="Attribute" value="State" />
					 <jsp:param name="Select" value="<%=SiMngrBn.State %>" />
					 <jsp:param name="None" value="true" />
					 <jsp:param name="OrderBy" value="" />
				</jsp:include>

			 </select>
	
	</div>
 </div>
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="PIN" class="control-label blue-grey-600" >PIN</label>
	  <input type="text" name="PIN" id="PIN" class="form-control" value="<%=SiMngrBn.PIN %>"  />
	</div>
 
  <div class="form-group col-sm-6">
	  <label for="Landline" class="control-label blue-grey-600" >Landline</label>
	  <input type="text" name="Landline" id="Landline" class="form-control" value="<%=SiMngrBn.Landline %>"  />
	</div>
 </div>
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="Mobile" class="control-label blue-grey-600" >Mobile</label>
	  <input type="text" name="Mobile" id="Mobile" class="form-control" value="<%=SiMngrBn.Mobile %>"  />
	</div>
 
  <div class="form-group col-sm-6">
	  <label for="Email" class="control-label blue-grey-600" >Email</label>
	  <input type="text" name="Email" id="Email" class="form-control" value="<%=SiMngrBn.Email %>"  />
	</div>
 </div>
 
              <!-- Example Basic Form -->
                <p>&nbsp;</p>
                <h4><i class="icon fa fa-bookmark iccolor" aria-hidden="true"></i> Other Information</h4>
								<hr class="hr-res" />
 
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="Username" class="control-label blue-grey-600" >Username</label>
	  <input type="text" name="Username" id="Username" class="form-control" value="<%=SiMngrBn.Username %>"  />
	</div>
 
  <div class="form-group col-sm-6">
	  <label for="Password" class="control-label blue-grey-600" >Password</label>
	  <input type="text" name="Password" id="Password" class="form-control" value="<%=SiMngrBn.Password %>"  />
	</div>
 </div>
<div class="row" >
  <div class="form-group col-sm-6">
	  <label for="CurrentStatus" class="control-label blue-grey-600" >Login Status</label>
		<%=CurrentStatusFlag.getDropList("CurrentStatus", "CurrentStatus", SiMngrBn.CurrentStatus, false, false, "form-control show-tick", "data-plugin='selectpicker' data-container='body' data-live-search='false'") %>
	</div>

  <div class="form-group col-sm-6">
	  <label for="MultiLogin" class="control-label blue-grey-600" >Multi Login</label>
	  
			 <select name="MultiLogin" id="MultiLogin" class="form-control show-tick" data-plugin="selectpicker">
			   <!-- <option value="">--None--</option> -->
         <!-- <option value="">--ALL--</option> -->
      	 <option value="0" <%if( SiMngrBn.MultiLogin == 0 ){%>  selected="selected" <% } %> >&nbsp;No&nbsp;</option>
      	 <option value="1" <%if( SiMngrBn.MultiLogin == 1 ){%>  selected="selected" <% } %> >&nbsp;Yes&nbsp;</option>
			 </select>
	</div>

</div>
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="SuperAdminRight" class="control-label blue-grey-600" >Super AdminRight</label>
	  
			 <select name="SuperAdminRight" id="SuperAdminRight" class="form-control show-tick" data-plugin="selectpicker">
			   <!-- <option value="">--None--</option> -->
         <!-- <option value="">--ALL--</option> -->
      	 <option value="0" <%if( SiMngrBn.SuperAdminRight == 0 ){%>  selected="selected" <% } %> >&nbsp;No&nbsp;</option>
      	 <option value="1" <%if( SiMngrBn.SuperAdminRight == 1 ){%>  selected="selected" <% } %> >&nbsp;Yes&nbsp;</option>
			 </select>
	</div>
	 
  <div class="form-group col-sm-6">
	  <label for="AccessModule" class="control-label blue-grey-600" >Access Module</label>
	  <input type="text" name="AccessModule" id="AccessModule" class="form-control" value="<%=SiMngrBn.AccessModule %>"  />
	</div>

</div>	

</div>

<div class="panel-form-box-footer text-center">
      <button type="submit" class="btn btn-primary" title="Submit for update"><i class="fa fa-check" aria-hidden="true"></i>&nbsp;Update</button>
      <button type="button" class="btn btn-default btn-outline" title="Cancel Update" onclick="history.go(-1);"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
</div>

</div>

</form>


<%
 } //end if(nAction==CHANGE_FORM)
%>
<% if(nAction==SEARCH_RECORDS)
{ 
   session.removeAttribute(QUERY_OBJECT_ID);
%>
<form action="<%=thisFile %>" method="POST"  accept-charset="UTF-8" class="form-horizontal" id="sitemanager_Search">
<input type="hidden" name="Action" value="Result" />
<%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<%=ParamReturnPath %>" />
<% 
} 
%>


<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="submit" style="font-size: 10px;margin-left: 5px;margin-top: -5px;" data-original-title="Go To Result Page" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-arrow-right" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	

      <div class="form-group">
        <label class="control-label blue-grey-600 col-sm-3">Search By ID :
          <span class="checkbox-custom checkbox-inline checkbox-primary" style="padding-top: 2px;display:none;">&nbsp;<input type="checkbox" name="AdminID_RNG_CHK" id="AdminID_RNG_CHK" onchange="CheckSearchRange('AdminID')"><label for="AdminID_RNG_CHK"></label></span>
        </label>
      	<div class="col-sm-1" id="AdminID_OPR_BLK"><%=NumberSearchdroplist.getOperatorList("AdminID_OPERATOR", "AdminID_OPERATOR", "form-control show-tick", "data-plugin='selectpicker'" )  %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-sm-2"><input type="text" name="AdminID" id="AdminID" class="form-control" /></div>
      	<label class="control-label blue-grey-600 col-sm-1 text-center" id="AdminID_RNG_LBL" style="display:none;width: 5.333%;margin-bottom: 0px;">TO</label>
      	<div class="col-sm-2" id="AdminID_RNG_BLK" style="display:none"><input type="text" name="AdminID_TO" id="AdminID_TO" class="form-control" /></div>
      </div>			

      <div class="form-group">
        <label class="col-sm-3 control-label blue-grey-600">First Name :</label>
      	<div class="col-sm-2"><%= StringSearchdroplist.getDropList("FirstName_SEARCHTYPE", StringSearch.START, null, "form-control show-tick", "data-plugin='selectpicker'") %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-sm-3"><input type="text" name="FirstName" id="FirstName" class="form-control" /></div>
      </div>		
		
      <div class="form-group">
        <label class="col-sm-3 control-label blue-grey-600">Last Name :</label>
      	<div class="col-sm-2"><%= StringSearchdroplist.getDropList("LastName_SEARCHTYPE", StringSearch.START, null, "form-control show-tick", "data-plugin='selectpicker'") %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-sm-3"><input type="text" name="LastName" id="LastName" class="form-control" /></div>
      </div>		
		
      <div class="form-group">
        <label class="col-sm-3 control-label blue-grey-600">Gender :</label>
				<div class="col-sm-3">
			 <select name="Gender" id="Gender" class="form-control show-tick" data-plugin="selectpicker" data-container="body" data-live-search="false">
			 <jsp:include page ="/include-page/master/getlistitems.jsp" >
			     <jsp:param name="Attribute" value="Gender" />
					 <jsp:param name="All" value="true" />
					 <jsp:param name="OrderBy" value="" />
				</jsp:include>
			 </select>
			  </div>
      </div>		
		
      <div class="form-group">
        <label class="col-sm-3 control-label blue-grey-600">Employment Code :</label>
      	<div class="col-sm-2"><%= StringSearchdroplist.getDropList("EmpCode_SEARCHTYPE", StringSearch.START, null, "form-control show-tick", "data-plugin='selectpicker'") %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-sm-3"><input type="text" name="EmpCode" id="EmpCode" class="form-control" /></div>
      </div>		
		
      <div class="form-group">
        <label for="CurrentStatus" class="col-sm-3 control-label blue-grey-600">Login Status :</label>
        <div class="col-sm-3"><%=CurrentStatusFlag.getDropList("CurrentStatus", "CurrentStatus", CurrentStatusFlag.OK, true, false, "form-control show-tick", "data-plugin='selectpicker' data-container='body' data-live-search='false'") %></div>
      </div>		  

			<div class="form-group">
        <label for="CurrentStatus" class="col-sm-3 control-label blue-grey-600">Current Status :</label>
        <div class="col-sm-3"><%=LoginStatusFlag.getDropList("LoginStatus", "LoginStatus", (short)-1, true, false, "form-control show-tick", "data-plugin='selectpicker' data-container='body' data-live-search='false'") %></div>
      </div>		  

      <div class="form-group">
        <label class="col-sm-3 control-label blue-grey-600">Sort By :</label>
        <div class="col-sm-2">
      	  <select name="OrderBy" id="OrderBy" class="form-control show-tick" data-plugin="selectpicker">
					<option selected="selected" value="AdminID" >AdminID</option>
      		  <option value="FirstName" >FirstName</option>
      		  <option value="LastName" >LastName</option>
      		  <option value="Gender" >Gender</option>
      		  <option value="EmpCode" >EmpCode</option>
      		  <option value="CurrentStatus" >CurrentStatus</option>		
      		</select>
        </div>
				<span class="visible-xs-block" style="line-height: 0.5;">&nbsp;</span>
				<div class="col-sm-3">
				  <div class="radio-custom radio-inline radio-primary" data-original-title="Ascending" data-placement="bottom" data-toggle="tooltip" data-trigger="hover">
            <input type="radio" name="Sort" id="ASC" value="ASC" checked="checked">
            <label for="ASC"><i aria-hidden="true" class="icon wb-sort-asc" style="font-size: 18px;"></i></label>
          </div>
				  <div class="radio-custom radio-inline radio-primary" style="margin-left: 20px;" data-original-title="Descending" data-placement="bottom" data-toggle="tooltip" data-trigger="hover">
            <input type="radio" name="Sort" id="DESC" value="DESC">
            <label for="DESC"><i aria-hidden="true" class="icon wb-sort-des" style="font-size: 18px;"></i></label>
          </div>
				</div>
      </div>

      <div class="form-group">
        <label class="col-sm-3 control-label blue-grey-600">Records Per Page :</label>
        <div class="col-sm-2"><input type="text" name="ROWS" id="ROWS" class="form-control" value="20" /></div>
      </div>	
			
</div>

<div class="panel-form-box-footer">
			  <div class="col-md-offset-3 col-sm-offset-4" style="padding-left: 15px;">
          <button type="submit" class="btn btn-primary" title="Submit For Search"><i class="fa fa-search" aria-hidden="true"></i>&nbsp;Search</button>
          <button type="button" class="btn btn-default btn-outline" title="Cancel Search" onclick="history.go(-1);"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
  				<% if(bAllowAdd == true){ %>
  				<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="NavigateTo('<%=thisFile %>?Action=New<%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon fa fa-plus"></i></button>
  				<% } %>
				</div>
</div>

</div>

</form>


<% 
}// end if (nAction==SEARCH_RECORDS)
%>

<% 
if(nAction==SEARCH_RESULT)
{ 
int sno = 0 ;
int LastBlock=0;
String WhereClause=null;
String OrderByClause=null;
int RePaginateCount = 0 ;
try
{
  RePaginateCount=java.lang.Integer.parseInt(request.getParameter("RePaginateCount"));
}
catch (NumberFormatException ex )
{
  RePaginateCount=0;
}


  if(QryObj != null )
	{
	  // Query found in session use that instead of making new one.
		
		 WhereClause = QryObj.whereclause ;
		 OrderByClause = QryObj.orderbyclause ;
if(RePaginateCount > 0)
{
     QryObj.offset = 0 ;
		 QryObj.pagesize = RePaginateCount ;
}
else
{
  	 try
		 {
		     QryObj.offset = java.lang.Integer.parseInt( request.getParameter("OFFSET") );
     }
     catch (NumberFormatException ex )
     {
	      
     }
}		 
	
	}
	else // else of  if(QryObj != null )
	{
	  // Query not is session create new one from submitted search form.
		 qStr = new com.webapp.utils.MakeQueryString( request, application );
		 // qStr = new com.webapp.utils.MakeQueryString( request, "MYSQL" );
		 
		 
     QryObj = new com.webapp.login.SearchQuery();
     qStr.setTablename(SiMngrBn._tablename);
     // qStr.setOrderByClause(" ORDERBY ? ");
     
		 // Old Code: qStr.addNumberParam("AdminID") ;
	   if(request.getParameter("AdminID_RNG_CHK") != null)
		 {
		    qStr.addNumberInRangeParam("AdminID", "AdminID", "AdminID_TO")  ;
		 }
		 else
		 {
		    String  AdminID_OPERATOR = request.getParameter("AdminID_OPERATOR");
				qStr.addNumberParam("AdminID", AdminID_OPERATOR );
				
		 }
    // Automatically add Foreign Keys in Search Creterion

    // Add  Search Fields 
		/* Hint
		You may use this trick to retain selection in new  form values if new form
		is called from search result page
		if ( qStr.addStringParam("$Field", false) ) QryObj.setKey("$Field" ,request.getParameter("$Field"));
		*/
		
		

	 // Old Code: qStr.addStringParam("FirstName", false);
	  short FirstName_SEARCHTYPE = RequestHelper.getShort(request, "FirstName_SEARCHTYPE");
	  qStr.addStringParam("FirstName", FirstName_SEARCHTYPE);
	 // For multiple selection select drop list use: qStr.addMultiSelectParam("FirstName", true );
	
	 
	 // Old Code: qStr.addStringParam("LastName", false);
	  short LastName_SEARCHTYPE = RequestHelper.getShort(request, "LastName_SEARCHTYPE");
	  qStr.addStringParam("LastName", LastName_SEARCHTYPE);
	 // For multiple selection select drop list use: qStr.addMultiSelectParam("LastName", true );
	
	 
	    qStr.addStringParam("Gender", false);
	  //short Gender_SEARCHTYPE = RequestHelper.getShort(request, "Gender_SEARCHTYPE");
	  //qStr.addStringParam("Gender", Gender_SEARCHTYPE);
	 // For multiple selection select drop list use: qStr.addMultiSelectParam("Gender", true );
	
	 
	 // Old Code: qStr.addStringParam("EmpCode", false);
	  short EmpCode_SEARCHTYPE = RequestHelper.getShort(request, "EmpCode_SEARCHTYPE");
	  qStr.addStringParam("EmpCode", EmpCode_SEARCHTYPE);
	 // For multiple selection select drop list use: qStr.addMultiSelectParam("EmpCode", true );
	
	      qStr.addNumberParam("LoginStatus");
	      qStr.addNumberParam("CurrentStatus");
		/*
	   if(request.getParameter("LoginStatus_RNG_CHK") != null)
		 {
		    qStr.addNumberInRangeParam("CurrentStatus", "CurrentStatus", "LoginStatus_TO")  ;
		 }
		 else
		 {
		    String  LoginStatus_OPERATOR = request.getParameter("LoginStatus_OPERATOR");
				qStr.addNumberParam("CurrentStatus", LoginStatus_OPERATOR );
		 }
		 */
 	 // For multiple selection select drop list use: qStr.addMultiSelectParam("CurrentStatus", false );
	
 		 QryObj.jndidsn  = "jdbc/$DATABASE" ;
     QryObj.table = "sitemanager"  ;
		  
     QryObj.whereclause = qStr.getWhereClause() ; 
		 QryObj.orderbyclause  = qStr.getOrderByClause("OrderBy") ;
		 String Sort  = request.getParameter("Sort") ;
	   if(Sort==null ) Sort="ASC" ;
		 QryObj.query =  qStr.getSQL() ;
		  
		 WhereClause = QryObj.whereclause ;
		 OrderByClause = QryObj.orderbyclause + Sort ;

     QryObj.count = SiMngrBn.recordCount(WhereClause); 
     QryObj.offset = 0 ;
     QryObj.pagesize = 0 ;
		 try
		 {
		     QryObj.pagesize=java.lang.Integer.parseInt(request.getParameter("ROWS"));
     }
     catch (NumberFormatException ex )
     {
	       QryObj.pagesize=20;
     }
		 session.setAttribute(QUERY_OBJECT_ID, QryObj ) ;


 } // end if
  
  String WhrParam  = RequestHelper.encodeBase64( WhereClause.getBytes()) ;
  String RetPath = new String( com.webapp.base64.UrlBase64.encode( ( thisFile+"?Action=Default" ).getBytes() ) );
         

%>
<!-- RECORDS FOUND -->

 <div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %> ( <%=QryObj.count %> )
		<a href="<%=thisFile %>?Action=Search<%=ForeignKeyParam %><%=ReturnPathLink %>" class="pull-right" style="text-decoration: none;"><i class='icon fa fa-search iccolor' aria-hidden='true'></i><span class="hidden-xs iccolor" style="font-size: 15px;">Search Again</span></a>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	

<!-- $CHECK Look for chain -->
<!-- NAVIGATION BAR BEGIN -->
<%@include file="/include-page/master/pagination-header.inc"%>
<!-- NAVIGATION BAR END -->
<% 
if(QryObj.count > 0)  
{ 
//  Records are there
%>		

<% if(bAllowAdd == true){ %>
		<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="NavigateTo('<%=thisFile %>?Action=New<%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon fa fa-plus"></i></button>
<% } %>

<table class="table table-curved table-condensed Rslt-Act-nav-tbl">
<tr>
<td align="center" class="col-sm-6"><i aria-hidden="true" class="icon fa fa-check-square-o iccolor"></i>&nbsp;<a href="javascript:void(0)" onclick="ResetAllChecked()">Reset Password</a></td>
<td align="center" class="col-sm-6"><i aria-hidden="true" class="icon fa fa-check-square-o iccolor"></i>&nbsp;<a href="javascript:void(0)" onclick="ClearStatusAllChecked()">Clear Status</a></td>
</tr>
</table>

<form action="<%=thisFile %>"  accept-charset="UTF-8" id="sitemanager_list" method="post">
<input type="hidden" name="Action" value="ProcessChecked" />
<input type="hidden" name="CheckedAction" id="CheckedAction" value="Unknown" />
<%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<%=ParamReturnPath %>" />
<% 
} 
%>

<div class="table-responsive">
<table class="table table-bordered table-striped Rslt-Act-tbl" id="sitemanager_Result_tbl">
<thead>
<tr>
<th>
<% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary" data-original-title="Check / Uncheck All" data-trigger="hover" data-placement="top" data-toggle="tooltip"><input type="checkbox" name="sitemanager_Result_checkall" id="sitemanager_Result_checkall"><label></label></span>&nbsp;&nbsp;
<% } %>
</th>
<th>Name</th>
<th>Employment<br />Code</th>
<th>Mobile</th>
<th>Email</th>
<th>Super<br />AdminRight</th>
<th>Reset<br />Password&nbsp;&nbsp;<i aria-hidden="true" class="icon fa fa-question-circle fa-lg iccolor" data-original-title="<%=resettooltiptext %>" data-trigger="hover" data-placement="bottom" data-toggle="tooltip"></i></th>
<th>Clear<br />Status&nbsp;&nbsp;<i aria-hidden="true" class="icon fa fa-question-circle fa-lg iccolor" data-original-title="<%=clearstatustooltiptext %>" data-trigger="hover" data-placement="bottom" data-toggle="tooltip"></i></th>

<% if(bAllowUpdate == false && bAllowDelete == false){ %> <% } else { %>
<th class="text-center">
<button class="btn btn-icon btn-default btn-outline" type="button" style="padding: 5px;display: none;" data-original-title="View" data-trigger="hover" data-placement="top" data-toggle="tooltip"><i aria-hidden="true" class="icon wb-info"></i></button>
<% if(bAllowDelete == true){ %>
<button onclick="DeleteAllChecked()" class="btn btn-icon btn-default btn-outline" type="button" style="padding: 5px;color: #f96868;" data-original-title="Delete All Checked" data-trigger="hover" data-placement="top" data-toggle="tooltip"><i aria-hidden="true" class="icon wb-trash"></i></button>
<% } %>
</th>
<% } %>
</tr>
</thead>
<tbody>

<% 

/** Check for pagination support 
  if pagination is supported by SQL implementation ( LIMIT and OFFSET key words ) 
	than call :  SiMngrBn.openTable(WhereClause, OrderByClause, QryObj.pagesize, QryObj.offset  ); 
	and remove while( SiMngrBn.skipRow() ){} part of loop.
	This will give much better result that usual openTable(WhereClause, OrderByClause ); method call
	
*/

SiMngrBn.openTable(WhereClause, OrderByClause );  

int n=0;
while(n< QryObj.offset)
{
 n++ ;
 SiMngrBn.skipRow();
} 
 n=0;
sno=QryObj.offset;

while(SiMngrBn.nextRow() && n < QryObj.pagesize )
{
sno++;
n++;
DelWarning = "Really want to Delete AdminID : "+SiMngrBn.AdminID+" " ;
// $CHECK
%>
<tr>
<td>
<% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary"><input type="checkbox" name="AdminID" id="AdminID_<%=SiMngrBn.AdminID %>"  value="<%=SiMngrBn.AdminID %>"><label></label></span>&nbsp;&nbsp;
<% } %>
<%=sno %> 
<button onclick="NavigateTo('<%=thisFile %>?Action=Show&AdminID=<%=SiMngrBn.AdminID %><%=ForeignKeyParam %><%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon wb-eye" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="View" data-trigger="hover" data-placement="top" data-toggle="tooltip"></button>
</td>
	<td><%if(SiMngrBn.Gender.equalsIgnoreCase("Male")){ %><i aria-hidden="true" class="icon fa fa-male iccolor"></i><% }else{ %><i class="icon fa fa-female iccolor" aria-hidden="true"></i><% } %>&nbsp;&nbsp;<%=ShowItem.showAdminName(SiMngrBn.AdminID, 1) %></td>
	<td><%=SiMngrBn.EmpCode %></td>
	<td><%=SiMngrBn.Mobile %></td>
	<td><%=SiMngrBn.Email %></td>
	<td><%if(SiMngrBn.SuperAdminRight==1){%><i aria-hidden="true" class="icon fa fa-check"></i>&nbsp;YES<% }else{ %><i aria-hidden="true" class="icon fa fa-close"></i>&nbsp;NO<% } %></td>
	<td><a href="javascript:void(0)" onclick="ResetPassword('<%=SiMngrBn.AdminID %>')">Reset Password</a></td>
	<td>
	<% if(SiMngrBn.LoginStatus == LoginStatusFlag.LOGGED){ %>
	<a href="javascript:void(0)" onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=ClearSession&AdminID=<%=SiMngrBn.AdminID %><%=ForeignKeyParam %><%=ReturnPathLink %>','Clear Current Login Status of \n<%=ShowItem.showAdminName(SiMngrBn.AdminID, 1) %> ?')">Clear <!-- Current Login  -->Status</a>
	<% }else{ %>
	NOT LOGGED
	<% } %>
	</td>


<% if(bAllowUpdate == false && bAllowDelete == false){ %> <% } else { %>
<td class="text-center">
<% if(bAllowUpdate == true){ %>
<button onclick="NavigateTo('<%=thisFile %>?Action=Change&AdminID=<%=SiMngrBn.AdminID %><%=ForeignKeyParam %><%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon fa fa-pencil" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="Edit" data-trigger="hover" data-placement="top" data-toggle="tooltip"></button>
<% } %>
<% if(bAllowDelete == true){ %>
<button onclick="DeleteRecord('<%=SiMngrBn.AdminID %>', '<%=DelWarning %>', '<%=thisFile %>?Action=Delete<%=ForeignKeyParam %><%=ReturnPathLink %>&AdminID=<%=SiMngrBn.AdminID %>' )" class="btn btn-pure btn-primary icon fa fa-trash-o" type="button" style="font-size: 20px;padding: 0;margin-left: 12px;" data-original-title="Delete" data-trigger="hover" data-placement="top" data-toggle="tooltip"></button>
<% } %>
</td>
<% } %>
</tr>
<% 
} // end while( SiMngrBn.nextRow());
SiMngrBn.closeTable();
 %>
</tbody>
</table>
</div>
</form>

<% if(bAllowFooterPageNavigation == true)
{ 
%>
<!-- Footer Pagination-->
<% 
if(QryObj.count >= 10 && QryObj.pagesize >= 10 && QryObj.offset < (QryObj.count - QryObj.pagesize)  ) 
{
%>

<!-- NAVIGATION BAR BEGIN -->
<%@include file="/include-page/master/pagination-footer.inc"%>
<!-- NAVIGATION BAR END -->


<%  
} // END if(QryObj.count >= 10 && QryObj.pagesize >= 10 && QryObj.offset < (QryObj.count - QryObj.pagesize)  )
%>
<!-- END Footer Pagination-->

<% 
} // END if(bAllowFooterPageNavigation == true)
%>

<!-- RECORDS FOUND NOT FOUNT-->
<% 
}
else // else of if(QryObj.count > 0) 
{
//  Records are not found
%>
<p align="center" ><big>Records satisfying search criteria not found! </big></p>

<% 
} // end  if(QryObj.count > 0) 
%>
</div>
</div>

<% 
} // end if (nAction==SEARCH_RESULT)
%>

<% if(nAction==SHOW_RECORD)
{
// $CHECK
SiMngrBn.locateRecord(nAdminID);
DelWarning = "Really want to Delete AdminID : "+SiMngrBn.AdminID+" " ;
%>
<div class="panel" style="margin-bottom: 15px;">
  <div class="panel-heading" style="padding: 0 0 10px;">
    <h3 class="panel-title page-title-action"><%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<% if(bAllowDelete == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Delete" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="DeleteRecord('<%=SiMngrBn.AdminID %>', '<%=DelWarning %>', '<%=thisFile %>?Action=Delete<%=ForeignKeyParam %><%=ReturnPathLink %>&AdminID=<%=SiMngrBn.AdminID %>' )"><i aria-hidden="true" class="icon wb-trash" style="margin: 0;"></i></button>
		<% } %>
		<% if(bAllowUpdate == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="submit" style="font-size: 10px;margin-top: -5px;" data-original-title="Edit" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="NavigateTo('<%=thisFile %>?Action=Change&AdminID=<%=SiMngrBn.AdminID %><%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon wb-pencil" style="margin: 0;"></i></button>
    <% } %>
		</h3>
	</div>
<!-- 
<div class="panel-body panel-form-box-body container-fluid">	
</div>
 -->
</div>

<!--{{ Showing Single Record Data Start -->
<div class="page-profile">
<div class="row">
  <div class="col-sm-3">
    <!-- <h4>ID : <%=SiMngrBn.AdminID %></h4> -->
		
           <!-- Page Widget -->
          <div class="widget widget-shadow text-center">
            <div class="widget-header">
              <div class="widget-header-content">
                  <figure class="overlay overlay-hover" id="photo_div">
                    <img src="<%=appPath %>/sitemanagerphoto/<%=SiMngrBn.AdminID %>" alt="..." style="width:150px;height:150px;" class="overlay-figure img-responsive img-rounded img-bordered img-bordered-primary center-block ">
										<a href="javascript:void(0);" onclick="performClick(document.getElementById('theFile'));">
<!-- 
                    <figcaption class="overlay-slide-bottom overlay-panel overlay-bottom overlay-background center-block" style="width:150px;padding: 10px;"> 
                      <p><u>Edit</u></p>
                    </figcaption>
 -->
										</a>
                  </figure>
                <form action="<%=thisFile %>" method="post" enctype="multipart/form-data" id="image_upload_form" />
                <input type="hidden" name="Action" value="UpdatePhoto" />
                <input type="hidden" name="AdminID" value="<%=SiMngrBn.AdminID %>" />
                <input type="file" enctype="multipart/form-data" name="AdminPhotograph" id="theFile" style="display: none" onchange="$('#image_upload_form').submit();" />
                </form>		 	 
               <h4 class="profile-user"><%=StrValue(SiMngrBn.AdminID) %>.&nbsp;<%=ShowItem.showAdminName(SiMngrBn.AdminID, 3) %></h4>
                <p class="profile-job"><% if(SiMngrBn.SuperAdminRight == 1) {%>Super Admin<% }else{ %>Admin<% } %></p>

              </div>
            </div>
          </div>
          <!-- End Page Widget -->

  </div>
  <div class="col-sm-9">
          <!-- Panel -->
          <div class="panel">
            <div class="panel-body nav-tabs-animate nav-tabs-horizontal">

              <ul class="nav nav-tabs nav-tabs-line" data-plugin="nav-tabs" role="tablist">
                <li class="active" role="presentation"><a data-toggle="tab" href="#Personal" aria-controls="Personal" role="tab"><i class="icon wb-user" aria-hidden="true"></i> Personal</a></li>
                <li role="presentation"><a data-toggle="tab" href="#Contact" aria-controls="Contact" role="tab"><i class="icon fa fa-mobile-phone fa-lg" aria-hidden="true"></i> Contact</a></li>
                <li role="presentation"><a data-toggle="tab" href="#System" aria-controls="System" role="tab"><i aria-hidden="true" class="icon fa fa-cog"></i> System</a></li>
                <li class="dropdown" role="presentation" style="display: none;">
                  <a class="dropdown-toggle" data-toggle="dropdown" href="#" aria-expanded="false"><span class="caret"></span> <i class="icon fa fa-bars" aria-hidden="true"></i></a>
                  <ul class="dropdown-menu" role="menu">
                    <li role="presentation" style="display: none;"><a data-toggle="tab" href="#Personal" aria-controls="Personal" role="tab"><i class="icon wb-user" aria-hidden="true"></i> Personal</a></li>
                    <li role="presentation" style="display: none;"><a data-toggle="tab" href="#Contact" aria-controls="Contact" role="tab"><i class="icon fa fa-mobile-phone fa-lg" aria-hidden="true"></i> Contact</a></li>
										<li role="presentation" style="display: none;"><a data-toggle="tab" href="#System" aria-controls="System" role="tab"><i aria-hidden="true" class="icon fa fa-cog"></i> System</a></li>
                  </ul>
                </li>
              </ul>

              <div class="tab-content">
                <div class="tab-pane active animation-slide-left" id="Personal" role="tabpanel">

  							  <div class="list-group">
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Name :</h4>
                      <p class="list-group-item-text"><%if(SiMngrBn.Gender.equalsIgnoreCase("Male")){ %><i aria-hidden="true" class="icon fa fa-male fa-lg iccolor"></i><% }else{ %><i class="icon fa fa-female iccolor" aria-hidden="true"></i><% } %>&nbsp;&nbsp;<%=ShowItem.showAdminName(SiMngrBn.AdminID, 1) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Employment Code :</h4>
                      <p class="list-group-item-text"><%=StrValue(SiMngrBn.EmpCode) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Birth Date :</h4>
                      <p class="list-group-item-text"><%=DateTimeHelper.showDatePicker(SiMngrBn.BirthDate) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Marital Status :</h4>
                      <p class="list-group-item-text"><%=StrValue(SiMngrBn.MaritalStatus) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Joining Date :</h4>
                      <p class="list-group-item-text"><%=DateTimeHelper.showDatePicker(SiMngrBn.JoiningDate) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Leaving Date :</h4>
                      <p class="list-group-item-text"><%=DateTimeHelper.showDatePicker(SiMngrBn.LeavingDate) %></p>
                    </li>
                  </div>


                </div>

                <div class="tab-pane animation-slide-left" id="Contact" role="tabpanel">
                  <p>&nbsp;</p>
  							  <div class="list-group">
									  <p><h4><i class="icon fa fa-flag iccolor" aria-hidden="true"></i>Address :</h4></p>
                    <li class="list-group-item">
                      
                      <p class="list-group-item-text"><%=StrValue(SiMngrBn.Address) %></p>
											<p class="list-group-item-text"><%=StrValue(SiMngrBn.City) %> - <%=StrValue(SiMngrBn.PIN) %></p>
											<p class="list-group-item-text"><%=StrValue(SiMngrBn.State) %></p>
                    </li>
										
										<p><h4><i class="icon fa fa-phone iccolor" aria-hidden="true"></i>Contact :</h4></p>
										
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Mobile :</h4>
                      <p class="list-group-item-text"><%=StrValue(SiMngrBn.Mobile) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Email :</h4>
                      <p class="list-group-item-text"><%=StrValue(SiMngrBn.Email) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Landline :</h4>
                      <p class="list-group-item-text"><%=StrValue(SiMngrBn.Landline) %></p>
                    </li>


                  </div>

                </div>

                <div class="tab-pane animation-slide-left" id="System" role="tabpanel">
  							  <div class="list-group">
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Username :</h4>
                      <p class="list-group-item-text"><%=StrValue(SiMngrBn.Username) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Password :</h4>
                      <p class="list-group-item-text"><%=StrValue(SiMngrBn.Password) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Super AdminRight :</h4>
                      <p class="list-group-item-text"><%if(SiMngrBn.SuperAdminRight==1){%><i aria-hidden="true" class="icon fa fa-check"></i>&nbsp;YES<% }else{ %><i aria-hidden="true" class="icon fa fa-close"></i>&nbsp;NO<% } %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Login Status :</h4>
                      <p class="list-group-item-text"><%=StrValue(CurrentStatusFlag.getLabel(SiMngrBn.CurrentStatus)) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Multi Login :</h4>
                      <p class="list-group-item-text"><%if(SiMngrBn.MultiLogin==1){%><i aria-hidden="true" class="icon fa fa-check"></i>&nbsp;YES<% }else{ %><i aria-hidden="true" class="icon fa fa-close"></i>&nbsp;NO<% } %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Update DateTime :</h4>
                      <p class="list-group-item-text"><%=DateTimeHelper.showDateTimePicker(SiMngrBn.UpdateDateTime) %></p>
                    </li>
                  </div>
								
                </div>
              </div>



		
            </div>
          </div>
          <!-- End Panel -->
		

  </div>
</div>

</div>

<%
}//end if(nAction==SHOW_RECORD) 
%>

</div><!-- main div end #maindiv -->

</div><!--   div end .page_container -->

	<jsp:include page ="/admin/include-page/footer.jsp" flush="true" />
	 
  <jsp:include page ="/include-page/js/main-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

	<jsp:include page ="/include-page/js/jfield-js.jsp" flush="true" />
  <jsp:include page ="/include-page/js/bootstrap-select-js.jsp" flush="true" />
  <jsp:include page="/include-page/js/bootstrap-eModal-js.jsp" flush="true" />
  <jsp:include page ="/include-page/js/bootstrap-datepicker-js.jsp" flush="true" />
  
	<jsp:include page="/include-page/js/jvalidate-js.jsp" flush="true" />

  <script src="<%=appPath %>/global/js/plugins/responsive-tabs.min.js"></script>
  <script src="<%=appPath %>/global/js/components/tabs.min.js"></script>


<script language="JavaScript" type="text/javascript">
<!--

function performClick(node) 
{ 
   var evt = document.createEvent("MouseEvents");
   evt.initEvent("click", true, false);
   node.dispatchEvent(evt);
   var pathnew = document.getElementById('theFile').value;
}

<% 
if(MessageText!=null)
{ 
	String Notify = MessageText.replace("\n","<br/>").replace("\r","");
%>
	toastr.success('<%= Notify %>');
<% 
} 
%> 

function DeleteRecord(del_id, del_msg, del_url) {
swal({
  title: 'Are you sure?',
  text:  del_msg,
  type: 'question',
  showCancelButton: true
	//,animation: false
}).then(function() {
  NavigateTo(del_url);
}, function(dismiss) {
  // dismiss can be 'cancel', 'overlay', 'close', 'timer'
  if (dismiss === 'cancel') {
    //toastr.info("Delete Cancel !");
  }
});	
}


function GoToBlock()
{
   var obj = document.getElementById("block") ;
   var val = obj.options[obj.selectedIndex].value ;
   var moveto = "<%=thisFile %>?<%=DEFAULT_ACTION %><%=ForeignKeyParam %><%=ReturnPathLink %>&OFFSET="+val ;
   NavigateTo(moveto);
}

function RePaginate()
{
  var nrows = parseInt( $("#RowCount").val() );
	if(isNaN(nrows) || nrows <= 0 )
	{
	  alert("Invalid record number entered.");
		return;
	}
	
  var RepaginateURL = "<%=thisFile %>?<%=DEFAULT_ACTION %><%=ForeignKeyParam %><%=ReturnPathLink %>&RePaginateCount="+nrows ;
	NavigateTo(RepaginateURL);
}




function ResetPassword(id)
{
var options = {
        url: "<%=appPath %>/admin/superadmin/resetpassword/resetpasswordofSitemanager-popup.jsp?AdminID="+id,
        title:'<i class="icon fa fa-cogs iccolor" aria-hidden="true"></i>&nbsp;Reset Password',
        size: eModal.size.lg
    };
  eModal.iframe(options)
}

function closeModal()
{
  eModal.close();
}

function ResetAllChecked()
{
     var sel_items = $("input[name='AdminID']").fieldArray();
	   var sel_count = ( sel_items !=null ) ?  sel_items.length: 0 ;
		 var msg = "Really want to Reset Password of ( "+sel_count+" ) checked items ?" ;
		
		 if(sel_count==0)
		 {
		   swal({title: '',text: 'You must check at least one item !',type: 'info',confirmButtonText:'OK'})
			 return false ;
		 }
		 else
		 {
        swal({
          title: 'Are you sure?',
          text:  msg,
          type: 'question',
          showCancelButton: true
        	,animation: false
        }).then(function() {
  		      $("#CheckedAction").val("Reset");
            $('#sitemanager_list' ).submit();
        }, function(dismiss) {
          // dismiss can be 'cancel', 'overlay', 'close', 'timer'
          if (dismiss === 'cancel') {
            //toastr.info("Delete Cancel !");
          }
        })
			}
		 return false;	 
} 


function ClearStatusAllChecked()
{
     var sel_items = $("input[name='AdminID']").fieldArray();
	   var sel_count = ( sel_items !=null ) ?  sel_items.length: 0 ;
		 var msg = "Really want to Clear Current Login Status of ( "+sel_count+" ) checked items ?" ;
		
		 if(sel_count==0)
		 {
		   swal({title: '',text: 'You must check at least one item !',type: 'info',confirmButtonText:'OK'})
			 return false ;
		 }
		 else
		 {
        swal({
          title: 'Are you sure?',
          text:  msg,
          type: 'question',
          showCancelButton: true
        	,animation: false
        }).then(function() {
  		      $("#CheckedAction").val("ClearStatus");
            $('#sitemanager_list' ).submit();
        }, function(dismiss) {
          // dismiss can be 'cancel', 'overlay', 'close', 'timer'
          if (dismiss === 'cancel') {
            //toastr.info("Delete Cancel !");
          }
        })
			}
		 return false;	 
} 



// Support for check boxes in data list.


$("#sitemanager_Result_checkall").click(function () {
   if ($("#sitemanager_Result_checkall").is(':checked')) {
        $("#sitemanager_Result_tbl input[type=checkbox]").each(function () {
          $(this).prop("checked", true);
      });
   } else {
       $("#sitemanager_Result_tbl input[type=checkbox]").each(function () {
        $(this).prop("checked", false);
      });
   }
});
 
function DeleteAllChecked()
{
     var sel_items = $("input[name='AdminID']").fieldArray();
	   var sel_count = ( sel_items !=null ) ?  sel_items.length: 0 ;
		 var msg = "Really want to Delete ( "+sel_count+" ) checked items ?" ;
		
		 if(sel_count==0)
		 {
		   swal({title: '',text: 'You must check at least one item for Deletion !',type: 'info',confirmButtonText:'OK'})
			 return false ;
		 }
		 else
		 {
        swal({
          title: 'Are you sure?',
          text:  msg,
          type: 'question',
          showCancelButton: true
        	,animation: false
        }).then(function() {
  		      $("#CheckedAction").val("Delete");
            $('#sitemanager_list' ).submit();
        }, function(dismiss) {
          // dismiss can be 'cancel', 'overlay', 'close', 'timer'
          if (dismiss === 'cancel') {
            //toastr.info("Delete Cancel !");
          }
        })
			}
		 return false;	 
} 

function CheckedActivity()
{
     var sel_items_actv = $("input[name='AdminID']").fieldArray();
	   var sel_count_actv = ( sel_items_actv !=null ) ?  sel_items_actv.length: 0 ;
		 var msg = "Activity for ( "+sel_count_actv+" ) checked items ?" ;
		 
		 if(sel_count_actv==0)
		 {
		   swal({title: '',text: 'You must check at least one item for checked activity !',type: 'info',confirmButtonText:'OK'})
			 return false ;
		 }
		 else
		 {
        swal({
          title: 'Please confirm !',
          text:  msg,
          type: 'question',
          showCancelButton: true
        	,animation: false
        }).then(function() {
  		      $("#CheckedAction").val("Activity");
            $('#sitemanager_list' ).submit();
        }, function(dismiss) {
          // dismiss can be 'cancel', 'overlay', 'close', 'timer'
          if (dismiss === 'cancel') {
            //toastr.info("Delete Cancel !");
          }
        })
			}
		 return false;	 
} 



function CheckSearchRange(search_field)
{
  var rng_chk = search_field+"_RNG_CHK" ;
	var opr_blk   = search_field+"_OPR_BLK" ;
	var rng_blk   = search_field+"_RNG_BLK" ;
	var rng_lbl   = search_field+"_RNG_LBL" ;
	
	if( $("#"+rng_chk).prop("checked") )
	{
	  // Range check box is checked
	  // Show range input and hide operators
		$("#"+rng_blk).show();
		$("#"+rng_lbl).show(); 
		$("#"+opr_blk).hide(); 
	}
	else
	{
	  // Range check box is NOT checked
	  // Hide range input and show operators
		$("#"+rng_blk).hide();
		$("#"+rng_lbl).hide();
		$("#"+opr_blk).show(); 
	}

}

// Initialize jQuery 
$(document).ready(function() {
// Other JQuery initialization here

/*   Form validation code Start : for validation plugin */
<% 
if(nAction==NEW_FORM ) 
{
%>
// New Entry Form  
 $("#sitemanager_Add").validate({ 
   rules: 
   {
    FirstName:"required",
    LastName:"required",
    Gender:"required",
    EmpCode:"required",
    JoiningDate:"required",
    Mobile:"required",
    Username: {
				required: true,
				remote: "<%=appPath %>/include-page/ajax-backend/validation/admin-user-validation.jsp"//,async: false
			},
    Password:"required",
    SuperAdminRight:"required",
    MultiLogin:"required"
   },
		messages: {
			Username: {
						remote: "The Username is already Taken"
						}
		}
 });  

<%
 }  
else if( nAction==CHANGE_FORM ) 
{
%>
// Update Entry Form  
 $("#sitemanager_Update").validate({ 
   rules: 
   {
    FirstName:"required",
    LastName:"required",
    Gender:"required",
    EmpCode:"required",
    JoiningDate:"required",
    Mobile:"required",
    Username: {
				required: true,
				remote: "<%=appPath %>/include-page/ajax-backend/validation/admin-user-validation.jsp"//,async: false
			},
    Password:"required",
    SuperAdminRight:"required",
    MultiLogin:"required"
   },
		messages: {
			Username: {
						remote: "The Username is already Taken"
						}
		} 
 }); // End form validation code.

<%
 }
else if( nAction==SEARCH_RECORDS ) 
{
%>
// Search Form  

  $("#sitemanager_Search").validate(); // Please put class="required" in mandatory fields
<%
 } 
%>

/* Form validation code End */

/* Search autocomplete support -Start */
  // JSP Block Start
  <%  
	if( nAction==SEARCH_RECORDS ) 
	{ 
	%>
	  /* un comment this to enable
	  $('#?FieldID').devbridgeAutocomplete({
    serviceUrl: "<%=appPath %>/include-page/master/autocomplete-list.jsp",
		params: {table:"sitemanager",field:"?FieldName"} 
	  });
    */
	
	<% 
	} 
	%>
	// JSP Block End
/* Search autocomplete support -End */

});  
// end of jQuery Initialize block
// -->
</script>
	
<jsp:include page ="/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>

