FROM node:18

WORKDIR /app

# Instalar dependencias globales
RUN npm install -g npm@latest

# El resto de la instalación se hará en el docker-compose
# ya que necesitamos acceso al código del volumen

EXPOSE 5173

CMD ["sh", "-c", "npm install && npm run dev -- --host 0.0.0.0"]
