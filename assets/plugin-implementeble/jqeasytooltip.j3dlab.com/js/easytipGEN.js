
$(document).ready(function(){
	$('#tipgenerator').click(function(event) {

		$('#tipgeneratorresult strong, #tipgeneratorresult img').jqeasytooltip('destroy');
		$('#tipgeneratorresult ,#tipgeneratorcode').hide();
		$('#tipgeneratorresult').empty();
		$('#tipgeneratorcode .pcode').empty();

		var datatipcontent		= $("#datatipcontent").val();
		var datatipposition		= $("#datatipposition").val();
		var datatiptagcontent	= $("#datatiptagcontent").val();
		var datatipmaxwidth		= $("#datatipmaxwidth").val();
		var datatiptheme		= $("#datatiptheme").val();
		var datatipevent		= $("#datatipevent").val();
		var datatipeventout		= $("#datatipeventout").val();
		var datatipanimation	= $("#datatipanimation").val();
		var datatipanimationout	= $("#datatipanimationout").val();
		var datatipicon			= $("#datatipicon").val();
		var datatipfollowcursor	= $("#datatipfollowcursor").val();

		var datatipminmargin	= $("#datatipminmargin").val();
		var datatipmouseleave	= $("#datatipmouseleave").val();

		datatipcontent = datatipcontent.replace(/"/g,"'");
		if(datatipcontent.length>0){ datatipcontent = 'data-tipcontent="'+datatipcontent+'"' }else{datatipcontent = ""};
		// if(datatiptagcontent.length>0){
		// 	datatiptagcontent = 'data-tiptagcontent="'+datatiptagcontent+'"';
		// 	datatipcontent = '';
		// };

		if(datatiptheme.length>0){ datatiptheme = 'data-tiptheme="'+datatiptheme+'" ' }else{datatiptheme = ""};
		if(datatipposition.length>0){datatipposition = 'data-tipposition="'+datatipposition+'" '}else{datatipposition = ""};
		if(datatipevent.length>0){datatipevent = 'data-tipevent ="'+datatipevent+'" '}else{datatipevent = ""};
		if(datatipeventout.length>0){datatipeventout = 'data-tipeventout ="'+datatipeventout+'" '}else{datatipeventout = ""};
		if(datatipanimation.length>0){datatipanimation = 'data-tipanimation ="'+datatipanimation+'" '}else{datatipanimation = ""};
		if(datatipanimationout.length>0){datatipanimationout = 'data-tipanimationout ="'+datatipanimationout+'" '}else{datatipanimationout = ""};
		if(datatipfollowcursor.length>0){datatipfollowcursor = 'data-tipfollowcursor ="'+datatipfollowcursor+'" '}else{datatipfollowcursor = ""};
		// if(datatiptagcontent.length>0){ datatiptagcontent = 'data-tiptagcontent="'+datatiptagcontent+'" '; datatipcontent = 'data-tiptagcontent="Paste it on our proyect <br/> to run easy tip."'; }else{datatiptagcontent = ""};
		if(datatipicon.length>0){ datatipicon = 'data-tipicon="'+datatipicon+'" ' }else{datatipicon = ""};
		if(datatipmaxwidth.length>0){ datatipmaxwidth = 'data-tipmaxwidth="'+datatipmaxwidth+'" ' }else{datatipmaxwidth = ""};

		if(datatipminmargin.length>0){ datatipminmargin = 'data-tipminmargin="'+datatipminmargin+'" ' }else{datatipminmargin = ""};
		if(datatipmouseleave.length>0){ datatipmouseleave = 'data-tipmouseleave="'+datatipmouseleave+'" ' }else{datatipmouseleave = ""};

		/*Append examples*/
		var strongexample = '<strong class="jqeasytooltip" '+datatipcontent+datatiptheme+datatipposition+datatipevent+datatipeventout+datatipanimation+datatipanimationout+datatipfollowcursor+datatipicon+datatipmaxwidth+datatipminmargin+datatipmouseleave+'>Your custom jqEasytooltip</strong>'
		var imgexample = '<img class="jqeasytooltip" src="images/sampleimages/34.jpg" '+datatipcontent+datatiptheme+datatipposition+datatipevent+datatipeventout+datatipanimation+datatipanimationout+datatipfollowcursor+datatipicon+datatipmaxwidth+datatipminmargin+datatipmouseleave+ ' />'


		$('#tipgeneratorresult').append(strongexample +  imgexample);


		strongexample = strongexample.replace(/</g,"&lt;");
		imgexample = imgexample.replace(/</g,"&lt;");
		strongexample = strongexample.replace(/>/g,"&gt;");
		imgexample = imgexample.replace(/>/g,"&gt;");
		/*Create shortcodes*/
		$('#tipgeneratorcode .pcode#code1').append('<div class="MRG_Bx2">'+strongexample+'</div>');
		$('#tipgeneratorcode .pcode#code2').append('<div>'+imgexample+'</div>');

		/*inizialice new easy tips*/
		$('#tipgeneratorresult strong, #tipgeneratorresult img').jqeasytooltip();

		/*Show tips*/
		$('#tipgeneratorresult , #tipgeneratorcode').slideDown();
	});
});
