<% String appPath=request.getContextPath(); %>
<!-- jquery -->
<script src="<%=appPath %>/assets/js/jquery/jquery-1.12.1.min.js"></script>	

<!-- browser upgrade notice-->
<script>
//browser upgrade warning
$("body").prepend(" <!--[if lt IE 9]> <p class='browserupgrade'>You are using an <strong>outdated</strong> browser. Please <a href='http://browsehappy.com/'> upgrade your browser</a> to improve your experience.</p> <![endif]--> ");
//caps lock warning
$("[type=password]").keypress(function(o){var t=$(this),i=$(".tooltip").is(":visible"),e=String.fromCharCode(o.which);e.toUpperCase()!==e||e.toLowerCase()===e||o.shiftKey?i&&t.tooltip("hide"):i||t.tooltip("show"),t.blur(function(o){t.tooltip("hide")})});		
</script>

<!-- bootstrap -->
<script src="<%=appPath %>/assets/js/bootstrap/bootstrap.min.js"></script>

<!-- pace - Page Loding Effect -->	
<script src="<%=appPath %>/assets/vendor/pace/pace.min.js"></script>

<!-- sweetalert2 - dialog Effect -->	
<script src="<%=appPath %>/assets/vendor/sweetalert2/sweetalert2.min.js"></script>

<!-- toastr - For Notification -->
<script src="<%=appPath %>/assets/vendor/toastr/toastr.min.js"></script>

<!-- nicescroll - For fancy scrollBar -->
<script src="<%=appPath %>/assets/vendor/nicescroll/jquery.nicescroll.min.js"></script>

<!-- bootstrap-select - For Select box -->
<script src="<%=appPath %>/assets/vendor/bootstrap-select/bootstrap-select.min.js"></script>


<script type="text/javascript">
<!--

function NavigateTo(url) {
  document.location.href = url;
}

function LogoutConfirm(url) {
  swal({
    title: "Are you sure?",
    text: "You will not be able to recover this Session!",
    type: "question",
    showCancelButton: true,
    closeOnConfirm: false	
  }).then(function(isConfirm) {
    if (isConfirm === true) {
      NavigateTo(url);
    }
    else if (isConfirm === false) {
      toastr.info('Logout Cancel !');
    }
    else {
      //swal('Any fool can use a computer');
    }
  });
}

$(document).ready(function() {
//scroll on top
  //Scroll to Top |||||| fa-square-o fa-circle-thin | fa-angle-up fa-arrow-up fa-space-shuttle fa-rotate-270
  $('body').append('<div class="toTop animated bounceInUp" data-toggle="tooltip" data-placement="auto left" title="Scroll to Top"><span class="fa-stack fa-lg"><i class="fa fa-circle-thin fa-stack-2x"></i><i class="fa fa-space-shuttle fa-rotate-270 fa-stack-1x"></i></span></div>');
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
	
	//for tooltip
  $('[data-toggle="tooltip"]').tooltip();
	//for modal icon bar animation
	$(".navbar-toggle").on("click", function () {$(this).toggleClass("active");});
	
	//for bootstrap select
	$('.selectpicker').selectpicker();
	
	//for fancy Scrollbar
	$('#wrenchModal .modal-content').niceScroll();
	//$('#bs3selctid').niceScroll();
	
	
//for sideber icon animation
function toggleChevron(e) {
    $(e.target)
        .prev('a[data-toggle="collapse"]')
        .find('i.fa')
        .toggleClass('fa-minus fa-plus');
}
$('.foriconanim').on('hide.bs.collapse', toggleChevron);
$('.foriconanim').on('show.bs.collapse', toggleChevron);

$(".wrenchModal").on('show.bs.modal', function () {
//$(".navbar-fixed-top").css({'z-index': '2030'});
$(".navbar-fixed-top").addClass('zindexnav');

});
$(".wrenchModal").on('hidden.bs.modal', function () {
//$(".navbar-fixed-top").css({'z-index': ''});
$(".navbar-fixed-top").removeClass('zindexnav');
});


});
// -->
</script>