<% 
String appPath=request.getContextPath(); 
String menuType = request.getParameter("menuType");
%>
  <!--[if lt IE 9]>
    <script src="<%=appPath %>/global/vendor/html5shiv/html5shiv.min.js"></script>
    <![endif]-->

  <!--[if lt IE 10]>
    <script src="<%=appPath %>/global/vendor/media-match/media.match.min.js"></script>
    <script src="<%=appPath %>/global/vendor/respond/respond.min.js"></script>
    <![endif]-->

  <!-- Scripts -->
  <script src="<%=appPath %>/global/vendor/modernizr/modernizr.min.js"></script>
  <script src="<%=appPath %>/global/vendor/breakpoints/breakpoints.min.js"></script>
  <script>
    Breakpoints();
  </script>
