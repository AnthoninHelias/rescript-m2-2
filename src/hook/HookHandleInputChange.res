// ─── handleInputChange ───────────────────────────────────────────────────────
// Utilitaire partagé : lit la valeur d'un champ texte et met à jour l'état.
let handleInputChange = (setter: (string => string) => unit, e: ReactEvent.Form.t) => {
  let value = (e->ReactEvent.Form.target)["value"]
  setter(_ => value)
}