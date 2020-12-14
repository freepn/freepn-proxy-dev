# -*- coding: utf-8 -*-
#
# Usage: mitmdump -s filter_injector.py --set filterurl=<url_path_filter.js>
# (this script works best with --anticache)

import typing
from mitmproxy import ctx, http

from bs4 import BeautifulSoup


class jsInjector():

    def load(self, loader):
        loader.add_option(
            name='filterurl',
            typespec=typing.Optional[str],
            default='',
            help='url path to filter.js (required)'
        )

    def response(self, flow: http.HTTPFlow) -> None:
        if flow.request.host in ctx.options.filterurl:
            return
        # Only process 200 responses of HTML content.
        response_content_type = flow.response.headers.get('content-type')
        if not response_content_type == 'text/html':
            return
        if not flow.response.status_code == 200:
            return
        #flow.response.headers.pop('Strict-Transport-Security', None)
        #flow.response.headers.pop('Content-Security-Policy', None)
        orig_encoding = flow.response.headers.get("content-encoding")
        if orig_encoding:
            ctx.log.info('Got content encoding: {}'.format(orig_encoding))

        html = BeautifulSoup(flow.response.text, 'lxml')

        if html.body:
            script = html.new_tag(
                'script',
                type='text/javascript',
                src=ctx.options.filterurl)
            html.body.insert(0, script)
            flow.response.text = str(html)
            ctx.log.info('Filter URL {} has been injected!'.format(ctx.options.filterurl))

addons = [jsInjector()]
