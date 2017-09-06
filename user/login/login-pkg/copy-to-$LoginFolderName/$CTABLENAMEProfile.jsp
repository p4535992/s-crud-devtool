<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="$WEBAPP.*, $WEBAPP.apputil.*, $BeanPackage.*"%>
<%@ page import="com.webapp.utils.*" %>
<%@ page import="org.apache.commons.lang3.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="$BeanName" scope="page" class="$BeanPackage.$BeanClass" />
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
$WEBAPP.$LoginClass LogUsr =  ($WEBAPP.$LoginClass)session.getAttribute("$LoginObjectID") ;
$BeanName.locateRecord(LogUsr.$IDField);

String Action = request.getParameter("Action") ;
if(Action==null) Action="Form" ; // Other action Update ChangeForm
String Message = request.getParameter("Message");

if(("Update").equalsIgnoreCase(Action))
{
     $BeanName.locateRecord($BeanName.$IDField);

     $BeanName.FirstName = request.getParameter("FirstName");
     $BeanName.MiddleName = request.getParameter("MiddleName");
     $BeanName.LastName = request.getParameter("LastName");
     $BeanName.Gender = request.getParameter("Gender");
     $BeanName.BirthDate = DateTimeHelper.requestDatePicker( request, "BirthDate" );
     $BeanName.MaritalStatus = request.getParameter("MaritalStatus");
     $BeanName.Address = request.getParameter("Address");
     $BeanName.City = request.getParameter("City");
     $BeanName.State = request.getParameter("State");
     $BeanName.PIN = request.getParameter("PIN");
     $BeanName.Landline = request.getParameter("Landline");
     $BeanName.Mobile = request.getParameter("Mobile");
     $BeanName.Email = request.getParameter("Email");
     $BeanName.Username = request.getParameter("Username");
     $BeanName.UpdateDateTime = new java.sql.Timestamp(System.currentTimeMillis());

		 $BeanName.updateRecord($BeanName.$IDField);
     response.sendRedirect(response.encodeRedirectURL(thisFile+"?Message=Profile Updated !")); 
}
if(("UpdatePhoto").equalsIgnoreCase(Action))
{
response.setDateHeader("Expires", 0 );
response.setHeader("Cache-Control", "no-cache, post-check=0, pre-check=0"); 
response.setHeader("Pragma", "no-cache"); 

Update$CTABLENAMEPhoto $CTABLENAMEPhoto = new Update$CTABLENAMEPhoto(request) ;

$CTABLENAMEPhoto.update$CTABLENAMEPhotograph($BeanName.$IDField, "$CTABLENAMEPhotograph" );

response.sendRedirect(response.encodeRedirectURL(thisFile+"?Action=Form"));

}

%>
<%@include file="/$LoginFolderName/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
		
	<title>$CTABLENAME Profile</title>
	
  <jsp:include page ="/include-page/css/main-css.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>
<style type="text/css">
<!-- 
.page-profile .widget-header{padding:40px 15px;background-color:#fff}.page-profile .widget-footer{padding:10px;background-color:#f6f9fd}.page-profile .widget .avatar{width:130px;margin-bottom:10px}.page-profile .profile-user{margin-bottom:10px;color:#263238}.page-profile .profile-job{margin-bottom:20px;color:#a3afb7}.page-profile .profile-social{margin:25px 0}.page-profile .profile-social .icon{margin:0 10px;color:rgba(55,71,79,.4)}.page-profile .profile-stat-count{display:block;margin-bottom:3px;color:#526069;font-size:20px;font-weight:100}.page-profile .profile-stat-count+span{color:#a3afb7}.page-profile .page-content .list-group-item{padding:15px 15px;border-top-color:#e4eaec}.page-profile .page-content .list-group-item:first-child{border-top:transparent}.page-profile .page-content .list-group-item:last-child{border-bottom-color:#e4eaec}.page-profile .page-content .list-group-item .media .avatar{width:50px}.page-profile .page-content .list-group-item .media small{color:#a3afb7}.page-profile .page-content .list-group-item .media-heading{font-size:16px}.page-profile .page-content .list-group-item .media-heading span{margin-left:5px;color:#76838f;font-size:14px}.page-profile .page-content .list-group-item .media .media:first-child{border-top:none}.page-profile .profile-readMore{margin:40px 0}.page-profile .profile-brief{margin-top:20px}.page-profile .profile-uploaded{max-width:220px;width:100%;max-height:150px;padding-right:20px;margin-bottom:5px} 
-->
</style> 
<jsp:include page="/include-page/css/formValidation-css.jsp" flush="true" />
<jsp:include page="/include-page/css/bootstrap-select-css.jsp" flush="true" />
<jsp:include page="/include-page/css/bootstrap-datepicker-css.jsp" flush="true" />
 
  <jsp:include page ="/include-page/common/main-head-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>  

</head>
<body class="<%=menuTypeClass %> page-profile <%=$BeanName.LoginRole %>" >

  <jsp:include page ="/$LoginFolderName/include-page/nav-body.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
		 <jsp:param  name="MenuTitle" value="NavUserDropdown"/>
		 <jsp:param  name="MenuLink" value="Profile"/>
	</jsp:include>  

  <jsp:include page ="/$LoginFolderName/include-page/menu-body.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
		 <jsp:param  name="MenuTitle" value=""/>
		 <jsp:param  name="MenuLink" value=""/>
	</jsp:include>   

<!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
  	  <div class="row">
        <div class="col-sm-6">
  			  <h3 class="page-title-res"><i aria-hidden="true" class="icon fa fa-user iccolor"></i>Profile</h3>
  	    </div>
        <div class="col-sm-6">
          <ol class="breadcrumb breadcrumb-res">
            <li><a href="<%=appPath %>/$LoginFolderName/index.jsp"><i aria-hidden="true" class="icon fa fa-home fa-lg"></i><span class="hidden-xs">Home</span></a></li>
            <li class="active">Profile</li>
          </ol>			
  	    </div>
  		</div>	
			<hr class="hr-res" />

      <div class="row">
        <div class="col-md-3">
								 
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
               <h4 class="profile-user"><%=ShowItem.show$CTABLENAMEName($BeanName.$IDField, 3) %></h4>
                <p class="profile-job"><%=$BeanName.LoginRole %></p>

                  <div class="well well-sm">
                  <ul class="list-group list-group-gap" style="margin-bottom: 0px;">
                    <li class="list-group-item">
                      <i aria-hidden="true" class="icon fa fa-camera iccolor"></i>
              				<a href="javascript:void(0);" onclick="capturePhoto('<%=$BeanName.$IDField %>')">Update through webcam</a>
                    </li>
                  </ul>		
                  </div>										
								
								<% if(("Form").equalsIgnoreCase(Action)) {%>
								<button type="button" class="btn btn-primary" onclick="NavigateTo('<%=thisFile %>?Action=ChangeForm')"><i aria-hidden="true" class="icon wb-edit"></i> Edit Profile</button>
								<% }else{ %>
								<button type="button" class="btn btn-primary" onclick="NavigateTo('<%=thisFile %>')"><i aria-hidden="true" class="icon wb-eye"></i> View Profile</button>
								<% } %>
              </div>
            </div>
          </div>
          <!-- End Page Widget -->
        </div>
				
        <div class="col-md-9">
          <!-- Panel -->
          <div class="panel">
            <div class="panel-body nav-tabs-animate nav-tabs-horizontal">

<% 
if(("Form").equalsIgnoreCase(Action))
{
%>
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
                      <p class="list-group-item-text"><%if($BeanName.Gender.equalsIgnoreCase("Male")){ %><i aria-hidden="true" class="icon fa fa-male fa-lg iccolor"></i><% }else{ %><i class="icon fa fa-female fa-lg iccolor" aria-hidden="true"></i><% } %>&nbsp;&nbsp;<%=ShowItem.show$CTABLENAMEName($BeanName.$IDField, 3) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Birth Date :</h4>
                      <p class="list-group-item-text"><%=DateTimeHelper.showDatePicker($BeanName.BirthDate) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Marital Status :</h4>
                      <p class="list-group-item-text"><%=StrValue($BeanName.MaritalStatus) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Joining Date :</h4>
                      <p class="list-group-item-text"><%=DateTimeHelper.showDatePicker($BeanName.JoiningDate) %></p>
                    </li>
                  </div>

                </div>

                <div class="tab-pane animation-slide-left" id="Contact" role="tabpanel">
                  <p>&nbsp;</p>
  							  <div class="list-group">
									  <p><h4><i class="icon fa fa-flag iccolor" aria-hidden="true"></i>Address :</h4></p>
                    <li class="list-group-item">
                      
                      <p class="list-group-item-text"><%=StrValue($BeanName.Address) %></p>
											<p class="list-group-item-text"><%=StrValue($BeanName.City) %> - <%=StrValue($BeanName.PIN) %></p>
											<p class="list-group-item-text"><%=StrValue($BeanName.State) %></p>
                    </li>
										
										<p><h4><i class="icon fa fa-phone iccolor" aria-hidden="true"></i>Contact :</h4></p>
										
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Landline :</h4>
                      <p class="list-group-item-text"><%=StrValue($BeanName.Landline) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Mobile :</h4>
                      <p class="list-group-item-text"><%=StrValue($BeanName.Mobile) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Email :</h4>
                      <p class="list-group-item-text"><%=StrValue($BeanName.Email) %></p>
                    </li>


                  </div>

                </div>

                <div class="tab-pane animation-slide-left" id="System" role="tabpanel">
								
  							  <div class="list-group">
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Employment Code :</h4>
                      <p class="list-group-item-text"><%=StrValue($BeanName.EmpCode) %></p>
                    </li>
                    <li class="list-group-item">
                      <h4 class="list-group-item-heading">Username :</h4>
                      <p class="list-group-item-text"><%=StrValue($BeanName.Username) %></p>
                    </li>
                  </div>
								
                </div>
              </div>
<% 
}
else if(("ChangeForm").equalsIgnoreCase(Action))
{
%>
                  <form method="post" action="<%=thisFile %>" id="$CTABLENAME_ChangeForm" autocomplete="off">
									<input type="hidden" name="Action" value="Update" />

		      <div class="row row-lg">
            <div class="col-sm-12">
              <!-- Personal Information -->
              
                <h4><i class="icon wb-user iccolor" aria-hidden="true"></i> Personal Information</h4>
								<hr class="hr-res" />
                <div>
									
                    <div class="row">
                      <div class="form-group col-sm-4">
                        <label for="FirstName" class="control-label blue-grey-600">First Name</label>
                        <input type="text" name="FirstName" id="FirstName" value="<%=$BeanName.FirstName %>" class="form-control" autocomplete="off" placeholder="First Name" >
                      </div>
                      <div class="form-group col-sm-4">
                        <label for="MiddleName" class="control-label blue-grey-600">Middle Name</label>
                        <input type="text" name="MiddleName" id="MiddleName" value="<%=$BeanName.MiddleName %>" class="form-control" autocomplete="off" placeholder="Middle Name" >
                      </div>
                      <div class="form-group col-sm-4">
                        <label for="LastName" class="control-label blue-grey-600">Last Name</label>
                        <input type="text" name="LastName" id="LastName" value="<%=$BeanName.LastName %>" class="form-control" autocomplete="off" placeholder="Last Name" >
                      </div>
                    </div>
										<div class="row">
                    <div class="form-group col-sm-6">
                      <label for="Gender" class="control-label blue-grey-600">Gender</label>
                    	 <select name="Gender" id="Gender" class="form-control show-tick" data-plugin="selectpicker">
                    		<jsp:include page ="/include-page/master/getlistitems.jsp">
                    		       <jsp:param  name="Attribute" value="Gender"/>
                    					 <jsp:param  name="Select" value="<%=$BeanName.Gender %>"/>
                    		</jsp:include>
                       </select>
                    </div>
                    <div class="form-group col-sm-6">
                      <label for="MaritalStatus" class="control-label blue-grey-600">Marital Status</label>
                    	 <select name="MaritalStatus" id="MaritalStatus" class="form-control show-tick" data-plugin="selectpicker">
                    		<jsp:include page ="/include-page/master/getlistitems.jsp">
                    		       <jsp:param  name="Attribute" value="MaritalStatus"/>
                    					 <jsp:param  name="Select" value="<%=$BeanName.MaritalStatus %>"/>
                    		</jsp:include>
                       </select>
                    </div>
										</div>
										<div class="row">
                    <div class="form-group col-sm-6">
                      <label for="BirthDate" class="control-label blue-grey-600">Birth Date</label>
										 <div class="input-group input-group-icon">	
                      <input type="text" name="BirthDate" id="BirthDate" value="<%=DateTimeHelper.showDatePicker($BeanName.BirthDate) %>" class="form-control" data-plugin="datepicker readonlybg" autocomplete="off" placeholder="Birth Date" >
  										<span class="input-group-addon">
                        <span class="icon fa fa-calendar" aria-hidden="true"></span>
                      </span>
										 </div>	
                    </div>
										</div>
                </div>
             
              <!-- End Personal Information -->
							
							
              <!-- Contact Information -->
                <p>&nbsp;</p>
                <h4><i class="icon fa fa-mobile-phone fa-lg iccolor" aria-hidden="true"></i> Contact Information</h4>
								<hr class="hr-res" />
                <div>
                    <div class="row">
                      <div class="form-group col-sm-6">
                        <label for="Address" class="control-label blue-grey-600">Address</label>
												<textarea rows="2" name="Address" id="Address" class="form-control" placeholder="Address" ><%=$BeanName.Address %></textarea>
                      </div>
                      <div class="form-group col-sm-6">
												<label for="City" class="control-label blue-grey-600">City</label>
												<input type="text" name="City" id="City" value="<%=$BeanName.City %>" class="form-control" autocomplete="off" placeholder="City" >
                      </div>
                    </div>
                    <div class="row">
                      <div class="form-group col-sm-6">
                        <label for="State" class="control-label blue-grey-600">State</label>
                    	 <select name="State" id="State" class="form-control show-tick" data-plugin="selectpicker" data-live-search="true">
                    		<jsp:include page ="/include-page/master/getlistitems.jsp">
                    		       <jsp:param  name="Attribute" value="State"/>
                    					 <jsp:param  name="Select" value="<%=$BeanName.State %>"/>
                    		</jsp:include>
                       </select>
                      </div>
                      <div class="form-group col-sm-6">
                        <label for="PIN" class="control-label blue-grey-600">PIN</label>
                        <input type="text" name="PIN" id="PIN" value="<%=$BeanName.PIN %>" class="form-control" autocomplete="off" placeholder="PIN" >
                      </div>
                    </div>
                    <div class="row">
                      <div class="form-group col-sm-6">
                        <label for="Mobile" class="control-label blue-grey-600">Mobile</label>
												<input type="text" name="Mobile" id="Mobile" value="<%=$BeanName.Mobile %>" class="form-control" autocomplete="off" placeholder="Mobile" >
                      </div>
                      <div class="form-group col-sm-6">
												<label for="Landline" class="control-label blue-grey-600">Landline</label>
												<input type="text" name="Landline" id="Landline" value="<%=$BeanName.Landline %>" class="form-control" autocomplete="off" placeholder="Landline" >
                      </div>
                    </div>
                    <div class="form-group">
                      <label for="Email" class="control-label blue-grey-600">Email Address</label>
                      <input type="text" name="Email" id="Email" value="<%=$BeanName.Email %>" class="form-control" autocomplete="off" placeholder="Email Address" >
                    </div>
                </div>
             
              <!-- End Contact Information -->
							
							
              <!-- Example Basic Form -->
                <p>&nbsp;</p>
                <h4><i class="icon fa fa-cog iccolor" aria-hidden="true"></i> System Information</h4>
								<hr class="hr-res" />
                <div>
                    <div class="row">
                      <div class="form-group col-sm-6">
												<label for="Username" class="control-label blue-grey-600">Username</label>
												<input type="text" name="Username" id="Username" value="<%=$BeanName.Username %>" class="form-control" autocomplete="off" placeholder="Username" >
                      </div>
                    </div>
                </div>
								<p>&nbsp;</p>
								    <div class="form-group">
                        <button type="submit" class="btn btn-primary"><i class="icon fa fa-check" aria-hidden="true"></i>&nbsp;Update</button>
												<button type="button" class="btn btn-default btn-outline" onclick="NavigateTo('<%=appPath %>/$LoginFolderName/$CTABLENAMEProfile.jsp')"><i class="fa fa-remove" aria-hidden="true"></i>&nbsp;Cancel</button>
                    </div>

              <!-- End Example Basic Form -->
            </div>
					</div>	
     </form>
<%
}  
else // end if(("ChangeForm").equalsIgnoreCase(Action))
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
          <!-- End Panel -->
        </div>
      </div>
    </div>
  </div>
  <!-- End Page -->

				
  <jsp:include page="/$LoginFolderName/include-page/footer.jsp" flush="true" />
	
  <jsp:include page="/include-page/js/main-js.jsp">
	   <jsp:param  name="menuType" value="<%=menuType %>"/>
	</jsp:include>
	<jsp:include page="/include-page/js/formValidation-js.jsp" flush="true" />
	<jsp:include page="/include-page/js/bootstrap-select-js.jsp" flush="true" />
	<jsp:include page="/include-page/js/bootstrap-datepicker-js.jsp" flush="true" />
	<jsp:include page="/include-page/js/bootstrap-eModal-js.jsp" flush="true" />
	
  <script src="<%=appPath %>/global/js/plugins/responsive-tabs.min.js"></script>
  <script src="<%=appPath %>/global/js/components/tabs.min.js"></script>

<script>

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
        url: "webcam/$CTABLENAMEcapture.jsp?ID="+id,
        title:'<i class="icon fa fa-upload iccolor" aria-hidden="true"></i>&nbsp;Upload Photograph',
        size: eModal.size.lg
    };
  eModal.iframe(options)
}

<% 
if(Message!=null)
{ 
%>
toastr.success("<%=Message %>")	
<% 
} 
%>

$(document).ready(function() {

    $('#$CTABLENAME_ChangeForm').formValidation({
        framework: 'bootstrap',
        fields: {
            FirstName: {
                validators: {
                    notEmpty: {
                        message: 'The First Name is required'
                    }
                }
            },
            LastName: {
                validators: {
                    notEmpty: {
                        message: 'The Last Name is required'
                    }
                }
            },
            BirthDate: {
                validators: {
                    date: {
                        format: 'DD/MM/YYYY',
												separator: '/',
                        message: 'The value is not a valid date'
                    }
                }
            },
            PIN: {
                validators: {
                    notEmpty: {
                        message: 'The field is required'
                    }
                }
            },
            Mobile: {
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
            Email: {
                validators: {
                    emailAddress: {
                        message: 'The value is not a valid email address'
                    }
                }
            },
            Username: {
                validators: {
                    notEmpty: {
                        message: 'The field is required'
                    }
                }
            }
        }
    });
			
});

</script>
	
	<jsp:include page="/include-page/common/Google-Analytics.jsp" flush="true" />

</body>
</html>