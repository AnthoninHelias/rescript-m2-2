@react.component
let make = (~questionId: int) => {
  let (questionTitle, setQuestionTitle) = React.useState(() => None)
  let (responses, setResponses) = React.useState(() => [])

  React.useEffect(() => {
    let loadData = async () => {
      // Charger la question
      let title = await Connection_bdd.fetchQuestionById(questionId)
      setQuestionTitle(_ => title)
      
      // Charger les réponses
      let reponses = await Connection_bdd.fetchResponsesByQuestionId(questionId)
      setResponses(_ => reponses)
    }
    let _ = loadData()
    None
  }, [questionId])

  <div className="max-w-200">
    <h2>
      {
        switch questionTitle {
        | Some(title) => title->React.string
        | None => "Chargement de la question..."->React.string
        }
      }
    </h2>
    <ul>
      {responses->Array.map(item =>
        <li key={item.title}>
          {item.title->React.string}
        </li>
      )->React.array}
    </ul>
  </div>
}
