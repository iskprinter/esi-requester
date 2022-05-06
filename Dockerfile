FROM node:14-alpine AS install
WORKDIR /app
COPY ./package.json ./package-lock.json ./
RUN npm ci

FROM install AS build
COPY . ./
RUN npm run build

FROM build AS test
RUN npm test

FROM node:14-alpine as package
WORKDIR /app
COPY --from=build /app/dist/* ./
CMD ["node", "--enable-source-maps", "app.js"]
