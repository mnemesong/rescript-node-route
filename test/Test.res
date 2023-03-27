Router.createHttpServer(
    [
        {
            methods: [#get],
            urls: ["/", "/hello"],
            answer: Router.answerPlainText("Hello!")
        }
    ],
    80,
    %raw("() => {}")
)