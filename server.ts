import { readFileSync } from 'fs';
import {} from 'uuid';  // trigger perry-stdlib linking (needed for HTTP server symbols)

declare function js_http_server_create(port: number): number;
declare function js_http_server_accept_v2(server: number): number;
declare function js_http_request_method(req: number): string;
declare function js_http_request_path(req: number): string;
declare function js_http_respond_html(req: number, status: number, body: string): boolean;
declare function js_http_respond_not_found(req: number): boolean;

const PORT = 3000;
const html = readFileSync('./index.html', 'utf8');

const server = js_http_server_create(PORT);
console.log(`Hone landing server running at http://localhost:${PORT}`);

while (true) {
  const req = js_http_server_accept_v2(server);

  if (req < 0) {
    console.log('Server error');
    break;
  }

  const method = js_http_request_method(req);
  const path = js_http_request_path(req);

  console.log(`${method} ${path}`);

  if (method === 'GET' && (path === '/' || path === '/index.html')) {
    js_http_respond_html(req, 200, html);
  } else {
    js_http_respond_not_found(req);
  }
}
