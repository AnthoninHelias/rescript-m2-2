// ─── useQuiz ─────────────────────────────────────────────────────────────────
// Gère toute la navigation du questionnaire : ID courant, numéro, total,
// état terminé, et le handler de clic sur une réponse.
// Retourne un record avec tout l'état et la fonction handleResponseClick.

type quizState = {
  currentQuestionId: int,
  questionNumber: int,
  totalQuestions: int,
  isFinished: bool,
  handleResponseClick: unit => unit,
}

let useQuiz = (~startId: int): quizState => {
  let (currentQuestionId, setCurrentQuestionId) = React.useState(() => startId)
  let (isFinished, setIsFinished) = React.useState(() => false)
  let (totalQuestions, _) = React.useState(() => 3 + Js.Math.floor_int(Math.random() *. 3.0))
  let (questionNumber, setQuestionNumber) = React.useState(() => 1)

  let handleResponseClick = React.useCallback(() => {
    if questionNumber >= totalQuestions {
      setIsFinished(_ => true)
    } else {
      setCurrentQuestionId(prev => prev + 1)
      setQuestionNumber(prev => prev + 1)
    }
  }, [questionNumber, totalQuestions])

  {currentQuestionId, questionNumber, totalQuestions, isFinished, handleResponseClick}
}
