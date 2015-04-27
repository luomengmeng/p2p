$(function (){
	 //   $('a.title').eq(0).next('div').css({'display':'block'});
	 $('.visiteds').parent().show();
	 $('a.title').each(function(index, element) {
	 	$(this).click(function (){
	 		$(this).next('div').slideToggle('slow');
	 	});
	 });

	 $('.tongtit div').eq(0).addClass('xshi');
	 $('.tongtit div').each(function(index, element) {
	 	$('.contents').eq(0).css("display","block");
	 	$(this).click(function (){
	 		$('.tongtit div').removeClass('xshi');
	 		$('.tongtit div').eq(index).addClass('xshi');
	 		$('.contents').hide('slow');
	 		$('.contents').eq(index).show('slow');
	 	});
	 });
	 $('.xiaoxi li div').eq(0).css('display','block');
	 $('.contents').each(function(){
	 	$(this).find('.xiaoxi li').eq(0).css('color','#ff6766');
	 	$(this).find('.xiaoxi li').eq(0).find('div').css('display','block');
	 });
	 $('.xiaoxi li .display_nb').each(function (i){
	 	$(this).click(function (){
	 		$('.xiaoxi li div').hide();
	 		$('.xiaoxi li').css({"color":"#4cadda"});
	 		$(this).parent().css({"color":"#ff6766"});
	 		$(this).parent().find('div').css({"display":"block"});
	 	});
	 });
	 $('.xiaoxi li div .right').click(function (){
	 	$(this).parent().css({'display':'none'});
	 	$(this).parents('li').css({"color":"#4cadda"});
	 });
	 sjrzyz=function (a,b){
	 	if(b==undefined){
	 		b="^1{1}(3|5|8){1}[0-9]{9}$";
	 	}else{
	 		b=b;
	 	};
	 	var telval=$(a).val();
	 	var patt=new RegExp(b,"g");
	 	var booltel=patt.test(telval);
	 	if(booltel==false){
	 		alert('请您填写正确的手机号码。');
	 		$(a).css({'border':'1px solid red'});
	 		$(a).val('');
	 		return false;
	 	}else{
	 		$(a).css({'border':'1px solid #ccc'});	
	 	}
	 }
	 $('.sjyzforms .tel').blur(function (){
	 	sjrzyz('.sjyzform .tel');
	 });
	 $('form.sjyzforms').submit(function (){
	 	if($('.sjyzform .tel').val()==''){
	 		$('.sjyzform .tel').css({'border':'1px solid red'});
	 		return false;
	 	}
	 	sjrzyz('.sjyzform .tel');
	 });
	 $('.grzlform input.grzlsj').blur(function (){
	 	grzlsjzhi=$('input.grzlsj').val();
	 	var sjyz=/^1{1}(3|5|8){1}[0-9]{9}$/.test(grzlsjzhi);
	 	if(!sjyz){
	 		alert('请填写正确的手机号码。');
	 		$('input.grzlsj').val('');
				//$('input.grzlsj').focus();
				$('input.grzlsj').css({'border':'1px solid red'}); 
				return false;
			}else{
				$('input.grzlsj').css({'border':'1px solid #ccc'}); 
			}
		});
	 $('.grzlform input.grzldh').blur(function (){
	 	grzldhzhi=$('input.grzldh').val();
	 	var dhyz=/^0\d{2,3}-?\d{7,8}$/.test(grzldhzhi);
	 	if(!dhyz){
	 		alert('请填写正确的电话号码。'); 
	 		$('input.grzldh').val('');
				//$('input.grzldh').focus();
				$('input.grzldh').css({'border':'1px solid red'});
				return false; 
			}else{
				$('input.grzldh').css({'border':'1px solid #ccc'}); 
			}
		});
	 $('form.grzlform').submit(function (){
	 	$('.grzlform input').each(function (i,e){
	 		if($(this).val()==''){
	 			alert('请填写完整，谢谢。');
	 			return false;
	 		}
	 	});
	 });
	 $('.fileup').hide();		
	 $('.touxiangd').click(function (){
	 	$('.modals').css('display','block');
	 	$('.hqyzmers').click(function (){
	 		$('input.fileup').trigger('click');	   
	 	});
	 });
	 $('.hqyzreset').click(function (){
	 	$('input.fileup').val('');
	 	$('.modals').css('display','none');
	 	return false;
	 });
	 $('.hqyzm').click(function (){
	 	$('.modals').css('display','none');
	 });
	 $('.touzilist .title .right').click(function (){
	 	$('.touzilist .lister').slideToggle();
	 });

	 $('.txxqtabcon').css({"display":"none"});
	 $('.txxqtabcon').eq(0).css({"display":"block"});
	 $('.txxqtab a').each(function (i,e){
	 	$('.txxqtab a').eq(0).css({"color":"#000","borderBottom":"2px solid #ff6666"});
	 	$(this).click(function (){
	 		$('.txxqtab a').css({"color":"#9c9d9d","borderBottom":"0"});
	 		$(this).css({"color":"#000","borderBottom":"2px solid #ff6666"});
	 		$('.txxqtabcon').css({"display":"none"});
	 		$('.txxqtabcon').eq(i).css('display','block');
	 	});
	 });

	 $('.alert .close').click(function(){
	 	 $(this).parent().hide();
	 })

	});

