// xMod 1.3 JS Library: Configuration
// This file can be edited

$("document").ready(function () {
  $(function () {
    var tabContainers = $('div.tabs > div');
    tabContainers.hide().filter(':first').show();
    
    $('div.tabs ul.tabNavigation a').click(function () {
      tabContainers.hide();
      tabContainers.filter(this.hash).show();
      $('div.tabs ul.tabNavigation a').removeClass('selected');
      $(this).addClass('selected');
      return false;
    }).filter(':first').click();
  });
  
  
$("a.x87").fancybox();
               
 /* Using custom settings */
               
      $("a#inline").fancybox({
        'hideOnContentClick': true
    });
               
               /* Apply fancybox to multiple items */
               
      $("a.group").fancybox({
               'transitionIn'	:	'elastic',
               'transitionOut'	:	'elastic',
               'speedIn'		:	600, 
               'speedOut'		:	200, 
               'overlayShow'	:	false
               });
               
  
});



$("html").addClass("js");

$(function () {
  if ($('#acc3').length) {
    $.fn.accordion.defaults.container = false;
    $("#acc3").accordion({
      initShow: "#current"
    });
    $("#acc1").accordion({
      el: ".h",
      head: "h4, h5",
      next: "div",
      initShow: "div.outer:eq(1)"
    });
    $("#acc2").accordion({
      obj: "div",
      wrapper: "div",
      el: ".h",
      head: "h4, h5",
      next: "div",
      initShow: "div.shown"
    });
    
    
    $("html").removeClass("js");
    //$(".erased2").css("display", "none");
  }
  
  
	$('.monthList td').each(
		function(i, val1)
		{
			$monthCell = $(val1);
			var dateBits = $monthCell.attr("id").split('-');
			var divId = "datepicker" + dateBits[0] + dateBits[1];
			var lastDay = new Date((new Date(dateBits[0], dateBits[1],1))-1).getDate();
			
			$( "#" + divId )
				.datepicker(
					{
						dateFormat: 'yy-mm-dd',
						changeMonth: false,
    					changeYear: false,
						minDate: dateBits[0] + "-" + dateBits[1] + "-01",
						maxDate: dateBits[0] + "-" + dateBits[1] + "-" + lastDay,
						hideIfNoPrevNext: true,
						onSelect: function(date, inst) 
						   {
								//Date.format = "yyyy-mm-dd",
								
								window.location = "../../profiles/date/" + date + ".html"
								//alert($(inst).toString())
						   },
						beforeShowDay: function(date)
						   {
						   		currentMonth = getFormattedDate(date, false)
						   		var today = date.getDate()
						   		if(today < 10)
						   		{
						   			today = "0" + today
						   		}
						   		
						   		var daysList = $("#" + currentMonth).attr("days")
						   		if(daysList !== undefined)
						   		{						   		
									var days = daysList.split(',');
									
									for(day = 0; day < days.length; day++)
									{
										var dayBits = days[day].split(":")
										
										if(dayBits[0] == today)
										{
											if(dayBits[1] > 1)
											{
												return [true, 'm_items', dayBits[1] + " items"]
											}
											else
											{
												return [true, 'one_item', dayBits[1] + " item"]
											}
										}
										
									}
								}
						   		
						   		return [false, 'no_items', '']
						   },
						hide: true
					}	
				).hide();
				
				$monthCell
					.click(
						function() 
						{
							$("span[id^='datepicker']").each
							(
								function(j, val2)
								{
									if($(val2).attr("id") != divId)
									{
										$(val2).datepicker().hide()
									}
									else
									{
										$("#" + divId).toggle()	
									}
								}			
							)
										
      					});
      
		}
	)  
  
});

function show(a) {
  if (a.childNodes[0].style.display == "inline") {
    a.childNodes[0].style.display = "none"
  } else {
    a.childNodes[0].style.display = "inline"
  }
}


$(function () {
  if ($('.accordion2').length) {
    $('.accordion2').accordion({
      autoHeight: false,
      collapsible: true
    });
  }
});


function getFormattedDate(date)
{
	year = date.getFullYear()
	month = date.getMonth() + 1
	if(month < 10)
	{
		month = "0" + month
	}
	
	return year + "-" + month
};




















