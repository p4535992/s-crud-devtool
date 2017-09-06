<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.$WEBAPP.appsms.*, com.$WEBAPP.appmail.*, com.db.$DATABASE.*"%> 
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*,javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.base64.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<jsp:useBean id="SmBn" scope="page" class="com.db.$DATABASE.Sms_joblogBean" />
<%-- Hint: You may need declaration of beans for foreign key fields
<jsp:useBean id="SmsJobID_Bean" class="com.db.$DATABASE.SmsJobID_ClassName"  />
--%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);

com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);


final int SmBn_SmsJobLogID = 0, SmBn_SmsJobID = 1, SmBn_DispatchDateTime = 2, SmBn_RefNo = 3, SmBn_Target = 4, SmBn_MobileNumber = 5, SmBn_SMSText = 6, SmBn_MobileNumberStatus = 7, SmBn_SmsJobLogFlag = 8, SmBn_Response = 9 ;

String FieldLabel[] = {"SmsJobLogID", "SmsJobID", "Dispatch DateTime", "RefNo", "Target", 
                       "Mobile Number", "SMSText", "Mobile No. Status", "Job Log Flag", "Response"
                       } ;

   final int DEFAULT = 0 ;
   final int SEARCH_RECORDS = 1 ;
   final int SEARCH_RESULT = 2;
   final int SHOW_RECORD = 3 ;
   final int PROCESS_CHECKED=4;

final String DEFAULT_ACTION ="Action=Default";
final String QUERY_OBJECT_ID = "sms_joblogQuery" ;

int  default_cmd = DEFAULT ;
// Show data flag
appMakeQueryString qStr =  null ;


int nAction = DEFAULT ;
String PageTitle = null ;
String MessageText = null ;
MessageText = request.getParameter("Message");

String ParamAction = request.getParameter("Action");
if(ParamAction==null) ParamAction = "Search" ;
StringBuffer ForeignKeyParam = new StringBuffer("");

if(ParamAction != null)
{
    if(ParamAction.equalsIgnoreCase("Default")) nAction = DEFAULT  ;
    else if (ParamAction.equalsIgnoreCase("Search")) nAction = SEARCH_RECORDS ;
    else if (ParamAction.equalsIgnoreCase("Result")) nAction = SEARCH_RESULT ;
    else if (ParamAction.equalsIgnoreCase("Show")) nAction = SHOW_RECORD ;
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
boolean bResultActionCheckbox = false;

com.webapp.login.SearchQuery QryObj = (com.webapp.login.SearchQuery) session.getAttribute(QUERY_OBJECT_ID) ;
if(QryObj!=null) default_cmd=SEARCH_RESULT ;
else default_cmd = SEARCH_RECORDS ;
if(nAction==DEFAULT) nAction = default_cmd ;

// ID field is Integer ( number ) type
int nSmsJobLogID = 0;
try
{
   nSmsJobLogID = Integer.parseInt(request.getParameter("SmsJobLogID"));
}
catch(NumberFormatException ex)
{ 
   nSmsJobLogID = 0;
}
SmBn.locateRecord(nSmsJobLogID);
String SmsJobID = request.getParameter("SmsJobID");
if(SmsJobID==null) SmsJobID = ""; 
ForeignKeyParam.append("&SmsJobID="+SmsJobID) ;





 if(nAction == PROCESS_CHECKED)
 {
    qStr  = new appMakeQueryString( request, application );
		//  qStr  = new com.$WEBAPP.MakeQueryString( request, "MYSQL" );
	  qStr.addMultiSelectParam(SmBn._tablename, "SmsJobLogID", false  );
	  String CheckedAction = request.getParameter("CheckedAction");
		
		String chk_items[] = request.getParameterValues("SmsJobLogID");
	  int chk_count = 0;
	  chk_count  = (chk_items != null ) ? chk_items.length : 0 ;
	  String WhrCls =qStr.getWhereClause() ;
	  String ChkQuery = qStr.SQL( " SELECT * FROM  `sms_joblog` "+ WhrCls + " ORDER BY `sms_joblog`.`SmsJobLogID` " );
	  
		if("Delete".equalsIgnoreCase(CheckedAction) && chk_count > 0  )
		{
		    /* Poll through records to be deleted in case values are there in dependent table 
				
				   SmBn.openTable(WhrCls, " ORDER BY `SmsJobLogID` ");
           while(SmBn.nextRow())
           {
					   
           }
					 SmBn.closeTable();
				*/
				if(bAllowDelete == true)
				{
				 int del_cnt = SmBn.executeUpdate( qStr.SQL( "DELETE FROM `sms_joblog` "+WhrCls+" ") );
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
          String redirect  = "sms_joblog-selection-activity.jsp?Count="+chk_count+"&WhereClause="+WhereParam+"&ReturnPath="+ReturnPath; 
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



 

// Set the correct page title according to Action Flag
if (nAction==SEARCH_RECORDS) PageTitle="<i class='fa fa-search iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Search Record" ;
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
	<title>Bulk SMS Job Log</title>

  <jsp:include page ="/include-page/css/main-css.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

	<jsp:include page ="/include-page/css/bootstrap-select-css.jsp" flush="true" />
  <jsp:include page ="/include-page/css/bootstrap-datetimepicker-css.jsp" flush="true" />
  	
  <jsp:include page ="/include-page/common/main-head-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

</head>

<body class="<%=menuTypeClass %> <%=SiMngrBn.LoginRole %>" onload="InitPage()" >


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
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i>Bulk SMS Job Log</h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<%=appPath %>/admin/index.jsp"><i aria-hidden="true" class="fa fa-home fa-lg margin-right-5"></i><span class="hidden-xs">Home</span></a></li>
						<li><a href="<%=appPath %>/admin/superadmin/sms/smslogs/smsjobs.jsp?Action=Show&SmsJobID=<%=SmsJobID %>">Sms Job</a></li>
            <li class="active">Job Log</li>
          </ol>			
  	    </div>
  		</div>	
 
<!-- 
<blockquote class="blockquote blockquote-success appblockquote">
<span class=" blue-grey-700">For : </span>SmsJobID
</blockquote>    
 -->

<% if(nAction==SEARCH_RECORDS)
{ 
 session.removeAttribute(QUERY_OBJECT_ID);
%>
<form action="<%=thisFile %>" method="POST" class="form-horizontal" id="sms_joblog_Search" accept-charset="UTF-8" >
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
<input type="hidden" name="SmsJobID" value="<%=SmsJobID %>" />


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
          <span class="checkbox-custom checkbox-inline checkbox-primary" style="padding-top: 2px;display:none;">&nbsp;<input type="checkbox" name="SmsJobLogID_RNG_CHK" id="SmsJobLogID_RNG_CHK" onchange="CheckSearchRange('SmsJobLogID')"><label for="SmsJobLogID_RNG_CHK"></label></span>
        </label>
      	<div class="col-md-1 col-sm-2 col-xs-12" id="SmsJobLogID_OPR_BLK"><%=NumberSearchdroplist.getOperatorList("SmsJobLogID_OPERATOR", "SmsJobLogID_OPERATOR", "form-control show-tick", "data-plugin='selectpicker'" )  %></div>
      	<span id="SmsJobLogID_RNG_XSVIS" class="visible-xs-*">&nbsp;</span>
      	<div class="col-md-2 col-sm-3 col-xs-12"><input type="text" name="SmsJobLogID" id="SmsJobLogID" class="form-control" /></div>
      	<label class="control-label col-sm-1 text-center" id="SmsJobLogID_RNG_LBL" style="display:none;width: 5.333%;margin-bottom: 0px;">TO</label>
      	<div class="col-md-2 col-sm-3 col-xs-12" id="SmsJobLogID_RNG_BLK" style="display:none"><input type="text" name="SmsJobLogID_TO" id="SmsJobLogID_TO" class="form-control" /></div>
      </div>			
 -->

      <div class="form-group">
        <label class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%=FieldLabel[SmBn_DispatchDateTime] %> :
        <span class="checkbox-custom checkbox-inline checkbox-primary" style="padding-top: 2px;display:none;"><input type="checkbox" name="DispatchDateTime_RNG_CHK" id="DispatchDateTime_RNG_CHK" onchange="CheckSearchRange('DispatchDateTime')"><label for="DispatchDateTime_RNG_CHK"></label></span>
      	</label>
      	<div class="col-md-1 col-sm-2 col-xs-12" id="DispatchDateTime_OPR_BLK"><%=NumberSearchdroplist.getOperatorList("DispatchDateTime_OPERATOR", "DispatchDateTime_OPERATOR", "form-control show-tick", "data-plugin='selectpicker'" ) %></div>
      	<span id="DispatchDateTime_RNG_XSVIS" class="visible-xs-*">&nbsp;</span>
      	<div class="col-md-3 col-sm-3 col-xs-12"><div class="input-group input-group-icon"><input type="text" name="DispatchDateTime" id="DispatchDateTime" class="form-control datetimepicker readonlybg"><span class="input-group-addon"><span class="icon fa fa-calendar" aria-hidden="true"></span></span></div></div>
      	<label class="col-sm-1 control-label blue-grey-600 text-center" id="DispatchDateTime_RNG_LBL" style="display:none;width: 5.333%;margin-bottom: 0px;">TO</label>
      	<div class="col-md-3 col-sm-3 col-xs-12" id="DispatchDateTime_RNG_BLK" style="display:none"><div class="input-group input-group-icon"><input type="text" name="DispatchDateTime_TO" id="DispatchDateTime_TO" class="form-control datetimepicker readonlybg"><span class="input-group-addon"><span class="icon fa fa-calendar" aria-hidden="true"></span></span></div></div>
      </div>
 
<!-- 
      <div class="form-group">
        <label for="MobileNumber" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%=FieldLabel[SmBn_MobileNumber] %> :</label>
        <div class="col-md-3 col-sm-4 col-xs-12"><input type="text" name="MobileNumber" id="MobileNumber" class="form-control" /></div>
      </div>	
 -->
      <div class="form-group">
        <label class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%=FieldLabel[SmBn_MobileNumber] %> :</label>
      	<div class="col-md-2 col-sm-3 col-xs-12"><%= StringSearchdroplist.getDropList("MobileNumber_SEARCHTYPE", StringSearch.START, null, "form-control show-tick", "data-plugin='selectpicker'") %></div>
      	<span class="visible-xs-*">&nbsp;</span>
      	<div class="col-md-3 col-sm-3 col-xs-12"><input type="text" name="MobileNumber" id="MobileNumber" class="form-control" /></div>
      </div>		
		
      <div class="form-group">
        <label for="MobileNumberStatus" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600"><%=FieldLabel[SmBn_MobileNumberStatus] %> :</label>
        <div class="col-md-3 col-sm-3 col-xs-12">
				<%=MobileNumberStatus.getDropList("MobileNumberStatus", "MobileNumberStatus", (short)0, true, false, "form-control show-tick", "data-plugin='selectpicker' data-container='body' data-live-search='false'") %>
				</div>
      </div>				
	  

      <div class="form-group">
        <label for="OrderBy" class="col-md-3 col-sm-4 col-xs-12 control-label blue-grey-600">Sort By :</label>
        <div class="col-sm-2">
      	  <select name="OrderBy" id="OrderBy" class="form-control show-tick" data-plugin="selectpicker">
					<option selected="selected" value="SmsJobLogID" >SmsJobLogID</option>
      		  <option value="DispatchDateTime" ><%=FieldLabel[SmBn_DispatchDateTime] %></option>
      		  <option value="MobileNumber" ><%=FieldLabel[SmBn_MobileNumber] %></option>
      		  <option value="MobileNumberStatus" ><%=FieldLabel[SmBn_MobileNumberStatus] %></option>		
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
		 qStr = new appMakeQueryString( request, application );
		 // qStr = new appMakeQueryString( request, "MYSQL" );

     QryObj = new com.webapp.login.SearchQuery();
		 qStr.setTablename(SmBn._tablename);
     // qStr.setOrderByClause(" ORDERBY ? ");
     
		 // Old Code: qStr.addNumberParam(SmBn._tablename, "SmsJobLogID") ;
	   if(request.getParameter("SmsJobLogID_RNG_CHK") != null)
		 {
		    qStr.addNumberInRangeParam(SmBn._tablename, "SmsJobLogID", "SmsJobLogID", "SmsJobLogID_TO")  ;
		 }
		 else
		 {
		    String  SmsJobLogID_OPERATOR = request.getParameter("SmsJobLogID_OPERATOR");
				qStr.addNumberParam(SmBn._tablename, "SmsJobLogID", SmsJobLogID_OPERATOR );
		 }
    // Automatically add Foreign Keys in Search Creterion

			 qStr.addNumberParam(SmBn._tablename, "SmsJobID");  // Foreign Key
    	 		
    // Add  Search Fields 
		/* Hint
		You may use this trick to retain selection in new  form values if new form
		is called from search result page
		if ( qStr.addStringParam(SmBn._tablename, "$Field", false) ) QryObj.setKey("$Field" ,request.getParameter("$Field"));
		*/		

	 // Old Code: qStr.addCalDateTimeParam(SmBn._tablename, "DispatchDateTime", "="); 
	 // Let dateTime behave like a number
	 	  if(request.getParameter("DispatchDateTime_RNG_CHK") != null)
		 {
				qStr.addDateTimeInRange(SmBn._tablename, "DispatchDateTime", "DispatchDateTime" ,"DispatchDateTime_TO" );
		 }
		 else
		 {
		    String DispatchDateTime_OPERATOR = request.getParameter("DispatchDateTime_OPERATOR");
				qStr.addCalDateTimeParam(SmBn._tablename, "DispatchDateTime", DispatchDateTime_OPERATOR);
		 }	
	
	 // Old Code: qStr.addStringParam(SmBn._tablename, "MobileNumber", false);
	  short MobileNumber_SEARCHTYPE = RequestHelper.getShort(request, "MobileNumber_SEARCHTYPE");
	  qStr.addStringParam(SmBn._tablename, "MobileNumber", MobileNumber_SEARCHTYPE);
	 // For multiple selection select drop list use: qStr.addMultiSelectParam("MobileNumber", true );
	
	 	
	      qStr.addNumberParam(SmBn._tablename, "MobileNumberStatus");
		/*
	   if(request.getParameter("MobileNumberStatus_RNG_CHK") != null)
		 {
		    qStr.addNumberInRangeParam(SmBn._tablename, "MobileNumberStatus", "MobileNumberStatus", "MobileNumberStatus_TO")  ;
		 }
		 else
		 {
		    String  MobileNumberStatus_OPERATOR = request.getParameter("MobileNumberStatus_OPERATOR");
				qStr.addNumberParam(SmBn._tablename, "MobileNumberStatus", MobileNumberStatus_OPERATOR );
		 }
		 */
 	 // For multiple selection select drop list use: qStr.addMultiSelectParam("MobileNumberStatus", false );
	
 		 QryObj.jndidsn  = "jdbc/$DATABASE" ;
     QryObj.table = "sms_joblog"  ;
		 
		 String Sort = request.getParameter("Sort") ;
	   if(Sort == null ) Sort = "ASC" ;
		  
     QryObj.whereclause = qStr.getWhereClause() ; 
		 QryObj.orderbyclause = qStr.getOrderByClause(SmBn._tablename, "OrderBy") + Sort ;
		 QryObj.query =  qStr.getSQL() ;
		  
		 WhereClause = QryObj.whereclause ;
		 OrderByClause = QryObj.orderbyclause ;

     QryObj.count = SmBn.recordCount(WhereClause); // joinrecordCount(String Join, String JoinTableName, String OnIDField, String WhereClause)
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

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %> ( <%=QryObj.count %> )
		<a href="<%=thisFile %>?Action=Search<%=ForeignKeyParam %><%=ReturnPathLink %>" class="pull-right" style="text-decoration: none;"><i class='icon fa fa-search iccolor' aria-hidden='true'></i><span class="hidden-xs iccolor" style="font-size: 15px;">Search Again</span></a>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">
<!-- Header Pagination-->
<%@include file="/include-page/master/pagination-header.inc"%>
<!-- END Header Pagination-->

<% 
if(QryObj.count > 0)  
{ 
%><form action="<%=thisFile %>" method="post" id="sms_joblog_list" accept-charset="UTF-8" >
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

<input type="hidden" name="SmsJobID" value="<%=SmsJobID %>" />

<div class="table-responsive">
<table class="table table-bordered table-striped table-hover Rslt-Act-tbl" id="sms_joblog_Result_tbl">
<thead>
<tr>
<th>
<% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary" data-original-title="Check / Uncheck All" data-trigger="hover" data-placement="right" data-toggle="tooltip" data-container="body"><input type="checkbox" name="sms_joblog_Result_checkall" id="sms_joblog_Result_checkall"><label></label></span>&nbsp;&nbsp;
<% } %>&nbsp;
</th>
<th><%=FieldLabel[SmBn_DispatchDateTime] %></th>
<th><%=FieldLabel[SmBn_RefNo] %></th>
<th><%=FieldLabel[SmBn_Target] %></th>
<th><%=FieldLabel[SmBn_MobileNumber] %></th>
<th><%=FieldLabel[SmBn_SMSText] %></th>
<th><%=FieldLabel[SmBn_MobileNumberStatus] %></th>
<th><%=FieldLabel[SmBn_SmsJobLogFlag] %></th>

</tr>
</thead>
<tbody>

<% 

// joinopenTable(String Join, String JoinTableName, String OnIDField, String WhereClause, String OrderByClause )
SmBn.openTable(WhereClause, OrderByClause );  

  int n=0;
  while(n< QryObj.offset)
  {
   n++ ;
   SmBn.skipRow();
  } 
   n=0;
  sno=QryObj.offset;

while(SmBn.nextRow() && n < QryObj.pagesize )
{
sno++;
n++;
%>
<tr>
<td>
<% if(bResultActionCheckbox == true){ %>
<span class="checkbox-custom checkbox-inline checkbox-primary"><input type="checkbox" name="SmsJobLogID" id="SmsJobLogID_<%=SmBn.SmsJobLogID %>"  value="<%=SmBn.SmsJobLogID %>"><label for="SmsJobLogID_<%=SmBn.SmsJobLogID %>"> <%=sno %></label></span><% }else{ %>
<%=sno %><% } %>

<button onclick="NavigateTo('<%=thisFile %>?Action=Show&SmsJobLogID=<%=SmBn.SmsJobLogID %><%=ForeignKeyParam %><%=ReturnPathLink %>')" class="btn btn-pure btn-primary icon wb-eye" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="View" data-trigger="hover" data-placement="top" data-toggle="tooltip" data-container="body"></button>
</td>
  <td> <%=DateTimeHelper.showDateTimePicker(SmBn.DispatchDateTime) %></td> 
  <td><%=SmBn.RefNo %></td>
	<td><%=SmBn.Target %></td>
	<td><%=SmBn.MobileNumber %></td>
	<td><%=SmBn.SMSText %></td>
	<td><%=MobileNumberStatus.getLabel(SmBn.MobileNumberStatus) %></td>
	<td><%=SMSDispatchStatus.getLabel(SmBn.SmsJobLogFlag) %></td>
	
</tr>
<% 
} // end while( SmBn.nextRow());
SmBn.closeTable();
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
SmBn.locateRecord(nSmsJobLogID);
%>
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><%=PageTitle %>
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;margin-left: 5px;" data-original-title="Back To Result" data-placement="bottom" data-toggle="tooltip" data-container="body" data-trigger="hover" onclick="NavigateTo('<%=thisFile %>?<%=DEFAULT_ACTION %><%=ForeignKeyParam %><%=ReturnPathLink %>')" ><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
		</h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">


<!--{{ Showing Single Record Data Start -->

<div class="row">
  <div class="col-sm-3">
    <h4>ID : <%=SmBn.SmsJobLogID %></h4>
    <!--  uncomment this 
    <div class="well well-sm">
    <ul class="list-group list-group-gap" style="margin-bottom: 0px;">
      <li class="list-group-item">
        <i aria-hidden="true" class="icon fa fa-anchor iccolor"></i><a href="#?SmsJobLogID=<%=SmBn.SmsJobLogID %>">Menu Link 1</a>
      </li>
      <li class="list-group-item">
        <i aria-hidden="true" class="icon fa fa-anchor iccolor"></i><a href="#?SmsJobLogID=<%=SmBn.SmsJobLogID %>">Menu Link 2</a>
      </li>
    </ul>		
    </div>		
    -->
  </div>
  <div class="col-sm-9">
    <div class="table-responsive">
    <table class="table table-bordered table-condensed table-striped">
<!-- 		
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SmBn_SmsJobLogID] %></span></td>
     <td><%=StrValue(SmBn.SmsJobLogID) %></td>
     </tr>
 -->		 
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SmBn_SmsJobID] %></span></td>
     <td><%=StrValue(SmBn.SmsJobID) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SmBn_DispatchDateTime] %></span></td>
     <td><%=DateTimeHelper.showDateTimePicker(SmBn.DispatchDateTime) %></td> 
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SmBn_RefNo] %></span></td>
     <td><%=StrValue(SmBn.RefNo) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SmBn_Target] %></span></td>
     <td><%=StrValue(SmBn.Target) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SmBn_MobileNumber] %></span></td>
     <td><%=StrValue(SmBn.MobileNumber) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SmBn_SMSText] %></span></td>
     <td><%=StrValue(SmBn.SMSText) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SmBn_MobileNumberStatus] %></span></td>
     <td><%=StrValue(MobileNumberStatus.getLabel(SmBn.MobileNumberStatus)) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SmBn_SmsJobLogFlag] %></span></td>
     <td><%=StrValue(SMSDispatchStatus.getLabel(SmBn.SmsJobLogFlag)) %></td>
     </tr>
     <tr>
     <td><span class="blue-grey-700"><%=FieldLabel[SmBn_Response] %></span></td>
     <td><%=StrValue(SmBn.Response) %></td>
     </tr>
     <tr>

    </tr>
    </table>
    </div>
    <!--}} Showing Single Record Data End -->

  </div>
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
  <jsp:include page ="/include-page/js/bootstrap-datetimepicker-js.jsp" flush="true" />
  <jsp:include page="/include-page/js/jvalidate-js.jsp" flush="true" />

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



// Support for check boxes in data list.


$("#sms_joblog_Result_checkall").click(function () {
   if ($("#sms_joblog_Result_checkall").is(':checked')) {
        $("#sms_joblog_Result_tbl input[type=checkbox]").each(function () {
          $(this).prop("checked", true);
      });
   } else {
        $("#sms_joblog_Result_tbl input[type=checkbox]").each(function () {
          $(this).prop("checked", false);
      });
   }
});
 
function DeleteAllChecked()
{
     var sel_items = $("input[name='SmsJobLogID']").fieldArray();
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
            $('#sms_joblog_list' ).submit();
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
     var sel_items_actv = $("input[name='SmsJobLogID']").fieldArray();
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
            $('#sms_joblog_list' ).submit();
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
/* Form validation code Start : for validation plugin */


<%
if( nAction==SEARCH_RECORDS ) 
{
%>
// Search Form  
  //fetch_Course(1,<%=nModuleID %>,'SrchAct')
  $("#sms_joblog_Search").validate({ errorPlacement: function(error, element) {} }); // Please put class="required" in mandatory fields
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

	  $('#?FieldID').devbridgeAutocomplete({
    serviceUrl: "<%=appPath %>/include-page/master/autocomplete-list.jsp",
		params: {table:"sms_joblog",field:"?FieldName"} 
	  });
    */
	
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

