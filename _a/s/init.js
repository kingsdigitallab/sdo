// xMod 1.3 JS Library: Initialisation
// This file should NOT be edited: copy it into your personality pack and edit it there.
//
// The default file loads two functions which work on every xMod 1.3 site.  The other functions
// will throw an error if they are called on pages where there are no tabs or collapsible content
// so don't use them unless you know you need to.


// ZA added
function generateUrl(path, number) {
	if (number.length > 2 && number.length < 9) {
	  var dotPos = number.indexOf(".");
	  
		var city = number.substring(0, dotPos);
		var uppercity = city.toUpperCase();
		var inscriptnum = number.substring(dotPos + 1) * 100;
		var inscription = padLeft(inscriptnum.toString(), '0', 5);
		
		//location.href = path + '/' + uppercity + inscription + '.html';
		location.href = path + '/' + uppercity + inscription + '.html';
	}
}

function padLeft(str, pad, len) {
while(str.length < len) {
str = "" + pad + str;
}

return str;
}
// end ZA added


window.onload = function() {
externalLinks();
popupManager();

// Enable the following functions ONLY if they're needed: copy this file into the local 
// personality pack and make sure it's loaded in from there.  
// Note that collapseContent() and tabContent() REQUIRE entries in the config.js file, which should
// also be moved into the PPack and loaded in here.

collapseContent();
tabContent();

}