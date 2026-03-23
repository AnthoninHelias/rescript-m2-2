@react.component
let make = (~nom: string, ~setNom: (string => string) => unit) => {
  let (password, setPassword) = React.useState(() => "")

  let apiBaseUrl = "https://qcm-api-a108ec633b51.herokuapp.com"
  let handleLogin = _ => {
    // Construction de l'URL de connexion
    let url = apiBaseUrl ++ "/login/" ++ nom ++ "/" ++ password

    // Appel API GET pour vérifier les informations de connexion
    Fetch.fetch(url, {method: #GET})
    ->Promise.then(response => {
      if response->Fetch.Response.ok {
        // Redirection vers le questionnaire si ok
        RescriptReactRouter.push("/app")
      } else {
        // Log d'erreur si échec
        Console.log("Identifiant ou mot de passe incorrect.")
      }
      Promise.resolve()
    })
    ->Promise.catch(err => {
      Console.log2("Erreur lors de la tentative de connexion :", err)
      Promise.resolve()
    })
    ->ignore
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
        onClick={_ => {
          let randomId = (Math.random() *. 1000.0)->Int.fromFloat->Int.toString
          let tempPseudo = "Invite_" ++ randomId
          let tempIden = "invite." ++ randomId
          let tempPass = "temp123"

          let payload = {
            "identifiant": tempIden,
            "mot_de_passe": tempPass,
            "pseudo": tempPseudo,
          }

          Fetch.fetch(
            apiBaseUrl ++ "/utilisateurs/create",
            {
              method: #POST,
              headers: Fetch.Headers.fromObject({
                "Content-Type": "application/json",
              }),
              body: Fetch.Body.string(JSON.stringify(Obj.magic(payload))),
            },
          )
          ->Promise.then(response => {
            if response->Fetch.Response.ok {
              let loginUrl = apiBaseUrl ++ "/login/" ++ tempPseudo ++ "/" ++ tempPass
              Fetch.fetch(loginUrl, {method: #GET})->Promise.then(res => {
                if res->Fetch.Response.ok {
                  setNom(_ => tempPseudo)
                  setPassword(_ => tempPass)
                  RescriptReactRouter.push("/app")
                }
                Promise.resolve()
              })
            } else {
              Console.log("Erreur lors de la création de l'utilisateur.")
              Promise.resolve()
            }
          })
          ->Promise.catch(err => {
            Console.log2("Erreur réseau :", err)
            Promise.resolve()
          })
          ->ignore
        }}
      >
        {React.string("Utilisateur temporaire")}
      </button>
      <button className="button-1 bg-violet-600/50" onClick={handleLogin}>
        {React.string("Se connecter")}
      </button>
    </div>
  </div>
}
