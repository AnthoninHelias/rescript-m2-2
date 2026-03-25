// ─── Hooks ───────────────────────────────────────────────────────────────────
// Point d'entrée unique pour tous les hooks personnalisés.
// Ré-exporte depuis les modules séparés pour que les composants puissent
// continuer à appeler Hooks.useLogin, Hooks.useQuiz, etc.

include HookHandleInputChange
include HookUseQuestion
include HookUseLogin
include HookUseQuiz
