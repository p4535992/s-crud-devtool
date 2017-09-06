<% String appPath=request.getContextPath(); %>
<!-- bootstrap-editable - form -->
<script src="<%=appPath %>/global/vendor/bootstrap-editable/bootstrap-editable.min.js"></script>
<script>
$(document).ready(function() {
$(".editable_element").editable({
		validate: function(a) {return "" == $.trim(a) ? "This field is required" : void 0}
});
});
</script>