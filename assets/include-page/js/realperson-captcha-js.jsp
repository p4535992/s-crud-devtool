<% String appPath=request.getContextPath(); %>
<!-- realperson - captcha plugin - js  -->
<script src="<%=appPath %>/assets/vendor/realperson-captcha/jquery.plugin.min.js"></script>
<script src="<%=appPath %>/assets/vendor/realperson-captcha/jquery.realperson.min.js"></script>
<script>
$(function() {
	$('#realPersoncaptcha').realperson({regenerate: '<i class="fa fa-refresh fa-lg"></i>', chars: $.realperson.alphanumeric, length: 4});
});
</script>
