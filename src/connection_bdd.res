// ─── Bindings axios ─────────────────────────────────────────────────────────
// Axios est la bibliothèque JavaScript utilisée pour faire des requêtes HTTP.
// On déclare ici ses types et on l'importe depuis le paquet npm "axios".
type axiosResponse<'a> = {data: 'a}

type axios
@module("axios") external axios: axios = "default"
@send external get: (axios, string) => promise<axiosResponse<'a>> = "get"

// ─── Types de données ────────────────────────────────────────────────────────
// Représente une ligne de résultat renvoyée par l'API pour une question
type questionRow = {intitule: string}
// Réponse complète de l'endpoint GET /questions/:id
type questionResponse = {rows: array<questionRow>}

// Représente une ligne renvoyée par l'API pour une réponse possible
type reponseRow = {
  titre: string,
  correct: bool,
}
// Réponse complète de l'endpoint GET /reponse/:id
type reponseResponse = {rows: array<reponseRow>}

// Type interne utilisé dans le composant UI (noms adaptés au front-end)
type reponse = {
  title: string,
  correct: bool,
}

// URL de base de l'API — centralisée ici pour éviter la répétition
let apiBaseUrl = "https://qcm-api-a108ec633b51.herokuapp.com"

// Récupère le texte d'une question à partir de son identifiant.
// Retourne Some(texte) si trouvée, None si absente ou en cas d'erreur réseau.
let fetchQuestionById = async (id: int): option<string> => {
  try {
    let response = await axios->get(`${apiBaseUrl}/questions/${id->Int.toString}`)
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

// Récupère les réponses proposées pour une question donnée.
// Retourne un tableau de réponses, ou [] en cas d'erreur réseau.
let fetchResponsesByQuestionId = async (id: int): array<reponse> => {
  try {
    let response = await axios->get(`${apiBaseUrl}/reponse/${id->Int.toString}`)
    let data: reponseResponse = response.data
    // Transforme chaque ligne BDD en type reponse utilisé dans l'UI
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
