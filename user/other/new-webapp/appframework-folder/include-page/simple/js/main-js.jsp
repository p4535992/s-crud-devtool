<% 
String appPath=request.getContextPath(); 
String menuType = request.getParameter("menuType");
%>
  <!-- Core  -->
  <script src="<%=appPath %>/global/vendor/jquery/jquery.min.js"></script>
  <script src="<%=appPath %>/global/vendor/bootstrap/bootstrap.min.js"></script>
  <script src="<%=appPath %>/global/vendor/animsition/animsition.min.js"></script>
  <!-- Scripts -->
  <script src="<%=appPath %>/global/js/core.min.js"></script>
	
  <!-- browser upgrade notice-->
  <script>
  //browser upgrade warning
  $("body").prepend(" <!--[if lt IE 9]> <p class='browserupgrade'>You are using an <strong>outdated</strong> browser. Please <a href='http://browsehappy.com/'> upgrade your browser</a> to improve your experience.</p> <![endif]--> ");
  //caps lock warning
  $("[type=password]").keypress(function(o){var t=$(this),i=$(".tooltip").is(":visible"),e=String.fromCharCode(o.which);e.toUpperCase()!==e||e.toLowerCase()===e||o.shiftKey?i&&t.tooltip("hide"):i||t.tooltip("show"),t.blur(function(o){t.tooltip("hide")})});		
  </script>
	