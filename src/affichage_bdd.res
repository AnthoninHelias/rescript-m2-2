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
  // Vrai si l'utilisateur a déjà saisi un nom non vide
  let (isStarted, setIsStarted) = React.useState(() => nom->String.trim !== "")

  // Hook personnalisé : navigation du quiz (ID courant, numéro, total, fin, handler)
  let {currentQuestionId, questionNumber, totalQuestions, isFinished, handleResponseClick} =
    Hooks.useQuiz(~startId=questionId)

  // Hook personnalisé : charge la question et ses réponses, avec cleanup anti-fuite
  let {title: questionTitle, responses, notFound} = Hooks.useQuestion(currentQuestionId)

  // Quand l'API ne trouve plus de question à cet ID → forcer la fin du quiz
  React.useEffect(() => {
    if notFound {
      handleResponseClick()
    }
    None
  }, (notFound, handleResponseClick))

  // ─── Rendu conditionnel selon l'état ────────────────────────────────────
  if !isStarted {
    // Écran 1 : demande le nom avant de commencer
    <div
      className="max-w-md mx-auto mt-24 p-8 rounded-2xl text-center"
      style={{
        background: "rgba(255,255,255,0.10)",
        backdropFilter: "blur(16px)",
        border: "1px solid rgba(255,255,255,0.20)",
      }}
    >
      <h2 className="text-2xl font-bold mb-3 text-white">
        {"Avant de commencer..."->React.string}
      </h2>
      <p className="text-white/70 mb-6"> {"Quel est votre nom ?"->React.string} </p>
      <input
        className="w-full px-4 py-2 rounded-lg mb-5 text-white placeholder-white/40 focus:outline-none focus:ring-2 focus:ring-violet-400"
        style={{background: "rgba(255,255,255,0.12)", border: "1px solid rgba(255,255,255,0.25)"}}
        type_="text"
        placeholder="Votre nom"
        value={nom}
        onChange={e => Hooks.handleInputChange(setNom, e)}
      />
      <button
        className="px-8 py-2 bg-violet-500 hover:bg-violet-600 text-white font-semibold rounded-lg transition-colors shadow-lg"
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
    <div
      className="max-w-md mx-auto mt-24 p-8 rounded-2xl text-center"
      style={{
        background: "rgba(255,255,255,0.10)",
        backdropFilter: "blur(16px)",
        border: "1px solid rgba(255,255,255,0.20)",
      }}
    >
      <div className="text-5xl mb-4"> {"🎉"->React.string} </div>
      <h2 className="text-2xl font-bold mb-3 text-white"> {"Résultat final !"->React.string} </h2>
      <p className="text-white/70 mb-6">
        {("Bravo " ++ nom ++ ", vous avez terminé le questionnaire !")->React.string}
      </p>
      <button
        className="mt-2 px-8 py-2 bg-violet-500 hover:bg-violet-600 text-white font-semibold rounded-lg transition-colors shadow-lg"
        // Retourne à la page d'accueil via le routeur
        onClick={_ => RescriptReactRouter.push("/")}
      >
        {"Retour à l'accueil"->React.string}
      </button>
    </div>
  } else {
    // Écran 3 : question en cours + liste des réponses cliquables
    <div
      className="max-w-md mx-auto mt-24 p-8 rounded-2xl"
      style={{
        background: "rgba(255,255,255,0.10)",
        backdropFilter: "blur(16px)",
        border: "1px solid rgba(255,255,255,0.20)",
      }}
    >
      // ── En-tête : nom + indicateur de progression ──
      <div className="flex justify-between items-center mb-4">
        <p className="text-sm text-violet-300 font-medium">
          {("Questionnaire de " ++ nom)->React.string}
        </p>
        <p className="text-sm text-white/60 font-semibold">
          {("Question " ++ questionNumber->Int.toString ++ " / " ++ totalQuestions->Int.toString)
            ->React.string}
        </p>
      </div>
      // ── Barre de progression ──
      <div
        className="w-full rounded-full mb-6"
        style={{background: "rgba(255,255,255,0.15)", height: "6px"}}
      >
        <div
          className="rounded-full transition-all duration-500"
          style={{
            background: "linear-gradient(90deg, #a78bfa, #7c3aed)",
            height: "6px",
            width: (questionNumber * 100 / totalQuestions)->Int.toString ++ "%",
          }}
        />
      </div>
      <h2 className="text-xl font-semibold mb-6 text-white">
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
            className="px-4 py-3 text-left text-white font-medium rounded-lg transition-all border border-white/20 hover:border-violet-400 shadow-sm hover:scale-[1.02]"
            style={{background: "rgba(255,255,255,0.08)"}}
          >
            {item.title->React.string}
          </button>
        )
        ->React.array}
      </div>
    </div>
  }
}
