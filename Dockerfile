FROM node:alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
RUN apk update
RUN apk add curl
RUN curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 >> ./cc-test-reporter
RUN chmod +x ./cc-test-reporter
COPY . .
RUN ./cc-test-reporter before-build --debug
RUN npm run test
RUN ./cc-test-reporter after-build --debug
RUN npm run build

FROM nginx
EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html
