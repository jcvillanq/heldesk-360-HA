# 🎫 HelpDesk 360

> **Plataforma integral de gestión de soporte IT con infraestructura empresarial dockerizada, alta disponibilidad, monitorización en tiempo real e inteligencia artificial.**

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![Docker](https://img.shields.io/badge/Docker-Swarm-2496ED?logo=docker&logoColor=white)
![Platform](https://img.shields.io/badge/Cloud-GCP-4285F4?logo=google-cloud&logoColor=white)

---

## 📋 Tabla de Contenidos

- [Descripción](#-descripción)
- [Arquitectura](#-arquitectura)
- [Stack Tecnológico](#-stack-tecnológico)
- [Estructura del Repositorio](#-estructura-del-repositorio)
- [Requisitos Previos](#-requisitos-previos)
- [Despliegue Rápido](#-despliegue-rápido)
- [Servicios y URLs](#-servicios-y-urls)
- [Monitorización](#-monitorización)
- [Equipo](#-equipo)

---

## 📖 Descripción

**HelpDesk 360** es un Trabajo de Fin de Grado (TFG) del ciclo ASIR que despliega una plataforma completa de gestión de incidencias y soporte técnico basada en **GLPI**, orquestada con **Docker Swarm** en un entorno cloud real sobre **Google Cloud Platform**.

El proyecto va más allá de instalar un software de ticketing: su valor reside en la infraestructura empresarial construida para sostenerlo, protegerlo, monitorizarlo y garantizar su disponibilidad continua, complementada con un módulo de **inteligencia artificial** que asiste tanto a usuarios finales como a técnicos.

### Características principales

| Característica | Descripción |
|---|---|
| 🐳 **Dockerización completa** | Todos los servicios contenerizados y orquestados con Docker Swarm |
| ⚡ **Alta disponibilidad** | Cluster multi-nodo con failover automático y balanceo de carga |
| 🔒 **Seguridad multicapa** | TLS automático, firewall, VPN WireGuard y autenticación centralizada LDAP |
| 📊 **Monitorización** | Stack completo Prometheus + Grafana + Alertmanager con dashboards en tiempo real |
| 🤖 **Inteligencia Artificial** | Chatbot para usuarios y asistente de clasificación para técnicos |
| 🔄 **CI/CD** | Pipeline GitHub Actions con lint, validación y despliegue automático |
| 💾 **Backups** | Copias de seguridad automatizadas con cifrado GPG y almacenamiento externo |

---

## 🏗 Arquitectura

```
Internet
    │
    ▼
[IP Pública: 34.16.3.100]
    │
    ▼
┌─────────────────────────────────────────────────────────┐
│                  DOCKER SWARM CLUSTER                   │
│                                                         │
│  ┌──────────────────────┐  ┌──────────────────────────┐ │
│  │  infraticket-server01│  │  infraticket-server02    │ │
│  │  (Manager - 10.128.0.2) │  (Worker - 10.128.0.3)  │ │
│  │                      │  │                          │ │
│  │  • Traefik (proxy)   │  │  • GLPI (réplica)        │ │
│  │  • GLPI (réplica)    │  │  • MariaDB               │ │
│  │  • Prometheus        │  │  • OpenLDAP              │ │
│  │  • Grafana           │  │  • Middleware IA          │ │
│  │  • Alertmanager      │  │                          │ │
│  └──────────────────────┘  └──────────────────────────┘ │
│                                                         │
│  ═══ Red frontend (overlay) ════════════════════════    │
│  ═══ Red backend  (overlay) ════════════════════════    │
│  ═══ Red monitoring (overlay) ══════════════════════    │
└─────────────────────────────────────────────────────────┘
```

### Redes Docker

| Red | Subred | Servicios |
|---|---|---|
| `frontend` | 172.20.0.0/24 | Traefik, GLPI web |
| `backend` | 172.21.0.0/24 | MariaDB, OpenLDAP, |
| `monitoring` | 172.22.0.0/24 | Prometheus, Grafana, exporters |
| `VPN WireGuard` | 10.10.0.0/24 | Acceso administración |

---

## 🛠 Stack Tecnológico

### Core
![GLPI](https://img.shields.io/badge/GLPI-10.x-orange?logo=data:image/svg+xml;base64,)
![MariaDB](https://img.shields.io/badge/MariaDB-10.x-003545?logo=mariadb&logoColor=white)
![OpenLDAP](https://img.shields.io/badge/OpenLDAP-1.5.0-lightblue)
![PHP](https://img.shields.io/badge/PHP-8.x-777BB4?logo=php&logoColor=white)

### Infraestructura
![Docker](https://img.shields.io/badge/Docker-Swarm-2496ED?logo=docker&logoColor=white)
![Traefik](https://img.shields.io/badge/Traefik-v2.11-24A1C1?logo=traefikproxy&logoColor=white)
![GCP](https://img.shields.io/badge/GCP-us--central1-4285F4?logo=google-cloud&logoColor=white)

### Monitorización
![Prometheus](https://img.shields.io/badge/Prometheus-latest-E6522C?logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-latest-F46800?logo=grafana&logoColor=white)
![Alertmanager](https://img.shields.io/badge/Alertmanager-latest-E6522C)


## 📁 Estructura del Repositorio

```
heldesk-360-HA/
├── app/
│   ├── dashboard/          # Portal web (Laravel - Antonio DAW)
│   └── glpi-config/        # Configuración y plugins de GLPI
├── docs/                   # Documentación técnica del proyecto
├── infra/
│   ├── dockerfiles/        # Dockerfiles personalizados
│   ├── swarm/              # Configuración del cluster Swarm
│   └── traefik/            # Configuración de Traefik y TLS
├── monitoring/
│   ├── alertmanager/       # Reglas y configuración de alertas
│   ├── backup-scripts/     # Scripts de backup automatizado
│   ├── grafana/            # Dashboards y datasources de Grafana
│   └── prometheus/         # Scrape configs y reglas de Prometheus
├── security/               # Hardening, Fail2ban, WireGuard
├── .env.example            # Plantilla de variables de entorno
├── .gitignore
├── docker-compose.yml      # Stack principal de Docker Swarm
└── README.md
```

---

## ✅ Requisitos Previos

- Docker Engine 24.x+ con Docker Swarm inicializado
- Dos nodos Linux (Ubuntu 22.04 LTS recomendado)
- Acceso SSH entre nodos
- Dominio o IP pública accesible (se usa `nip.io` para desarrollo)

---

## 🚀 Despliegue Rápido

### 1. Clonar el repositorio

```bash
git clone https://github.com/jcvillanq/heldesk-360-HA.git
cd heldesk-360-HA
```

### 2. Configurar variables de entorno

```bash
cp .env.example .env
nano .env   # Editar con los valores de tu entorno
```

Variables esenciales en `.env`:

```env
DOMAIN=34.16.3.100.nip.io          # Dominio o IP pública
MYSQL_ROOT_PASSWORD=<contraseña>
MYSQL_PASSWORD=<contraseña>
LDAP_ADMIN_PASSWORD=<contraseña>
TRAEFIK_ACME_EMAIL=tu@email.com
```

### 3. Exportar variables y desplegar

> ⚠️ **Importante:** Docker Swarm no lee `.env` automáticamente. Hay que exportar las variables manualmente antes de cada despliegue.

```bash
set -a; source .env; set +a
docker stack deploy -c docker-compose.yml hd360
```

### 4. Verificar el despliegue

```bash
docker stack services hd360
docker stack ps hd360
```

### Acceso inicial a GLPI

> ⚠️ Durante el wizard de instalación, escala GLPI a **1 réplica** para evitar problemas de sesión:

```bash
docker service scale hd360_glpi=1
# Completa la instalación web...
docker service scale hd360_glpi=2
```

---

## 🌐 Servicios y URLs

| Servicio | URL | Credenciales por defecto |
|---|---|---|
| **GLPI** | `https://infra-glpi.34.16.3.100.nip.io` | `glpi` / `glpi` *(cambiar en primer acceso)* |
| **Traefik Dashboard** | `https://infra-traefik.34.16.3.100.nip.io` | Solo desde VPN |
| **Grafana** | `https://infra-grafana.34.16.3.100.nip.io` | LDAP / `admin` |
| **Prometheus** | `https://infra-prometheus.34.16.3.100.nip.io` | Solo desde VPN |
| **phpLDAPadmin** | `https://infra-ldap.34.16.3.100.nip.io` | Solo desde VPN |
| **Alertmanager** | `https://infra-alertmanager.34.16.3.100.nip.io` | Solo desde VPN |

> 🔒 Los paneles de administración (Traefik, phpLDAPadmin, Prometheus, Alertmanager) están restringidos por VPN WireGuard.

---

### Secretos necesarios en GitHub

```
SSH_HOST          → IP pública del servidor manager
SSH_USERNAME      → jcvillan77
SSH_PRIVATE_KEY   → Clave privada (~/.ssh/github_actions_rsa)
```

---

## 📊 Monitorización

El stack de monitorización incluye:

- **Node Exporter** → Métricas del sistema operativo (CPU, RAM, disco, red)
- **cAdvisor** → Métricas de contenedores Docker
- **Prometheus** → Recolección y almacenamiento de métricas
- **Grafana** → Dashboards interactivos y visualización
- **Alertmanager** → Gestión y enrutamiento de alertas (email + Telegram)

### Dashboards disponibles

- Infraestructura general (nodos del cluster)
- Estado de contenedores Docker
- Base de datos MariaDB


## 👥 Equipo

| Miembro | Ciclo | Rol |
|---|---|---|
| **Juan Carlos. Villan** | ASIR | P1 — Infraestructura, Docker Swarm, CI/CD, Traefik |
| **Jose Manuel** | ASIR | P2 — LDAP/GLPI, configuración y documentación |
| **Ramón** | ASIR | P3 — Monitorización, seguridad y backups |
| **Antonio** | DAW | P4 — Portal Laravel y frontend |

---

## 📄 Licencia

Este proyecto se distribuye bajo la licencia **GPL v3**. Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

<p align="center">
  Trabajo de Fin de Grado · ASIR × 3 + DAW × 1 · 2025-2026
</p>
