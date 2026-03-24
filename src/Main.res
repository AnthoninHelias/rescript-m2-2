// Importe le fichier CSS global pour l'ensemble de l'application
%%raw("import './index.css'")

// Supprime les erreurs non critiques des extensions de navigateur
%%raw(`
  window.addEventListener('unhandledrejection', event => {
    if (event.reason && event.reason.message && event.reason.message.includes('tabs:outgoing')) {
      event.preventDefault()
    }
  })
`)

open Connection_bdd

// Module routeur : décide quel composant afficher selon l'URL courante
module Router = {
  @react.component
  let make = () => {
    // Lit l'URL actuelle dans le navigateur
    let url = RescriptReactRouter.useUrl()

    // État partagé : le nom de l'utilisateur, transmis à App et Affichage_bdd
    let (nom, setNom) = React.useState(() => "")

    // Vérifie si l'utilisateur est connecté
    let isLoggedIn = Connection_bdd.isLoggedIn()

    // Aiguillage selon le chemin de l'URL
    switch url.path {
    // Route "/affichage-bdd" → page du questionnaire (démarre à la question 1)
    | list{"affichage-bdd"} => 
      if isLoggedIn {
        <Affichage_bdd questionId={1} nom={nom} setNom={setNom} />
      } else {
        RescriptReactRouter.replace("/")
        <Page_connexion nom={nom} setNom={setNom} />
      }
    // Route "/app" → page du questionnaire
    | list{"app"} => 
      if isLoggedIn {
        <App nom={nom} setNom={setNom} />
      } else {
        RescriptReactRouter.replace("/")
        <Page_connexion nom={nom} setNom={setNom} />
      }
    // Toute autre route → page de connexion
    | _ => <Page_connexion nom={nom} setNom={setNom} />
    }
  }
}

// Point d'entrée : trouve l'élément HTML #root et y monte l'application React
switch ReactDOM.querySelector("#root") {
| Some(domElement) =>
  ReactDOM.Client.createRoot(domElement)->ReactDOM.Client.Root.render(
    // StrictMode active des avertissements supplémentaires en développement
    <React.StrictMode>
      <Router />
    </React.StrictMode>,
  )
| None => () // Si #root est absent du HTML, on ne fait rien
}