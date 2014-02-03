
function buildURL (link)
{
	// get current href value
	var current = link.getAttribute('href');
	
	// get values of all checkboxes on page
	var cbs = $("input:checkbox");
	
		// get values of lang radio button
	var lang = $('input:radio[name=lang]:checked').val();
	
	if (current.indexOf('&lang=') == -1)
	{
		//if it is checked and not in the current request param list then it will be need to be added
			current = current + '&lang=' + lang;
	}
	else if(current.indexOf('&lang='+lang) == -1)
	{
		var param = current.match('/lang=(de|en|all)/');
		current = current.replace(param, '&lang='+lang);
	}

	
	for (var i=0; i<cbs.length; i++)
	{	
	// foreach checkbox on the page
	
		var box_name = cbs[i].getAttribute('name');
		
		
		
		if (cbs[i].checked == true && current.indexOf(box_name) == -1)
		{
		//if it is checked and not in the current request param list then it will be need to be added
			current = current + '&' + box_name + '=1';
		}
		else if (cbs[i].checked == false && current.indexOf(box_name) != -1)
		{
			//if it is unchecked and but listed as checked in the request param list then it will need to be removed
			//
			var old = '&' + box_name + '=1';
			
			current = current.replace(old, '');
			//alert(old + '\n' + current);
		}
	}
		
	// set new href value 	
	link.setAttribute('href', current);

}

function validate()
{
	var paramstring = location.search.substr(1);
	var params = paramstring.split("&");
	
	for(var i = 0; i < params.length; i++)
	{
		if(params[i].indexOf('=1') != -1 && params[i].indexOf('p=') != -1)
		{
			//alert('Document in string: ' + paramstring);
			return true;
		}
	}
	
	var cbs = $("input[type=checkbox]:checked").length;
	
	if(cbs > 0)
	{
		//alert('Checkbox checked: ' + cbs);
		return true;
	}
	else
	{
		alert('At least one document must be selected.');
		return false;
	}
	
	console.log('error in sdo.js');
	
}