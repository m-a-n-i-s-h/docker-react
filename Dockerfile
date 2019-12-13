FROM node:alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
RUN apk update
RUN apk add curl
RUN curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 >> ./cc-test-reporter
RUN chmod +x ./cc-test-reporter
COPY . .
ENV CC_TEST_REPORTER_ID=cfab5344f8da719f549073675da3f5c4e7137cd38f354a3ea64f5535c070a3bc
RUN ./cc-test-reporter before-build --debug
RUN ./cc-test-reporter after-build -s 5 -d
RUN ./cc-test-reporter after-build --debug
RUN npm run build

FROM nginx
EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html
