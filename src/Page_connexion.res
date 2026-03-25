open Connection_bdd

// Binding axios minimal
type axios
@module("axios") external axios: axios = "default"
@send external get: (axios, string) => promise<axiosResponse<'a>> = "get"

// Génère et stocke un token d'authentification (2 minutes)
let generateToken = () => {
  let token = "token_" ++ Int.toString(Js.Math.random_int(0, 1000000))
  let expires = Date.now() +. 120000.0
  Dom.Storage.setItem("auth_token", token, Dom.Storage.localStorage)
  Dom.Storage.setItem("auth_expires", Float.toString(expires), Dom.Storage.localStorage)
  token
}

// Vérifie les identifiants et génère un token si valides
let login = async (pseudo: string, password: string): bool => {
  try {
    let response = await axios->get(`${Connection_bdd.apiBaseUrl}/login/${pseudo}/${password}`)
    if response.status == 200 && response.data == true {
      let _ = generateToken()
      true
    } else {
      false
    }
  } catch {
  | _ => {
      Console.error("Error logging in")
      false
    }
  }
}

// Gère la saisie de formulaire
let handleInputChange = (setter: (string => string) => unit, e: ReactEvent.Form.t) => {
  let value = (e->ReactEvent.Form.target)["value"]
  setter(_ => value)
}


@react.component
let make = (~nom: string, ~setNom: (string => string) => unit) => {
  let (password, setPassword) = React.useState(() => "")
  let (errorMessage, setErrorMessage) = React.useState(() => "")
  let (isLoading, setIsLoading) = React.useState(() => false)

  let handleLogin = async _ => {
    setIsLoading(_ => true)
    setErrorMessage(_ => "")
    let ok = await login(nom, password)
    setIsLoading(_ => false)
    // Condition: si la connexion est réussie (true), rediriger vers la page app
    if ok {
      RescriptReactRouter.push("/app")
    } else {
      setErrorMessage(_ => "Identifiant ou mot de passe incorrect.")
    }
  }

  let renderError = errorMessage != "" ? (
    <div className="error-message"> {React.string(errorMessage)} </div>
  ) : React.null

  <div>
    <header className="header-1">
      <h1 className="large-title"> {React.string("Page de connexion")} </h1>
    </header>
    <div className="div-2">
      {renderError}
      <input
        className="input-1"
        type_="text"
        placeholder="Entrez votre nom"
        value={nom}
        onChange={e => handleInputChange(setNom, e)}
      />
      <input
        className="input-1"
        type_="password"
        placeholder="Entrez votre mot de passe"
        value={password}
        onChange={e => handleInputChange(setPassword, e)}
      />
      <button
        className="button-1"
        disabled={isLoading}
        onClick={e => handleLogin(e)->ignore}
      >
        {React.string(isLoading ? "Connexion en cours..." : "Se connecter")}
      </button>
    </div>
  </div>
}