// Composant de la page d'accueil.
// Affiche un champ texte pour que l'utilisateur saisisse son nom,
// puis un bouton pour démarrer le questionnaire.
//
// Props :
//   ~nom    : valeur actuelle du nom (état partagé depuis Main)
//   ~setNom : fonction pour mettre à jour ce nom
@react.component
let make = (~nom: string, ~setNom: (string => string) => unit) => {
  <div>
    <header className="header-1">
      <h1 className="large-title"> {React.string("Page d'accueil")} </h1>
    </header>
    <div className="div-2">
      <img className="image-1" src="image-1.png" alt="Image d'accueil" />
      <p className="paragraph-1"> {React.string("Bienvenue sur votre questionnaire")} </p>
      <input
        className="input-1"
        type_="text"
        placeholder="Entrez votre nom"
        value={nom}
        onChange={e => Hooks.handleInputChange(setNom, e)}
      />
      <button
        className="button-1"
        // Redirige vers la page du questionnaire
        onClick={_ => RescriptReactRouter.push("/questions")}
      >
        {React.string("Commencer le questionnaire")}
      </button>
    </div>
  </div>
}
