# ClauNet Optimizador Windows 10/11

**Herramienta de optimización para equipos Windows 10/11 — desarrollada por [ClauNet](https://claunet.cl)**

---

## ¿Qué hace?

GUI en PowerShell compilada a `.exe` que permite optimizar equipos Windows 10/11 de forma rápida, segura y controlada. Ideal para técnicos en servicio y mantenimiento de PCs.

### Funciones incluidas (v1.5)

- **General** — Punto de restauración, perfil visual, plan de energía, bloquear actualización a Win11
- **Disco** — Limpieza de temporales, Cleanmgr, caché DNS, caché Windows Update, miniaturas
- **Apps** — Desinstalación de apps preinstaladas (bloatware), OneDrive, etc.
- **Extras** — Verificar activación Windows, top 5 procesos por RAM, uptime, SFC scan
- **Inicio** — Gestor de programas de inicio (habilitar/deshabilitar)
- **Privacidad** — Telemetría, Cortana, ID de publicidad, historial de actividad, sugerencias, ubicación

### Funciones adicionales

- ✅ **Marcar todo lo recomendado** — selecciona las opciones más seguras con un clic
- 📋 **Generar informe del equipo** — exporta un `.txt` al escritorio con info del sistema
- 🔄 Reiniciar / Cerrar desde la misma ventana

---

## Requisitos

- Windows 10 / Windows 11
- PowerShell 5.1 o superior
- Ejecutar como **Administrador**

---

## Uso

### Opción 1 — Ejecutable compilado

Descarga el `.exe` desde [Releases](../../releases) y ejecútalo como Administrador.

### Opción 2 — Desde el script fuente

```powershell
# Ejecutar en PowerShell como Administrador
.\Optimizar-Win10-GUI-v1.5.ps1
```

### Compilar a .exe (requiere ps2exe)

```powershell
# Instalar ps2exe si no lo tienes
Install-Module ps2exe -Scope CurrentUser

# Compilar
Invoke-ps2exe -inputFile "Optimizar-Win10-GUI-v1.5.ps1" `
              -outputFile "ClauNet-Optimizador-v1.5.exe" `
              -iconFile "claunet.ico" `
              -noConsole -requireAdmin
```

---

## Capturas

*Próximamente*

---

## Versiones

| Versión | Descripción |
|---------|-------------|
| v1.5 | Tab Privacidad, Marcar recomendados, Informe del equipo, UI moderna (bordes redondeados, tabs pill) |
| v1.0 | Versión inicial |

---

## Créditos

Desarrollado por **Claudio Torres** — [ClauNet](https://claunet.cl)  
Soporte IT · Desarrollo web · Cañete, Chile

---

> ⚠️ Esta herramienta modifica configuraciones del sistema. Se recomienda crear un punto de restauración antes de aplicar cambios (opción incluida en la herramienta).
