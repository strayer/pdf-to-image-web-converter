FROM node:18.13.0 AS build

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# node-canvas build dependencies for arm64
RUN [ "$(arch)" == "aarch64" ] && apt-get update && \
    apt-get install -y build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev || true

RUN npm install -g pnpm

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN pnpm install

COPY . .

RUN pnpm run build

# ---

FROM nginx:alpine-slim@sha256:314dd21ffd4c9ce2755b549aa7655378ab1e9627ca39c978e6a261549c83c72c

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/dist/ /usr/share/nginx/html/
