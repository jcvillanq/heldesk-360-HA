#!/bin/bash
# ===================================================
# HelpDesk 360 - Script de inicio (Docker Swarm)
# ===================================================
# Uso: ./start.sh
#
# Este script:
#   1. Verifica que Docker y Swarm están corriendo
#   2. Carga las variables de entorno del .env
#   3. Despliega el stack en Docker Swarm
#   4. Espera a que los servicios arranquen
#   5. Muestra las URLs de acceso
#
# NOTA: Solo necesitas ejecutar este script cuando:
#   - Despliegas por primera vez
#   - Cambias el docker-compose.yml
#   - Cambias el .env
#
# Si el servidor se reinicia, Swarm levanta los
# servicios automáticamente. No necesitas hacer nada.
# ===================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

DOMAIN="34.68.58.42.nip.io"
PROJECT_DIR="$HOME/heldesk-360-HA"
STACK_NAME="hd360"

echo ""
echo -e "${CYAN}${BOLD}====================================================${NC}"
echo -e "${CYAN}${BOLD}    HELPDESK 360 - Despliegue en Docker Swarm        ${NC}"
echo -e "${CYAN}${BOLD}====================================================${NC}"
echo ""

# --- Paso 1: Verificar Docker y Swarm ---
echo -e "${YELLOW}[1/5]${NC} Verificando Docker y Swarm..."
if ! command -v docker &> /dev/null; then
    echo -e "${RED}ERROR: Docker no está instalado.${NC}"
    exit 1
fi
if ! docker info 2>/dev/null | grep -q "Swarm: active"; then
    echo -e "${RED}ERROR: Docker Swarm no está activo en este nodo.${NC}"
    exit 1
fi
echo -e "${GREEN}  ✓ Docker Swarm activo${NC}"

# --- Paso 2: Verificar proyecto ---
echo -e "${YELLOW}[2/5]${NC} Verificando proyecto..."
cd "$PROJECT_DIR" || { echo -e "${RED}ERROR: No se encuentra $PROJECT_DIR${NC}"; exit 1; }
[ -f "docker-compose.yml" ] || { echo -e "${RED}ERROR: Falta docker-compose.yml${NC}"; exit 1; }
[ -f ".env" ] || { echo -e "${RED}ERROR: Falta .env${NC}"; exit 1; }
echo -e "${GREEN}  ✓ Proyecto encontrado${NC}"

# --- Paso 3: Cargar variables de entorno ---
echo -e "${YELLOW}[3/5]${NC} Cargando variables de entorno..."
export $(grep -v '^#' .env | grep -v '^$' | xargs)
echo -e "${GREEN}  ✓ Variables cargadas desde .env${NC}"

# --- Paso 4: Desplegar stack ---
echo -e "${YELLOW}[4/5]${NC} Desplegando stack en Swarm..."
echo ""
docker stack deploy -c docker-compose.yml ${STACK_NAME} 2>&1
echo ""

# --- Paso 5: Verificar servicios ---
echo -e "${YELLOW}[5/5]${NC} Esperando a que los servicios arranquen..."
sleep 15
echo ""
docker service ls --format "table {{.Name}}\t{{.Replicas}}\t{{.Image}}"
echo ""

echo -e "${CYAN}${BOLD}====================================================${NC}"
echo -e "${CYAN}${BOLD}       URLs de Acceso (HTTPS)                        ${NC}"
echo -e "${CYAN}${BOLD}====================================================${NC}"
echo ""
echo -e "  ${BOLD}GLPI (Helpdesk):${NC}         ${GREEN}https://infra-glpi.${DOMAIN}${NC}"
echo -e "  ${BOLD}Grafana:${NC}                 ${GREEN}https://infra-grafana.${DOMAIN}${NC}"
echo -e "  ${BOLD}Prometheus:${NC}              ${GREEN}https://infra-prometheus.${DOMAIN}${NC}"
echo -e "  ${BOLD}Traefik:${NC}                 ${GREEN}https://infra-traefik.${DOMAIN}${NC}"
echo -e "  ${BOLD}phpLDAPadmin:${NC}            ${GREEN}https://infra-ldap.${DOMAIN}${NC}"
echo -e "  ${BOLD}Alertmanager:${NC}            ${GREEN}https://infra-alertmanager.${DOMAIN}${NC}"
echo ""
echo -e "${CYAN}${BOLD}====================================================${NC}"
echo -e "${CYAN}${BOLD}       Comandos Útiles (Swarm)                       ${NC}"
echo -e "${CYAN}${BOLD}====================================================${NC}"
echo ""
echo -e "  Ver servicios:       ${BOLD}docker service ls${NC}"
echo -e "  Ver réplicas GLPI:   ${BOLD}docker service ps hd360_glpi${NC}"
echo -e "  Ver logs:            ${BOLD}docker service logs hd360_glpi${NC}"
echo -e "  Escalar GLPI:        ${BOLD}docker service scale hd360_glpi=3${NC}"
echo -e "  Estado del cluster:  ${BOLD}docker node ls${NC}"
echo -e "  Parar todo:          ${BOLD}docker stack rm hd360${NC}"
echo ""
echo -e "${YELLOW}Si el servidor se reinicia, los servicios se levantan"
echo -e "solos. Solo ejecuta este script si cambias compose o .env${NC}"
echo ""
