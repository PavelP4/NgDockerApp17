###
FROM node:alpine AS build

WORKDIR /usr/src/app

RUN npm cache clean --force

COPY . .

RUN npm install -g @angular/cli
RUN npm install
RUN npm run build --prod

###
FROM build AS serve
WORKDIR /usr/src/app
CMD ["ng", "serve", "--host", "0.0.0.0"]

###
FROM nginx:latest AS ngi

COPY --from=build /usr/src/app/dist/app17 /usr/share/nginx/html
COPY /nginx.conf  /etc/nginx/conf.d/default.conf

EXPOSE 80