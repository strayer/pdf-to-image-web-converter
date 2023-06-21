FROM node:18.16.1 AS build

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

FROM nginx:alpine-slim@sha256:403cf8596530a5ae73c3d3ac957f9402e560294db9d63594dc9f1059f5917729

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/dist/ /usr/share/nginx/html/
