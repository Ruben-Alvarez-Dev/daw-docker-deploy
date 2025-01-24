# Función para manejar errores
function Handle-Error {
    param($ErrorMessage)
    Write-Host "`nError: $ErrorMessage" -ForegroundColor Red
    exit 1
}

Write-Host "Iniciando instalacion del entorno de desarrollo..." -ForegroundColor Green

# Limpiar el entorno anterior si existe
Write-Host "`nLimpiando el entorno anterior..." -ForegroundColor Yellow
docker compose down --volumes --rmi all 2>$null
docker system prune -af --volumes 2>$null

# Asegurarse de que no hay contenedores o redes residuales
Write-Host "`nVerificando limpieza del entorno..." -ForegroundColor Yellow
docker network prune -f 2>$null

# Clonar repositorios
Write-Host "`nClonando repositorios..." -ForegroundColor Yellow

if (Test-Path "daw_frontend") {
    Remove-Item -Recurse -Force "daw_frontend"
}
if (Test-Path "daw_backend") {
    Remove-Item -Recurse -Force "daw_backend"
}

try {
    git clone https://github.com/Ruben-Alvarez-Dev/daw_frontend.git
    if (-not $?) { Handle-Error "Error al clonar el repositorio frontend" }
    
    git clone https://github.com/Ruben-Alvarez-Dev/daw_backend.git
    if (-not $?) { Handle-Error "Error al clonar el repositorio backend" }
} catch {
    Handle-Error "Error al clonar los repositorios: $_"
}

# Iniciar contenedores
Write-Host "`nIniciando contenedores Docker..." -ForegroundColor Yellow
try {
    # Esperar a que Docker esté listo
    Start-Sleep -Seconds 5
    
    # Construir y levantar contenedores
    docker compose up --build -d
    if (-not $?) { Handle-Error "Error al iniciar los contenedores" }
    
    # Esperar a que los servicios estén listos
    Write-Host "`nEsperando a que los servicios esten listos..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30
    
    # Verificar que los contenedores están funcionando
    $containers = docker ps --format "{{.Names}}"
    if (-not ($containers -match "daw-app" -and $containers -match "daw-db" -and $containers -match "daw-phpmyadmin")) {
        Handle-Error "No todos los contenedores estan en ejecucion"
    }
} catch {
    Handle-Error "Error en la configuracion de Docker: $_"
}

Write-Host "`nInstalacion completada con exito!" -ForegroundColor Green
Write-Host "`nPuedes acceder a:"
Write-Host "Frontend: http://localhost:5173" -ForegroundColor Cyan
Write-Host "Backend API: http://localhost:8000" -ForegroundColor Cyan
Write-Host "phpMyAdmin: http://localhost:8080" -ForegroundColor Cyan

# Mostrar los logs en tiempo real
Write-Host "`nMostrando logs de los contenedores..." -ForegroundColor Yellow
docker compose logs -f
