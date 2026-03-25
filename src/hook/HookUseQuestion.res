// ─── useQuestion ────────────────────────────────────────────────────────────
// Charge la question et les réponses pour l'ID donné, avec cleanup anti-fuite.
// Réinitialise automatiquement l'état à chaque changement d'ID.
// Retourne le titre (option), les réponses, et un flag notFound.

type questionData = {
  title: option<string>,
  responses: array<Connection_bdd.reponse>,
  notFound: bool,
}

let useQuestion = (questionId: int): questionData => {
  let (title, setTitle) = React.useState(() => None)
  let (responses, setResponses) = React.useState(() => [])
  let (notFound, setNotFound) = React.useState(() => false)

  React.useEffect(() => {
    let cancelled = ref(false)
    // Réinitialise l'état pour la nouvelle question avant le chargement
    setTitle(_ => None)
    setResponses(_ => [])
    setNotFound(_ => false)

    let load = async () => {
      let fetched = await Connection_bdd.fetchQuestionById(questionId)
      if !cancelled.contents {
        switch fetched {
        | Some(t) =>
          setTitle(_ => Some(t))
          let reponses = await Connection_bdd.fetchResponsesByQuestionId(questionId)
          if !cancelled.contents {
            setResponses(_ => reponses)
          }
        | None => setNotFound(_ => true)
        }
      }
    }

    let _ = load()
    // Cleanup : évite les setState si le composant est démonté entre-temps ne sert a rien
    Some(() => cancelled := true)
  }, [questionId])

  {title, responses, notFound}
}