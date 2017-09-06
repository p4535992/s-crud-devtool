$(document).ready(function(){


$('.customeasytip').jqeasytooltip({
	theme:"tipthemesquarecustom"
});

$('#ajaxcontent').jqeasytooltip({
	content: function(callback){
		$.ajax({
			url:"content.html",
			success: function(data){
				console.log(data);
				callback(data);
			}
		});
	}
});


$("#tooltipMinimalform").jqeasytooltip({
            content: function(callback){
                $.ajax({
                    url:"forms.html", //A string containing the URL to which the request is sent.
                    success: function(data){
                            callback(data); // callback request. Pass data to a callback function inside jqeasytooltip
                    }
                });
            },
            followcursor: false, // tooltip following the cursor.. true or false
            event: "click", //event that fires the tooltip open
            eventout: "click", //event that fires the tooltip close
            mouseleave:false
}); //

$('#eventstip').jqeasytooltip({
	open:function(){
		$('#eventstip').html('Open');
	},
	close:function(){
		$('#eventstip').html('Close');
	},
	init:function(){
		$('#eventstip').html('Initialized');
	}
});

$('#eventstipclickopen').jqeasytooltip({
	open:function(){
		$('#eventstipclickopen').html('Click to Close');
	},
	close:function(){
		$('#eventstipclickopen').html('Click to Open');


	}
});


//be creative code
var t1,t2,t3,tfinal;
$('#startProcess').on('click', function(){
	$('#process1').jqeasytooltip('close');
	$('#process2').jqeasytooltip('close');
	$('#process3').jqeasytooltip('close');
	clearTimeout(t1);
	clearTimeout(t2);
	clearTimeout(t3);
	clearTimeout(tfinal);

	t1 = setTimeout(function(){
	$('#process1').jqeasytooltip('open');
	},200);

	t2 =setTimeout(function(){
		$('#process1').jqeasytooltip('close');
		$('#process2').jqeasytooltip('open');
	},1500);

	t3= setTimeout(function(){
		$('#process2').jqeasytooltip('close');
		$('#process3').jqeasytooltip('open');
	},3000);

	tfinal = setTimeout(function(){
		$('#process3').jqeasytooltip('close');
	},6000);
});





var timeset
function opentool(tooltip,newtooltip,time){
	console.log("dentro")
	clearTimeout(timeset);
	timeset = setTimeout(function(){
		tooltip.jqeasytooltip('close');
		newtooltip.jqeasytooltip('open');
	},time);
}






	SyntaxHighlighter.all();
	// nice scroll
	// nice = $("body").niceScroll({
 //    		cursorcolor:"#00acee",
 //    		cursorborder: '0',
 //    		cursorborderradius : '0',
 //    		zindex:'999999',
 //    		cursoropacitymin:'0.5',
 //    		cursorwidth :10,
 //    		background: 'rgba(255,255,255,0.5)'
 //    });



	//Scrool functions------------------------------------------------------------------------------------------------------------*/

	$('nav a').click(function(){
		var scrollto = $(this).attr('href');
		$('html, body').animate({ scrollTop: $(scrollto).offset().top }, 1500);
		return false;
	});

	/*jquery apear --------------------------------------------------------------------------------------------------------------*/

	$('.appear').appear();

	$(document.body).on('appear', '.appear', function(e, $affected) {
		// this code is executed for each appeared element
		var animation = $(this).data('animation');
		if(animation!=undefined){
			$(this).addClass($(this).data('animation'));
		}else{
			$(this).addClass('fadein');
		}

	});

	$(document.body).on('disappear', '.appear', function(e, $affected) {
		// this code is executed for each disappeared element
		var animation = $(this).data('animation');
		if(animation!=undefined){
			//$(this).removeClass($(this).data('animation'));
		}else{
			//$(this).removeClass('fadein');
		}
	});



    // Testimonials Cycle------------------

    $('#cylceservices').cycle();



	//Google Maps--------------------------

	var stylemap = [ { "stylers": [ { "hue": "#00b2ff" }, { "saturation": -37 }, { "lightness": 15 } ] },{ "featureType": "landscape", "stylers": [ { "color": "#e7e5e4" } ] },{ "featureType": "road.highway", "stylers": [ { "color": "#cddada" }, { "saturation": -25 } ] },{ } ]

	//map config options
    var myOptions = {
      zoom: 8,
      center: new google.maps.LatLng(-34.397, 150.644),
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      sensor: 'true',
      styles: stylemap
    }


    //inicializate google maps in div element
    var map = new google.maps.Map(document.getElementById("map"), myOptions);


    var image = 'images/marker.png';

    //Create markers to add
    var marker = new google.maps.Marker({
        position: new google.maps.LatLng(-34, 150),
        map: map,
        icon: image
    });

    var marker2 = new google.maps.Marker({
        position: new google.maps.LatLng(-34.5, 151),
        map: map,
        icon: image
    });


    var marker3 = new google.maps.Marker({
        position: new google.maps.LatLng(-34.9, 148),
        map: map,
        icon: image
    });


    //Markers Click event. Create infobox and config for the tooltip
    google.maps.event.addListener(marker, "click", function(e) {

      var configtooltip = {
        position: "tiptop",
        content: "Map example marker with icon",
        maxwidth: "200",
        theme: "tipthemeblue",
        icon:"fa fa-refresh fa-spin",
        event: "click",
        eventout: "click",
        followcursor: false,
        delay: 500,
        animation:"swingX",
        animationout:"swingYclose"
      }

      var infoBox = new InfoBox({latlng: marker.getPosition(), map: map, tooltip: configtooltip});

    });

    google.maps.event.addListener(marker2, "click", function(e) {

      var configtooltip2 = {
        position: "tipright",
        content: "<iframe src='//player.vimeo.com/video/7449107?&autoplay=1' width='265' height='200' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>",
        theme: "tipthemeblue",
        event: "click",
        eventout: "click",
        followcursor: false,
        delay: 500,
        animation:"glow",
        animationout:"swingYclose",
      }

      var infoBox2 = new InfoBox({latlng: marker2.getPosition(), map: map, tooltip: configtooltip2 });
    });

    google.maps.event.addListener(marker3, "click", function(e) {

      var configtooltip3 = {
        position: "tiptop",
        content: "<iframe width='300' height='200' frameborder='0' scrolling='no' marginheight='0' marginwidth='0' src='https://maps.google.es/?ie=UTF8&ll=31.052934,-27.070312&spn=138.197665,346.289063&t=m&z=1&output=embed'></iframe>",
        theme: "tipthemepurple",
        event: "click",
        eventout: "click",
        followcursor: false,
        delay: 500,
        animation:"swingZ",
        animationout:"swingZclose",
      }

      var infoBox3 = new InfoBox({latlng: marker3.getPosition(), map: map, tooltip:configtooltip3});
    });

    //--------------------------end-----------------------


    //----------Comic------------------------------------

    var cont = 0,time=-1000;
	var tp1,tp2,tp3;

 	var conversation1 = [
    ['<p class="specialcomic">I need a tooltip plugin, but...</p>'],
    ['<p class="specialcomic">All look the same!! </p>'],
    ['<p class="specialcomic">My web needs creativity, SEO, <br/>simplicity and usability...</p>'],
    ['<p class="specialcomic">Where I´m going to find something like that?!</p>']
 	];

 	var conversation2 = [
    ['<p class="specialcomic">Hi Jenny, I´m looking for a tooltip plugin</p>','<p class="specialcomic">Do you know jqeasytooltip?</p>'],
    ['<p class="specialcomic">No</p>','<p class="specialcomic">It is a versatile and easy to use plugin,<br/> you have to try it</p>'],
    ['<p class="specialcomic">Where do i buy it?</p>','<p class="specialcomic">Only 8$ in codecanyon</p>'],
    ['<p class="specialcomic">Whow!! </p>','<p class="specialcomic"> Yeah!</p>']
 	];

 	var conversation3 = [
    ['<p class="specialcomic">Even you can use it to create a comic</p>'],
    ['<p class="specialcomic">Try it on your own</p>']
 	];

    $(".comic img").jqeasytooltip('init',{
        followcursor:false,
        animation:"tipopen",
        animationout:"tipclose",
        theme:"tipthemewhite",
        open:function(){

        	var t = $(this).jqeasytooltip('get','tip');


			if(($(this).data("tipcontent")=="")||( $(this).html()=="" )){
				$(t).hide();
			 }
		}
	});


    $(".comic").off("mouseenter").on("mouseenter",function(e){


    	$comic = $(this);
    	clearComic();
    	$(".comic").not($(this)).addClass("grayscale");
    	var conversation = eval("conversation" + $(".comic").index($comic));

    	if($(this).attr("id")=="endComic"){
    		return;
    	}

        (function initComic() {

            $comic.find("img").jqeasytooltip('close');

            time =0;
            var images = [];


            $comic.find("img").each(function(){

                if($(this).data("timeout")!=undefined)
                    clearTimeout($(this).data("timeout"));

                time += 1500;
                $this = $(this);

                var converText;

                try
                {
                    converText = conversation[cont][$comic.find("img").index($this)];
                }catch(err){
                    // $('html, body').animate({
                    //     scrollTop: $comic.offset().top+350
                    // }, 2000);

                    clearTimeout(tp3);
                    return;
                }

                seTooltip($this,time,converText);

            });
            cont+=1;


            tp3 = setTimeout(initComic, 5000);
        })();



    });

	function seTooltip(element,time,converText){
		var tp = setTimeout(function(){
					$(element).jqeasytooltip('open',{
						content: converText,
						open: function(){
							var t = $(this).jqeasytooltip('get','tip');
							$(t).show();
						}
					});

		},time);
		$(element).data("time", time);
		$(element).data("timeout", tp);
	}

	function clearComic(){
		cont = 0;
    	time = 0;
        console.log(tp3);
    	clearTimeout(tp3);
        $(".comic img").each(function(){
            clearTimeout($(this).data("timeout"));
        });
    	//clearTimeout($(".comic img").data("timeout"));
    	$(".comic img").jqeasytooltip('close');
    	$(".comic").removeClass("grayscale");
	}

    $(".comic").off("mouseleave").on("mouseleave",function(e){
        // console.log("e.target");
        // console.log(e.target);
        //  console.log("$(.tipopen)");
        //  console.log($comic);
    	//if ($(e.target).attr("id")!=$comic.attr("id")) clearComic();
        clearComic();
    });


    //----------end--------------------------------------


});