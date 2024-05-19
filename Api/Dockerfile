# when using pm2 if it shows command not found then write npx at the start and the command after it

FROM node:10-alpine

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

WORKDIR /home/node/app

COPY package*.json ./

USER node

RUN npm install 

COPY --chown=node:node . .

EXPOSE 8000

CMD [ "npm", "start" ]