FROM node:17

RUN mkdir -p /app
WORKDIR /app

COPY ./package*.json ./
COPY ./router.js ./
COPY ./server.js ./
COPY ./user.json ./

RUN npm install


CMD [ "node", "server.js" ]

EXPOSE 3000