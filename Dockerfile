FROM node:alpine AS build
WORKDIR /app
COPY package*.json .
RUN npm install
COPY . .
RUN npm run build

FROM httpd AS server
COPY container.crt container.key /usr/local/apache2/conf/
COPY httpd.conf /usr/local/apache2/conf/
COPY httpd-ssl.conf /usr/local/apache2/conf/extra/
COPY --from=build ./app/dist/ /usr/local/apache2/htdocs/
EXPOSE 80
EXPOSE 443