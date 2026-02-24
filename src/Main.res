%%raw("import './index.css'")

module Router = {
  @react.component
  let make = () => {
    let url = RescriptReactRouter.useUrl()
    
    switch url.path {
    | list{"affichage-bdd"} => <Affichage_bdd questionId={1} />
    | _ => <App />
    }
  }
}

switch ReactDOM.querySelector("#root") {
| Some(domElement) =>
  ReactDOM.Client.createRoot(domElement)->ReactDOM.Client.Root.render(
    <React.StrictMode>
      <Router />
    </React.StrictMode>,
  )
| None => ()
}
