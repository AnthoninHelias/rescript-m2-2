// Bindings pour axios
type axiosResponse<'a> = {data: 'a}

type axios
@module("axios") external axios: axios = "default"
@send external get: (axios, string) => promise<axiosResponse<'a>> = "get"

// Types pour les réponses de l'API
type questionRow = {intitule: string}
type questionResponse = {rows: array<questionRow>}

type reponseRow = {
  titre: string,
  correct: bool,
}
type reponseResponse = {rows: array<reponseRow>}

// Type pour les réponses formatées
type reponse = {
  title: string,
  correct: bool,
}

// Récupérer une question par son ID
let fetchQuestionById = async (id: int): option<string> => {
  try {
    let response = await axios->get(`https://qcm-api-a108ec633b51.herokuapp.com/questions/${id->Int.toString}`)
    let data: questionResponse = response.data
    switch data.rows[0] {
    | Some(row) => Some(row.intitule)
    | None => None
    }
  } catch {
  | _ => {
      Console.error("Error fetching question")
      None
    }
  }
}

// Récupérer les réponses par ID de question
let fetchResponsesByQuestionId = async (id: int): array<reponse> => {
  try {
    let response = await axios->get(`https://qcm-api-a108ec633b51.herokuapp.com/reponse/${id->Int.toString}`)
    let data: reponseResponse = response.data
    data.rows->Array.map(row => {
      title: row.titre,
      correct: row.correct,
    })
  } catch {
  | _ => {
      Console.error("Error fetching responses")
      []
    }
  }
}
