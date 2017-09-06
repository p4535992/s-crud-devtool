<% String appPath=request.getContextPath(); %>
<!-- Animating-Numbers-Counting-Up-with-jQuery-Counter-Up -->
<script src="<%=appPath %>/global/vendor/jcounter-up/waypoints.min.js"></script>
<script src="<%=appPath %>/global/vendor/jcounter-up/jquery.counterup.min.js"></script>
<script>
$(document).ready(function() {
$('.Animated-counter').counterUp();
});
</script>