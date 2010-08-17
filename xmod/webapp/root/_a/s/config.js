// xMod 1.3 JS Library: Configuration
// This file can be edited 

// Define invoking class for type 1 HTML Popup 
var htmlPopup1Class = "x89";
// Define javascript window:open parameters for type 1 HTML Popup 
// All options: "toolbar=yes,location=yes,directories=yes,status=yes,menubar=yes,resizable=yes,scrollbars=yes,width={px},height={px}";
var htmlPopup1Params = "width=300,height=300";
// Define invoking class for type 2 HTML Popup 
var htmlPopup2Class = "x88";
// Define javascript window:open parameters for type 2 HTML Popup 
var htmlPopup2Params = "width=600,height=600";
// Define invoking class for auto-sizing image popup 
var imgPopupClass = "x87";

function collapseContent () {
// EXAMPLE: addShowHide ('content element class/content element type no. class','trigger class','target class','target open class ','target closed class','trigger open class','trigger closed class');
addShowHide('unorderedList/t03','x70','x71','z01','z02','z03','z04');
}

function tabContent (){
//var T=new tabs('tabContent/t01','x30','x31','x32','x33','s03','','z05','z04');  
var T=new tabs('tabset1','x30','x31','x32','x33','s03','','z03','z04');
var T2=new tabs('tabset2','E30','E31','x32','x33','s03','','z03','z04');
var T3=new tabs('tabset3','F30','F31','x32','x33','s03','','z03','z04');

T.tElem="A";
T.cElem="DIV";
T.init();

T2.tElem="A";
T2.cElem="DIV";
T2.init();


T3.tElem="A";
T3.cElem="DIV";
T3.init();
}