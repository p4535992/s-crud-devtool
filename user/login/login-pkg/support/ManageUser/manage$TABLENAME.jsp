<%@ page errorPage = "/errorpage.jsp" %><%@ page import="$WEBAPP.*, $WEBAPP.apputil.*, $WEBAPP.appsms.*, $WEBAPP.appmail.*, $BeanPackage.*"%> 
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*,javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.base64.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiMngrBn" scope="page" class="$BeanPackage.SitemanagerBean" />
<jsp:useBean id="$BeanName" scope="page" class="$BeanPackage.$BeanClass" />
<%! 
boolean CheckDuplicateEntry( String Username, $BeanPackage.$BeanClass $BeanName, String sAction, int nIDField )
{ 
   try
   {
	 		if(sAction.equals("AddChk"))
			{
			 	return ( $BeanName.recordCount(" WHERE `Username` = '"+Username+"'") > 0 ) ? false : true ;
			}
			else
			{
   		 	return ( $BeanName.recordCount(" WHERE `Username` = '"+Username+"' AND `$IDField` != "+nIDField+"") > 0 ) ? false : true ;
			}
   }  
   catch( java.sql.SQLException exSQL ) 
   {  
   		return false ; 
   } 
}
%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);

$WEBAPP.LoggedSitemanager LogUsr = ($WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);

%><!-- CHECK MAIL/SMS SERVICE -->
<%@ include file="/include-page/master/mail-sms-check.inc" %>
<%

final int $BeanName_$IDField = 0, $BeanName_FirstName = 1, $BeanName_MiddleName = 2, $BeanName_LastName = 3, $BeanName_Gender = 4, $BeanName_BirthDate = 5, $BeanName_MaritalStatus = 6, $BeanName_EmpCode = 7, $BeanName_JoiningDate = 8, $BeanName_LeavingDate = 9, $BeanName_Address = 10, $BeanName_City = 11, $BeanName_State = 12, $BeanName_PIN = 13, $BeanName_Landline = 14, $BeanName_Mobile = 15, $BeanName_Email = 16, $BeanName_Username = 17, $BeanName_Password = 18, $BeanName_PasswordType = 19, $BeanName_AccessModule = 20, $BeanName_LoginRole = 21, $BeanName_CurrentStatus = 22, $BeanName_LoginStatus = 23, $BeanName_MultiLogin = 24, $BeanName_MenuType = 25, $BeanName_UpdateDateTime = 26 ;

String FieldLabel[] = {"UbetID", "First Name", "Middle Name", "Last Name", "Gender", 
                       "Birth Date", "Marital Status", "Emp Code", "Joining Date", "Leaving Date", 
                       "Address", "City", "State", "PIN", "Landline", 
                       "Mobile", "Email", "Username", "Password", "Password Type", 
                       "Access Module", "Login Role", "Current Status", "LoginStatus", "MultiLogin ?", 
                       "MenuType", "Update DateTime"} ;

   final int DEFAULT = 0 ;
   final int SEARCH_RECORDS = 1 ;
   final int SEARCH_RESULT = 2;
   final int SHOW_RECORD = 3 ;
   final int NEW_FORM = 4 ;
   final int CHANGE_FORM = 5 ;
   final int ADD_RECORD = 6 ;
   final int UPDATE_RECORD = 7;
   final int DELETE_RECORD = 8 ;
   final int PROCESS_CHECKED=9;

final String DEFAULT_ACTION ="Action=Default";
final String QUERY_OBJECT_ID = "$TABLENAMEQuery" ;

int  default_cmd = DEFAULT ;
// Show data flag
$WEBAPP.apputil.appMakeQueryString qStr = null ;

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
}

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

//footer Page Navigation
boolean bAllowFooterPageNavigation = true;

//Result-Action Checkbox Visibility
boolean bResultActionCheckbox = true;

com.webapp.login.SearchQuery QryObj = (com.webapp.login.SearchQuery) session.getAttribute(QUERY_OBJECT_ID) ;
if(QryObj!=null) default_cmd=SEARCH_RESULT ;
else default_cmd = SEARCH_RECORDS ;
if(nAction==DEFAULT) nAction = default_cmd ;

// ID field is Integer ( number ) type
int n$IDField = 0;
try
{
   n$IDField = Integer.parseInt(request.getParameter("$IDField"));
}
catch(NumberFormatException ex)
{ 
   n$IDField = 0;
}
$BeanName.locateRecord(n$IDField);

if(("ClearSession").equalsIgnoreCase(ParamAction))
{
	$BeanName.LoginStatus = LoginStatusFlag.NOT_LOGGED ;
  $BeanName.updateRecord(n$IDField);
	
	MessageText = "Clear Current Login Status Successfully ! $IDField = "+n$IDField ;
	
response.sendRedirect(response.encodeRedirectURL(thisFile+"?Action=Show&$IDField="+n$IDField+"&Message="+MessageText));
}

if(("UpdatePhoto").equalsIgnoreCase(ParamAction))
{
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

Update$CTABLENAMEPhoto $CTABLENAMEPhoto = new Update$CTABLENAMEPhoto(request) ;

$CTABLENAMEPhoto.update$CTABLENAMEPhotograph(n$IDField, "$CTABLENAMEPhotograph" );

MessageText = "Photograph Updated ! $IDField = "+n$IDField ;

response.sendRedirect(response.encodeRedirectURL(thisFile+"?Action=Show&$IDField="+n$IDField+"&Message="+MessageText));

}

if(nAction==ADD_RECORD)
{

     $BeanName.$IDField= 0;

/* Auto increment column: 
     try  
      {
           $BeanName.$IDField = Integer.parseInt(request.getParameter("$IDField")) ;
      } catch( NumberFormatException ex)
     { 
         $BeanName.$IDField = 0 ;
     }
*/
     $BeanName.FirstName = request.getParameter("FirstName");
     $BeanName.MiddleName = request.getParameter("MiddleName");
     $BeanName.LastName = request.getParameter("LastName");
     $BeanName.Gender = request.getParameter("Gender");
     $BeanName.BirthDate = DateTimeHelper.requestDatePicker( request, "BirthDate" );
     $BeanName.MaritalStatus = request.getParameter("MaritalStatus");
     $BeanName.EmpCode = request.getParameter("EmpCode");
     $BeanName.JoiningDate = DateTimeHelper.requestDatePicker( request, "JoiningDate" );
     $BeanName.LeavingDate = DateTimeHelper.requestDatePicker( request, "LeavingDate" );
     $BeanName.Address = request.getParameter("Address");
     $BeanName.City = request.getParameter("City");
     $BeanName.State = request.getParameter("State");
     $BeanName.PIN = request.getParameter("PIN");
     $BeanName.Landline = request.getParameter("Landline");
     $BeanName.Mobile = request.getParameter("Mobile");
     $BeanName.Email = request.getParameter("Email");
      $BeanName.Username = request.getParameter("Username");
      $BeanName.Password = request.getParameter("Password");
      $BeanName.PasswordType = PasswordType.SERVICE ;
     $BeanName.AccessModule = request.getParameter("AccessModule");
      $BeanName.LoginRole = "$CTABLENAME";
    try 
     { 
          $BeanName.CurrentStatus = Short.parseShort(request.getParameter("CurrentStatus")) ;
    } catch( NumberFormatException ex)
     {     
         $BeanName.CurrentStatus = 0 ;
    }

          $BeanName.LoginStatus = LoginStatusFlag.NOT_LOGGED ;
    try 
     { 
          $BeanName.MultiLogin = Short.parseShort(request.getParameter("MultiLogin")) ;
    } catch( NumberFormatException ex)
     {     
         $BeanName.MultiLogin = 0 ;
    }
     $BeanName.MenuType = "topbar";
    $BeanName.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()); 
 

		if( bAllowAdd == true )
		{
		    if(CheckDuplicateEntry( $BeanName.Username, $BeanName, "AddChk", 0 ))
        {
           $BeanName.addRecord();
					 if($BeanName.recordCount("") == 1) QryObj.count = 1 ;
           MessageText = "One record added. New ID = "+$BeanName._autonumber ;
           // Page redirection code begin {{
        	 java.lang.StringBuffer rd = request.getRequestURL();
           rd.append("?"+DEFAULT_ACTION+ForeignKeyParam+"&Message="+MessageText);
           response.sendRedirect(response.encodeRedirectURL(rd.toString()));
        	 // }} Page redirection code end
        }
        else
        {
          MessageText = "Duplicate Entry Found!<br>No new record created." ;
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
        $BeanName.locateRecord(n$IDField);
    /* Auto increment column: 
     try  
      {
           $BeanName.$IDField = Integer.parseInt(request.getParameter("$IDField")) ;
      } catch( NumberFormatException ex)
     { 
         $BeanName.$IDField = 0 ;
     }
*/
     $BeanName.FirstName = request.getParameter("FirstName");
     $BeanName.MiddleName = request.getParameter("MiddleName");
     $BeanName.LastName = request.getParameter("LastName");
     $BeanName.Gender = request.getParameter("Gender");
     $BeanName.BirthDate = DateTimeHelper.requestDatePicker( request, "BirthDate" );
     $BeanName.MaritalStatus = request.getParameter("MaritalStatus");
     $BeanName.EmpCode = request.getParameter("EmpCode");
     $BeanName.JoiningDate = DateTimeHelper.requestDatePicker( request, "JoiningDate" );
     $BeanName.LeavingDate = DateTimeHelper.requestDatePicker( request, "LeavingDate" );
     $BeanName.Address = request.getParameter("Address");
     $BeanName.City = request.getParameter("City");
     $BeanName.State = request.getParameter("State");
     $BeanName.PIN = request.getParameter("PIN");
     $BeanName.Landline = request.getParameter("Landline");
     $BeanName.Mobile = request.getParameter("Mobile");
     $BeanName.Email = request.getParameter("Email");
      $BeanName.Username = request.getParameter("Username");
      $BeanName.Password = request.getParameter("Password");
     $BeanName.AccessModule = request.getParameter("AccessModule");

    try 
     { 
          $BeanName.CurrentStatus = Short.parseShort(request.getParameter("CurrentStatus")) ;
    } catch( NumberFormatException ex)
     {     
         $BeanName.CurrentStatus = 0 ;
    }
    try 
     { 
          $BeanName.MultiLogin = Short.parseShort(request.getParameter("MultiLogin")) ;
    } catch( NumberFormatException ex)
     {     
         $BeanName.MultiLogin = 0 ;
    }
     $BeanName.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()); // DateTimeHelper.requestDateTimePicker( request, "UpdateDateTime" ) ; 
 
   
	  if(bAllowUpdate == true)
		{
		    if(CheckDuplicateEntry( $BeanName.Username, $BeanName, "UpdateChk", n$IDField ))
        {
    	     $BeanName.updateRecord(n$IDField);
           MessageText = "One record updated. Updated ID = "+n$IDField ;
           // Page redirection code begin {{
        	 java.lang.StringBuffer rd = request.getRequestURL();
           rd.append("?"+DEFAULT_ACTION+ForeignKeyParam+"&Message="+MessageText);
           response.sendRedirect(response.encodeRedirectURL(rd.toString()));
        	 // }} Page redirection code end
        }
        else
        {
          MessageText = "Duplicate Entry Found!<br>Record not Updated." ;
        }
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
    $BeanName.locateRecord(n$IDField);
    // $CHECK
		if(bAllowDelete == true)
		{
       $BeanName.deleteRecord(n$IDField);
		    MessageText = "Record Deleted. ID = "+n$IDField ;
				// Delete dependences in other related tables.
        // String DelRef = "DELETE FROM <table> WHERE <table>.<REF>="+n$IDField ;
        // $BeanName.executeUpdate(DelRef);
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
    qStr  = new $WEBAPP.apputil.appMakeQueryString( request, application );
		//  qStr  = new $WEBAPP.apputil.MakeQueryString( request, "MYSQL" );
	  qStr.addMultiSelectParam($BeanName._tablename, "$IDField", false  );
	  String CheckedAction = request.getParameter("CheckedAction");
		
		String chk_items[] = request.getParameterValues("$IDField");
	  int chk_count = 0;
	  chk_count  = (chk_items != null ) ? chk_items.length : 0 ;
	  String WhrCls =qStr.getWhereClause() ;
	  String ChkQuery = qStr.SQL( " SELECT * FROM  `$TABLENAME` "+ WhrCls + " ORDER BY `$TABLENAME`.`$IDField` " );
	  
		if("Delete".equalsIgnoreCase(CheckedAction) && chk_count > 0  )
		{
		    /* Poll through records to be deleted in case values are there in dependent table 
				
				   $BeanName.openTable(WhrCls, " ORDER BY `$IDField` ");
           while($BeanName.nextRow())
           {
					   
           }
					 $BeanName.closeTable();
				*/
				if(bAllowDelete == true)
				{
				 int del_cnt = $BeanName.executeUpdate( qStr.SQL( "DELETE FROM `$TABLENAME` "+WhrCls+" ") );
				 MessageText = " ( "+del_cnt+" ) records are deleted." ;
				}
				else
				{
				  MessageText = "Record deletion not permitted." ;
				}
		}
		
		if("Activity".equalsIgnoreCase(CheckedAction) && chk_count > 0 )
		{
		      String WhereParam  = RequestHelper.encodeBase64( WhrCls.getBytes()) ;
          String ReturnPath = new String( com.webapp.base64.UrlBase64.encode( ( thisFile+"?Action=Default" ).getBytes() ) );
          String redirect  = "$TABLENAME-selection-activity.jsp?Count="+chk_count+"&WhereClause="+WhereParam+"&ReturnPath="+ReturnPath; 
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
{	 bRetPath=true;

   ReturnPath = new String( UrlBase64.decode( ParamReturnPath ));
	 ReturnPathLink="&ReturnPath="+ParamReturnPath;
}
else  // Default return path
{
   ReturnPath = appPath+"/admin/index.jsp" ;
}
%>
<%@include file="/admin/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
	<title>Manage $CTABLENAME</title>

  <jsp:include page ="/include-page/css/main-css.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

	<jsp:include page ="/include-page/css/bootstrap-select-css.jsp" flush="true" />
  <jsp:include page ="/include-page/css/bootstrap-datepicker-css.jsp" flush="true" />
  <jsp:include page ="/include-page/css/datatables-css.jsp" flush="true" />
	<jsp:include page ="/include-page/css/autocomplete-css.jsp" flush="true" />
	
  <style type="text/css">
  <!-- 
  .page-profile .widget-header{padding:40px 15px;background-color:#fff}.page-profile .widget-footer{padding:10px;background-color:#f6f9fd}.page-profile .widget .avatar{width:130px;margin-bottom:10px}.page-profile .profile-user{margin-bottom:10px;color:#263238}.page-profile .profile-job{margin-bottom:20px;color:#a3afb7}.page-profile .profile-social{margin:25px 0}.page-profile .profile-social .icon{margin:0 10px;color:rgba(55,71,79,.4)}.page-profile .profile-stat-count{display:block;margin-bottom:3px;color:#526069;font-size:20px;font-weight:100}.page-profile .profile-stat-count+span{color:#a3afb7}.page-profile .page-content .list-group-item{padding:15px 15px;border-top-color:#e4eaec}.page-profile .page-content .list-group-item:first-child{border-top:transparent}.page-profile .page-content .list-group-item:last-child{border-bottom-color:#e4eaec}.page-profile .page-content .list-group-item .media .avatar{width:50px}.page-profile .page-content .list-group-item .media small{color:#a3afb7}.page-profile .page-content .list-group-item .media-heading{font-size:16px}.page-profile .page-content .list-group-item .media-heading span{margin-left:5px;color:#76838f;font-size:14px}.page-profile .page-content .list-group-item .media .media:first-child{border-top:none}.page-profile .profile-readMore{margin:40px 0}.page-profile .profile-brief{margin-top:20px}.page-profile .profile-uploaded{max-width:220px;width:100%;max-height:150px;padding-right:20px;margin-bottom:5px} 
  -->
  </style>   
  	
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
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i>Manage $CTABLENAME</h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<%=appPath %>/admin/index.jsp"><i aria-hidden="true" class="fa fa-home fa-lg margin-right-5"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active">$CTABLENAME</li>
          </ol>			
  	    </div>
  		</div>	

<% if(nAction==NEW_FORM)
{
  /* 
    Hint: Use this to get form values in case new form is called from serach result.
    Place value of form field as item before each field
    String item=null;
    if(QryObj!=null)item=QryObj.getKey("$Field") ; 
    else item="";
  */
%>			
<form action="<%=thisFile %>" method="POST" name="ubet_Add" id="ubet_Add" accept-charset="UTF-8" >
<input type="hidden" name="Action" value="Add" />
<input type="hidden" name="M" value="<%=nModuleID %>" />
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
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Back" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>
	
<div class="panel-body panel-form-box-body container-fluid">

<!-- INSERT ADD FROM -->



<!-- Personal Information -->            
<h4><i class="icon wb-user iccolor" aria-hidden="true"></i> Personal Information</h4>
<hr class="hr-res" />


<div class="row">
  <div class="form-group col-sm-4 req">
	  <label for="FirstName" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_FirstName] %></label>
	  <input type="text" name="FirstName" id="FirstName" class="form-control" />
	</div>
 
  <div class="form-group col-sm-4">
	  <label for="MiddleName" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_MiddleName] %></label>
	  <input type="text" name="MiddleName" id="MiddleName" class="form-control" />
	</div>
  <div class="form-group col-sm-4">
	  <label for="LastName" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_LastName] %></label>
	  <input type="text" name="LastName" id="LastName" class="form-control" />
	</div>
 </div>
<div class="row" >

 
  <div class="form-group col-sm-6">
	  <label for="Gender" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_Gender] %></label>
	  
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
	  <label for="MaritalStatus" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_MaritalStatus] %></label>
	  
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
	  <label for="BirthDate" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_BirthDate] %></label>
	  
		  <div class="input-group input-group-icon">	
			  <input type="text" name="BirthDate" id="BirthDate" class="form-control readonlybg" data-plugin="datepicker">
				  <span class="input-group-addon">
					  <span class="icon fa fa-calendar" aria-hidden="true"></span>
					</span>
			</div>	
	</div>
  <div class="form-group col-sm-6">
	  <label for="EmpCode" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_EmpCode] %></label>
	  <input type="text" name="EmpCode" id="EmpCode" class="form-control" />
	</div>
 
 </div>
<div class="row" >

 
  <div class="form-group col-sm-6">
	  <label for="JoiningDate" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_JoiningDate] %></label>
	  
		  <div class="input-group input-group-icon">	
			  <input type="text" name="JoiningDate" id="JoiningDate" class="form-control readonlybg" data-plugin="datepicker">
				  <span class="input-group-addon">
					  <span class="icon fa fa-calendar" aria-hidden="true"></span>
					</span>
			</div>	
	
	</div>
  <div class="form-group col-sm-6">
	  <label for="LeavingDate" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_LeavingDate] %></label>
	  
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
	  <label for="Address" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_Address] %></label>
		<textarea rows="2" name="Address" id="Address" class="form-control" ></textarea>
	</div>
 </div>
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="City" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_City] %></label>
	  <input type="text" name="City" id="City" class="form-control" />
	</div>
 
  <div class="form-group col-sm-6">
	  <label for="State" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_State] %></label>
	  
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
	  <label for="PIN" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_PIN] %></label>
	  <input type="text" name="PIN" id="PIN" class="form-control" />
	</div>
 
  <div class="form-group col-sm-6">
	  <label for="Landline" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_Landline] %></label>
	  <input type="text" name="Landline" id="Landline" class="form-control" />
	</div>
 </div>
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="Mobile" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_Mobile] %></label>
	  <input type="text" name="Mobile" id="Mobile" class="form-control" />
	</div>
 
  <div class="form-group col-sm-6">
	  <label for="Email" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_Email] %></label>
	  <input type="text" name="Email" id="Email" class="form-control" />
	</div>
 </div>
 
              <!-- Example Basic Form -->
                <p>&nbsp;</p>
                <h4><i class="icon fa fa-cog iccolor" aria-hidden="true"></i> System Information</h4>
								<hr class="hr-res" />
 
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="Username" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_Username] %></label>
	  <input type="text" name="Username" id="Username" class="form-control" />
	</div>
 
  <div class="form-group col-sm-6">
	  <label for="Password" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_Password] %></label>
	  <input type="text" name="Password" id="Password" class="form-control" />
	</div>
 </div>

<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="CurrentStatus" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_CurrentStatus] %></label>
		<%=CurrentStatusFlag.getDropList("CurrentStatus", "CurrentStatus", CurrentStatusFlag.OK, false, false, "form-control show-tick", "data-plugin='selectpicker' data-container='body' data-live-search='false'") %>
	</div>

  <div class="form-group col-sm-6">
	  <label for="MultiLogin" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_MultiLogin] %></label>
	  
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
	  <label for="AccessModule" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_AccessModule] %></label>
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

$BeanName.locateRecord(n$IDField);
%>
<form action="<%=thisFile %>" method="POST" name="ubet_Update" id="ubet_Update" accept-charset="UTF-8" >
<input type="hidden" name="Action" value="Update" />
<input type="hidden" name="$IDField" value="<%=n$IDField %>" />
<input type="hidden" name="M" value="<%=nModuleID %>" />
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
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Back" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">
 
<!-- INSERT UPDATE FORM  --> 


<!-- Personal Information -->            
<h4><i class="icon wb-user iccolor" aria-hidden="true"></i> Personal Information</h4>
<hr class="hr-res" />


<div class="row">
  <div class="form-group col-sm-4">
	  <label for="FirstName" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_FirstName] %></label>
	  <input type="text" name="FirstName" id="FirstName" class="form-control" value="<%=$BeanName.FirstName %>"  />
	</div>
 
  <div class="form-group col-sm-4">
	  <label for="MiddleName" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_MiddleName] %></label>
	  <input type="text" name="MiddleName" id="MiddleName" class="form-control" value="<%=$BeanName.MiddleName %>"  />
	</div>
	
  <div class="form-group col-sm-4">
	  <label for="LastName" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_LastName] %></label>
	  <input type="text" name="LastName" id="LastName" class="form-control" value="<%=$BeanName.LastName %>"  />
	</div>
</div>
<div class="row" >
  <div class="form-group col-sm-6">
	  <label for="Gender" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_Gender] %></label>
	  
			 <select name="Gender" id="Gender" class="form-control show-tick" data-plugin="selectpicker" data-container="body" data-live-search="false">
			 <jsp:include page ="/include-page/master/getlistitems.jsp" >
			     <jsp:param name="Attribute" value="Gender" />
					 <jsp:param name="Select" value="<%=$BeanName.Gender %>" />
					 <jsp:param name="None" value="true" />
					 <jsp:param name="OrderBy" value="" />
				</jsp:include>
			 </select>
			 
	</div>
  <div class="form-group col-sm-6">
	  <label for="MaritalStatus" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_MaritalStatus] %></label>
	  
			 <select name="MaritalStatus" id="MaritalStatus" class="form-control show-tick" data-plugin="selectpicker" data-container="body" data-live-search="false">
			 <jsp:include page ="/include-page/master/getlistitems.jsp" >
			     <jsp:param name="Attribute" value="MaritalStatus" />
					 <jsp:param name="Select" value="<%=$BeanName.MaritalStatus %>" />
					 
					 <jsp:param name="None" value="true" />
					 <jsp:param name="OrderBy" value="" />
				</jsp:include>

			 </select>
	
	</div>
</div>
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="BirthDate" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_BirthDate] %></label>
	  
		  <div class="input-group input-group-icon">	
			  <input type="text" name="BirthDate" id="BirthDate" class="form-control readonlybg"  value="<%=DateTimeHelper.showDatePicker($BeanName.BirthDate) %>" data-plugin="datepicker">
				  <span class="input-group-addon">
					  <span class="icon fa fa-calendar" aria-hidden="true"></span>
					</span>
			</div>	
	
	</div>
  <div class="form-group col-sm-6">
	  <label for="EmpCode" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_EmpCode] %></label>
	  <input type="text" name="EmpCode" id="EmpCode" class="form-control" value="<%=$BeanName.EmpCode %>"  />
	</div>

</div>
<div class="row" >

 
  <div class="form-group col-sm-6">
	  <label for="JoiningDate" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_JoiningDate] %></label>
	  
		  <div class="input-group input-group-icon">	
			  <input type="text" name="JoiningDate" id="JoiningDate" class="form-control readonlybg"  value="<%=DateTimeHelper.showDatePicker($BeanName.JoiningDate) %>" data-plugin="datepicker">
				  <span class="input-group-addon">
					  <span class="icon fa fa-calendar" aria-hidden="true"></span>
					</span>
			</div>	
	
	</div>
  <div class="form-group col-sm-6">
	  <label for="LeavingDate" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_LeavingDate] %></label>
	  
		  <div class="input-group input-group-icon">	
			  <input type="text" name="LeavingDate" id="LeavingDate" class="form-control readonlybg"  value="<%=DateTimeHelper.showDatePicker($BeanName.LeavingDate) %>" data-plugin="datepicker">
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
	  <label for="Address" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_Address] %></label>
		<textarea rows="2" name="Address" id="Address" class="form-control" ><%=$BeanName.Address %></textarea>
	</div>
 </div>
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="City" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_City] %></label>
	  <input type="text" name="City" id="City" class="form-control" value="<%=$BeanName.City %>"  />
	</div>
 
  <div class="form-group col-sm-6">
	  <label for="State" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_State] %></label>
	  
			 <select name="State" id="State" class="form-control show-tick" data-plugin="selectpicker" data-container="body" data-live-search="false">
			 <jsp:include page ="/include-page/master/getlistitems.jsp" >
			     <jsp:param name="Attribute" value="State" />
					 <jsp:param name="Select" value="<%=$BeanName.State %>" />
					 <jsp:param name="None" value="true" />
					 <jsp:param name="OrderBy" value="" />
				</jsp:include>

			 </select>
	
	</div>
 </div>
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="PIN" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_PIN] %></label>
	  <input type="text" name="PIN" id="PIN" class="form-control" value="<%=$BeanName.PIN %>"  />
	</div>
 
  <div class="form-group col-sm-6">
	  <label for="Landline" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_Landline] %></label>
	  <input type="text" name="Landline" id="Landline" class="form-control" value="<%=$BeanName.Landline %>"  />
	</div>
 </div>
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="Mobile" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_Mobile] %></label>
	  <input type="text" name="Mobile" id="Mobile" class="form-control" value="<%=$BeanName.Mobile %>"  />
	</div>
 
  <div class="form-group col-sm-6">
	  <label for="Email" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_Email] %></label>
	  <input type="text" name="Email" id="Email" class="form-control" value="<%=$BeanName.Email %>"  />
	</div>
 </div>
 
              <!-- Example Basic Form -->
                <p>&nbsp;</p>
                <h4><i class="icon fa fa-cog iccolor" aria-hidden="true"></i> System Information</h4>
								<hr class="hr-res" />
 
<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="Username" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_Username] %></label>
	  <input type="text" name="Username" id="Username" class="form-control" value="<%=$BeanName.Username %>"  />
	</div>
 
  <div class="form-group col-sm-6">
	  <label for="Password" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_Password] %></label>
	  <input type="text" name="Password" id="Password" class="form-control" value="<%=$BeanName.Password %>"  />
	</div>
 </div>
<div class="row" >
  <div class="form-group col-sm-6">
	  <label for="CurrentStatus" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_CurrentStatus] %></label>
		<%=CurrentStatusFlag.getDropList("CurrentStatus", "CurrentStatus", $BeanName.CurrentStatus, false, false, "form-control show-tick", "data-plugin='selectpicker' data-container='body' data-live-search='false'") %>
	</div>

  <div class="form-group col-sm-6">
	  <label for="MultiLogin" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_MultiLogin] %></label>
	  
			 <select name="MultiLogin" id="MultiLogin" class="form-control show-tick" data-plugin="selectpicker">
			   <!-- <option value="">--None--</option> -->
         <!-- <option value="">--ALL--</option> -->
      	 <option value="0" <%if( $BeanName.MultiLogin == 0 ){%>  selected="selected" <% } %> >&nbsp;No&nbsp;</option>
      	 <option value="1" <%if( $BeanName.MultiLogin == 1 ){%>  selected="selected" <% } %> >&nbsp;Yes&nbsp;</option>
			 </select>
	</div>

</div>

<div class="row" >

  <div class="form-group col-sm-6">
	  <label for="AccessModule" class="control-label blue-grey-600" ><%=FieldLabel[$BeanName_AccessModule] %></label>
	  <input type="text" name="AccessModule" id="AccessModule" class="form-control" value="<%=$BeanName.AccessModule %>"  />
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
<form action="<%=thisFile %>" method="POST" class="form-horizontal" id="ubet_Search" accept-charset="UTF-8" >
<input type="hidden" name="Action" value="Result" />
<input type="hidden" name="M" value="<%=nModuleID %>" />
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
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="submit" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Go To Result" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover"><i aria-hidden="true" class="icon wb-arrow-right" style="margin: 0;"></i></button>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="reset" style="font-size: 10px;margin-top: -5px;" data-original-title="Reset Form" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover"><i aria-hidden="true" class="icon wb-refresh" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

<!-- 
      <div class="form-group">
        <label class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600">Search By ID :
          <span class="checkbox-custom checkbox-inline checkbox-primary" style="padding-top: 2px;display:none;">&nbsp;<input type="checkbox" name="$IDField_RNG_CHK" id="$IDField_RNG_CHK" onchange="CheckSearchRange('$IDField')"><label for="$IDField_RNG_CHK"></label></span>
        </label>
      	<div class="col-md-1 col-sm-2 col-xs-12" id="$IDField_OPR_BLK"><%=NumberSearchdroplist.getOperatorList("$IDField_OPERATOR", "$IDField_OPERATOR", "form-control show-tick", "data-plugin='selectpicker'" ) %></div>
      	<span id="$IDField_RNG_XSVIS" class="visible-xs-*">&nbsp;</span>
      	<div class="col-md-2 col-sm-3 col-xs-12"><input type="text" name="$IDField" id="$IDField" class="form-control" /></div>
      	<label class="control-label col-sm-1 text-center" id="$IDField_RNG_LBL" style="display:none;width: 5.333%;margin-bottom: 0px;">TO</label>
      	<div class="col-md-2 col-sm-3 col-xs-12" id="$IDField_RNG_BLK" style="display:none"><input type="text" name="$IDField_TO" id="$IDField_TO" class="form-control" /></div>
      </div>			
 -->
 
      <div class="form-group">
        <label class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%=FieldLabel[$BeanName_BirthDate] %> :
          <span class="checkbox-custom checkbox-inline checkbox-primary" style="padding-top: 2px;">&nbsp;<input type="checkbox" name="Dateofbirth" id="Dateofbirth"><label for="Dateofbirth"></label></span>
			  </label>
						<jsp:include page ="/include-page/master/month-date-list.jsp">
        			 <jsp:param name="ElementName" value="BirthDate" />
							 <jsp:param name="ElementID" value="BirthDate" />
							 <jsp:param name="ClassName" value="form-control show-tick" />
							 <jsp:param name="Plugin" value="data-plugin='selectpicker'" />
        		</jsp:include>
      </div>	
 
      <div class="form-group">
        <label class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%=FieldLabel[$BeanName_FirstName] %> :</label>
      	<div class="col-md-2 col-sm-3 col-xs-12"><%= StringSearchdroplist.getDropList("FirstName_SEARCHTYPE", StringSearch.START, null, "form-control show-tick", "data-plugin='selectpicker'") %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-md-3 col-sm-3 col-xs-12"><input type="text" name="FirstName" id="FirstName" class="form-control" /></div>
      </div>		

      <div class="form-group">
        <label class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%=FieldLabel[$BeanName_LastName] %> :</label>
      	<div class="col-md-2 col-sm-3 col-xs-12"><%= StringSearchdroplist.getDropList("LastName_SEARCHTYPE", StringSearch.START, null, "form-control show-tick", "data-plugin='selectpicker'") %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-md-3 col-sm-3 col-xs-12"><input type="text" name="LastName" id="LastName" class="form-control" /></div>
      </div>			

      <div class="form-group">
        <label class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%=FieldLabel[$BeanName_Gender] %> :</label>
				<div class="col-md-3 col-sm-4 col-xs-12">
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
        <label class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%=FieldLabel[$BeanName_EmpCode] %> :</label>
      	<div class="col-md-2 col-sm-3 col-xs-12"><%= StringSearchdroplist.getDropList("EmpCode_SEARCHTYPE", StringSearch.START, null, "form-control show-tick", "data-plugin='selectpicker'") %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-md-3 col-sm-3 col-xs-12"><input type="text" name="EmpCode" id="EmpCode" class="form-control" /></div>
      </div>		

      <div class="form-group">
        <label for="CurrentStatus" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%=FieldLabel[$BeanName_CurrentStatus] %> :</label>
        <div class="col-md-3 col-sm-3 col-xs-12"><%=CurrentStatusFlag.getDropList("CurrentStatus", "CurrentStatus", CurrentStatusFlag.OK, true, false, "form-control show-tick", "data-plugin='selectpicker' data-container='body' data-live-search='false'") %></div>
      </div>		  
				
	  

      <div class="form-group">
        <label for="OrderBy" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600">Sort By :</label>
        <div class="col-sm-2">
      	  <select name="OrderBy" id="OrderBy" class="form-control show-tick" data-plugin="selectpicker">
					<option selected="selected" value="$IDField" >$IDField</option>
      		  <option value="FirstName" ><%=FieldLabel[$BeanName_FirstName] %></option>
      		  <option value="LastName" ><%=FieldLabel[$BeanName_LastName] %></option>
      		  <option value="Gender" ><%=FieldLabel[$BeanName_Gender] %></option>
      		  <option value="EmpCode" ><%=FieldLabel[$BeanName_EmpCode] %></option>
      		  <option value="CurrentStatus" ><%=FieldLabel[$BeanName_CurrentStatus] %></option>		
      		</select>
        </div>
				<span class="visible-xs-block" style="line-height: 0.5;">&nbsp;</span>
				<div class="col-sm-3">
				  <div class="radio-custom radio-inline radio-primary" data-original-title="Ascending" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover">
            <input type="radio" name="Sort" id="ASC" value="ASC" checked="checked">
            <label for="ASC"><i aria-hidden="true" class="icon wb-sort-asc" style="font-size: 18px;"></i></label>
          </div>
				  <div class="radio-custom radio-inline radio-primary" style="margin-left: 20px;" data-original-title="Descending" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover">
            <input type="radio" name="Sort" id="DESC" value="DESC">
            <label for="DESC"><i aria-hidden="true" class="icon wb-sort-des" style="font-size: 18px;"></i></label>
          </div>
				</div>
      </div>

      <div class="form-group">
        <label for="ROWS" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600">Records Per Page :</label>
        <div class="col-sm-2"><input type="text" name="ROWS" id="ROWS" class="form-control" value="20" /></div>
      </div>	

</div>

<div class="panel-form-box-footer">
			  <div class="col-md-offset-3 col-sm-offset-4" style="padding-left: 15px;">
          <button type="submit" class="btn btn-primary" title="Submit For Search"><i class="fa fa-search" aria-hidden="true"></i>&nbsp;Search</button>
          <button type="button" class="btn btn-default btn-outline" title="Cancel Search" onclick="history.go(-1);"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
					<!-- <button type="button" class="btn btn-default btn-outline" title="Cancel Search" onclick="NavigateTo('<%=appPath %>/admin/index.jsp')"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button> -->
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
		 qStr = new $WEBAPP.apputil.appMakeQueryString( request, application );
		 // qStr = new $WEBAPP.apputil.appMakeQueryString( request, "MYSQL" );
		 
		 
     QryObj = new com.webapp.login.SearchQuery();
     qStr.setTablename($BeanName._tablename);
     // qStr.setOrderByClause($BeanName._tablename, String FieldName, true)
     
		 // Old Code: qStr.addNumberParam($BeanName._tablename, "$IDField") ;
	   if(request.getParameter("$IDField_RNG_CHK") != null)
		 {
		    qStr.addNumberInRangeParam($BeanName._tablename, "$IDField", "$IDField", "$IDField_TO")  ;
		 }
		 else
		 {
		    String  $IDField_OPERATOR = request.getParameter("$IDField_OPERATOR");
				qStr.addNumberParam($BeanName._tablename, "$IDField", $IDField_OPERATOR );
		 }
    // Automatically add Foreign Keys in Search Creterion

    // Add  Search Fields 
		/* Hint
		You may use this trick to retain selection in new  form values if new form
		is called from search result page
		if ( qStr.addStringParam($BeanName._tablename, "$Field", false) ) QryObj.setKey("$Field" ,request.getParameter("$Field"));
		*/
		
		if(request.getParameter("BirthDate")!=null)
		{
		   int bd_Date = RequestHelper.getInteger(request, "BirthDate_Date" );
			 int bd_Month = RequestHelper.getInteger(request, "BirthDate_Month" );
		   qStr.addCriterion(" MONTH(`BirthDate`)="+bd_Month+" AND DAY(`Dateofbirth`)="+bd_Date+" ");
		}	 		

	 // Old Code: qStr.addStringParam($BeanName._tablename, "FirstName", false);
	  short FirstName_SEARCHTYPE = RequestHelper.getShort(request, "FirstName_SEARCHTYPE");
	  qStr.addStringParam($BeanName._tablename, "FirstName", FirstName_SEARCHTYPE);
	 // For multiple selection select drop list use: qStr.addMultiSelectParam("FirstName", true );
	
	 
	 // Old Code: qStr.addStringParam($BeanName._tablename, "LastName", false);
	  short LastName_SEARCHTYPE = RequestHelper.getShort(request, "LastName_SEARCHTYPE");
	  qStr.addStringParam($BeanName._tablename, "LastName", LastName_SEARCHTYPE);
	 // For multiple selection select drop list use: qStr.addMultiSelectParam("LastName", true );
	 
	  qStr.addStringParam($BeanName._tablename, "Gender", false);	
	 
	 // Old Code: qStr.addStringParam($BeanName._tablename, "EmpCode", false);
	  short EmpCode_SEARCHTYPE = RequestHelper.getShort(request, "EmpCode_SEARCHTYPE");
	  qStr.addStringParam($BeanName._tablename, "EmpCode", EmpCode_SEARCHTYPE);
	 // For multiple selection select drop list use: qStr.addMultiSelectParam("EmpCode", true );
	
	 	
	   qStr.addNumberParam($BeanName._tablename, "CurrentStatus");
	
 		 QryObj.jndidsn = "jdbc/$DATABASE" ;
     QryObj.table = "$TABLENAME"  ;
		 
		 String Sort = request.getParameter("Sort") ;
	   if(Sort == null ) Sort = "ASC" ;
		  
     QryObj.whereclause = qStr.getWhereClause() ; 
		 QryObj.orderbyclause = qStr.getOrderByClause($BeanName._tablename, "OrderBy") + Sort ;
		 QryObj.query = qStr.getSQL() ;
		  
		 WhereClause = QryObj.whereclause ;
		 OrderByClause = QryObj.orderbyclause ;

     QryObj.count = $BeanName.recordCount(WhereClause); // joinrecordCount(String Join, String JoinTableName, String OnIDField, String WhereClause)
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

	String WhrParam = "SELECT * FROM `$TABLENAME` "+ WhereClause + " ";
  String SQLWhrParam = RequestHelper.encodeBase64( WhrParam.getBytes()) ;
  String RetPath = new String( com.webapp.base64.UrlBase64.encode( ( thisFile+"?Action=Default" ).getBytes() ) );         
%>
<!-- RECORDS FOUND -->

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><span class="dropdown">
		<a href="#" id="ResultIconDropdown" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false" aria-hidden="true"><i class="fa fa-th-list iccolor"></i></a>&nbsp;&nbsp;Search Result ( <%=QryObj.count %> )
  		<% if(mbSMS && bSMS) { %>
			<ul class="dropdown-menu" aria-labelledby="ResultIconDropdown" role="menu">
  				<li role="presentation"><a href="javascript:void(0)" role="menuitem" onclick="SendBulkSMSToResult('<%=QryObj.count %>','<%=SQLWhrParam %>')">Send SMS to Result</a></li>
  		</ul>	
			<% } %>	
		</span>
		<a href="<%=thisFile %>?Action=Search<%=ForeignKeyParam %><%=ReturnPathLink %>" class="pull-right" style="text-decoration: none;"><i class='icon fa fa-search iccolor' aria-hidden='true'></i><span class="hidden-xs iccolor" style="font-size: 15px;">Search Again</span></a>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

<!-- Header Pagination-->
<%@include file="/include-page/master/pagination-header.inc"%>
<!-- END Header Pagination-->
<% if(bAllowAdd == true){ %>
		<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="NavigateTo('<%=thisFile %>?Action=New<%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon fa fa-plus"></i></button>
<% } %>
<% 
if(QryObj.count > 0)  
{ 
%>
 
		

<form action="<%=thisFile %>" method="post" id="ubet_list" accept-charset="UTF-8" >
<input type="hidden" name="Action" value="ProcessChecked" />
<input type="hidden" name="CheckedAction" id="CheckedAction" value="Unknown" />
<input type="hidden" name="M" value="<%=nModuleID %>" />
<%
if( bRetPath)
{ 
%>
<input type="hidden" name="ReturnPath" value="<%=ParamReturnPath %>" />
<% 
} 
%>


<div class="table-responsive wd-table-responsive">
<table class="table table-bordered table-striped table-hover Rslt-Act-tbl wdatatable" id="ubet_Result_tbl" width="100%" >
<thead>
<tr><!--for hidden column th: class="wd_col_notvisible" -->
<th>
<% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary" data-original-title="Check / Uncheck All" data-trigger="hover" data-placement="right" data-toggle="tooltip" data-container="body"><input type="checkbox" name="ubet_Result_checkall" id="ubet_Result_checkall"><label></label></span>
<% if(mbSMS && bSMS) { %>&nbsp;&nbsp;<a href="javascript:void(0);" onclick="SendBulkSMS()"><i class="fa fa-envelope-o fa-lg" aria-hidden="true"></i></a><% } %><% } %>&nbsp;
</th>
<th>Name</th>
<th><%=FieldLabel[$BeanName_EmpCode] %></th>
<th><%=FieldLabel[$BeanName_Mobile] %></th>
<th><%=FieldLabel[$BeanName_Email] %></th>

<% if(bAllowUpdate == false && bAllowDelete == false){ %> <% } else { %>
<th class="text-center">
<!-- for multiselect action -->
<button class="btn btn-icon btn-default btn-outline" type="button" style="padding: 5px;display: none;" data-original-title="View" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"><i aria-hidden="true" class="icon wb-info"></i></button>
<% if(bAllowDelete == true){ %>
<button onclick="DeleteAllChecked()" class="btn btn-icon btn-default btn-outline" type="button" style="padding: 5px;color: #f96868;" data-original-title="Delete All Checked" data-trigger="hover" data-placement="left" data-toggle="tooltip" data-container="body"><i aria-hidden="true" class="icon wb-trash"></i></button>
<% } %>&nbsp;
</th>
<% } %>
</tr>
</thead>
<tbody>

<% 

/** Check for pagination support 
  if pagination is supported by SQL implementation ( LIMIT and OFFSET key words ) 
	than call :  $BeanName.openTable(WhereClause, OrderByClause, QryObj.pagesize, QryObj.offset  ); 
	and remove while( $BeanName.skipRow() ){} part of loop.
	This will give much better result that usual openTable(WhereClause, OrderByClause ); method call
	
*/
// joinopenTable(String Join, String JoinTableName, String OnIDField, String WhereClause, String OrderByClause )
$BeanName.openTable(WhereClause, OrderByClause );  

int n=0;
while(n< QryObj.offset)
{
 n++ ;
 $BeanName.skipRow();
} 
 n=0;
sno=QryObj.offset;

while($BeanName.nextRow() && n < QryObj.pagesize )
{
sno++;
n++;
DelWarning = "Really want to Delete $IDField : "+$BeanName.$IDField+" " ;
// $CHECK
%>
<tr>
<td>
<% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary"><input type="checkbox" name="$IDField" id="$IDField_<%=$BeanName.$IDField %>"  value="<%=$BeanName.$IDField %>"><label for="$IDField_<%=$BeanName.$IDField %>"> <%=sno %></label></span><% }else{ %>
<%=sno %><% } %>

<button onclick="NavigateTo('<%=thisFile %>?Action=Show&$IDField=<%=$BeanName.$IDField %><%=ForeignKeyParam %><%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon wb-eye" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="View" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button>
</td>
 <td><%if($BeanName.Gender.equalsIgnoreCase("Male")){ %><i aria-hidden="true" class="icon fa fa-male iccolor"></i><% }else{ %><i class="icon fa fa-female iccolor" aria-hidden="true"></i><% } %>&nbsp;&nbsp;<%=ShowItem.show$CTABLENAMEName($BeanName.$IDField, 1) %></td>
	<td><%=$BeanName.EmpCode %></td>
	<td><%=$BeanName.Mobile %></td>
	<td><%=$BeanName.Email %></td>
	
<% if(bAllowUpdate == false && bAllowDelete == false){ %> <% } else { %>
<td class="text-center">
<% if(bAllowUpdate == true){ %>
<button onclick="NavigateTo('<%=thisFile %>?Action=Change&$IDField=<%=$BeanName.$IDField %><%=ForeignKeyParam %><%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon fa fa-pencil" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="Edit" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button>
<% } %>
<% if(bAllowDelete == true){ %>
<button onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=Delete<%=ForeignKeyParam %><%=ReturnPathLink %>&$IDField=<%=$BeanName.$IDField %>','<%=DelWarning %>')" class="btn btn-pure btn-primary icon fa fa-trash-o" type="button" style="font-size: 20px;padding: 0;margin-left: 12px;" data-original-title="Delete" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button>
<% } %>
</td>
<% } %>
</tr>
<% 
} // end while( $BeanName.nextRow());
$BeanName.closeTable();
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
<!-- Footer Pagination-->
<%@include file="/include-page/master/pagination-footer.inc"%>
<!-- END Footer Pagination-->
<%  
} // END if(QryObj.count >= 10 && QryObj.pagesize >= 10 && QryObj.offset < (QryObj.count - QryObj.pagesize)  )
%>
<!-- END Footer Pagination-->

<% 
} // END if(bAllowFooterPageNavigation == true)
%>

<% 
}
else // else of if(QryObj.count > 0) 
{
//  Records are not found
%>
<p>&nbsp;</p>
<p align="center" ><big>Records satisfying search criteria not found ! </big></p>

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
$BeanName.locateRecord(n$IDField);
DelWarning = "Really want to Delete $IDField : "+$BeanName.$IDField+" " ;
%>
<!-- umcomment this & put after mobile field value
<% if(mbSMS && bSMS && $BeanName.Mobile != null && $BeanName.Mobile.length()>0) { %>&nbsp;&nbsp;[ <a href="javascript:void(0);" onclick="SendSMS('<%=$BeanName.Mobile %>')">SMS</a> ]<% } %> 
-->
		<% if(bAllowAdd == true){ %>
  	<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="NavigateTo('<%=thisFile %>?Action=New<%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon fa fa-plus"></i></button>
  	<% } %>

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Back To Result" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="NavigateTo('<%=thisFile %>?<%=DEFAULT_ACTION %><%=ForeignKeyParam %><%=ReturnPathLink %>')" ><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		<% if(bAllowDelete == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Delete" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=Delete<%=ForeignKeyParam %><%=ReturnPathLink %>&$IDField=<%=$BeanName.$IDField %>','<%=DelWarning %>')" ><i aria-hidden="true" class="icon wb-trash" style="margin: 0;"></i></button>
		<% } %>
		<% if(bAllowUpdate == true){ %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;" data-original-title="Edit" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="NavigateTo('<%=thisFile %>?Action=Change&$IDField=<%=$BeanName.$IDField %><%=ForeignKeyParam %><%=ReturnPathLink %>')"><i aria-hidden="true" class="icon wb-pencil" style="margin: 0;"></i></button>
    <% } %>
		</h3>
	</div>

<!-- <div class="panel-body panel-form-box-body container-fluid"></div> -->
</div>
<!-- Start Showing Single Record Data  -->
<div class="page-profile">
<div class="row">
  <div class="col-sm-3">
    <!-- <h4>ID : <%=$BeanName.$IDField %></h4> -->

           <!-- Page Widget -->
           <div class="widget widget-shadow text-center">
            <div class="widget-header">
              <div class="widget-header-content">
                  <figure class="overlay overlay-hover" id="photo_div">
                    <img src="<%=appPath %>/$TABLENAMEphoto/<%=$BeanName.$IDField %>" alt="..." style="width:150px;height:150px;" class="overlay-figure img-responsive img-rounded img-bordered img-bordered-primary center-block ">
										<a href="javascript:void(0);" onclick="performClick(document.getElementById('theFile'));">
                    <figcaption class="overlay-slide-bottom overlay-panel overlay-bottom overlay-background center-block" style="width:150px;padding: 10px;"> 
                      <p><u>Edit</u></p>
                    </figcaption>
										</a>
                  </figure>
                <form action="<%=thisFile %>" method="post" enctype="multipart/form-data" id="image_upload_form" />
                <input type="hidden" name="Action" value="UpdatePhoto" />
                <input type="hidden" name="$IDField" value="<%=$BeanName.$IDField %>" />
                <input type="file" enctype="multipart/form-data" name="$CTABLENAMEPhotograph" id="theFile" style="display: none" onchange="$('#image_upload_form').submit();" />
                </form>		 	 
               <h4 class="profile-user"><%=StrValue($BeanName.$IDField) %>.&nbsp;<%=ShowItem.show$CTABLENAMEName($BeanName.$IDField, 3) %></h4>
                <p class="profile-job"><%=StrValue($BeanName.LoginRole) %></p>

                  <div class="well well-sm">
                  <ul class="list-group list-group-gap" style="margin-bottom: 0px;">
                    <li class="list-group-item">
                      <i aria-hidden="true" class="icon fa fa-camera iccolor"></i>
              				<a href="javascript:void(0);" onclick="capturePhoto('<%=$BeanName.$IDField %>')">Update through webcam</a>
                    </li>
                  </ul>		
                  </div>										
								
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
								<li role="presentation"><a data-toggle="tab" href="#Other" aria-controls="Other" role="tab"><i class="icon fa fa-bookmark" aria-hidden="true"></i> Other</a></li>
                <li class="dropdown" role="presentation" style="display: none;">
                  <a class="dropdown-toggle" data-toggle="dropdown" href="#" aria-expanded="false"><span class="caret"></span> <i class="icon fa fa-bars" aria-hidden="true"></i></a>
                  <ul class="dropdown-menu" role="menu">
                    <li role="presentation" style="display: none;"><a data-toggle="tab" href="#Personal" aria-controls="Personal" role="tab"><i class="icon wb-user" aria-hidden="true"></i> Personal</a></li>
                    <li role="presentation" style="display: none;"><a data-toggle="tab" href="#Contact" aria-controls="Contact" role="tab"><i class="icon fa fa-mobile-phone fa-lg" aria-hidden="true"></i> Contact</a></li>
										<li role="presentation" style="display: none;"><a data-toggle="tab" href="#System" aria-controls="System" role="tab"><i aria-hidden="true" class="icon fa fa-cog"></i> System</a></li>
                    <li role="presentation" style="display: none;"><a data-toggle="tab" href="#Other" aria-controls="Other" role="tab"><i class="icon fa fa-bookmark" aria-hidden="true"></i> Other</a></li>
                  </ul>
                </li>
              </ul>

              <div class="tab-content">
                <div class="tab-pane active animation-slide-left" id="Personal" role="tabpanel">

  							  <div class="list-group">
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Name :</h4>
                      <p class="list-group-item-text"><%if($BeanName.Gender.equalsIgnoreCase("Male")){ %><i aria-hidden="true" class="icon fa fa-male fa-lg iccolor"></i><% }else{ %><i class="icon fa fa-female fa-lg iccolor" aria-hidden="true"></i><% } %>&nbsp;&nbsp;<%=ShowItem.show$CTABLENAMEName($BeanName.$IDField, 1) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading"><%=FieldLabel[$BeanName_EmpCode] %> :</h4>
                      <p class="list-group-item-text"><%=StrValue($BeanName.EmpCode) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading"><%=FieldLabel[$BeanName_BirthDate] %> :</h4>
                      <p class="list-group-item-text"><%=DateTimeHelper.showDatePicker($BeanName.BirthDate) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading"><%=FieldLabel[$BeanName_MaritalStatus] %> :</h4>
                      <p class="list-group-item-text"><%=StrValue($BeanName.MaritalStatus) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading"><%=FieldLabel[$BeanName_JoiningDate] %> :</h4>
                      <p class="list-group-item-text"><%=DateTimeHelper.showDatePicker($BeanName.JoiningDate) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading"><%=FieldLabel[$BeanName_LeavingDate] %> :</h4>
                      <p class="list-group-item-text"><%=DateTimeHelper.showDatePicker($BeanName.LeavingDate) %></p>
                    </li>
                  </div>


                </div>

                <div class="tab-pane animation-slide-left" id="Contact" role="tabpanel">
  							  <div class="list-group">
									  <p><h4><i class="icon fa fa-flag iccolor" aria-hidden="true"></i><%=FieldLabel[$BeanName_Address] %> :</h4></p>
                    <li class="list-group-item">
                      
                      <p class="list-group-item-text"><%=StrValue($BeanName.Address) %></p>
											<p class="list-group-item-text"><%=StrValue($BeanName.City) %> - <%=StrValue($BeanName.PIN) %></p>
											<p class="list-group-item-text"><%=StrValue($BeanName.State) %></p>
                    </li>
										
										<p><h4><i class="icon fa fa-phone iccolor" aria-hidden="true"></i>Contact :</h4></p>
										
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading"><%=FieldLabel[$BeanName_Mobile] %> :</h4>
                      <p class="list-group-item-text"><%=StrValue($BeanName.Mobile) %><% if(mbSMS && bSMS && $BeanName.Mobile != null && $BeanName.Mobile.length()>0) { %>&nbsp;&nbsp;[ <a href="javascript:void(0);" onclick="SendSMS('<%=$BeanName.Mobile %>')">SMS</a> ]<% } %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading"><%=FieldLabel[$BeanName_Email] %> :</h4>
                      <p class="list-group-item-text"><%=StrValue($BeanName.Email) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading"><%=FieldLabel[$BeanName_Landline] %> :</h4>
                      <p class="list-group-item-text"><%=StrValue($BeanName.Landline) %></p>
                    </li>


                  </div>

                </div>

                <div class="tab-pane animation-slide-left" id="System" role="tabpanel">
  							  <div class="list-group">
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading"><%=FieldLabel[$BeanName_Username] %> :</h4>
                      <p class="list-group-item-text"><%=StrValue($BeanName.Username) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading"><%=FieldLabel[$BeanName_Password] %> :</h4>
                      <p class="list-group-item-text"><%=StrValue($BeanName.Password) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading"><%=FieldLabel[$BeanName_CurrentStatus] %> :</h4>
                      <p class="list-group-item-text"><%=StrValue(CurrentStatusFlag.getLabel($BeanName.CurrentStatus)) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading"><%=FieldLabel[$BeanName_MultiLogin] %> :</h4>
                      <p class="list-group-item-text"><%if($BeanName.MultiLogin==1){%><i aria-hidden="true" class="icon fa fa-check"></i>&nbsp;YES<% }else{ %><i aria-hidden="true" class="icon fa fa-close"></i>&nbsp;NO<% } %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading"><%=FieldLabel[$BeanName_UpdateDateTime] %> :</h4>
                      <p class="list-group-item-text"><%=DateTimeHelper.showDateTimePicker($BeanName.UpdateDateTime) %></p>
                    </li>
                  </div>
								
                </div>
                <div class="tab-pane animation-slide-left" id="Other" role="tabpanel">
								<p>&nbsp;</p>
								<% if(SiMngrBn.SuperAdminRight == 1){ %>
								<ul class="list-group list-group-full">
                  <li class="list-group-item"><a href="javascript:void(0)" onclick="ResetPassword('<%=$BeanName.$IDField %>')"><h4><i aria-hidden="true" class="icon fa fa-check-square-o iccolor"></i>&nbsp;<span style="color: #62a8ea;">Reset Password</span></h4></a></li>
                  <% if($BeanName.MultiLogin == 0){ %>
									<li class="list-group-item"><a href="javascript:void(0)" onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=ClearSession&$IDField=<%=$BeanName.$IDField %><%=ForeignKeyParam %><%=ReturnPathLink %>','Clear Current Login Status of \n<%=ShowItem.show$CTABLENAMEName($BeanName.$IDField, 1) %> ?')"><h4><i aria-hidden="true" class="icon fa fa-chain-broken iccolor"></i>&nbsp;<span style="color: #62a8ea;">Clear Login Status</span></h4></a></li>
                  <% } %>
								</ul>
								<% } %>
								
                </div>
              </div>
		
            </div>
          </div>
          <!-- End Panel -->
  </div>
</div>

</div>
<!-- End Showing Single Record Data  -->


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
  <jsp:include page ="/include-page/js/bootstrap-datepicker-js.jsp" flush="true" />
  <jsp:include page ="/include-page/js/datatables-js.jsp" flush="true" />
	<jsp:include page ="/include-page/js/bootstrap-eModal-js.jsp" flush="true" />
	<jsp:include page ="/include-page/js/autocomplete-js.jsp" flush="true" />
	
  <!-- /include-page/js/formValidation-js.jsp -->

	<jsp:include page="/include-page/js/jvalidate-js.jsp" flush="true" />

  <script src="<%=appPath %>/global/js/plugins/responsive-tabs.min.js"></script>
  <script src="<%=appPath %>/global/js/components/tabs.min.js"></script>
	
	
<script>
<% 
if(MessageText!=null)
{ 
	String Notify = MessageText.replace("\n","<br/>").replace("\r","");
%>
	toastr.success('<%= Notify %>');
<% 
} 
%>

function performClick(node) 
{ 
   var evt = document.createEvent("MouseEvents");
   evt.initEvent("click", true, false);
   node.dispatchEvent(evt);
   var pathnew = document.getElementById('theFile').value;
}

function capturePhoto(id)
{
var options = {
        url: "webcam/admin-$CTABLENAMEcapture.jsp?ID="+id,
        title:'<i class="icon fa fa-upload iccolor" aria-hidden="true"></i>&nbsp;Upload Photograph',
        size: eModal.size.lg
    };
  eModal.iframe(options)
} 

function ResetPassword(id)
{
var options = {
        url: "<%=appPath %>/admin/superadmin/resetpassword/resetpasswordof$TABLENAME-popup.jsp?$IDField="+id,
        title:'<i class="icon fa fa-cogs iccolor" aria-hidden="true"></i>&nbsp;Reset Password',
        size: eModal.size.lg
    };
  eModal.iframe(options)
}

function closeModal()
{
  eModal.close();
}

function InitPage()
{
// Do something on page init
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
	  swal({title: '',text: 'Invalid number entered !',type: 'error',confirmButtonText:'OK'})
		return;
	}
	
  var RepaginateURL = "<%=thisFile %>?<%=DEFAULT_ACTION %><%=ForeignKeyParam %><%=ReturnPathLink %>&RePaginateCount="+nrows ;
	NavigateTo(RepaginateURL);
}

function SendSMS(num)
{
var options = {
        url: "<%=appPath %>/admin/sms/singlesms-POPUP.jsp?MobileNumber="+num,
        title:'<i class="icon fa fa-cogs iccolor" aria-hidden="true"></i>&nbsp;Send SMS',
        size: eModal.size.lg
    };
  eModal.iframe(options)
}

function SendBulkSMSToResult(cnt,sqlwhrcls)
{
		   var options = {
        url: "<%=appPath %>/admin/sms/bulksmsResult-POPUP.jsp?sql="+sqlwhrcls+"&Count="+cnt+"&Target=Mobile&Refno=$IDField",
        title:'<i class="icon fa fa-cogs iccolor" aria-hidden="true"></i>&nbsp;Send Bulk SMS',
        size: eModal.size.lg
       };
  		eModal.iframe(options)
}

function SendBulkSMS()
{
     var Base64={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=Base64._utf8_encode(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._keyStr.charAt(s)+this._keyStr.charAt(o)+this._keyStr.charAt(u)+this._keyStr.charAt(a)}return t},decode:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9+/=]/g,"");while(f<e.length){s=this._keyStr.indexOf(e.charAt(f++));o=this._keyStr.indexOf(e.charAt(f++));u=this._keyStr.indexOf(e.charAt(f++));a=this._keyStr.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=Base64._utf8_decode(t);return t},_utf8_encode:function(e){e=e.replace(/\r\n/g,"\n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},_utf8_decode:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}};
		 //var Base64={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(a){var c,d,e,f,g,h,i,b="",j=0;for(a=Base64._utf8_encode(a);j<a.length;)c=a.charCodeAt(j++),d=a.charCodeAt(j++),e=a.charCodeAt(j++),f=c>>2,g=(3&c)<<4|d>>4,h=(15&d)<<2|e>>6,i=63&e,isNaN(d)?h=i=64:isNaN(e)&&(i=64),b=b+this._keyStr.charAt(f)+this._keyStr.charAt(g)+this._keyStr.charAt(h)+this._keyStr.charAt(i);return b},decode:function(a){var c,d,e,f,g,h,i,b="",j=0;for(a=a.replace(/[^A-Za-z0-9\+\/\=]/g,"");j<a.length;)f=this._keyStr.indexOf(a.charAt(j++)),g=this._keyStr.indexOf(a.charAt(j++)),h=this._keyStr.indexOf(a.charAt(j++)),i=this._keyStr.indexOf(a.charAt(j++)),c=f<<2|g>>4,d=(15&g)<<4|h>>2,e=(3&h)<<6|i,b+=String.fromCharCode(c),64!=h&&(b+=String.fromCharCode(d)),64!=i&&(b+=String.fromCharCode(e));return b=Base64._utf8_decode(b)},_utf8_encode:function(a){a=a.replace(/\r\n/g,"\n");for(var b="",c=0;c<a.length;c++){var d=a.charCodeAt(c);d<128?b+=String.fromCharCode(d):d>127&&d<2048?(b+=String.fromCharCode(d>>6|192),b+=String.fromCharCode(63&d|128)):(b+=String.fromCharCode(d>>12|224),b+=String.fromCharCode(d>>6&63|128),b+=String.fromCharCode(63&d|128))}return b},_utf8_decode:function(a){for(var b="",c=0,d=c1=c2=0;c<a.length;)d=a.charCodeAt(c),d<128?(b+=String.fromCharCode(d),c++):d>191&&d<224?(c2=a.charCodeAt(c+1),b+=String.fromCharCode((31&d)<<6|63&c2),c+=2):(c2=a.charCodeAt(c+1),c3=a.charCodeAt(c+2),b+=String.fromCharCode((15&d)<<12|(63&c2)<<6|63&c3),c+=3);return b}};
     
		 var sel_items = $("input[name='$IDField']").fieldArray();
	   var sel_count = ( sel_items !=null ) ?  sel_items.length: 0 ;

		 if(sel_count==0)
		 {
		   swal({title: '',text: 'You must check at least one item for SMS !',type: 'info',confirmButtonText:'OK'})
			 return false ;
		 }
		 else
		 {
		   var sqlparam = " SELECT * FROM `$TABLENAME` WHERE `$IDField` IN ("+sel_items+") ";
		   // Encode the String
       var encodedString = Base64.encode(sqlparam.toString());
		   var options = {
        url: "<%=appPath %>/admin/sms/bulksms-POPUP.jsp?sql="+encodedString+"&Count="+sel_count+"&Target=Mobile&Refno=$IDField",
        title:'<i class="icon fa fa-cogs iccolor" aria-hidden="true"></i>&nbsp;Send Bulk SMS',
        size: eModal.size.lg
       };
  		eModal.iframe(options)

		 }
}

// Support for check boxes in data list.

$("#ubet_Result_checkall").click(function () {
   if ($("#ubet_Result_checkall").is(':checked')) {
        $("#ubet_Result_tbl input[type=checkbox]").each(function () {
          $(this).prop("checked", true);
					$('table.wdatatable').DataTable().rows().select();//for TR select
      });
   } else {
        $("#ubet_Result_tbl input[type=checkbox]").each(function () {
          $(this).prop("checked", false);
					$('table.wdatatable').DataTable().rows().deselect();//for TR Deselect
      });
   }
});
 
function DeleteAllChecked()
{
     var sel_items = $("input[name='$IDField']").fieldArray();
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
            $('#ubet_list' ).submit();
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
     var sel_items_actv = $("input[name='$IDField']").fieldArray();
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
            $('#ubet_list' ).submit();
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
	var opr_blk = search_field+"_OPR_BLK" ;
	var rng_blk = search_field+"_RNG_BLK" ;
	var rng_lbl = search_field+"_RNG_LBL" ;
	var rng_xsvis = search_field+"_RNG_XSVIS" ;
	
	if( $("#"+rng_chk).prop("checked") )
	{
	  // Range check box is checked
	  // Show range input and hide operators
		$("#"+rng_blk).show();
		$("#"+rng_lbl).show(); 
		$("#"+opr_blk).hide(); 
		$("#"+rng_xsvis).hide();
	}
	else
	{
	  // Range check box is NOT checked
	  // Hide range input and show operators
		$("#"+rng_blk).hide();
		$("#"+rng_lbl).hide();
		$("#"+opr_blk).show(); 
		$("#"+rng_xsvis).show();
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
 $("#$TABLENAME_Add").validate({ 
   rules: 
   {
    FirstName:"required",
    LastName:"required",
    Gender:"required",
    EmpCode:"required",
    JoiningDate:"required",
    Mobile:"required",
    Username:"required",
    Password:"required",
    SuperAdminRight:"required",
    MultiLogin:"required"
   }
 });  

<%
 }  
else if( nAction==CHANGE_FORM ) 
{
%>
// Update Entry Form  
 $("#$TABLENAME_Update").validate({ 
   rules: 
   {
    FirstName:"required",
    LastName:"required",
    Gender:"required",
    EmpCode:"required",
    JoiningDate:"required",
    Mobile:"required",
    Username:"required",
    Password:"required",
    SuperAdminRight:"required",
    MultiLogin:"required"
   }
 }); // End form validation code.

<%
 }
else if( nAction==SEARCH_RECORDS ) 
{
%>
// Search Form  

  $("#$TABLENAME_Search").validate(); // Please put class="required" in mandatory fields
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
		//Css : page="/include-page/css/autocomplete-css.jsp"
		//JS : page="/include-page/js/autocomplete-js.jsp"
   */
	  $('#FirstName').devbridgeAutocomplete({
    serviceUrl: "<%=appPath %>/include-page/master/autocomplete-list.jsp",
		params: {table:"$TABLENAME",field:"FirstName"} 
	  });

	  $('#LastName').devbridgeAutocomplete({
    serviceUrl: "<%=appPath %>/include-page/master/autocomplete-list.jsp",
		params: {table:"$TABLENAME",field:"LastName"} 
	  });

	  $('#EmpCode').devbridgeAutocomplete({
    serviceUrl: "<%=appPath %>/include-page/master/autocomplete-list.jsp",
		params: {table:"$TABLENAME",field:"EmpCode"} 
	  });
    
	<% 
	} 
	%>
	// JSP Block End
/* Search autocomplete support -End */

});  
// end of jQuery Initialize block

</script>
	
<jsp:include page ="/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>

