// Composant principal du questionnaire.
// Gère trois écrans selon l'état :
//   1. Saisie du nom (si l'utilisateur n'a pas encore entré son nom)
//   2. Question + réponses (déroulement normal du QCM)
//   3. Écran de fin (quand l'API ne renvoie plus de question)
//
// Props :
//   ~questionId : identifiant de la première question (é généralement 1)
//   ~nom        : nom de l'utilisateur
//   ~setNom     : fonction pour modifier le nom
@react.component
let make = (~questionId: int, ~nom: string, ~setNom: (string => string) => unit) => {
  // Identifiant de la question actuellement affichée
  let (currentQuestionId, setCurrentQuestionId) = React.useState(() => questionId)
  // Passe à true quand l'API ne renvoie plus de question (fin du QCM)
  let (isFinished, setIsFinished) = React.useState(() => false)

  // Texte de la question courante (None pendant le chargement)
  let (questionTitle, setQuestionTitle) = React.useState(() => None)
  // Réponses proposées pour la question courante
  let (responses, setResponses) = React.useState(() => [])

  // Vrai si l'utilisateur a déjà saisi un nom non vide
  let (isStarted, setIsStarted) = React.useState(() => nom->String.trim !== "")

  // Effet lancé à chaque changement de question :
  // appelle l'API pour récupérer le titre et les réponses
  React.useEffect(() => {
    let loadData = async () => {
      let title = await Connection_bdd.fetchQuestionById(currentQuestionId)

      switch title {
      | Some(t) => {
          // Question trouvée : mise à jour du titre et chargement des réponses
          setQuestionTitle(_ => Some(t))
          let reponses = await Connection_bdd.fetchResponsesByQuestionId(currentQuestionId)
          setResponses(_ => reponses)
        }
      | None =>
        // Aucune question à cet ID → le questionnaire est terminé
        setIsFinished(_ => true)
      }
    }

    // On ignore la promesse retournée (async fire-and-forget dans l'effet)
    let _ = loadData()
    None // Pas de fonction de nettoyage (cleanup)
  }, [currentQuestionId])

  // Appelée quand l'utilisateur clique sur une réponse :
  // passe à la question suivante et réinitialise l'affichage
  // Note : le champ "correct" est disponible mais le score n'est pas encore calculé
  let handleResponseClick = () => {
    setCurrentQuestionId(prev => prev + 1)
    // Réinitialise la question et les réponses le temps du chargement
    setQuestionTitle(_ => None)
    setResponses(_ => [])
  }

  // ─── Rendu conditionnel selon l'état ────────────────────────────────────
  if !isStarted {
    // Écran 1 : demande le nom avant de commencer
    <div className="max-w-md mx-auto mt-10 p-6 bg-white rounded-xl shadow-md text-center">
      <h2 className="text-2xl font-bold mb-4 text-gray-800">
        {"Avant de commencer..."->React.string}
      </h2>
      <p className="text-gray-600 mb-4">
        {"Quel est votre nom ?"->React.string}
      </p>
      <input
        className="w-full px-4 py-2 border border-gray-300 rounded-lg mb-4 text-gray-700 focus:outline-none focus:border-blue-400"
        type_="text"
        placeholder="Votre nom"
        value={nom}
        onChange={e => {
          // Lit la valeur saisie dans le champ texte
          let value = (e->ReactEvent.Form.target)["value"]
          setNom(_ => value)
        }}
      />
      <button
        className="px-6 py-2 bg-blue-500 text-white font-semibold rounded-lg hover:bg-blue-600 transition-colors"
        onClick={_ => {
          if nom->String.trim !== "" {
            setIsStarted(_ => true)
          }
        }}
      >
        {"Commencer"->React.string}
      </button>
    </div>
  } else if isFinished {
    // Écran 2 : message de fin avec le nom de l'utilisateur
    <div className="max-w-md mx-auto mt-10 p-6 bg-white rounded-xl shadow-md text-center">
      <h2 className="text-2xl font-bold mb-4 text-gray-800">
        {"Résultat final !"->React.string}
      </h2>
      <p className="text-lg text-gray-600 mb-4">
        {("Bravo " ++ nom ++ ", vous avez terminé le questionnaire !")->React.string}
      </p>
      <button
        className="mt-4 px-6 py-2 bg-blue-500 text-white font-semibold rounded-lg hover:bg-blue-600 transition-colors"
        // Retourne à la page d'accueil via le routeur
        onClick={_ => RescriptReactRouter.push("/")}
      >
        {"Retour à l'accueil"->React.string}
      </button>
    </div>
  } else {
    // Écran 3 : question en cours + liste des réponses cliquables
    <div className="max-w-md mx-auto mt-10 p-6 bg-white rounded-xl shadow-md">
      <p className="text-sm text-blue-500 font-medium mb-2">
        {("Questionnaire de " ++ nom)->React.string}
      </p>
      <h2 className="text-xl font-semibold mb-6 text-gray-800">
        {switch questionTitle {
        | Some(title) => title->React.string
        | None => "Chargement de la question..."->React.string
        }}
      </h2>
      <div className="flex flex-col gap-3">
        {responses
        ->Array.map(item =>
            // Chaque réponse est un bouton ; le clic avance à la question suivante
            <button
              key={item.title}
              onClick={_ => handleResponseClick()}
              className="px-4 py-3 bg-gray-50 hover:bg-blue-50 text-left text-gray-700 font-medium rounded-lg transition-colors border border-gray-200 hover:border-blue-300 shadow-sm"
            >
              {item.title->React.string}
            </button>
          )
        ->React.array}
      </div>
    </div>
  }
}
