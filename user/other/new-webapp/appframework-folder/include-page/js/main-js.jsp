<%@ page import="com.$WEBAPP.*, com.$WEBAPP.apputil.*"%>
<% 
String appPath=request.getContextPath(); 
String menuType = request.getParameter("menuType");

AppSetting si = new AppSetting(application);

        int disable_normal_js =0;
        try
        {
            disable_normal_js = Integer.parseInt(si.getValue("KEY-DISABLE-NORMAL"));
        }
        catch(NumberFormatException ex)
        {
            disable_normal_js = 0;
        }

        int disable_hard_js =0;
        try
        {
            disable_hard_js = Integer.parseInt(si.getValue("KEY-DISABLE-HARD"));
        }
        catch(NumberFormatException ex)
        {
            disable_hard_js = 0;
        }
				
boolean flgLinkAsPost = false ;
if( "YES".equals(si.getValue("POST-LINK-FLAG")) )
{
 		flgLinkAsPost = true ;
}				
%>

  <!-- Core  -->
  <script src="<%=appPath %>/global/vendor/jquery/jquery.min.js"></script>
  <script src="<%=appPath %>/global/vendor/bootstrap/bootstrap.min.js"></script>
  <script src="<%=appPath %>/global/vendor/animsition/animsition.min.js"></script>
  <script src="<%=appPath %>/global/vendor/asscroll/jquery-asScroll.min.js"></script>
  <script src="<%=appPath %>/global/vendor/mousewheel/jquery.mousewheel.min.js"></script>
  <script src="<%=appPath %>/global/vendor/asscrollable/jquery.asScrollable.all.min.js"></script>
  <script src="<%=appPath %>/global/vendor/ashoverscroll/jquery-asHoverScroll.min.js"></script>

  <!-- Plugins -->
  <script src="<%=appPath %>/global/vendor/slidepanel/jquery-slidePanel.min.js"></script>

  <!-- Scripts -->
  <script src="<%=appPath %>/global/js/core.min.js"></script>
  <script src="<%=appPath %>/assets/<%=menuType %>/js/site.min.js"></script>

  <script src="<%=appPath %>/assets/<%=menuType %>/js/sections/menu.min.js"></script>
  <script src="<%=appPath %>/assets/<%=menuType %>/js/sections/menubar.min.js"></script>
  <script src="<%=appPath %>/assets/<%=menuType %>/js/sections/sidebar.min.js"></script>

  <script src="<%=appPath %>/global/js/components/asscrollable.min.js"></script>
  <script src="<%=appPath %>/global/js/components/animsition.min.js"></script>
  <script src="<%=appPath %>/global/js/components/slidepanel.min.js"></script>
  
  <!-- Toastr - Notification -->	
  <script src="<%=appPath %>/global/vendor/toastr/toastr.min.js"></script>
  <!-- sweetalert2 - dialog Effect -->	
  <script src="<%=appPath %>/global/vendor/sweetalert2/sweetalert2.min.js"></script>

<% if(disable_normal_js == 2){%>
<script src="<%=appPath %>/global/js/disable_normal.js"></script>
<% }	%>

<% if(disable_hard_js == 2){%>
<script src="<%=appPath %>/global/js/disable-hard.js"></script>
<% }	%>

  <script>
    (function(document, window, $) {
      'use strict';

      var Site = window.Site;
      $(document).ready(function() {
        Site.run();
      });
    })(document, window, jQuery);
  </script>
	
  <!-- browser upgrade notice-->
  <script>
  //browser upgrade warning
  $("body").prepend(" <!--[if lt IE 9]> <p class='browserupgrade'>You are using an <strong>outdated</strong> browser. Please <a href='http://browsehappy.com/'> upgrade your browser</a> to improve your experience.</p> <![endif]--> ");
  </script>
	
<script type="text/javascript">
<!--

function NavigateTo(url) 
{
  <%  
  if(flgLinkAsPost)
  {
  %>	
      var href = url;
      var parts = href.split('?');
      var url = parts[0];
  		
  		if(typeof parts[1] === 'undefined')
  		{
        $("body").append('<form action="'+url+'" method="post" id="poster"></form>');
        $("#poster").submit();		
  		}
  		else
  		{
        var params = parts[1].split('&');
        var pp, inputs = '';
        for(var i = 0, n = params.length; i < n; i++) 
        {
          pp = params[i].split('=');
          inputs += '<input type="hidden" name="' + pp[0] + '" value="' + pp[1] + '" />';
        }
        $("body").append('<form action="'+url+'" method="post" id="poster">'+inputs+'</form>');
        $("#poster").submit();
  		}
  <%  
  } 
  else
  { 
  %>	
  		document.location.href = url;
  <%  
  }
  %>
}

function AppConfirm(typ,title,url,msg) {
swal({
  title: title,
  text: msg,
  type: typ,
  showCancelButton: true
	//,animation: false
}).then(function() {
  NavigateTo(url);
}, function(dismiss) {
  // dismiss can be 'cancel', 'overlay', 'close', 'timer'
  if (dismiss === 'cancel') {
    //toastr.info("Logout Cancel !");
  }
});	
}

$(document).ready(function() {
//scroll on top data-toggle="tooltip" data-placement="auto left" data-original-title="Scroll to Top" title=""
  //Scroll to Top |||||| fa-square-o fa-circle-thin | fa-angle-up fa-arrow-up fa-space-shuttle fa-rotate-270
  $('body').append('<div class="toTop animsition" title="Scroll to Top" data-animsition-in-class="fade-in" data-animsition-in-duration="1000" data-animsition-out-class="fade-out" data-animsition-out-duration="800"><span class="fa-stack fa-lg"><i class="fa fa-circle-thin fa-stack-2x"></i><i class="fa fa-space-shuttle fa-rotate-270 fa-stack-1x"></i></span></div>');
  $(window).scroll(function() {
    if ($(this).scrollTop() != 0) {
      $('.toTop').fadeIn();
    }
    else {
      $('.toTop').fadeOut();
    }
  });
  $('.toTop').click(function() {
    $("html, body").animate({
      scrollTop: 0
    }, 500);
    return false;
  });
	
//var mq = window.matchMedia("(max-width: 480px)" );
//if (mq.matches) {
  $(".readonlybg").attr("readonly","true");
//} 
	
$(':reset').on('click', function(evt) {
        evt.preventDefault()
        $form = $(evt.target).closest('form')
        $form[0].reset()
        $form.find('select').selectpicker('render')
				//$form.validate().resetForm()
				//$form.data("formValidation").resetForm(!0)
				//$(":file").filestyle('clear');
				//$form.find('select').val('').selectpicker('refresh'); // for built in selected
				 /* for normal input type file
				 //var $el = $form.find('[type=file]');
         //$el.wrap('<form>').closest('form').get(0).reset();
         //$el.unwrap();
				 */
    });	
		
<%  
if(flgLinkAsPost)
{
%>	
var a_link = $("a");
var li_a_link = $("li a");
				
$(a_link.selector+", "+li_a_link.selector).click(function(e) {

  if($(this).attr("href").indexOf("#") == 0 || $(this).attr("href").indexOf("void") > 0)
	{
    //alert("Rock On!");
  }
  else
  {
    e.stopPropagation();
    e.preventDefault();
    var href = this.href;
    var parts = href.split('?');
    var url = parts[0];
		if(typeof parts[1] === 'undefined')
		{
      $("body").append('<form action="'+url+'" method="post" id="poster"></form>');
      $("#poster").submit();		
		}
		else
		{
      var params = parts[1].split('&');
      var pp, inputs = '';
      for(var i = 0, n = params.length; i < n; i++) 
      {
        pp = params[i].split('=');
        inputs += '<input type="hidden" name="' + pp[0] + '" value="' + pp[1] + '" />';
      }
      $("body").append('<form action="'+url+'" method="post" id="poster">'+inputs+'</form>');
      $("#poster").submit();
		}
  }
});
<%  
} //END if(flgLinkAsPost) 
%>		
		
	
});
// -->
</script>		