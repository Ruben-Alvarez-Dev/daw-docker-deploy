#!/bin/bash

# Colores para mensajes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== Iniciando instalación del entorno de desarrollo ===${NC}"

# Función para matar proceso en un puerto
kill_process_on_port() {
    local port=$1
    local pid=$(lsof -ti :$port)
    if [ ! -z "$pid" ]; then
        echo -e "${YELLOW}Puerto $port está en uso. Terminando proceso ${pid}...${NC}"
        kill -9 $pid
        sleep 1
    fi
}

# Función para verificar y liberar puerto
check_and_free_port() {
    local port=$1
    if lsof -i ":$port" >/dev/null 2>&1; then
        echo -e "${YELLOW}Puerto $port está en uso.${NC}"
        read -p "¿Quieres terminar el proceso que usa este puerto? (s/n): " choice
        case "$choice" in 
            s|S|"" ) 
                kill_process_on_port $port
                ;;
            * )
                echo -e "${RED}No se puede continuar sin liberar el puerto $port.${NC}"
                exit 1
                ;;
        esac
    fi
}

# Verificar puertos necesarios
echo -e "\n${BLUE}[1/6]${NC} Verificando puertos..."
check_and_free_port 5173  # Frontend
check_and_free_port 8000  # Backend
check_and_free_port 3306  # MySQL
check_and_free_port 8080  # phpMyAdmin

# Verificar Docker
echo -e "\n${BLUE}[2/6]${NC} Verificando Docker..."
if ! command -v docker >/dev/null 2>&1; then
    echo -e "${RED}Error: Docker no está instalado.${NC}"
    echo "Por favor, instala Docker desde https://docs.docker.com/get-docker/"
    exit 1
fi

# Verificar que Docker está en ejecución
echo -e "\n${BLUE}[3/6]${NC} Verificando que Docker está en ejecución..."
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}Error: Docker no está en ejecución.${NC}"
    echo "Por favor, inicia Docker Desktop o el daemon de Docker y vuelve a intentarlo."
    exit 1
fi

# Verificar Docker Compose
echo -e "\n${BLUE}[4/6]${NC} Verificando Docker Compose..."
if ! docker compose version >/dev/null 2>&1; then
    echo -e "${RED}Error: Docker Compose no está disponible.${NC}"
    echo "Por favor, asegúrate de que Docker está actualizado e incluye Docker Compose."
    exit 1
fi

# Detener contenedores existentes
echo -e "\n${BLUE}[5/6]${NC} Deteniendo contenedores existentes..."
docker compose down -v >/dev/null 2>&1
docker compose down --remove-orphans -v >/dev/null 2>&1

# Inicializar submódulos git si no existen
echo -e "\n${BLUE}[6/6]${NC} Configurando repositorios..."
if [ ! -d "frontend/.git" ] || [ ! -d "backend/.git" ]; then
    git submodule update --init --recursive
fi

# Iniciar contenedores
echo -e "\n${BLUE}Iniciando contenedores...${NC}"
docker compose up -d

# Verificar estado
echo -e "\n${BLUE}=== Verificando estado de los servicios ===${NC}"
sleep 5  # Esperar a que los contenedores estén listos

if docker compose ps | grep -q "Up"; then
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
    echo "Revisa el estado con: docker compose ps"
    exit 1
fi
