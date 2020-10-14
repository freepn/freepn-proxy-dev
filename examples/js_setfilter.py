# Adapted from:
#  http://pankajmalhotra.com/Injecting-Javascript-In-HTML-Content-Using-MITM-Proxy
#
# usage:
#  mitmdump -p 8080 -s "js_setfilter.py http://path/to/filter.js"
#
# (this script works best with --anticache)
from bs4 import BeautifulSoup
from libmproxy.protocol.http import decoded

# On start of proxy server ask for src as an argument
def start(context, argv):
    if len(argv) != 2:
        raise ValueError('Usage: -s "js_setfilter.py src"')
    context.src_url = argv[1]


def response(context, flow):
    with decoded(flow.response):  # Remove content encoding (gzip, ...)
        html = BeautifulSoup(flow.response.content)
        """
        # To Allow CORS
        if "Content-Security-Policy" in flow.response.headers:
            del flow.response.headers["Content-Security-Policy"]
        """
        if html.body and ('text/html' in flow.response.headers["content-type"][0]):
            script = html.new_tag(
                "script",
                src=context.src_url)
            html.body.insert(0, script)
            flow.response.content = str(html)
            context.log("******* Filter Injected *******")
