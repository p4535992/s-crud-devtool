<%@ page errorPage = "/errorpage.jsp" %>
<%@ page import="java.io.*, java.lang.*, java.util.*, com.beanwiz.* "%>
<% 
String appPath = request.getContextPath() ;
String thisFile = appPath+request.getServletPath() ;
String Message = request.getParameter("Message");

%>
<!DOCTYPE HTML>
<html class="no-js" lang="en">
<head>
  <jsp:include page="/assets/include-page/common/meta-tag.jsp" flush="true" />
  <title>Development Tool</title>
  <jsp:include page="/assets/include-page/css/main-css.jsp" flush="true" />
  <jsp:include page="/assets/include-page/common/main-head-js.jsp" flush="true" />
<style type="text/css">
</style>	
	 
</head>
<body>
<jsp:include page="/header.jsp" flush="true" />

<% 
if(Message!=null)
{ 
%>
<div  id="msg_block" class="alert alert-danger" role="alert">
<table summary=""  cellpadding="4" cellspacing="0"  width="100%">
<tr>
<td width="90%" align="left">
<span style="color:maroon;"><%=Message %></span>
</td>
<td width="10%" align="right">
[ <a href="javascript:void(0)"  onclick="{ $('#msg_block').hide(); }  ">&times;</a> ]
&nbsp;&nbsp;
</td>

</tr>
</table>
</div>
<% 
} 
%>
  <div class="container" style="padding-left:5px ;padding-right:5px ;">
    <div class="col-xs-12 col-sm-4 col-sm-offset-4" style="padding-left:5px ;padding-right:5px ;">
      <div class="panel panel-primary animated pulse box-shadow">
        <div class="panel-heading text-center">
          <h4><i aria-hidden="true" class="icon glyphicon glyphicon-log-in"></i>&nbsp;&nbsp;User LogIn</h4>
				</div>
        <div class="panel-body margin-bot-15">
				
          <form action="<%=appPath %>/user_login_check/" method="post" id="loginForm" autocomplete="off">
            <div class="col-xs-12">
              <div class="form-group text-center" style="color: gray;"> 
							    <span class="fa-stack fa-3x">
                    <i class="fa fa-circle-thin fa-stack-2x"></i>
                    <i class="fa fa-user fa-stack-1x"></i>
                  </span> 
			        </div>
              <div class="form-group">
									<input type="text" class="form-control input-lg" name="LoginID" id="LoginID" placeholder="Username" />
              </div>
              <div class="form-group">
                  <div class="input-group input-group-lg shpassword">
									<input type="password" class="form-control input-lg"  name="Password" id="Password" placeholder="Password" data-toggle="password" data-toggle="tooltip" data-trigger="manual" data-title="Caps lock is on" />
								  </div>
              </div>
              <div class="form-group" > <!-- style="padding-top: 15px;" -->
							    <input type="text" id="realPersoncaptcha" name="realPersoncaptcha" class="form-control" placeholder="Retype Above Text" style="text-transform: uppercase">
							</div>
              <div class="form-group">
							      <div class="checkbox checkbox-primary">
                        <input type="checkbox" id="rememberMe" name="rememberMe">
                        <label for="rememberMe">Remember me</label>
                    </div>      
							</div>
              <div class="form-group">
                <div class="row">
                  <div class="col-xs-6"> <button type="submit" class="btn btn-primary btn-lg pull-right">Sign in</button> </div>
                  <div class="col-xs-6"> <button type="button" class="btn btn-primary btn-lg fRESET">Reset</button> </div>
                </div>
              </div>
            </div>
          </form>
					
        </div>
      </div>
    </div>
  </div>
  <!-- /container -->
  <jsp:include page="/assets/include-page/common/footer.jsp" flush="true" />
  <jsp:include page="/assets/include-page/js/main-js.jsp" flush="true" />
	<jsp:include page="/assets/include-page/js/formValidation-js.jsp" flush="true" />
  <jsp:include page="/assets/include-page/js/hideShowPassword-js.jsp" flush="true" />
  <jsp:include page="/assets/include-page/js/realperson-captcha-js.jsp" flush="true" />
<script>
$(document).ready(function() {

    $('#loginForm').formValidation({
        framework: 'bootstrap',
        fields: {
            LoginID: {
                validators: {
                    notEmpty: {
                        message: 'The username is required'
                    }
                }
            },
            Password: {
                validators: {
                    notEmpty: {
                        message: 'The password is required'
                    }
                }
            },
            realPersoncaptcha: {
                validators: {
                    notEmpty: {
                        message: 'The Code required'
                    },
                    regexp: {
                        regexp: /^[a-zA-Z0-9]*$/i,
                        message: 'The code can consist of alphanumeric characters only'
                    },
                    remote: {
                        message: 'The Code is not correct',
                        url: '<%=appPath %>/backend/validation/realperson_captchavalidation.jsp',
                        data: {
														realPersoncaptchaHash: $('#realPersoncaptcha').realperson('getHash')
                        },
                        type: 'POST'
                    }
                }
            }
        }
    });
		
		//saw one error at one time 
		//.on('err.validator.fv', function(e, data) {
    //    data.element.data('fv.messages').find('.help-block[data-fv-for="' + data.field + '"]').hide().filter('[data-fv-validator="' + data.validator + '"]').show();
   // })


    if (localStorage.checkBoxValidation && localStorage.checkBoxValidation != '') {
        $('#rememberMe').attr('checked', 'checked');
        $('#LoginID').val(localStorage.userName);
        $('#Password').val(localStorage.password);
    } else {
        $('#rememberMe').removeAttr('checked');
        $('#LoginID').val('');
        $('#Password').val('');
    }

    $('#loginForm').on('submit', function() {

        if ($('#rememberMe').is(':checked')) {
            // save username and password
            localStorage.userName = $('#LoginID').val();
            localStorage.password = $('#Password').val();
            localStorage.checkBoxValidation = $('#rememberMe').val();
        } else {
            localStorage.userName = '';
            localStorage.password = '';
            localStorage.checkBoxValidation = '';
        }
    });
});

</script>
<jsp:include page="/assets/include-page/common/Google-Analytics.jsp" flush="true" />
</body>
</html>

