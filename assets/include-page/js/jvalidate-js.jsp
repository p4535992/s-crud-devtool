<% String appPath=request.getContextPath(); %>
<!-- jquery validation -->
<script src="<%=appPath %>/assets/vendor/jvalidate/jquery.validate.min.js"></script>
<script src="<%=appPath %>/assets/vendor/jvalidate/additional-methods.min.js"></script>
<script>
$(document).ready(function() {


// override jquery validate plugin defaults
$.validator.setDefaults({
    highlight: function(element) {
        $(element).closest('.form-group').addClass('has-error');//.removeClass('has-success')
    },
    unhighlight: function(element) {
        $(element).closest('.form-group').removeClass('has-error');//.addClass('has-success')
    },
    errorElement: 'span',
    errorClass: 'help-block',
    errorPlacement: function(error, element) {
        if(element.parent('.input-group').length || element.prop('type') === 'checkbox' || element.prop('type') === 'radio') {
            error.insertAfter(element.parent());
        } else if (element.parent('.radio-inline').length || element.parent('.checkbox-inline').length) {
            error.insertAfter(element.parent().parent());
        }else {
            error.insertAfter(element);
        }
    }
});	

//reset button
$('.jRESET').on("click",function(e){$(this.form).validate().resetForm()});
//e.preventDefault(),$(this.form).trigger("reset"),
});
</script>	