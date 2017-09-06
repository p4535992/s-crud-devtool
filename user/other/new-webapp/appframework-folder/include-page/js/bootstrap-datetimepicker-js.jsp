<% String appPath=request.getContextPath(); %>
<!-- bootstrap-datetimepicker - DateTime -->
<script src="<%=appPath %>/global/vendor/bootstrap-datetimepicker/moment.min.js"></script>
<script src="<%=appPath %>/global/vendor/bootstrap-datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript">
$(function () {
  $('.datetimepicker').datetimepicker({
	            focusOnShow:false,
							useCurrent: false,
	            ignoreReadonly: true,
                icons: {
                    time: "fa fa-clock-o",
                    date: "fa fa-calendar",
                    up: "fa fa-arrow-up",
                    down: "fa fa-arrow-down",
										next: "fa fa-chevron-circle-right",
										previous: "fa fa-chevron-circle-left",
										today: "fa fa-arrows",
										clear: "fa fa-trash-o",
										close: "fa fa-close"
                },
								format: 'DD/MM/YYYY hh:mm A',
								showTodayButton: true,
								showClear: true,
								showClose: true
								
            });
});
</script>
