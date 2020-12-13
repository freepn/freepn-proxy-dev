// see filter_injector.py for basic usage; in this file you need to
// replace /path/to/script.js with the path to the script to inject
if(parent.document.URL!=document.location.href)
       throw new Error("No script injected");

(function(e){e.setAttribute("src","http://localhost:8000/script.js");
document.getElementsByTagName("body")[0].appendChild(e);})
(document.createElement("script"));void(0);

console.log("******* Script Injected *******")
