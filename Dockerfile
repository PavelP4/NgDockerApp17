###
FROM node:alpine AS build

WORKDIR /usr/src/app

#RUN npm cache clean --force
#RUN npm install -g @angular/cli

COPY package*.json .
RUN npm install

COPY . .
RUN npm run build --output-path=./dist/app17 --prod

###
FROM build AS serve
WORKDIR /usr/src/app
CMD ["ng", "serve", "--host", "0.0.0.0"]

###
FROM nginx:latest AS ngi

COPY --from=build /usr/src/app/dist/app17 /usr/share/nginx/html
COPY /nginx.conf  /etc/nginx/conf.d/default.conf

EXPOSE 80