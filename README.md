# Entorno de Desarrollo Docker

Este proyecto contiene un entorno de desarrollo completo utilizando Docker, que incluye:

- Frontend (Node.js)
- Backend (PHP)
- Base de datos (MySQL)

## Estructura del Proyecto

```
.
├── frontend/         # Proyecto frontend
├── backend/         # Proyecto backend
├── docker/          # Configuraciones de Docker
└── docker-compose.yml
```

## Requisitos Previos

- Docker
- Docker Compose
- Git

## Instalación

1. Clona este repositorio:
```bash
git clone [URL-DEL-REPO]
```

2. Clona los repositorios de frontend y backend en sus respectivas carpetas:
```bash
git clone https://github.com/Ruben-Alvarez-Dev/daw_frontend frontend
git clone https://github.com/Ruben-Alvarez-Dev/daw_backend backend
```

3. Inicia los contenedores:
```bash
docker-compose up -d
```

## Uso

- Frontend: http://localhost:3000
- Backend: http://localhost:8000
- MySQL: localhost:3306

## Gestión de Repositorios

Cada proyecto (frontend y backend) mantiene su propio repositorio Git independiente. Puedes realizar commits y push desde dentro de cada carpeta de manera normal.
