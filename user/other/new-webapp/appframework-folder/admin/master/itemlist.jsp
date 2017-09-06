<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*, com.db.$DATABASE.* " %>
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, javax.servlet.*, javax.servlet.http.* " %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.* com.webapp.base64.* " %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ include file="/portablesql.inc" %>
<jsp:useBean id="SiMngrBn" scope="page" class="com.db.$DATABASE.SitemanagerBean" />
<jsp:useBean id="ItemBean" scope="page" class="com.db.$DATABASE.MasteritemlistBean" />
<jsp:useBean id="ITblBn" scope="page" class="com.db.$DATABASE.MasteritemtableBean" />

<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
com.$WEBAPP.LoggedSitemanager LogUsr =  (com.$WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);

java.sql.Timestamp CT = new java.sql.Timestamp(System.currentTimeMillis()) ;

// Action authorization || Enable : true & Disable : false
boolean bAllowAdd = true ;
boolean bAllowUpdate = true;
boolean bAllowDelete = true;


boolean bShow  = false ;
boolean bNew   = false ;
boolean bAdd   = false ;
boolean bChange = false ;
boolean bUpdate = false;
boolean bDelete = false ;

String Message=null;
Message= request.getParameter("Message") ;


String Action = request.getParameter("Action");
if(Action==null) Action = "Show" ;

String Attribute = request.getParameter("Attribute");
int nRecordID=0;
try
 { 
 	 nRecordID = Integer.parseInt(request.getParameter("RecordID")) ;
 } catch( NumberFormatException ex)
 { 
	 nRecordID = 0 ;
 }

if("Show".equalsIgnoreCase(Action))
	 {
 	    bShow  = true ; 
	 }

if("Add".equalsIgnoreCase(Action))
	 {
	 
     bShow  = true ; 
	   bAdd   = true ;
		// Check for duplicate value in Options ;
		String AddOption = request.getParameter("Options");
		String AddAtr =  request.getParameter("Attribute");
		if( ItemBean.recordCount( _PSQL( " WHERE  `Attribute`='"+AddAtr +"' AND `Options`='"+AddOption+"' ") ) > 0 )
		{
		   Message="Duplicate entry for "+AddOption+" found, nothing added.";
		
		}
		else
		{
		    ItemBean.RecordID =0;
		    ItemBean.Attribute = AddAtr ;
		    ItemBean.Options = AddOption ;
				ItemBean.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()); 
        ItemBean.addRecord();
				Message="Option "+AddOption+" added successfully.";
				  // Page redirection code begin {{
         java.lang.StringBuffer rd = request.getRequestURL();
         rd.append("?Message="+Message+"&Attribute="+Attribute+"&Action=Show");
         response.sendRedirect(response.encodeRedirectURL(rd.toString()));
       // }} Page redirection code end
		 } 
	 }
if("Update".equalsIgnoreCase(Action))
   {
     bShow   = true ; 
	   bUpdate = true ;
		 ItemBean.locateRecord(nRecordID);
		 String OldOption=ItemBean.Options ;

		 // Fill the bean with updated values

		 ItemBean.RecordID  = nRecordID;
		 ItemBean.Attribute = request.getParameter("Attribute");
		 ItemBean.Options = request.getParameter("Options");
		 ItemBean.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis()); 
     ItemBean.updateRecord(nRecordID);
		 Message="Option "+ItemBean.Options+" updated successfully.";
		 
		 // Poll through dependent tables and change that value in all table columns
		  com.webapp.db.GenericQuery gQry = new com.webapp.db.GenericQuery(ApplicationResource.database, application );
		  gQry.beginExecute();
			ITblBn.openTable(_PSQL(" WHERE `masteritemtable`.`Attribute` = '"+Attribute+"' "), " ");
			while(ITblBn.nextRow())
			{
			   String updQry = _PSQL( " UPDATE `"+ITblBn.TableName+"` SET `"+ITblBn.ColumnName+"` = '"+ItemBean.Options+"',`UpdateDateTime` = '"+CT+"' WHERE `"+ITblBn.ColumnName+"` = '"+OldOption+"'" ) ;
			   gQry.continueExecute(updQry);			 
			}
			ITblBn.closeTable();
		  gQry.endExecute();
		 
		 
   }
if("Delete".equalsIgnoreCase(Action))
   {
	   ItemBean.locateRecord(nRecordID);
	   String DelItem=ItemBean.Options ;
     bShow   = true ; 
	   bDelete = true ;
		 ItemBean.deleteRecord(nRecordID);
		 Message= " "+DelItem+" deleted." ;
   }

if("New".equalsIgnoreCase(Action))
   {
     bShow   = false ; 
	   bNew  = true ;
   }
if("Change".equalsIgnoreCase(Action))
   {
     bShow   = false ; 
	   bChange = true ;
   }

%>
<%@include file="/admin/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
		
	<title>Set option : <%=Attribute %></title>
	
  <jsp:include page ="/include-page/css/main-css.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  
  <jsp:include page ="/include-page/common/main-head-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  

</head>
<body class="<%=menuTypeClass %> <%=SiMngrBn.LoginRole %>" >

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
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-cogs iccolor"></i>Set option : <%=Attribute %></h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<%=appPath %>/admin/index.jsp"><i aria-hidden="true" class="icon fa fa-home fa-lg"></i><span class="hidden-xs">Home</span></a></li>
						<li><a href="<%=appPath %>/admin/master/attriblist.jsp">Attribute</a></li>
            <li class="active">Option</li>
          </ol>			
  	    </div>
  		</div>	

<% if(bNew)
{
%>

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class='fa fa-plus iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Add Option
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">		

<form action="itemlist.jsp" method="post" id="item_add">
<input type="hidden" name="Action" value="Add">
<input type="hidden" name="Attribute" value="<%=Attribute %>">

<div class="row">
<div class="form-group col-sm-4 col-sm-offset-4">
  <div class="input-group">
    <input type="text" name="Options" id="Options" class="form-control required" placeholder="Enter New Option">
    <span class="input-group-btn">
		<button class="btn btn-default btn-outline" tabindex="-1" type="button" onclick="{ $('#Options').val(''); }"><i aria-hidden="true" class="icon fa fa-refresh"></i></button>
		<button class="btn btn-primary" type="submit"><i class='fa fa-plus' aria-hidden='true'></i>&nbsp;Add</button>
		</span>
  </div>
</div>
</div>

</form>


</div>
</div>


<% 
} // end if (bNew) 
%>

 

<% 
if(bChange)
{
ItemBean.locateRecord(nRecordID);
%>
<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class='fa fa-edit iccolor' aria-hidden='true'></i>&nbsp;&nbsp;Change Option
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	

<form action="itemlist.jsp" method="post" id="item_update">
<input type="hidden" name="Action" value="Update">
<input type="hidden" name="Attribute" value="<%=Attribute %>">
<input type="hidden" name="RecordID" value="<%=nRecordID %>">

<div class="row">
<div class="form-group col-sm-4 col-sm-offset-4">
  <div class="input-group">
    <input type="text" name="Attributes" id="Attributes" value="<%=ItemBean.Options %>" class="form-control required">
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


<% 
} // end if (bChange) 
%>
 
<% 
if(bShow)
{ 
	 String WhrCls = _PSQL("WHERE `masteritemlist`.`Attribute` = '"+Attribute+"' ") ;
	 String OrdBy = _PSQL("ORDER BY `Options` ") ;
   ItemBean.openTable(WhrCls, OrdBy );
%>

<!-- <p align="center"><a href="itemlist.jsp?Action=New&Attribute=<%=Attribute %>"><b>Add new option item </b></a> <b> for entity :<span class="label"> <%=Attribute %></span></b></p> -->

<div class="panel panel-form-box panel-form-box-primary">
  <div class="panel-heading panel-form-box-header panel-form-box-with-border">
    <h3 class="panel-title page-title-action"><i class='fa fa-bookmark iccolor' aria-hidden='true'></i>&nbsp;&nbsp;List of Option
		<button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-left: 5px;margin-top: -5px;" data-original-title="cancel" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="history.go(-1);"><i aria-hidden="true" class="icon wb-close" style="margin: 0;"></i></button>
    <button class="btn btn-icon btn-dark btn-outline btn-round btn-sm pull-right" type="button" style="font-size: 10px;margin-top: -5px;" data-original-title="Dependent Table" data-placement="bottom" data-toggle="tooltip" data-trigger="hover" onclick="NavigateTo('itemtables.jsp?Attribute=<%=Attribute %>')"><i aria-hidden="true" class="icon fa fa-table" style="margin: 0;"></i></button>
    </h3>
	</div>

<div class="panel-body panel-form-box-body container-fluid">	

<% if(bAllowAdd == true){ %>
<button class="btn btn-floating btn-success fixed-add-btn-circle" type="button" onclick="{ $('#new_form').slideToggle(); }" ><i aria-hidden="true" class="icon fa fa-plus"></i></button>
<% } %>

<div id="new_form" style="display:none">
<form action="itemlist.jsp" method="post" id="item_add">
<input type="hidden" name="Action" value="Add">
<input type="hidden" name="Attribute" value="<%=Attribute %>">

<div class="row">
<div class="form-group col-sm-4 col-sm-offset-4">
  <div class="input-group">
    <input type="text" name="Options" id="Options" class="form-control required" placeholder="Enter New Option">
    <span class="input-group-btn">
		<button class="btn btn-default btn-outline" tabindex="-1" type="button" onclick="{ $('#Options').val(''); }"><i aria-hidden="true" class="icon fa fa-refresh"></i></button>
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
 <th>Option</th> 
<% if(bAllowUpdate == false && bAllowDelete == false){ %> <% } else { %> 
<th>&nbsp;</th>
<% } %>
 </tr>
</thead>
<tbody>
<% 
int no=0;
while(ItemBean.nextRow())
{
no++ ;
String DelWarning = "Really want to Delete Option : "+ItemBean.Options+" " ;
%> 
<tr>
 <td> <%=no  %></td>
 <td><%= ItemBean.Options %>  </td> 
 
<% if(bAllowUpdate == false && bAllowDelete == false){ %> <% } else { %>
<td>
<% if(bAllowUpdate == true){ %>
<button onclick="{ $('#changeDIV_<%=ItemBean.RecordID %>').slideToggle(); }" class="btn btn-pure btn-primary icon fa fa-pencil" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="Edit" data-trigger="hover" data-placement="top" data-toggle="tooltip"></button>
<!-- <button onclick="NavigateTo('<%=thisFile %>?Action=Change&Attribute=<%=Attribute %>')" class="btn btn-pure btn-primary icon fa fa-pencil" type="button" style="font-size: 20px;padding: 0;margin-left: 5px;" data-original-title="Edit" data-trigger="hover" data-placement="top" data-toggle="tooltip"></button> -->
<% } %>
<% if(bAllowDelete == true){ %>
<button onclick="AppConfirm('question','Are you sure ?','<%=thisFile %>?Action=Delete&Attribute=<%=Attribute %>&RecordID=<%=ItemBean.RecordID %>','<%=DelWarning %>')" class="btn btn-pure btn-primary icon fa fa-trash-o" type="button" style="font-size: 20px;padding: 0;margin-left: 12px;" data-original-title="Delete" data-trigger="hover" data-placement="top" data-toggle="tooltip"></button>
<% } %>
</td>
<% } %>
</tr>

<tr id="changeDIV_<%=ItemBean.RecordID %>" style="display:none;">
<td colspan="3">
<form action="itemlist.jsp" method="post" id="item_update">
<input type="hidden" name="Action" value="Update">
<input type="hidden" name="Attribute" value="<%=ItemBean.Attribute %>">
<input type="hidden" name="RecordID" value="<%=ItemBean.RecordID %>">
<div>
<div class="form-group col-sm-4 col-sm-offset-4" style="margin-bottom: 10px;margin-top: 10px;">
  <div class="input-group">
    <input type="text" name="Options" id="Options" value="<%=ItemBean.Options %>" class="form-control required">
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
} // end while(ItemBean.nextRow()) 
%>

</tbody>
</table>
</div>

</div>
</div>

<% 
} // end if(bShow) 
%>
			
			
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
if(bShow || bNew) 
{
%>
	$("#item_add").validate();
<%
} 
%>
<% 
if(bShow || bChange) 
{
%>
  $("#item_update").validate();
<%
} 
%>
});
</script>
	<jsp:include page="/include-page/common/Google-Analytics.jsp" flush="true" />
				
</body>
</html>

