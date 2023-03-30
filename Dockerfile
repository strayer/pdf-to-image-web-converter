FROM node:18.15.0 AS build

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

FROM nginx:alpine-slim@sha256:84111fd4584e9282a7331d73e031bd6160cff8cb3a43b31c10a42b7b09bb1bec

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/dist/ /usr/share/nginx/html/
