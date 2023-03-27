let printReqFunction: Router.requestHandlerFunc = 
    %raw(`(req) => ({code: 200, headers: [], answer: req.method})`)

let routes: array<Router.route> =
    [ { methods: [#get, #patch]
      , urls: ["/"]
      , handler: printReqFunction
      }
    , { methods: [#get]
      , urls: ["/hello"]
      , handler: (req) => {code: 200, headers: {"Content-Type": "text/plain"}, answer: "Hello!"}
      }
    ]

let unhandlingRequestHandler: Router.unhandlingRequestHandlerFunc =
    (req) => { code: 500, headers: {"Content-Type": "text/plain"}, answer: "Страницы не существует!"}

Router.createHttpServer(
    routes, 
    unhandlingRequestHandler, 
    80, 
    %raw("() => {console.log('start')}")
)