let printReqFunction: Http.requestHandlerFunc = 
    %raw(`(req) => ({code: 200, headers: [], answer: req.method})`)

let routes: array<Http.route> =
    [ { methods: [#get, #patch]
      , urls: ["/"]
      , handler: printReqFunction
      }
    , { methods: [#get]
      , urls: ["/hello"]
      , handler: (req) => {code: 200, headers: {"Content-Type": "text/plain"}, answer: "Hello!"}
      }
    ]

let unhandlingRequestHandler: Http.unhandlingRequestHandlerFunc =
    (req) => { code: 500, headers: {"Content-Type": "text/plain"}, answer: "Страницы не существует!"}

Http.createHttpServer(
    routes, 
    unhandlingRequestHandler, 
    80, 
    %raw("() => {console.log('start')}")
)