ARG NODE_VERSION=8-alpine

FROM node:${NODE_VERSION}

WORKDIR /app

ADD ./package*.json ./

RUN npm install

ENV NODE_ENV=production
ADD . .
RUN npm run build

RUN npm prune

# multi-stage build
FROM node:${NODE_VERSION}

ENV NODE_ENV=production
RUN apk update && apk add --no-cache \
        graphicsmagick \
		openssl

WORKDIR /app
COPY --from=0 /app .

CMD sleep 10 && npm start
