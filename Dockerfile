FROM node:18-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install
RUN ng build

COPY . .

WORKDIR /app/dist  # Adjust if needed

COPY . .

FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
