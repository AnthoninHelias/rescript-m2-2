// Importe le fichier CSS global pour l'ensemble de l'application
%%raw("import './index.css'")

// Module routeur : décide quel composant afficher selon l'URL courante
module Router = {
  @react.component
  let make = () => {
    // Lit l'URL actuelle dans le navigateur
    let url = RescriptReactRouter.useUrl()

    // État partagé : le nom de l'utilisateur, transmis à App et Affichage_bdd
    let (nom, setNom) = React.useState(() => "")

    // Aiguillage selon le chemin de l'URL
    switch url.path {
    // Route "/affichage-bdd" → page du questionnaire (démarre à la question 1)
    | list{"affichage-bdd"} => <Affichage_bdd questionId={1} nom={nom} setNom={setNom} />
    // Toute autre route → page d'accueil
    | _ => <App nom={nom} setNom={setNom} />
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
