var windowdimensions = getViewportSize();
ChanePicture();
$(window).resize(function(event) {
	windowdimensions = getViewportSize();
	ChanePicture();
});
function ChanePicture(){
	$('picture').each(function(){
		var responsivecuts = new Array();
		var currentimg;
		var i = 0;
		$(this).find('source').each(function(){
			responsivecuts[i] = parseInt($(this).attr('media').replace(/[^\d.]/g,''));
			if(responsivecuts[i]<=windowdimensions.width){
				currentimg = $(this).attr('src');
				$('#log').html(responsivecuts[i]+'-'+windowdimensions.width)
			}
			i++;
		})
		$(this).find('img').attr('src',currentimg)
	});
}
function getViewportSize(){
    var elmt = window,
        prop = 'inner';

    if (!('innerWidth' in window)){
        elmt = document.documentElement || document.body;
        prop = 'client';
    }
    return {
        width: parseInt(elmt[prop + 'Width' ]),
        height: parseInt(elmt[prop + 'Height'])
    };
}
