FROM node:18

WORKDIR /app

# Instalar una versión específica de npm compatible con Node 18
RUN npm install -g npm@10.2.4

# Copiar archivos de dependencias
COPY frontend/package*.json ./

# Instalar dependencias
RUN npm install

# Copiar el resto del código
COPY frontend/ .

EXPOSE 5173

CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
