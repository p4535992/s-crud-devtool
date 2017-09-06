<% String appPath=request.getContextPath(); %>
<!-- bootstrap-maxlength - Text Character counter -->
<script src="<%=appPath %>/global/vendor/bootstrap-maxlength/bootstrap-maxlength.js"></script>
<script type="text/javascript">
$.components.register("maxlength",{mode:"default",defaults:{showOnReady: false,alwaysShow: true,allowOverMax: true,placement: 'top-right-inside'}});
</script>
<style type="text/css">
.bootstrap-maxlength.label{margin-top:5px}
</style>