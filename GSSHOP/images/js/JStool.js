function MyAppGetHTMLElementsAtPoint(x,y) {
	var tags = "";
	var e = document.elementFromPoint(x,y);
	while (e) {
		if (e.tagName) {
			tags += e.tagName + ',';
		}
		e = e.parentNode;
	}
    
    
    if(tags.indexOf("FRAME") != -1 ) {
        
        tags ="";
        var e = window.frames.fd.document.elementFromPoint(x,y);
        while (e) {
            if (e.tagName) {
                tags += e.tagName + ',';
            }
            e = e.parentNode;
        }
         
        
    } 
     
	return tags;
}

function MyAppGetLinkSRCAtPoint(x,y) {
    
    
    
    var tags = "";
	var e = document.elementFromPoint(x,y);
	while (e) {
		if (e.tagName) {
			tags += e.tagName + ',';
		}
		e = e.parentNode;
	}
    
    
    if(tags.indexOf("FRAME") != -1 ) {
        
        tags ="";
        
        var e = window.frames.fd.document.elementFromPoint(x,y);
        while (e) {
            if (e.src) {
                tags += e.src;
                break;
            }
            e = e.parentNode;
        }
        
        
    }
    else {
        tags ="";
        
        var e = document.elementFromPoint(x,y);
        while (e) {
            if (e.src) {
                tags += e.src;
                break;
            }
            e = e.parentNode;
        }
        
        
    }
    
	return tags;
    
    
    
    
    
}

function MyAppGetLinkHREFAtPoint(x,y) {
	var tags = "";
	var e = document.elementFromPoint(x,y);
	while (e) {
		if (e.href) {
			tags += e.href;
			break;
		}
		e = e.parentNode;
	}
	return tags;
}
