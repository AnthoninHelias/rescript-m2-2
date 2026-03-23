@react.component
let make = (~nom: string, ~setNom: (string => string) => unit) => {
  let (password, setPassword) = React.useState(() => "")

  open Connection_bdd

  let handleLogin = async _ => {
    let ok = await login(nom, password)
    if ok {
      RescriptReactRouter.push("/app")
    } else {
      Console.log("Identifiant ou mot de passe incorrect.")
    }
  }

  <div>
    <header className="header-1">
      <h1 className="large-title"> {React.string("Page de connexion")} </h1>
    </header>
    <div className="div-2">
      <input
        className="input-1"
        type_="text"
        placeholder="Entrez votre nom"
        value={nom}
        onChange={e => {
          let value = (e->ReactEvent.Form.target)["value"]
          setNom(_ => value)
        }}
      />
      <input
        className="input-1"
        type_="password"
        placeholder="Entrez votre mot de passe"
        value={password}
        onChange={e => {
          let value = (e->ReactEvent.Form.target)["value"]
          setPassword(_ => value)
        }}
      />
      <button
        className="button-1"
        onClick={e => handleLogin(e)->ignore}
      >
        {React.string("Se connecter")}
      </button>
    </div>
  </div>
}
