#!/bin/bash

# Colores para mensajes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Iniciando instalación del entorno de desarrollo ===${NC}"

# Función para verificar si un puerto está en uso
check_port() {
    local port=$1
    if lsof -i ":$port" >/dev/null 2>&1; then
        echo -e "${RED}Error: El puerto $port está en uso.${NC}"
        echo -e "Por favor, libera el puerto $port y vuelve a intentarlo."
        exit 1
    fi
}

# Verificar puertos necesarios
echo -e "\n${BLUE}[1/5]${NC} Verificando puertos..."
check_port 5173  # Frontend
check_port 8000  # Backend
check_port 3306  # MySQL
check_port 8080  # phpMyAdmin

# Verificar Docker
echo -e "\n${BLUE}[2/5]${NC} Verificando Docker..."
if ! command -v docker >/dev/null 2>&1; then
    echo -e "${RED}Error: Docker no está instalado.${NC}"
    echo "Por favor, instala Docker desde https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker-compose >/dev/null 2>&1; then
    echo -e "${RED}Error: Docker Compose no está instalado.${NC}"
    echo "Por favor, instala Docker Compose desde https://docs.docker.com/compose/install/"
    exit 1
fi

# Inicializar submódulos git si no existen
echo -e "\n${BLUE}[3/5]${NC} Configurando repositorios..."
if [ ! -d "frontend/.git" ] || [ ! -d "backend/.git" ]; then
    git submodule update --init --recursive
fi

# Detener contenedores existentes y limpiar
echo -e "\n${BLUE}[4/5]${NC} Limpiando entorno anterior..."
docker-compose down -v >/dev/null 2>&1

# Iniciar contenedores
echo -e "\n${BLUE}[5/5]${NC} Iniciando contenedores..."
docker-compose up -d

# Verificar estado
echo -e "\n${BLUE}=== Verificando estado de los servicios ===${NC}"
sleep 5  # Esperar a que los contenedores estén listos

if docker-compose ps | grep -q "Up"; then
    echo -e "${GREEN}✓ Instalación completada con éxito${NC}"
    echo -e "\nPuedes acceder a:"
    echo -e "  ${GREEN}Frontend:${NC}    http://localhost:5173"
    echo -e "  ${GREEN}Backend:${NC}     http://localhost:8000"
    echo -e "  ${GREEN}phpMyAdmin:${NC}  http://localhost:8080"
    echo -e "\nCredenciales de Base de Datos:"
    echo -e "  ${GREEN}Usuario:${NC}     daw_user"
    echo -e "  ${GREEN}Contraseña:${NC}  daw_password"
    echo -e "  ${GREEN}Base de datos:${NC} daw_db"
else
    echo -e "${RED}⨯ Hubo problemas al iniciar algunos servicios${NC}"
    echo "Revisa el estado con: docker-compose ps"
    exit 1
fi
