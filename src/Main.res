%%raw("import './index.css'")

module Router = {
  @react.component
  let make = () => {
    let url = RescriptReactRouter.useUrl()
    let (nom, setNom) = React.useState(() => "")

    switch url.path {
    | list{"affichage-bdd"} => <Affichage_bdd questionId={1} nom={nom} setNom={setNom} />
    | _ => <App nom={nom} setNom={setNom} />
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
