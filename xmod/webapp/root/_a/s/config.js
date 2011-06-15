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
    $(".erased2").css("display", "none");
  }
});

function show(a) {
  if (a.childNodes[0].style.display == "inline") {
    a.childNodes[0].style.display = "none"
  } else {
    a.childNodes[0].style.display = "inline"
  }
}

$(function () {
  if ($('.accordion').length) {
    $('.accordion').accordion({
      autoHeight: false,
      collapsible: true
    });
  }
});