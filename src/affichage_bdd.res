@react.component
let make = (~questionId: int, ~nom: string, ~setNom: (string => string) => unit) => {
  let (currentQuestionId, setCurrentQuestionId) = React.useState(() => questionId)
  let (isFinished, setIsFinished) = React.useState(() => false)

  let (questionTitle, setQuestionTitle) = React.useState(() => None)
  let (responses, setResponses) = React.useState(() => [])

  // On utilise un état local pour valider le commencement du questionnaire
  let (isStarted, setIsStarted) = React.useState(() => nom->String.trim !== "")

  React.useEffect(() => {
    let loadData = async () => {
      let title = await Connection_bdd.fetchQuestionById(currentQuestionId)

      switch title {
      | Some(t) => {
          setQuestionTitle(_ => Some(t))
          let reponses = await Connection_bdd.fetchResponsesByQuestionId(currentQuestionId)
          setResponses(_ => reponses)
        }
      | None => {
          setIsFinished(_ => true)
        }
      }
    }

    let _ = loadData()
    None
  }, [currentQuestionId])

  let handleResponseClick = () => {
    setCurrentQuestionId(prev => prev + 1)
    setQuestionTitle(_ => None)
    setResponses(_ => [])
  }

  if !isStarted {
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
          let value = (e->ReactEvent.Form.target->Obj.magic)["value"]
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
    <div className="max-w-md mx-auto mt-10 p-6 bg-white rounded-xl shadow-md text-center">
      <h2 className="text-2xl font-bold mb-4 text-gray-800">
        {"Résultat final !"->React.string}
      </h2>
      <p className="text-lg text-gray-600 mb-4">
        {("Bravo " ++ nom ++ ", vous avez terminé le questionnaire !")->React.string}
      </p>
      <button
        className="mt-4 px-6 py-2 bg-blue-500 text-white font-semibold rounded-lg hover:bg-blue-600 transition-colors"
        onClick={_ => {
          let _ = RescriptReactRouter.push("/")
        }}
      >
        {"Retour à l'accueil"->React.string}
      </button>
    </div>
  } else {
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
