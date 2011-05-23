// xMod 1.3 JS Library: Configuration
// This file can be edited 


$("html").addClass("js");
$.fn.accordion.defaults.container = false; 
$(function() {
  $("#acc3").accordion({initShow : "#current"});
  $("#acc1").accordion({
      el: ".h", 
      head: "h4, h5", 
      next: "div", 
      initShow : "div.outer:eq(1)"
  });
  $("#acc2").accordion({
      obj: "div", 
      wrapper: "div", 
      el: ".h", 
      head: "h4, h5", 
      next: "div", 
      initShow : "div.shown"
    });
  $("html").removeClass("js");
});


function show(a) {
    if (a.childNodes[0].style.display == "inline") {
        a.childNodes[0].style.display = "none"
    } else {
        a.childNodes[0].style.display = "inline"
    }
}