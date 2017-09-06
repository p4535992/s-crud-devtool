<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="$WEBAPP.*, $WEBAPP.apputil.*, $BeanPackage.*"%> 
<%@ page import="java.io.*, java.util.*, java.text.*, java.math.*, java.sql.*, java.lang.*,javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="org.apache.commons.lang3.*, com.webapp.utils.*, com.webapp.db.*, com.webapp.jsp.*, com.webapp.resin.*, com.webapp.base64.*" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="SiMngrBn" scope="page" class="$BeanPackage.SitemanagerBean" />
<jsp:useBean id="$BeanName" scope="page" class="$BeanPackage.$BeanClass" />
<%
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
// Optional String thisFolder = appPath+JSPUtils.jspPageFolder(request);

$WEBAPP.LoggedSitemanager LogUsr = ($WEBAPP.LoggedSitemanager)session.getAttribute("theSitemanager") ;
SiMngrBn.locateRecord(LogUsr.AdminID);

boolean blocate = $BeanName.locateRecord(RequestHelper.getInteger(request, "ID"));

int nID = $BeanName.$IDField;
%>
<%@include file="/$LoginFolderName/nav_menu.inc"%>
<!DOCTYPE html>
<html class="no-js css-menubar" lang="en">
<head>
  <jsp:include page ="/include-page/common/meta-tag.jsp" flush="true" />
	<title>Capture Photgraph Through WebCam</title>

  <jsp:include page ="/include-page/css/main-css.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>
 	
  <jsp:include page ="/include-page/common/main-head-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>

</head>

<body class="<%=menuTypeClass %> <%=$BeanName.LoginRole %>" onload="InitPage()" style="padding-top: 0px;">

  <!-- Page -->
  <div class="page animsition">
    <div class="page-content container-fluid">
<% 
if(blocate)
{
%>

      <div class="panel panel-form-box panel-form-box-primary" style="margin-bottom:5px;">
          <div class="panel-heading panel-form-box-header panel-form-box-with-border">
            <h3 class="panel-title page-title-action"><i class='fa fa-bookmark iccolor' aria-hidden='true'></i>&nbsp;&nbsp;<%=ShowItem.show$CTABLENAMEName($BeanName.$IDField, 3) %></h3>
        	</div>
      </div>

<div class="panel panel-bordered panel-danger" id="cam_error" style="display:none;">
  <div class="panel-heading">
  	<h3 class="panel-title">Webcam Support Error</h3>
  </div>
  <div class="panel-body">
     Your web browser is not compliant with <b>HTML-5 </b> specifications, and it does not support capturing images through web cam.<br/>
     We recommand using latest versions of web browsers like <b>Mozilla Firefox </b>or <b>Google Chrome</b> as they  support <b>HTML-5</b> standards.
  </div>
</div>

    <table class="table table-condensed tab-table">
    <tr>
       <td align="center">
        <div class="panel panel-bordered panel-primary"  data-mh="my-group">
          <div class="panel-heading">
            <h3 class="panel-title"><i aria-hidden="true" class="icon fa fa-video-camera"></i>&nbsp;Webcam Streaming</h3>
          </div>
          <div class="panel-body">
            <p><div id="capture" style="width:200px; height:200px;"></p>
          </div>
        </div> 
			 </td>
       <td align="center">
        <div class="panel panel-bordered panel-primary"  data-mh="my-group">
          <div class="panel-heading">
            <h3 class="panel-title">Snapped Photo</h3>
          </div>
          <div class="panel-body">
					  <table border="0" cellpadding="4" cellspacing="4" summary="" width="100%" id="borderdiv" style="display:none;" >
              <tr>
							<td align="center">
                <div style="border:10px ridge #eee;width:220px; height:220px;">
    						  <div id="preview" style="width:200px; height:200px;" ></div>
    						</div>						
							</td>
							<td align="center">
    						<button type="button" id="UploadButton" value="" onclick="UploadImage()" class="btn btn-block btn-primary">Upload</button>
    						<br />
    						<button type="button" id="ClearButton" value="" onclick="ClearUpload()" class="btn btn-block btn-primary">Cancle</button>						
							</td>
							</tr>
            </table>
        </div> 			 
			 </td>
    </tr>
    </table>

<% 
}
else
{ 
%>
<p>&nbsp;</p>
<p align="center" ><big>Records satisfying criteria not found ! </big></p>
<% 
} 
%>			
			
    </div>
  </div>
  <!-- End Page -->
	<jsp:include page ="/$LoginFolderName/include-page/footer.jsp" flush="true" />
	 
	<jsp:include page ="/include-page/js/main-js.jsp" >	
  	 <jsp:param name="menuType" value="<%=menuType %>" />
  </jsp:include>
	<jsp:include page="/include-page/js/photobooth-js.jsp" flush="true" />
	<jsp:include page="/include-page/js/matchheight-js.jsp" flush="true" />
	


	

<script>

function InitPage()
{
// Do something on page init
}

var image_data_url = null; 
var camSupport = null;
 
function ClearUpload()
{
  $("#preview").html("Capture another image");
  $("#UploadButton").prop('disabled', true);
} 
 
function UploadImage()
{
   if(image_data_url == null)
	 {
	   alert("Image not captured.");
	 }
	 var strID="<%=nID %>" ;	 
	 $.ajax( "admin-$CTABLENAME-upload-image.jsp",{
	   data:{ID:strID,DataURL:image_data_url},
	   method:"POST"
	   }).done( function( data ) {
		   $("#preview").html(data);
			 image_data_url =null;
			 $("#UploadButton").prop('disabled', true);
			 parent.location.href = parent.location.href ; 

     }).fail(function(){
        $("#preview").html("Error in updating the record<br/> AJAX call failed." );
				image_data_url =null;
				$("#UploadButton").prop('disabled', true);
       }); 
} 
  
$(document).ready(function() {
	
	$('#capture').photobooth().on("image",function( event, dataUrl ){
	  image_data_url = dataUrl ;
	  $("#borderdiv").show(); 
	$( "#preview" ).html( '<img src="' + dataUrl + '" >');
  $("#UploadButton").prop('disabled', false);
	
});
	
	camSupport = $( '#capture' ).data( "photobooth" ).isSupported ;
	if(camSupport ==false) $("#cam_error").show();

	$("#UploadButton").prop('disabled', true);
	
});

</script>

<jsp:include page ="/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>

