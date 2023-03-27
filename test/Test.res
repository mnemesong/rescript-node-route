let printReqFunction: Router.requestHandlerFunc = 
    %raw(`(req) => ({code: 200, headers: [], answer: req.method})`)

let routes: array<Router.route> =
    [ { methods: [#get, #patch]
      , urls: ["/"]
      , handler: printReqFunction
      }
    ]

Router.createHttpServer(routes, 80, %raw("() => {console.log('start')}"))