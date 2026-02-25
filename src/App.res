
@react.component
let make = () => {
  <div >
   <header className = "header-1">
    <h1 className = "large-title"> {React.string("Page d'acceuil")} </h1>
   </header>
  <div className = "div-2">
      <img className = "image-1" src="image-2.png" alt="Image d'acceuil" />
      <p className = "paragraph-1"> {React.string("Bienvenue sur votre questionnaire")}</p>
      <input className = "input-1" type_="text" placeholder="Entrez votre nom"/>
      <button className = "button-1" onClick={_ => {
        let _ = RescriptReactRouter.push("/affichage-bdd")
      }} > {React.string("Commencer le questionnaire")} </button>
  </div>
  </div>
}


