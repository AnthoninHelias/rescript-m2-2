@react.component
let make = (~nom: string, ~setNom: (string => string) => unit) => {
  // Hook personnalisé : password, état loading/erreur et soumission
  let (password, setPassword, isLoading, errorMessage, handleLogin) = Hooks.useLogin(~nom)

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
        onChange={e => Hooks.handleInputChange(setNom, e)}
      />
      <input
        className="input-1"
        type_="password"
        placeholder="Entrez votre mot de passe"
        value={password}
        onChange={e => Hooks.handleInputChange(setPassword, e)}
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