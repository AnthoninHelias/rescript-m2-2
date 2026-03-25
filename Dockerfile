# ── Stage 1 : build ──────────────────────────────────────────────────────────
FROM node:22-alpine AS builder

WORKDIR /app

# Installer les dépendances
COPY package.json package-lock.json* ./
RUN npm ci

# Copier les sources
COPY . .

# 1) Compiler ReScript → .mjs
RUN npx rescript

# 2) Bundler Vite → dist/
RUN npm run build

# ── Stage 2 : serveur ────────────────────────────────────────────────────────
FROM nginx:stable-alpine

# Copier les fichiers buildés
COPY --from=builder /app/dist /usr/share/nginx/html

# Configuration nginx : proxy /api/ vers le backend, SPA fallback pour le reste
RUN printf 'server {\n\
    listen 80;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    location /api/ {\n\
        proxy_pass http://backend:3000/;\n\
    }\n\
    location / {\n\
        try_files $uri $uri/ /index.html;\n\
    }\n\
}\n' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
