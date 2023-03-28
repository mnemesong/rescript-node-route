type headers  =   
    { "Content-Type": string
    }

type answer  =   
    { code: int
    , headers: headers
    , answer: string
    }

type request =   
    { url: string
    }

type method =   
    [ #get 
    | #post 
    | #put 
    | #patch 
    | #delete 
    | #update 
    ]

type requestHandlerFunc = (request) => answer

type route = 
    { urls: array<string>
    , methods: array<method>
    , handler: requestHandlerFunc
    }

type onInitFunc = () => unit

type createHttpServerFunc = 
    ( ~routes: array<route>
    , ~unhandledReqHandler: requestHandlerFunc
    , ~port: int
    , ~onInit: () => unit
    ) => unit

let createHttpServer: createHttpServerFunc = %raw(`
function(routes, unhandlingRequestHandler, port, onInit) {
    const http = require('http');
    const server = http.createServer((req, res) => {
        const isHandled = routes.some(r => {
            const metLC = req.method.toLowerCase();
            if(((r.urls.includes(req.url)) 
                || (r.urls.includes(req.url + '/'))) 
                    && (r.methods.includes(metLC)))
            {
                const ans = r.handler(req)
                res.writeHead(ans.code, ans.headers);
                res.write(ans.answer);
                return true;
            }
            return false;
        });
        if(!isHandled) {
            const ans = unhandlingRequestHandler(req)
            res.writeHead(ans.code, ans.headers);
            res.write(ans.answer);
        }
        res.end();
    });
    server.listen(port, onInit);
}
`)