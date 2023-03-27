type answer<'headers> = {
    code: int,
    headers: 'headers,
    answer: string
}

type method = [ #get | # post | #put | #patch | #delete | #update ]

type answerFunc<'t, 'headers> = ('t) => answer<'headers>

type route<'headers> = {
    urls: array<string>,
    methods: array<method>,
    answer: answer<'headers>,
}

type port = int

type onInitFunc = () => unit

type createHttpServerFunc<'headers> = (array<route<'headers>>, port, onInitFunc) => unit

type onlyContentTypeHeader = {"Content-Type": string}

let answerPlainText: answerFunc<string, onlyContentTypeHeader> 
    = (text: string) => {
        code: 200,
        headers: {
            "Content-Type": "text/plain"
        },
        answer: text,
    }

let answerHtml: answerFunc<string, onlyContentTypeHeader> 
    = (html: string) => {
        code: 200,
        headers: {
            "Content-Type": "text/html"
        },
        answer: html,
    }
    
let answerAnyJson: answerFunc<'t, onlyContentTypeHeader>
    = (obj: 't) => {
        let str = Js.Json.stringifyAny(obj)
        Js.Option.isNone(str)
        ? {
            code: 500,
            headers: {
                "Content-Type": "application/json"
            },
            answer: "{'error': 'Json parse error'}",
        }
        : {
            code: 200,
            headers: {
                "Content-Type": "application/json"
            },
            answer: Js.Option.getExn(str)
        }
    }

let answerTextJson: answerFunc<string, onlyContentTypeHeader>
    = (jsonText) => {
        code: 200,
        headers: {
            "Content-Type": "application/json"
        },
        answer: jsonText,
    }

let answerTextCss: answerFunc<string, onlyContentTypeHeader>
    = (cssContent: string) => {
        code: 200,
        headers: {
            "Content-Type": "text/css"
        },
        answer: cssContent,
    }

let answerTextJs: answerFunc<string, onlyContentTypeHeader>
    = (jsContent: string) => {
        code: 200,
        headers: {
            "Content-Type": "text/js"
        },
        answer: jsContent,
    }

let createHttpServer: createHttpServerFunc<'headers> = %raw(`
function(routes, port, onInit) {
    const http = require('http');
    const server = http.createServer((req, res) => {
        routes.some(r => {
            const metLC = req.method.toLowerCase();
            if((r.urls.includes(req.url)) 
                || (r.urls.includes(req.url + '/')) 
                || (r.methods.includes(metLC))) 
            {
                res.writeHead(r.answer.code, r.answer.headers);
                res.write(r.answer.answer);
                return true;
            }
            return false;
        });
        res.end();
    });
    server.listen(port, onInit);
}
`)