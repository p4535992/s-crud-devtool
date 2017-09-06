<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="$WEBAPP.*, $WEBAPP.apputil.*, $BeanPackage.*"%>
<%@ page import="org.apache.commons.lang3.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="$BeanName" scope="page" class="$BeanPackage.$BeanClass" />
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath();
$WEBAPP.$LoginClass LogUsr =  ($WEBAPP.$LoginClass)session.getAttribute("$LoginObjectID") ;
$BeanName.locateRecord(LogUsr.$IDField);

String Action = request.getParameter("Action") ;
if(Action==null) Action="Form" ; // Other action Update

boolean bSuccess=false;
String Message = request.getParameter("Message");

if(("Update").equalsIgnoreCase(Action))
{
String Password = request.getParameter("Password");
String NewPassword1 = request.getParameter("NewPassword1");

          if(Password.equals($BeanName.Password))
	        {
					     $BeanName.locateRecord($BeanName.$IDField);
	             $BeanName.Password= NewPassword1;
			         $BeanName.updateRecord($BeanName.$IDField);
			         bSuccess=true;
	        }
	        else // Invalid Old Password
	        {
	             bSuccess=false;
               Message="Invalid Old Password";
	        }
					
     if(bSuccess)
     { 
		   response.sendRedirect(response.encodeRedirectURL(thisFile+"?Action=success"));
     }
     else // FAILURE
     { 
		   response.sendRedirect(response.encodeRedirectURL(thisFile+"?Message="+Message));
     } // end else of if(bSuccess)	
}
%>
<%@include file="/$LoginFolderName/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
	
	<title>Change Login Password</title>
	
  <jsp:include page ="/include-page/css/main-css.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  
<jsp:include page="/include-page/css/formValidation-css.jsp" flush="true" />
  <jsp:include page ="/include-page/common/main-head-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  

</head>

<body class="<%=menuTypeClass %> <%=$BeanName.LoginRole %>" >

  <jsp:include page ="/$LoginFolderName/include-page/nav-body.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
		 <jsp:param  name="MenuTitle" value="NavUserDropdown"/>
		 <jsp:param  name="MenuLink" value="ChangePassword"/>
	</jsp:include>  

  <jsp:include page ="/$LoginFolderName/include-page/menu-body.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
		 <jsp:param  name="MenuTitle" value=""/>
		 <jsp:param  name="MenuLink" value=""/>
	</jsp:include>  

  <!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
		
<% 
if(("Form").equalsIgnoreCase(Action))
{
%>
      <p><h1 class="page-title-res text-center"><i aria-hidden="true" class="icon fa fa-key"></i>Change Password</h1></p>
    <hr class="hr-res" />

<div class="row row-lg">

<div class="col-sm-6 col-sm-offset-3">
		
<div class="panel">
<div class="panel-body container-fluid">

    <form action="<%=thisFile %>" method="post" id="change_pass_form" class="form-horizontal" >
		<input type="hidden" name="Action" value="Update" />

                    <div class="form-group">
                      <label class="col-sm-5 control-label blue-grey-600">Old Password: </label>
                      <div class="col-sm-7">
                        <input class="form-control" name="Password" placeholder="Enter Old Password" type="password" >
                      </div>
                    </div>
                    <div class="form-group">
                      <label class="col-sm-5 control-label blue-grey-600">New Password: </label>
                      <div class="col-sm-7">
                        <input class="form-control" name="NewPassword1" placeholder="Enter New Password" type="password">
                      </div>
                    </div>
                    <div class="form-group">
                      <label class="col-sm-5 control-label blue-grey-600">Confirm New Password: </label>
                      <div class="col-sm-7">
                        <input class="form-control" name="NewPassword2" placeholder="Confirm New Password" type="password">
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="col-sm-7 col-sm-offset-5">
                        <button type="submit" class="btn btn-primary"><i class="icon fa fa-check" aria-hidden="true"></i>&nbsp;Update</button>
												<button type="button" class="btn btn-default btn-outline" onclick="NavigateTo('<%=appPath %>/$LoginFolderName/index.jsp')"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
                      </div>
                    </div>
    </form>

</div>
</div>

		
</div>
</div>
<% 
}
else if(("success").equalsIgnoreCase(Action))
{
%>
				 
<div class="row row-lg">

<div class="col-sm-6 col-md-6 col-sm-offset-3">
							
<div class="well well-sm well-success">
<ul class="list-icons">
<li><i class="wb-check" aria-hidden="true"></i>&nbsp;Your Login Password Changed Successfully</li>
</ul>
</div>

<a class="btn btn-icon btn-primary btn-round btn-block btn-lg" href="<%=appPath %>/$LoginFolderName/index.jsp" data-toggle="tooltip" data-placement="auto bottom" title="Home"><i class="fa fa-home fa-lg" aria-hidden="true"></i>&nbsp;Home</a>


</div>
</div>


<%
}  
else // end if(("Form").equalsIgnoreCase(Action))
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

  <jsp:include page="/$LoginFolderName/include-page/footer.jsp" flush="true" />
	
  <jsp:include page="/include-page/js/main-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>
<jsp:include page="/include-page/js/formValidation-js.jsp" flush="true" />
<script type="text/javascript">
<!--
$(document).ready(function(){
 // Init jQuery 

<% 
if(Message!=null && Message.length()>0)
{ 
%>
		
toastr.error("<%=Message %>", " ", {'timeOut': 0,'closeButton': true})	
<% 
} 
%>

    $('#change_pass_form').formValidation({
        framework: 'bootstrap',
        fields: {
            Password: {
                validators: {
                    notEmpty: {
                        message: 'The Password is required'
                    }
                }
            },
            NewPassword1: {
                validators: {
                    notEmpty: {
                        message: 'The Password is required'
                    }
                }
            },
            NewPassword2: {
						    trigger: 'blur',
                validators: {
                    notEmpty: {
                        message: 'The Password is required'
                    },
                    identical: {
                        field: 'NewPassword1',
                        message: 'Confirm password is not same as above'
                    }
                }
            }
        }
    });


 // End init
});
// --> 
</script>
	
	<jsp:include page="/include-page/common/Google-Analytics.jsp" flush="true" />

</body>
</html>
