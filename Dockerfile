FROM node:18.16.0 AS build

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

FROM nginx:alpine-slim@sha256:d4199460812b5750bbd551247ba99e2a1953b7e618d15458d6452c18ce6e2f72

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/dist/ /usr/share/nginx/html/
