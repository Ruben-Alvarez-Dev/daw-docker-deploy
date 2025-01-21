# Full-Stack Development Environment with Docker

This repository contains the Docker configuration for a full-stack development environment, combining a Laravel backend with a React frontend.

## Project Structure

- `daw_backend/`: Laravel backend application
- `daw_frontend/`: React frontend application
- `docker-compose.yml`: Docker services configuration
- `Dockerfile`: Main application container configuration
- `start-dev.sh`: Development environment startup script

## Features

- Laravel 10 backend with PHP 8.2
- React frontend with Vite
- MySQL 8.0 database
- phpMyAdmin for database management
- Hot reload for both frontend and backend
- Health checks for database readiness
- Docker volume persistence for database data

## Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/Ruben-Alvarez-Dev/daw-docker-deploy.git
   ```

2. Start the development environment:
   ```bash
   docker compose up
   ```

3. Access the applications:
   - Frontend: http://localhost:5173
   - Backend API: http://localhost:8000
   - phpMyAdmin: http://localhost:8080

## Development Workflow

The project is set up for active development:
- Frontend and backend code are mounted as volumes
- Changes to the code are reflected immediately
- Database data persists between container restarts

## Container Registry

The Docker image is available at:
```
docker pull rubenalvarezdev/daw_ruben_alvarez:dev
