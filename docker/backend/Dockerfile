FROM node:18-alpine

WORKDIR /app

COPY app/backend/package*.json ./
RUN npm install

COPY app/backend .

EXPOSE 5000

CMD ["node", "index.js"]