<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.* " %>
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, javax.servlet.*, javax.servlet.http.* " %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.* com.webapp.base64.* " %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ include file="/portablesql.inc" %>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<jsp:useBean id="AtrBean" scope="page" class="com.db.$DATABASE.MasterattributeBean" />
<jsp:useBean id="ItemBean" scope="page" class="com.db.$DATABASE.MasteritemlistBean" />

<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);

String Action = request.getParameter("Action");
java.sql.Timestamp CT = new java.sql.Timestamp(System.currentTimeMillis()) ;

// Action authorization || Enable : true & Disable : false
boolean bAllowAdd = true ;
boolean bAllowUpdate = false;
boolean bAllowDelete = false;

boolean bShow  = true;
boolean bAdd   = false ;
boolean bChange = false ;
boolean bUpdate = false;
boolean bDelete = false ;

String Message=null;
Message= request.getParameter("Message") ;

if(Action != null)	 
{
if(Action.equalsIgnoreCase("Show"))
	 {
 	    bShow  = true ; 
	 }

if(Action.equalsIgnoreCase("Add"))
	 {
	   // Check duplicatte 
	   String NewAtr = request.getParameter("Attributes");
		 if (AtrBean.locateRecord(NewAtr))
		 {
		   Message="Duplicate Entry, No Record Created." ;
		 }
		 else
		 {
		   AtrBean.Attributes=NewAtr;
			 AtrBean.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()); 
		   AtrBean.addRecord();
			 Message="Attribute : "+NewAtr+" created." ;
			  // Page redirection code begin {{
         java.lang.StringBuffer rd = request.getRequestURL();
         rd.append("?Message="+Message);
         response.sendRedirect(response.encodeRedirectURL(rd.toString()));
       // }} Page redirection code end
		 }
	   
     bShow  = true ; 
	   bAdd   = true ;
	 }
if(Action.equalsIgnoreCase("Update"))
   {
     bShow   = true ; 
	   bUpdate = true ;
		 String rec = request.getParameter("OldAttributes");
		 AtrBean.Attributes=request.getParameter("Attributes");
		 AtrBean.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()); 
		 AtrBean.updateRecord(rec);
		 Message="Attribute : "+rec+" updated." ;
		 // Reflect change in dependent itemlist bean for attribute change 
		 ItemBean.executeUpdate( _PSQL( "UPDATE `masteritemlist` SET `Attribute`='"+AtrBean.Attributes+"',`UpdateDateTime` = '"+CT+"' WHERE `Attribute`='"+rec+"' ") );
   }
if(Action.equalsIgnoreCase("Delete"))
   {
     bShow   = true ; 
	   bDelete = true ;
		 String delAtr = request.getParameter("Attributes");
		 AtrBean.deleteRecord(delAtr);
		 Message="Attribute : "+delAtr+" Deleted." ;
		 // Delete related items in itemlist table
		 ItemBean.executeUpdate( _PSQL("DELETE FROM `masteritemlist` WHERE `Attribute`='"+delAtr+"' ") );
		 ItemBean.executeUpdate( _PSQL("DELETE FROM `masteritemtable` WHERE `Attribute`='"+delAtr+"' ") );
   }


if(Action.equalsIgnoreCase("Change"))
   {
     bShow   = false ; 
	   bChange = true ;
   }

}	 

%>
<%@include file="/admin/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
		
	<title>Manage Attribute</title>
	
  <jsp:include page ="/include-page/css/main-css.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  
  <jsp:include page ="/include-page/common/main-head-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  

</head>
<body class="<%=menuTypeClass %> <%=SiMngrBn.LoginRole %>" onload="InitPage()">

  <jsp:include page ="/admin/include-page/nav-body.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  

  <jsp:include page ="/admin/include-page/menu-body.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
		 <jsp:param  name="MenuTitle" value="DatabaseTitle"/>
		 <jsp:param  name="MenuLink" value="MasterLink"/>
	</jsp:include>


  <!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
  	  <div class="row">
        <div class="col-sm-6">
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i>Manage Attribute</h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<%=appPath %>/admin/index.jsp"><i aria-hidden="true" class="icon fa fa-home fa-lg"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active">Attribute</li>
          </ol>			
  	    </div>
  		</div>	

<% 
if(bChange)
{ 
String ChngAttributes = request.getParameter("Attributes");
%>

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class='fa fa-edit iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Change Attribute 
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	

<form action="attriblist.jsp" method="post" id="updattrib">
<input type="hidden" name="Action" value="Update">
<input type="hidden" name="OldAttributes" value="<%=ChngAttributes%>" > 
<div class="row">
<div class="form-group col-sm-4 col-sm-offset-4">
  <div class="input-group">
    <input type="text" name="Attributes" id="Attributes" value="<%=ChngAttributes%>" class="form-control required">
    <span class="input-group-btn">
		<button class="btn btn-default btn-outline" tabindex="-1" type="reset"><i aria-hidden="true" class="icon fa fa-refresh"></i></button>
		<button class="btn btn-primary" type="submit"><i class='fa fa-edit' aria-hidden='true'></i>&nbsp;Update</button>
		</span>
  </div>
</div>
</div>
</form>

</div>
</div>

<% } // end if(Change)

if(bShow) 
{ 
%>
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class='fa fa-bookmark iccolor' aria-hidden='true'></i>&nbsp;&nbsp;List of Attribute
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">

<% if(bAllowAdd == true){ %>
<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="{ $('#new_form').slideToggle(); }" ><i aria-hidden="true" class="icon fa fa-plus"></i></button>
<% } %>

<div id="new_form" style="display:none">
<form action="attriblist.jsp" method="post" id="addattrib">
<input type="hidden" name="Action" value="Add">
<div class="row">
<div class="form-group col-sm-4 col-sm-offset-4">
  <div class="input-group">
    <input type="text" name="Attributes" id="Attributes" class="form-control required" placeholder="Enter New Attribute">
    <span class="input-group-btn">
		<button class="btn btn-default btn-outline" tabindex="-1" type="button" onclick="{ $('#Attributes').val(''); }"><i aria-hidden="true" class="icon fa fa-refresh"></i></button>
		<button class="btn btn-primary" type="submit"><i class='fa fa-plus' aria-hidden='true'></i>&nbsp;Add</button>
		</span>
  </div>
</div>
</div>
</form>
</div>

<div class="table-responsive">
<table class="table table-bordered table-striped Rslt-Act-tbl">
<thead>
<tr>
<th>S.No.</th>
<th>Attribute</th>
<th>Set Options</th>
<% if(bAllowUpdate == false && bAllowDelete == false){ %> <% } else { %> 
<th>&nbsp;</th>
<% } %>
</tr>
</thead>
<tbody>

<% 
int n=0;
AtrBean.openTable(" " ,_PSQL(" ORDER BY `Attributes` ") );
while(AtrBean.nextRow())
{
n++;
String DelWarning = "Really want to Delete Attribute : "+AtrBean.Attributes+" " ;
%> 
<tr>
 <td><%=n %></td>
 <td><%= AtrBean.Attributes %>  </td>
 <td><a href="itemlist.jsp?Action=Show&Attribute=<%=AtrBean.Attributes  %>">Set Options</a></td>
 
<% if(bAllowUpdate == false && bAllowDelete == false){ %> <% } else { %>
<td>
<% if(bAllowUpdate == true){ %>
<button onclick="{ $('#changeDIV_<%=AtrBean.Attributes %>').slideToggle(); }" class="btn btn-pure btn-primary icon fa fa-pencil" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="Edit" data-trigger="hover" data-placement="top" data-toggle="tooltip"></button>
<!-- <button onclick="NavigateTo('<%=thisFile %>?Action=Change&Attributes=<%=AtrBean.Attributes %>')" class="btn btn-pure btn-primary icon fa fa-pencil" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="Edit" data-trigger="hover" data-placement="top" data-toggle="tooltip"></button> -->
<% } %>
<% if(bAllowDelete == true){ %>
<button onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=Delete&Attributes=<%=AtrBean.Attributes %>','<%=DelWarning %>')" class="btn btn-pure btn-primary icon fa fa-trash-o" type="button" style="font-size: 20px;padding: 0;margin-left: 12px;" data-original-title="Delete" data-trigger="hover" data-placement="top" data-toggle="tooltip"></button>
<% } %>
</td>
<% } %>
</tr>
<tr id="changeDIV_<%=AtrBean.Attributes %>" style="display:none;">
<td colspan="4">

<form action="attriblist.jsp" method="post" id="updattrib">
<input type="hidden" name="Action" value="Update">
<input type="hidden" name="OldAttributes" value="<%=AtrBean.Attributes %>" > 
<div>
<div class="form-group col-sm-4 col-sm-offset-4" style="margin-bottom: 10px;margin-top: 10px;">
  <div class="input-group">
    <input type="text" name="Attributes" id="Attributes" value="<%=AtrBean.Attributes %>" class="form-control required">
    <span class="input-group-btn">
		<button class="btn btn-default btn-outline" tabindex="-1" type="reset"><i aria-hidden="true" class="icon fa fa-refresh"></i></button>
		<button class="btn btn-primary" type="submit"><i class='fa fa-edit' aria-hidden='true'></i>&nbsp;Update</button>
		</span>
  </div>
</div>
</div>
</form>

</td>
</tr>
<% 
} // end while(AtrBean.nextRow())
%>
</tbody>
</table>
</div>

</div>
</div>
<% }// end if (bShow) %>
			
			
    </div>
  </div>
  <!-- End Page -->

  <jsp:include page="/admin/include-page/footer.jsp" flush="true" />
	
  <jsp:include page="/include-page/js/main-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>
	<jsp:include page="/include-page/js/jvalidate-js.jsp" flush="true" />
<script>

<% 
if(Message!=null)
{ 
	String Notify = Message.replace("\n","<br/>").replace("\r","");
%>
	toastr.success('<%= Notify %>');
<% 
} 
%> 
 
$(document).ready(function() {

<% 
if(bShow) 
{
%>
	$("#addattrib").validate();
<%
 } 
%>
<% 
if(bShow || bChange) 
{
%>
  $("#updattrib").validate();
<%
 } 
%>
});
</script>
	
	<jsp:include page="/include-page/common/Google-Analytics.jsp" flush="true" />
				
</body>
</html>

