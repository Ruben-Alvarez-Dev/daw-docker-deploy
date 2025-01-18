# Entorno de Desarrollo Docker

Este proyecto contiene un entorno de desarrollo completo utilizando Docker, que incluye:
- Frontend (React + Vite)
- Backend (Laravel)
- Base de datos (MySQL)
- phpMyAdmin

## Requisitos Previos

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- Git

## Instalación Rápida

1. Clona este repositorio:
```bash
git clone --recursive https://github.com/Ruben-Alvarez-Dev/daw-docker-deploy
cd daw-docker-deploy
```

2. Ejecuta el script de instalación:
```bash
./install.sh
```

¡Eso es todo! El script se encargará de:
- Verificar los requisitos necesarios
- Configurar los repositorios
- Iniciar los contenedores
- Mostrar las URLs de acceso

## Acceso a los Servicios

- Frontend: http://localhost:5173
- Backend API: http://localhost:8000
- phpMyAdmin: http://localhost:8080

## Credenciales de Base de Datos

- Usuario: daw_user
- Contraseña: daw_password
- Base de datos: daw_db

## Estructura del Proyecto

```
.
├── frontend/         # Proyecto frontend (React + Vite)
├── backend/         # Proyecto backend (Laravel)
├── docker/          # Configuraciones de Docker
└── docker-compose.yml
```

## Comandos Útiles

### Frontend
```bash
# Instalar nuevas dependencias
docker-compose exec frontend npm install [package]

# Ver logs
docker-compose logs -f frontend
```

### Backend
```bash
# Ejecutar comandos de artisan
docker-compose exec backend php artisan [comando]

# Ver logs
docker-compose logs -f backend
```

### Base de Datos
```bash
# Acceder a MySQL
docker-compose exec mysql mysql -u daw_user -p
```

## Gestión de Repositorios

Cada proyecto (frontend y backend) mantiene su propio repositorio Git independiente.
Puedes hacer commits y push desde dentro de cada carpeta de manera normal.
