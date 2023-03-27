type handledResult<'t> =
    | Ok('t)
    | Error(string)

let toResult = (x) => Ok(x)

let toError = (s: string) => Error(s)

let bindResult = (x: ('a) => 'b, r: handledResult<'a>) => {
    try {
        switch r {
        | Ok(n) => Ok(x(n))
        | Error(s) => Error(s)  
        }
    } catch {
        | Js.Exn.Error(obj) =>
            switch Js.Exn.message(obj) {
            | Some(m) => Error(m)
            | None => Error("Undefined error")
            }
    }
}

let someResult = (x: ('a) => 'b, o: option<'a>) => {
    try {
        switch o {
        | Some(n) => Ok(x(n))
        | None => Error("None")  
        }
    } catch {
        | Js.Exn.Error(obj) =>
            switch Js.Exn.message(obj) {
            | Some(m) => Error(m)
            | None => Error("Undefined error")
            }
    }
}
