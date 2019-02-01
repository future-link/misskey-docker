ARG NODE_VERSION=10-alpine

FROM node:${NODE_VERSION}
RUN apk add --no-cache python2 build-base gcc

WORKDIR /app

ADD ./package*.json ./

RUN npm install

ENV NODE_ENV=production
ADD . .
RUN npm run build

RUN npm prune
RUN rm -rf src

# multi-stage build
FROM node:${NODE_VERSION}

ENV NODE_ENV=production
RUN apk update && \
    apk add --no-cache \
        graphicsmagick \
		openssl \
        wget \
        ca-certificates \
        bash && \
    wget https://raw.githubusercontent.com/vishnubob/wait-for-it/8ed92e8cab83cfed76ff012ed4a36cef74b28096/wait-for-it.sh \
        -O /usr/local/bin/wait-for-it && \
    chmod 755 /usr/local/bin/wait-for-it

WORKDIR /app
COPY --from=0 /app .

CMD ["wait-for-it", "-h", "db", "-p", "27017", "--", "npm", "start"]
