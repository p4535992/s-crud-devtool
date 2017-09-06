<% String appPath=request.getContextPath(); %>
<!-- FormValidation -->	
<script src="<%=appPath %>/global/vendor/formvalidation/formValidation.min.js"></script>
<script src="<%=appPath %>/global/vendor/formvalidation/formvalidation_bootstrap.min.js"></script>
<script>
$(document).ready(function() {
//prevent submit button disable after error thrown
$("form").on("err.field.fv",function(f,i){i.fv.disableSubmitButtons(!1)}).on("success.field.fv",function(f,i){i.fv.disableSubmitButtons(!1)});

//reset button
$('.fRESET').on("click",function(e){$(this.form).data("formValidation").resetForm(!0)});
//e.preventDefault(),$(this.form).trigger("reset"),

//saw one error at one time
$("form").on('err.validator.fv', function(e, data) {data.element.data('fv.messages').find('.help-block[data-fv-for="' + data.field + '"]').hide().filter('[data-fv-validator="' + data.validator + '"]').show();});

//Hiding success class [for color]
$("form").on('success.field.fv', function(e, data) {var $parent = data.element.parents('.form-group');$parent.removeClass('has-success');});
});
</script>