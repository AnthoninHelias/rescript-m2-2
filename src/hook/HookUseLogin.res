// ─── useLogin ───────────────────────────────────────────────────────────────
// Génère et stocke un token d'authentification valide 2 minutes
let generateToken = () => {
  let token = "token_" ++ Int.toString(Js.Math.random_int(0, 1000000))
  let expires = Date.now() +. 120000.0
  Dom.Storage.setItem("auth_token", token, Dom.Storage.localStorage)
  Dom.Storage.setItem("auth_expires", Float.toString(expires), Dom.Storage.localStorage)
  token
}

// Appelle l'API de login et génère un token si les identifiants sont valides
let loginRequest = async (pseudo: string, password: string): bool => {
  open Connection_bdd
  try {
    let response = await axios->get(`${apiBaseUrl}/login/${pseudo}/${password}`)
    if response.status == 200 && response.data == true {
      let _ = generateToken()
      true
    } else {
      false
    }
  } catch {
  | _ =>
    Console.error("Error logging in")
    false
  }
}

// Gère l'état et la logique de connexion (password, loading, erreur, soumission).
// Retourne (password, setPassword, isLoading, errorMessage, handleLogin).
let useLogin = (~nom: string) => {
  let (password, setPassword) = React.useState(() => "")
  let (isLoading, setIsLoading) = React.useState(() => false)
  let (errorMessage, setErrorMessage) = React.useState(() => "")

  let handleLogin = async _ => {
    setIsLoading(_ => true)
    setErrorMessage(_ => "")
    let ok = await loginRequest(nom, password)
    setIsLoading(_ => false)
    if ok {
      RescriptReactRouter.push("/accueil")
    } else {
      setErrorMessage(_ => "Identifiant ou mot de passe incorrect.")
    }
  }

  (password, setPassword, isLoading, errorMessage, handleLogin)
}
