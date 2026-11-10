<#
.SINOPSIS
    Interfaz grafica (Windows Forms) para optimizar equipos Windows 10/11 de bajos recursos.
    v1.5 - UI: StatusStrip, iconos Unicode en botones, tooltips, link 'Abrir log', botones
           Todo/Ninguno en Apps. Nuevas funciones: flush DNS, cache Windows Update,
           miniaturas, sfc /scannow, desactivar notificaciones/centro de actividades.
           Diagnostico: top 5 procesos RAM y uptime del sistema.
    v1.4 - Agrega: icono 'Este equipo' en el escritorio (restauracion via registro)
    v1.3 - Agrega: verificacion de Defender/activacion, limpieza de puntos de restauracion
    antiguos, deteccion Win10/Win11, desactivar OneDrive, listado completo de apps de inicio,
    lanzador de AdwCleaner, checklist de apps preinstaladas a quitar, panel de info del
    equipo, logo en encabezado y pie de ventana con links.

.NOTAS
    - Requiere ejecutarse como Administrador.
    - No desactiva Windows Update ni Windows Defender (solo informa su estado).
    - Necesita claunet.ico y claunet_header.png en la misma carpeta que el script/.exe.

.AUTOR
    ClauNet - Soporte IT y desarrollo web
    Claudio Torres (Clatto)
    claunet.cl | claudio@claunet.cl
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ---------- Recursos incrustados (icono y logo, sin depender de archivos externos) ----------
$IconoBase64 = "AAABAAEAEBAAAAAAIACuAgAAFgAAAIlQTkcNChoKAAAADUlIRFIAAAAQAAAAEAgGAAAAH/P/YQAAAnVJREFUeJyNk0+IlWUUxn/nfd/7b+5tbKZ0yCiEisAUtEVECDOLgdRAXDRB6LogWpQYLlp8XlciiAvbOC6DoAlctJBalY4LVxaRupRy5A6aU033fve73/e+57hQUScX8yyfw+F54PwOrFsmgKx1nzTMZPoofgb02hvI1qtYF8iOQldEAeYWzH/3gaT1Bz/Q7vPWWNPmsQZmgsCBr3lm4PWICW9r1OVRX0+Yr6+6oCdTZGdSVmNhZxc/C1+RmaMrKgDTP1nYdAcrcv2h+ZybLVZBAoz+1UFSBn7MbSoHoAauAcOV6tDlL+qn5hbMy3Rm4UJX4t750Y7Qrv9SDqlUcaZYXhEUCErCcFUi4XGx0OU7wz9f+aO7ZRQudCW+e6Z6T1ru9KggaSIMS6RKsG0KSwl+7+HLCA2HtwhJ6Yw3J1oghcyeyV/2vnHV1V2n7GNlQl7fCEv/wLE94AQ++gbefAl+vQllRCVAzPXc83Lxw2Ban6HmOsV/RIEwKOCdLXB9Gb78Huoenm3Cvu3w202IFY4Ss+Dev5XvOhsq0xsWPTEhKaENhzv98/07VRFRBQ926FvwgmCYGhGoaaTtLn5SXywHOu9aePE450j1gGhCgqBB0KhIewxpNUk4hBa1cqCLw9XbPzowufS5/7j/d9zfbOiV1iR+NKJsj+lg4wu48Umcd3p7ckLvTmzG12q6NOqnT/Oh29ubfzG/D9IDKN7K/hqvOhtmV3p649XXZKao/OF+DlWejrc66XxF2LHSKy8vnWrfWkskcwvm1+I7dbDXnjrYa/+P68zCE8uPEDeZWzBPZi7LzD224MjMPZyt830eVnxa0iPdA+SLMEjNbAprAAAAAElFTkSuQmCC"
$LogoBase64 = "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"

function Convertir-Base64AIcono($b64) {
    try {
        $bytes = [Convert]::FromBase64String($b64)
        $ms = New-Object System.IO.MemoryStream(, $bytes)
        return New-Object System.Drawing.Icon($ms)
    } catch { return $null }
}

function Convertir-Base64AImagen($b64) {
    try {
        $bytes = [Convert]::FromBase64String($b64)
        $ms = New-Object System.IO.MemoryStream(, $bytes)
        return [System.Drawing.Image]::FromStream($ms)
    } catch { return $null }
}

# ---------- Verificacion de administrador ----------
$esAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $esAdmin) {
    [System.Windows.Forms.MessageBox]::Show("Este programa debe ejecutarse como Administrador.`nUsa el archivo .bat, que lo hace automaticamente.", "Permisos insuficientes", "OK", "Error")
    exit 1
}

$logPath = "$env:PUBLIC\Documents\ClauNet_Optimizacion_Log.txt"
function Log($mensaje) {
    $linea = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $mensaje"
    Add-Content -Path $logPath -Value $linea
    $txtLog.AppendText("$linea`r`n")
}

Add-Content -Path $logPath -Value "=================================================="
Add-Content -Path $logPath -Value "ClauNet - Optimizador Windows 10/11 v1.5 | claunet.cl"
Add-Content -Path $logPath -Value "Ejecutado el $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Add-Content -Path $logPath -Value "=================================================="

# ==========================================================
# FUNCIONES DE UTILIDAD / METRICAS
# ==========================================================

function Obtener-Metricas {
    $resultado = [PSCustomObject]@{ EspacioLibreGB = $null; RamLibreGB = $null }
    try {
        $drive = Get-PSDrive -Name C -ErrorAction Stop
        $resultado.EspacioLibreGB = [math]::Round($drive.Free / 1GB, 2)
    } catch {}
    try {
        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
        $resultado.RamLibreGB = [math]::Round(($os.FreePhysicalMemory * 1KB) / 1GB, 2)
    } catch {}
    return $resultado
}

function Obtener-InfoEquipo {
    $resultado = [PSCustomObject]@{ Windows = "Desconocido"; RAM_Texto = "Desconocido"; RAM_GB = $null; CPU = "Desconocido" }
    try {
        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
        $resultado.Windows = "$($os.Caption) (Build $($os.BuildNumber))"
    } catch {}
    try {
        $cs = Get-CimInstance Win32_ComputerSystem -ErrorAction Stop
        $ramGB = [math]::Round($cs.TotalPhysicalMemory / 1GB, 1)
        $resultado.RAM_GB = $ramGB
        $resultado.RAM_Texto = "$ramGB GB"
    } catch {}
    try {
        $cpu = Get-CimInstance Win32_Processor -ErrorAction Stop | Select-Object -First 1 -ExpandProperty Name
        $resultado.CPU = $cpu.Trim()
    } catch {}
    return $resultado
}

function Detectar-TipoDisco {
    try {
        $tipo = Get-PhysicalDisk | Select-Object -First 1 -ExpandProperty MediaType -ErrorAction Stop
        if ($tipo -eq "SSD" -or $tipo -eq "HDD") { return $tipo }
        return "Desconocido"
    } catch { return "Desconocido" }
}

function Detectar-TipoEquipo {
    try {
        $chassis = (Get-CimInstance -ClassName Win32_SystemEnclosure -ErrorAction Stop).ChassisTypes | Select-Object -First 1
        $tiposPortatil = @(8, 9, 10, 11, 12, 14, 18, 21, 30, 31, 32)
        if ($tiposPortatil -contains $chassis) { return "Portatil" }
        return "Escritorio"
    } catch { return "Desconocido" }
}

function Detectar-VersionWindows {
    try {
        $build = [System.Environment]::OSVersion.Version.Build
        if ($build -ge 22000) { return "Windows 11" }
        return "Windows 10"
    } catch { return "Desconocido" }
}

function Verificar-SaludDisco {
    try {
        $disco = Get-PhysicalDisk | Select-Object -First 1
        return $disco.HealthStatus
    } catch { return "Desconocido" }
}

function Verificar-Defender {
    try {
        $svc = Get-Service -Name WinDefend -ErrorAction Stop
        if ($svc.Status -eq 'Running') { return "Activo" }
        return "INACTIVO (Estado: $($svc.Status))"
    } catch { return "No se pudo determinar" }
}

function Verificar-Activacion {
    # Se reporta el texto crudo de slmgr, sin interpretar - los mensajes varian por
    # idioma/edicion y no quiero arriesgar una lectura equivocada de "activado o no".
    try {
        $resultado = cscript //nologo "$env:SystemRoot\System32\slmgr.vbs" /xpr 2>$null
        if ($resultado) { return ($resultado -join " ").Trim() }
        return "No se pudo determinar"
    } catch { return "No se pudo determinar" }
}

# ==========================================================
# FUNCIONES DE OPTIMIZACION
# ==========================================================

function Optimizar-Temporales {
    Log "Limpiando archivos temporales..."
    $rutas = @("$env:TEMP\*", "C:\Windows\Temp\*", "C:\Windows\Prefetch\*", "C:\Windows\SoftwareDistribution\Download\*")
    foreach ($r in $rutas) { Remove-Item -Path $r -Recurse -Force -ErrorAction SilentlyContinue }
    try { Clear-RecycleBin -Force -ErrorAction SilentlyContinue } catch {}
    Log "Temporales y papelera limpiados."
}

function Aplicar-PerfilVisual-Taller {
    Log "Aplicando perfil visual de rendimiento..."
    try {
        # 1. VisualFXSetting = 2 = Mejor rendimiento (clave principal que Windows usa para leer la configuracion)
        $rutaVFX = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
        if (-not (Test-Path $rutaVFX)) { New-Item -Path $rutaVFX -Force | Out-Null }
        New-ItemProperty -Path $rutaVFX -Name "VisualFXSetting" -PropertyType DWord -Value 2 -Force | Out-Null

        # 2. UserPreferencesMask para mejor rendimiento (desactiva animaciones, mantiene ClearType)
        $rutaDesktop = "HKCU:\Control Panel\Desktop"
        $bytesMask = [byte[]](0x90,0x12,0x01,0x80,0x10,0x00,0x00,0x00)
        New-ItemProperty -Path $rutaDesktop -Name "UserPreferencesMask" -PropertyType Binary -Value $bytesMask -Force | Out-Null

        # 3. Efectos individuales
        New-ItemProperty -Path $rutaDesktop -Name "DragFullWindows" -PropertyType String -Value "0" -Force | Out-Null   # No mostrar contenido al arrastrar ventana
        New-ItemProperty -Path $rutaDesktop -Name "FontSmoothing" -PropertyType String -Value "2" -Force | Out-Null     # Mantener ClearType (legibilidad)
        New-ItemProperty -Path $rutaDesktop -Name "FontSmoothingType" -PropertyType DWord -Value 2 -Force | Out-Null
        New-ItemProperty -Path $rutaDesktop -Name "MenuShowDelay" -PropertyType String -Value "0" -Force | Out-Null     # Menus instantaneos

        $rutaWindowMetrics = "HKCU:\Control Panel\Desktop\WindowMetrics"
        if (-not (Test-Path $rutaWindowMetrics)) { New-Item -Path $rutaWindowMetrics -Force | Out-Null }
        New-ItemProperty -Path $rutaWindowMetrics -Name "MinAnimate" -PropertyType String -Value "0" -Force | Out-Null  # Sin animacion al minimizar/maximizar

        $rutaAdvanced = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        New-ItemProperty -Path $rutaAdvanced -Name "TaskbarAnimations"  -PropertyType DWord -Value 0 -Force | Out-Null  # Sin animaciones en barra de tareas
        New-ItemProperty -Path $rutaAdvanced -Name "ListviewShadow"      -PropertyType DWord -Value 0 -Force | Out-Null  # Sin sombra bajo el cursor
        New-ItemProperty -Path $rutaAdvanced -Name "ListviewAlphaSelect" -PropertyType DWord -Value 0 -Force | Out-Null  # Seleccion solida (sin translucido)

        # 4. Aplicar cambios al perfil de usuario inmediatamente (sin cerrar sesion)
        Start-Process -FilePath "rundll32.exe" -ArgumentList "user32.dll,UpdatePerUserSystemParameters ,1,True" -Wait -ErrorAction SilentlyContinue

        Log "Perfil visual de rendimiento aplicado correctamente."
    } catch { Log "Error al aplicar el perfil visual: $($_.Exception.Message)" }
}

function Optimizar-PlanEnergia {
    Log "Configurando plan de energia 'Equilibrado'..."
    try {
        powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
        Log "Plan de energia configurado."
    } catch { Log "Error al configurar plan de energia." }
}

function Optimizar-Servicios {
    Log "Ajustando servicios no criticos a modo Manual..."
    $servicios = @("DiagTrack", "dmwappushservice", "MapsBroker", "RemoteRegistry", "Fax")
    foreach ($srv in $servicios) {
        try {
            $s = Get-Service -Name $srv -ErrorAction SilentlyContinue
            if ($s) {
                Set-Service -Name $srv -StartupType Manual -ErrorAction SilentlyContinue
                if ($s.Status -eq 'Running') { Stop-Service -Name $srv -Force -ErrorAction SilentlyContinue }
                Log "Servicio '$srv' ajustado a Manual."
            }
        } catch { Log "No se pudo ajustar el servicio '$srv'." }
    }
}

function Optimizar-SysMain {
    $tipoDisco = Get-PhysicalDisk | Select-Object -First 1 -ExpandProperty MediaType -ErrorAction SilentlyContinue
    if ($tipoDisco -eq "HDD") {
        try {
            Set-Service -Name "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue
            Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
            Log "SysMain (Superfetch) desactivado (disco HDD detectado)."
        } catch { Log "No se pudo desactivar SysMain." }
    } else {
        Log "Disco no es HDD (o no se pudo determinar) - SysMain se mantiene activo."
    }
}

function Optimizar-LimpiezaDisco {
    Log "Lanzando limpieza de disco nativa (cleanmgr)..."
    try {
        Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -WindowStyle Hidden -ErrorAction SilentlyContinue
        Log "cleanmgr lanzado en segundo plano."
    } catch { Log "cleanmgr no disponible." }
}

function Bloquear-ActualizacionWin11 {
    Log "Bloqueando oferta de actualizacion a Windows 11 (se mantiene el equipo en Windows 10)..."
    try {
        $ruta = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
        if (-not (Test-Path $ruta)) { New-Item -Path $ruta -Force | Out-Null }
        New-ItemProperty -Path $ruta -Name "TargetReleaseVersion" -PropertyType DWord -Value 1 -Force | Out-Null
        New-ItemProperty -Path $ruta -Name "TargetReleaseVersionInfo" -PropertyType String -Value "22H2" -Force | Out-Null
        New-ItemProperty -Path $ruta -Name "ProductVersion" -PropertyType String -Value "Windows 10" -Force | Out-Null
        Log "Politica aplicada: TargetReleaseVersion=Windows 10 22H2."
    } catch { Log "Error al bloquear actualizacion a Windows 11: $($_.Exception.Message)" }
}

function Crear-PuntoRestauracion {
    Log "Creando punto de restauracion..."
    try {
        Enable-ComputerRestore -Drive "$env:SystemDrive\" -ErrorAction SilentlyContinue
        Checkpoint-Computer -Description "ClauNet_PreOptimizacion" -RestorePointType "MODIFY_SETTINGS"
        Log "Punto de restauracion creado."
    } catch { Log "No se pudo crear punto de restauracion: $($_.Exception.Message)" }
}

function Limpiar-PuntosRestauracionAntiguos {
    Log "Limitando espacio reservado para puntos de restauracion antiguos..."
    try {
        vssadmin resize shadowstorage /for=$env:SystemDrive /on=$env:SystemDrive /maxsize=5GB | Out-Null
        Log "Espacio de shadow storage limitado a 5GB (purga automaticamente los puntos mas viejos si excedian ese limite)."
    } catch { Log "No se pudo limitar el espacio de puntos de restauracion: $($_.Exception.Message)" }
}

function Verificar-TRIM {
    Log "Verificando estado de TRIM (SSD)..."
    try {
        $estado = fsutil behavior query DisableDeleteNotify
        Log "Resultado: $estado"
        if ($estado -match "DisableDeleteNotify\s*=\s*1") {
            fsutil behavior set DisableDeleteNotify 0 | Out-Null
            Log "TRIM estaba desactivado - se reactivo correctamente."
        } else {
            Log "TRIM ya estaba activo. Sin cambios necesarios."
        }
    } catch { Log "No se pudo verificar/activar TRIM: $($_.Exception.Message)" }
}

function Desactivar-Hibernacion {
    Log "Desactivando hibernacion para liberar espacio en disco..."
    try {
        powercfg /hibernate off
        Log "Hibernacion desactivada (libera espacio equivalente a la RAM instalada)."
    } catch { Log "No se pudo desactivar hibernacion: $($_.Exception.Message)" }
}

function Desactivar-UltimoAcceso {
    Log "Desactivando registro de 'ultimo acceso' NTFS (reduce escrituras en SSD)..."
    try {
        fsutil behavior set disablelastaccess 1 | Out-Null
        Log "Marca de ultimo acceso NTFS desactivada."
    } catch { Log "No se pudo desactivar marca de ultimo acceso: $($_.Exception.Message)" }
}

function Mostrar-IconoEsteEquipo {
    Log "Mostrando icono 'Este equipo' en el escritorio..."
    try {
        $rutaIconos = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
        if (-not (Test-Path $rutaIconos)) { New-Item -Path $rutaIconos -Force | Out-Null }
        New-ItemProperty -Path $rutaIconos -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -PropertyType DWord -Value 0 -Force | Out-Null
        # Refrescar escritorio via API sin necesidad de reiniciar Explorer
        $code = '[DllImport("shell32.dll")] public static extern void SHChangeNotify(int wEventId, int uFlags, IntPtr dwItem1, IntPtr dwItem2);'
        $shell32 = Add-Type -MemberDefinition $code -Namespace WinAPI -Name Shell32Refresh -PassThru -ErrorAction SilentlyContinue
        if ($shell32) { $shell32::SHChangeNotify(0x8000000, 0, [IntPtr]::Zero, [IntPtr]::Zero) }
        Log "Icono 'Este equipo' activado. El icono aparece en el escritorio de inmediato."
    } catch { Log "Error al mostrar icono 'Este equipo': $($_.Exception.Message)" }
}

function Desactivar-Notificaciones {
    Log "Desactivando Centro de actividades y notificaciones de apps..."
    try {
        $rutaExp = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
        if (-not (Test-Path $rutaExp)) { New-Item -Path $rutaExp -Force | Out-Null }
        New-ItemProperty -Path $rutaExp -Name "DisableNotificationCenter" -PropertyType DWord -Value 1 -Force | Out-Null
        $rutaNotif = "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications"
        if (-not (Test-Path $rutaNotif)) { New-Item -Path $rutaNotif -Force | Out-Null }
        New-ItemProperty -Path $rutaNotif -Name "ToastEnabled" -PropertyType DWord -Value 0 -Force | Out-Null
        Log "Centro de actividades y notificaciones desactivados. Requiere cerrar sesion para aplicar."
    } catch { Log "Error al desactivar notificaciones: $($_.Exception.Message)" }
}

function Limpiar-CacheDNS {
    Log "Limpiando cache DNS del sistema..."
    try {
        ipconfig /flushdns | Out-Null
        Log "Cache DNS limpiado correctamente."
    } catch { Log "Error al limpiar cache DNS: $($_.Exception.Message)" }
}

function Limpiar-CacheWindowsUpdate {
    Log "Limpiando cache de Windows Update (SoftwareDistribution\Download)..."
    try {
        Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
        $rutaWU = "C:\Windows\SoftwareDistribution\Download"
        Remove-Item -Path "$rutaWU\*" -Recurse -Force -ErrorAction SilentlyContinue
        Start-Service -Name wuauserv -ErrorAction SilentlyContinue
        Log "Cache de Windows Update limpiado. Servicio wuauserv reiniciado."
    } catch { Log "Error al limpiar cache de Windows Update: $($_.Exception.Message)" }
}

function Limpiar-Miniaturas {
    Log "Eliminando cache de miniaturas (thumbcache)..."
    try {
        $rutaThumb = "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"
        $archivos = Get-Item "$rutaThumb\thumbcache_*.db" -ErrorAction SilentlyContinue
        if ($archivos) {
            $archivos | Remove-Item -Force -ErrorAction SilentlyContinue
            Log "Cache de miniaturas eliminado ($($archivos.Count) archivo(s)). Se regenera automaticamente al navegar carpetas."
        } else {
            Log "No se encontraron archivos thumbcache (ya limpios o en uso por Explorer)."
        }
    } catch { Log "Error al limpiar miniaturas: $($_.Exception.Message)" }
}

function Ejecutar-SFC {
    Log "Iniciando verificacion de integridad del sistema (sfc /scannow) en segundo plano..."
    try {
        Start-Process -FilePath "sfc.exe" -ArgumentList "/scannow" -WindowStyle Hidden
        Log "SFC iniciado. Puede tardar varios minutos. Ver resultado en: C:\Windows\Logs\CBS\CBS.log"
    } catch { Log "No se pudo iniciar sfc.exe: $($_.Exception.Message)" }
}

function Desactivar-OneDrive {
    Log "Desactivando autoarranque de OneDrive (sigue instalado, solo no abre solo)..."
    try {
        Get-Process -Name OneDrive -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
        $rutaRun = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
        if (Get-ItemProperty -Path $rutaRun -Name "OneDrive" -ErrorAction SilentlyContinue) {
            Remove-ItemProperty -Path $rutaRun -Name "OneDrive" -Force -ErrorAction SilentlyContinue
        }
        Log "OneDrive ya no arrancara automaticamente. Sigue instalado, se puede abrir manualmente cuando se necesite."
    } catch { Log "No se pudo desactivar el autoarranque de OneDrive: $($_.Exception.Message)" }
}

function Listar-AppsInicio {
    # Mantiene compatibilidad con el checkbox de Extras (lista en log)
    Log "Programas de inicio detectados:"
    try {
        $rutasRun = @(
            @{ Ruta = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"; Label = "HKCU" },
            @{ Ruta = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"; Label = "HKLM" }
        )
        foreach ($r in $rutasRun) {
            if (Test-Path $r.Ruta) {
                $props = Get-ItemProperty -Path $r.Ruta -ErrorAction SilentlyContinue
                if ($props) {
                    $props.PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' } | ForEach-Object {
                        Log "  [$($r.Label)] $($_.Name)"
                    }
                }
            }
        }
    } catch { Log "No se pudo obtener la lista de programas de inicio." }
}

function Cargar-TablaInicio {
    if (-not $script:lvInicio) { return }
    $script:lvInicio.Items.Clear()
    $rutasRun = @(
        @{ Ruta = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"; Label = "HKCU" },
        @{ Ruta = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"; Label = "HKLM" },
        @{ Ruta = "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"; Label = "HKLM32" }
    )
    foreach ($r in $rutasRun) {
        if (Test-Path $r.Ruta) {
            $props = Get-ItemProperty -Path $r.Ruta -ErrorAction SilentlyContinue
            if ($props) {
                $props.PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' } | ForEach-Object {
                    $item = New-Object System.Windows.Forms.ListViewItem($_.Name)
                    $item.SubItems.Add($r.Label) | Out-Null
                    $cmd = $_.Value; if ($cmd.Length -gt 60) { $cmd = $cmd.Substring(0,57) + "..." }
                    $item.SubItems.Add($cmd) | Out-Null
                    $item.Tag = @{ Name = $_.Name; Path = $r.Ruta; Value = $_.Value }
                    $script:lvInicio.Items.Add($item) | Out-Null
                }
            }
        }
    }
    $cnt = $script:lvInicio.Items.Count
    $script:lblInicioCount.Text = "$cnt programa$(if($cnt -ne 1){'s'}) encontrado$(if($cnt -ne 1){'s'}) en registros de inicio"
}

function Deshabilitar-InicioSeleccionados {
    $sel = @($script:lvInicio.CheckedItems)
    if ($sel.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Marca al menos un programa con la casilla.", "Aviso", "OK", "Warning")
        return
    }
    $rutaBackup = "HKCU:\Software\ClauNet\InicioBloqueado"
    if (-not (Test-Path $rutaBackup)) { New-Item -Path $rutaBackup -Force | Out-Null }
    $ok = 0; $err = 0
    foreach ($item in $sel) {
        try {
            $d = $item.Tag
            New-ItemProperty -Path $rutaBackup -Name $d.Name -Value "$($d.Path)|||$($d.Value)" -Force | Out-Null
            Remove-ItemProperty -Path $d.Path -Name $d.Name -Force
            $ok++
        } catch { $err++ }
    }
    Log "Inicio: $ok programa$(if($ok -ne 1){'s'}) deshabilitado$(if($ok -ne 1){'s'})$(if($err -gt 0){" ($err con error)"})."
    Cargar-TablaInicio
}

function Restaurar-InicioDeshabilitados {
    $rutaBackup = "HKCU:\Software\ClauNet\InicioBloqueado"
    if (-not (Test-Path $rutaBackup)) {
        [System.Windows.Forms.MessageBox]::Show("No hay programas deshabilitados para restaurar.", "Aviso", "OK", "Information"); return
    }
    $props = Get-ItemProperty -Path $rutaBackup -ErrorAction SilentlyContinue
    $lista = if ($props) { @($props.PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' }) } else { @() }
    if ($lista.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("No hay programas deshabilitados para restaurar.", "Aviso", "OK", "Information"); return
    }
    $nombres = ($lista | ForEach-Object { "  - $($_.Name)" }) -join "`n"
    $resp = [System.Windows.Forms.MessageBox]::Show("Se restauraran $($lista.Count) programa(s):`n$nombres`n`n¿Continuar?", "Restaurar inicio", "YesNo", "Question")
    if ($resp -ne "Yes") { return }
    $ok = 0
    foreach ($prop in $lista) {
        try {
            $partes = $prop.Value -split "\|\|\|", 2
            New-ItemProperty -Path $partes[0] -Name $prop.Name -Value $partes[1] -Force | Out-Null
            Remove-ItemProperty -Path $rutaBackup -Name $prop.Name -Force
            $ok++
        } catch {}
    }
    Log "Inicio: $ok programa$(if($ok -ne 1){'s'}) restaurado$(if($ok -ne 1){'s'})."
    Cargar-TablaInicio
}

# ==========================================================
# FUNCIONES DE PRIVACIDAD
# ==========================================================
function Deshabilitar-Telemetria {
    Log "Deshabilitando telemetria de Windows..."
    try {
        $ruta = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        if (-not (Test-Path $ruta)) { New-Item -Path $ruta -Force | Out-Null }
        New-ItemProperty -Path $ruta -Name "AllowTelemetry" -PropertyType DWord -Value 0 -Force | Out-Null
        Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue
        Stop-Service -Name "dmwappushservice" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "dmwappushservice" -StartupType Disabled -ErrorAction SilentlyContinue
        Log "Telemetria deshabilitada (AllowTelemetry=0, DiagTrack y dmwappushservice detenidos)."
    } catch { Log "Error al deshabilitar telemetria: $($_.Exception.Message)" }
}

function Deshabilitar-Cortana {
    Log "Deshabilitando Cortana..."
    try {
        $ruta = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        if (-not (Test-Path $ruta)) { New-Item -Path $ruta -Force | Out-Null }
        New-ItemProperty -Path $ruta -Name "AllowCortana" -PropertyType DWord -Value 0 -Force | Out-Null
        New-ItemProperty -Path $ruta -Name "AllowSearchToUseLocation" -PropertyType DWord -Value 0 -Force | Out-Null
        New-ItemProperty -Path $ruta -Name "ConnectedSearchUseWeb" -PropertyType DWord -Value 0 -Force | Out-Null
        Log "Cortana deshabilitada. Se aplicara tras reiniciar."
    } catch { Log "Error al deshabilitar Cortana: $($_.Exception.Message)" }
}

function Deshabilitar-IDPublicidad {
    Log "Deshabilitando ID de publicidad..."
    try {
        $ruta = "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
        if (-not (Test-Path $ruta)) { New-Item -Path $ruta -Force | Out-Null }
        New-ItemProperty -Path $ruta -Name "Enabled" -PropertyType DWord -Value 0 -Force | Out-Null
        $rutaCDP = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        if (Test-Path $rutaCDP) {
            New-ItemProperty -Path $rutaCDP -Name "SubscribedContent-338393Enabled" -PropertyType DWord -Value 0 -Force | Out-Null
            New-ItemProperty -Path $rutaCDP -Name "SubscribedContent-353694Enabled" -PropertyType DWord -Value 0 -Force | Out-Null
            New-ItemProperty -Path $rutaCDP -Name "SubscribedContent-353696Enabled" -PropertyType DWord -Value 0 -Force | Out-Null
        }
        Log "ID de publicidad deshabilitado (anuncios personalizados desactivados)."
    } catch { Log "Error al deshabilitar ID publicidad: $($_.Exception.Message)" }
}

function Deshabilitar-HistorialActividad {
    Log "Deshabilitando historial de actividad y timeline..."
    try {
        $ruta = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
        if (-not (Test-Path $ruta)) { New-Item -Path $ruta -Force | Out-Null }
        New-ItemProperty -Path $ruta -Name "EnableActivityFeed" -PropertyType DWord -Value 0 -Force | Out-Null
        New-ItemProperty -Path $ruta -Name "PublishUserActivities" -PropertyType DWord -Value 0 -Force | Out-Null
        New-ItemProperty -Path $ruta -Name "UploadUserActivities" -PropertyType DWord -Value 0 -Force | Out-Null
        Log "Historial de actividad y timeline deshabilitados."
    } catch { Log "Error al deshabilitar historial de actividad: $($_.Exception.Message)" }
}

function Deshabilitar-SugerenciasInicio {
    Log "Quitando sugerencias y publicidad del menu Inicio..."
    try {
        $ruta = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        if (-not (Test-Path $ruta)) { New-Item -Path $ruta -Force | Out-Null }
        New-ItemProperty -Path $ruta -Name "SubscribedContent-338388Enabled" -PropertyType DWord -Value 0 -Force | Out-Null
        New-ItemProperty -Path $ruta -Name "SubscribedContent-310093Enabled" -PropertyType DWord -Value 0 -Force | Out-Null
        New-ItemProperty -Path $ruta -Name "SystemPaneSuggestionsEnabled" -PropertyType DWord -Value 0 -Force | Out-Null
        New-ItemProperty -Path $ruta -Name "SoftLandingEnabled" -PropertyType DWord -Value 0 -Force | Out-Null
        New-ItemProperty -Path $ruta -Name "SilentInstalledAppsEnabled" -PropertyType DWord -Value 0 -Force | Out-Null
        Log "Sugerencias y publicidad del menu Inicio deshabilitadas."
    } catch { Log "Error al deshabilitar sugerencias del menu Inicio: $($_.Exception.Message)" }
}

function Deshabilitar-Ubicacion {
    Log "Deshabilitando seguimiento de ubicacion..."
    try {
        $ruta = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors"
        if (-not (Test-Path $ruta)) { New-Item -Path $ruta -Force | Out-Null }
        New-ItemProperty -Path $ruta -Name "DisableLocation" -PropertyType DWord -Value 1 -Force | Out-Null
        New-ItemProperty -Path $ruta -Name "DisableLocationScripting" -PropertyType DWord -Value 1 -Force | Out-Null
        Log "Seguimiento de ubicacion deshabilitado."
    } catch { Log "Error al deshabilitar ubicacion: $($_.Exception.Message)" }
}

# ==========================================================
# FUNCION GENERAR INFORME DEL SISTEMA
# ==========================================================
function Generar-InformeSistema {
    Log "Generando informe del sistema..."
    try {
        $fecha = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $fechaArchivo = Get-Date -Format "yyyyMMdd_HHmmss"
        $rutaInforme = Join-Path ([Environment]::GetFolderPath("Desktop")) "Informe_Sistema_$fechaArchivo.txt"

        $sb = [System.Text.StringBuilder]::new()
        [void]$sb.AppendLine("========================================================")
        [void]$sb.AppendLine("   INFORME DEL SISTEMA - ClauNet Optimizador v1.5")
        [void]$sb.AppendLine("   Generado: $fecha")
        [void]$sb.AppendLine("========================================================")
        [void]$sb.AppendLine("")

        $so = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
        $pc = Get-CimInstance Win32_ComputerSystem -ErrorAction SilentlyContinue
        $cpu = Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1
        [void]$sb.AppendLine("[EQUIPO]")
        [void]$sb.AppendLine("  Nombre:       $($pc.Name)")
        [void]$sb.AppendLine("  Fabricante:   $($pc.Manufacturer)")
        [void]$sb.AppendLine("  Modelo:       $($pc.Model)")
        [void]$sb.AppendLine("")

        [void]$sb.AppendLine("[SISTEMA OPERATIVO]")
        [void]$sb.AppendLine("  Version:      $($so.Caption) ($($so.Version))")
        [void]$sb.AppendLine("  Build:        $($so.BuildNumber)")
        [void]$sb.AppendLine("  Arquitectura: $($so.OSArchitecture)")
        [void]$sb.AppendLine("  Instalado:    $($so.InstallDate)")
        [void]$sb.AppendLine("")

        [void]$sb.AppendLine("[PROCESADOR]")
        [void]$sb.AppendLine("  CPU:          $($cpu.Name)")
        [void]$sb.AppendLine("  Nucleos:      $($cpu.NumberOfCores) fisicos / $($cpu.NumberOfLogicalProcessors) logicos")
        [void]$sb.AppendLine("  Velocidad:    $($cpu.MaxClockSpeed) MHz")
        [void]$sb.AppendLine("")

        $ramTotal = [math]::Round($pc.TotalPhysicalMemory / 1GB, 1)
        $ramDisp = [math]::Round($so.FreePhysicalMemory / 1MB, 1)
        [void]$sb.AppendLine("[MEMORIA RAM]")
        [void]$sb.AppendLine("  Total:        $ramTotal GB")
        [void]$sb.AppendLine("  Disponible:   $ramDisp GB")
        [void]$sb.AppendLine("")

        [void]$sb.AppendLine("[DISCOS]")
        Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" -ErrorAction SilentlyContinue | ForEach-Object {
            $total = [math]::Round($_.Size / 1GB, 1)
            $libre = [math]::Round($_.FreeSpace / 1GB, 1)
            $usoPct = if ($_.Size -gt 0) { [math]::Round(($_.Size - $_.FreeSpace) / $_.Size * 100, 0) } else { 0 }
            [void]$sb.AppendLine("  [$($_.DeviceID)] $total GB total | $libre GB libre | $usoPct% uso")
        }
        [void]$sb.AppendLine("")

        [void]$sb.AppendLine("[ACTIVACION WINDOWS]")
        try {
            $lic = Get-CimInstance SoftwareLicensingProduct -Filter "ApplicationId='55c92734-d682-4d71-983e-d6ec3f16059f' AND LicenseStatus=1" -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($lic) {
                [void]$sb.AppendLine("  Estado:       Activado")
                [void]$sb.AppendLine("  Edicion:      $($lic.Name)")
            } else {
                [void]$sb.AppendLine("  Estado:       No activado o licencia no encontrada")
            }
        } catch {
            [void]$sb.AppendLine("  Estado:       No se pudo verificar")
        }
        [void]$sb.AppendLine("")

        [void]$sb.AppendLine("[PROGRAMAS DE INICIO]")
        $rutasRun = @(
            @{ Ruta = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"; Label = "HKCU" },
            @{ Ruta = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"; Label = "HKLM" },
            @{ Ruta = "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"; Label = "HKLM32" }
        )
        foreach ($r in $rutasRun) {
            if (Test-Path $r.Ruta) {
                $props = Get-ItemProperty -Path $r.Ruta -ErrorAction SilentlyContinue
                if ($props) {
                    $props.PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' } | ForEach-Object {
                        [void]$sb.AppendLine("  [$($r.Label)] $($_.Name)")
                    }
                }
            }
        }
        [void]$sb.AppendLine("")

        [void]$sb.AppendLine("[TOP 10 PROCESOS POR USO DE MEMORIA]")
        Get-Process -ErrorAction SilentlyContinue | Sort-Object WorkingSet64 -Descending | Select-Object -First 10 | ForEach-Object {
            $mb = [math]::Round($_.WorkingSet64 / 1MB, 0)
            [void]$sb.AppendLine("  $($_.Name) - $mb MB")
        }
        [void]$sb.AppendLine("")

        $uptime = (Get-Date) - $so.LastBootUpTime
        [void]$sb.AppendLine("[UPTIME]")
        [void]$sb.AppendLine("  Tiempo encendido: $($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m")
        [void]$sb.AppendLine("")

        [void]$sb.AppendLine("[LOG DE OPTIMIZACIONES RECIENTES]")
        if (Test-Path $logPath) {
            $lineas = Get-Content $logPath -Tail 20 -ErrorAction SilentlyContinue
            foreach ($l in $lineas) { [void]$sb.AppendLine("  $l") }
        } else {
            [void]$sb.AppendLine("  (sin log disponible)")
        }
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("========================================================")
        [void]$sb.AppendLine("  Generado por ClauNet Optimizador v1.5")
        [void]$sb.AppendLine("  Desarrollado por ClauNet (claunet.cl)")
        [void]$sb.AppendLine("========================================================")

        $sb.ToString() | Out-File -FilePath $rutaInforme -Encoding UTF8
        Log "Informe guardado en: $rutaInforme"
        Start-Process "notepad.exe" -ArgumentList $rutaInforme
    } catch {
        Log "Error al generar informe: $($_.Exception.Message)"
        [System.Windows.Forms.MessageBox]::Show("No se pudo generar el informe.`n`nError: $($_.Exception.Message)", "Error", "OK", "Error")
    }
}

function Quitar-AppPreinstalada($paquete) {
    # v1.3.2: se quita -AllUsers de Remove-AppxPackage. Confirmado en pruebas reales
    # que el error 0x80070002 no era por saturacion (fallaban las mismas apps siempre,
    # no al azar) sino porque -AllUsers falla si el paquete no esta registrado para
    # TODOS los perfiles del equipo. Se remueve solo para el usuario actual + se evita
    # que se reinstale para perfiles nuevos via Remove-AppxProvisionedPackage.
    $intentos = 0
    $exito = $false
    while ($intentos -lt 2 -and -not $exito) {
        $intentos++
        try {
            # Ejecutar en proceso oculto para evitar la ventana de despliegue de Windows
            $cmd = "Get-AppxPackage -Name '$paquete' -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction Stop; " +
                   "Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object { `$_.DisplayName -eq '$paquete' } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null"
            $proc = Start-Process powershell.exe -WindowStyle Hidden -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$cmd`"" -Wait -PassThru
            if ($proc.ExitCode -ne 0) { throw "Proceso de remocion termino con codigo $($proc.ExitCode)" }
            Log "App '$paquete' removida (usuario actual + no se reinstalara para nuevos perfiles)."
            $exito = $true
        } catch {
            if ($intentos -ge 2) {
                Log "No se pudo remover '$paquete' tras $intentos intento(s): $($_.Exception.Message)"
            } else {
                Start-Sleep -Milliseconds 1000
            }
        }
    }
    Start-Sleep -Milliseconds 500
}

# ==========================================================
# VENTANA PRINCIPAL
# ==========================================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "ClauNet - Optimizador Windows 10/11 v1.5 (bajos recursos)"
$form.Size = New-Object System.Drawing.Size(560, 810)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(250, 251, 253)
# Doble buffer para evitar parpadeo en owner-draw
$form.GetType().GetProperty("DoubleBuffered", [System.Reflection.BindingFlags]"Instance,NonPublic").SetValue($form, $true, $null)

# ---------- Paleta ClauNet (extraida del logo) ----------
$ColorAcento = [System.Drawing.Color]::FromArgb(41, 121, 235)
$ColorAcentoClaro = [System.Drawing.Color]::FromArgb(74, 158, 255)
$ColorAcentoOscuro = [System.Drawing.Color]::FromArgb(29, 84, 175)
$ColorFondo = [System.Drawing.Color]::FromArgb(250, 251, 253)
$ColorFondoTab = [System.Drawing.Color]::White
$ColorFondoCard = [System.Drawing.Color]::FromArgb(243, 245, 249)
$ColorBorde = [System.Drawing.Color]::FromArgb(220, 225, 235)
$ColorTexto = [System.Drawing.Color]::FromArgb(40, 40, 40)
$ColorTextoSuave = [System.Drawing.Color]::FromArgb(120, 120, 120)

# ---------- Helper: Bordes redondeados ----------
function Set-RoundedRegion {
    param($ctrl, [int]$radius = 8)
    if ($ctrl.Width -le 0 -or $ctrl.Height -le 0) { return }
    $gp = New-Object System.Drawing.Drawing2D.GraphicsPath
    $w = $ctrl.Width; $h = $ctrl.Height; $d = $radius * 2
    $gp.AddArc(0, 0, $d, $d, 180, 90)
    $gp.AddArc($w - $d, 0, $d, $d, 270, 90)
    $gp.AddArc($w - $d, $h - $d, $d, $d, 0, 90)
    $gp.AddArc(0, $h - $d, $d, $d, 90, 90)
    $gp.CloseFigure()
    $ctrl.Region = New-Object System.Drawing.Region($gp)
}

function Aplicar-EstiloBoton($boton, $primario = $true) {
    $boton.FlatStyle = "Flat"
    $boton.FlatAppearance.BorderSize = 0
    $boton.Cursor = [System.Windows.Forms.Cursors]::Hand
    if ($primario) {
        $boton.BackColor = $ColorAcento
        $boton.ForeColor = [System.Drawing.Color]::White
        $boton.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 9)
    } else {
        $boton.BackColor = [System.Drawing.Color]::FromArgb(232, 238, 250)
        $boton.ForeColor = $ColorAcentoOscuro
        $boton.Font = New-Object System.Drawing.Font("Segoe UI", 8.5)
    }
    Set-RoundedRegion $boton 10
    $boton.Add_Resize({ Set-RoundedRegion $this 10 })
    $boton.Add_MouseEnter({ $this.BackColor = if ($this.ForeColor -eq [System.Drawing.Color]::White) { $ColorAcentoClaro } else { [System.Drawing.Color]::FromArgb(215, 225, 248) } }.GetNewClosure())
    $boton.Add_MouseLeave({ $this.BackColor = if ($this.ForeColor -eq [System.Drawing.Color]::White) { $ColorAcento } else { [System.Drawing.Color]::FromArgb(232, 238, 250) } }.GetNewClosure())
}

# Ruta base (ya no es estrictamente necesaria para icono/logo, que ahora van incrustados,
# pero se deja por si en el futuro se necesita ubicar la carpeta del ejecutable)
$rutaBase = $null
try {
    $rutaBase = if ($PSScriptRoot) { $PSScriptRoot } else { [System.IO.Path]::GetDirectoryName([System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName) }
} catch {}

$iconoVentana = Convertir-Base64AIcono $IconoBase64
if ($iconoVentana) { $form.Icon = $iconoVentana }

# ---------- Logo en encabezado ----------
$picLogo = New-Object System.Windows.Forms.PictureBox
$picLogo.Location = New-Object System.Drawing.Point(15, 10)
$picLogo.Size = New-Object System.Drawing.Size(220, 44)
$picLogo.SizeMode = "Zoom"
$form.Controls.Add($picLogo)
$logoImagen = Convertir-Base64AImagen $LogoBase64
if ($logoImagen) { $picLogo.Image = $logoImagen }

# ---------- Panel card de info del equipo ----------
$panelInfo = New-Object System.Windows.Forms.Panel
$panelInfo.Location = New-Object System.Drawing.Point(15, 58)
$panelInfo.Size = New-Object System.Drawing.Size(510, 38)
$panelInfo.BackColor = [System.Drawing.Color]::FromArgb(240, 243, 248)
$form.Controls.Add($panelInfo)
Set-RoundedRegion $panelInfo 8

$lblInfoEquipo = New-Object System.Windows.Forms.Label
$lblInfoEquipo.Text = "  Detectando informacion del equipo..."
$lblInfoEquipo.Location = New-Object System.Drawing.Point(4, 2)
$lblInfoEquipo.Size = New-Object System.Drawing.Size(500, 34)
$lblInfoEquipo.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$lblInfoEquipo.ForeColor = [System.Drawing.Color]::FromArgb(90, 90, 100)
$panelInfo.Controls.Add($lblInfoEquipo)

# ---------- Control de pestanas ----------
# ---------- Linea divisoria bajo el encabezado ----------
$divisor = New-Object System.Windows.Forms.Panel
$divisor.Location = New-Object System.Drawing.Point(15, 100)
$divisor.Size = New-Object System.Drawing.Size(510, 1)
$divisor.BackColor = [System.Drawing.Color]::FromArgb(41, 100, 200)
$form.Controls.Add($divisor)

$tabs = New-Object System.Windows.Forms.TabControl
$tabs.Location = New-Object System.Drawing.Point(15, 105)
$tabs.Size = New-Object System.Drawing.Size(510, 335)
$tabs.DrawMode = [System.Windows.Forms.TabDrawMode]::OwnerDrawFixed
$tabs.SizeMode = [System.Windows.Forms.TabSizeMode]::Fixed
$tabs.ItemSize = New-Object System.Drawing.Size(82, 30)
$tabs.Padding = New-Object System.Drawing.Point(0, 0)
$tabs.Add_DrawItem({
    param($s, $e)
    $g = $e.Graphics
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $rect = $e.Bounds
    $isSelected = ($e.Index -eq $tabs.SelectedIndex)
    # Fondo limpio
    $g.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(250, 251, 253))), $rect)
    # Pill redondeada
    $pillRect = New-Object System.Drawing.Rectangle(($rect.X + 3), ($rect.Y + 4), ($rect.Width - 6), ($rect.Height - 8))
    $pillPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $r = 12
    $pillPath.AddArc($pillRect.X, $pillRect.Y, $r, $r, 180, 90)
    $pillPath.AddArc($pillRect.Right - $r, $pillRect.Y, $r, $r, 270, 90)
    $pillPath.AddArc($pillRect.Right - $r, $pillRect.Bottom - $r, $r, $r, 0, 90)
    $pillPath.AddArc($pillRect.X, $pillRect.Bottom - $r, $r, $r, 90, 90)
    $pillPath.CloseFigure()
    if ($isSelected) {
        $g.FillPath((New-Object System.Drawing.SolidBrush($ColorAcento)), $pillPath)
        $txtColor = [System.Drawing.Color]::White
        $fnt = New-Object System.Drawing.Font("Segoe UI Semibold", 8.5)
    } else {
        $g.FillPath((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(235, 238, 245))), $pillPath)
        $g.DrawPath((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(210, 215, 228), 1)), $pillPath)
        $txtColor = [System.Drawing.Color]::FromArgb(80, 90, 110)
        $fnt = New-Object System.Drawing.Font("Segoe UI", 8)
    }
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $g.DrawString($tabs.TabPages[$e.Index].Text, $fnt, (New-Object System.Drawing.SolidBrush($txtColor)), [System.Drawing.RectangleF]::op_Implicit($pillRect), $sf)
})
$form.Controls.Add($tabs)

$tabGeneral = New-Object System.Windows.Forms.TabPage
$tabGeneral.Text = "General"
$tabs.Controls.Add($tabGeneral)

$tabDisco = New-Object System.Windows.Forms.TabPage
$tabDisco.Text = "Disco"
$tabs.Controls.Add($tabDisco)

$tabApps = New-Object System.Windows.Forms.TabPage
$tabApps.Text = "Apps"
$tabs.Controls.Add($tabApps)

$tabExtras = New-Object System.Windows.Forms.TabPage
$tabExtras.Text = "Extras"
$tabs.Controls.Add($tabExtras)

$tabInicio = New-Object System.Windows.Forms.TabPage
$tabInicio.Text = "Inicio"
$tabs.Controls.Add($tabInicio)

$tabPrivacidad = New-Object System.Windows.Forms.TabPage
$tabPrivacidad.Text = "Privacidad"
$tabs.Controls.Add($tabPrivacidad)

# ---------- Pestana General ----------
$chkRestauracion = New-Object System.Windows.Forms.CheckBox
$chkRestauracion.Text = "Crear punto de restauracion antes de empezar (recomendado)"
$chkRestauracion.Location = New-Object System.Drawing.Point(15, 15)
$chkRestauracion.Size = New-Object System.Drawing.Size(460, 20)
$chkRestauracion.Checked = $true
$tabGeneral.Controls.Add($chkRestauracion)

$chkVisual = New-Object System.Windows.Forms.CheckBox
$chkVisual.Text = "Aplicar perfil visual ClauNet (personalizado, no 'apagar todo')"
$chkVisual.Location = New-Object System.Drawing.Point(15, 40)
$chkVisual.Size = New-Object System.Drawing.Size(460, 20)
$chkVisual.Checked = $true
$tabGeneral.Controls.Add($chkVisual)

$chkEnergia = New-Object System.Windows.Forms.CheckBox
$chkEnergia.Text = "Configurar plan de energia en 'Equilibrado'"
$chkEnergia.Location = New-Object System.Drawing.Point(15, 65)
$chkEnergia.Size = New-Object System.Drawing.Size(460, 20)
$chkEnergia.Checked = $true
$tabGeneral.Controls.Add($chkEnergia)

$chkBloquearWin11 = New-Object System.Windows.Forms.CheckBox
$chkBloquearWin11.Text = "Bloquear actualizacion a Windows 11 (mantener en Windows 10)"
$chkBloquearWin11.Location = New-Object System.Drawing.Point(15, 90)
$chkBloquearWin11.Size = New-Object System.Drawing.Size(460, 20)
$chkBloquearWin11.Checked = $true
$tabGeneral.Controls.Add($chkBloquearWin11)

$chkServicios = New-Object System.Windows.Forms.CheckBox
$chkServicios.Text = "Pasar servicios no criticos a modo Manual (DiagTrack, Fax, etc.)"
$chkServicios.Location = New-Object System.Drawing.Point(15, 115)
$chkServicios.Size = New-Object System.Drawing.Size(460, 20)
$chkServicios.Checked = $true
$tabGeneral.Controls.Add($chkServicios)

$chkNotificaciones = New-Object System.Windows.Forms.CheckBox
$chkNotificaciones.Text = "Desactivar Centro de actividades y notificaciones de apps"
$chkNotificaciones.Location = New-Object System.Drawing.Point(15, 140)
$chkNotificaciones.Size = New-Object System.Drawing.Size(460, 20)
$chkNotificaciones.Checked = $false
$tabGeneral.Controls.Add($chkNotificaciones)

$chkIconoEquipo = New-Object System.Windows.Forms.CheckBox
$chkIconoEquipo.Text = "Mostrar 'Este equipo' en el escritorio (oculto por defecto en Windows 10/11)"
$chkIconoEquipo.Location = New-Object System.Drawing.Point(15, 165)
$chkIconoEquipo.Size = New-Object System.Drawing.Size(460, 20)
$chkIconoEquipo.Checked = $true
$tabGeneral.Controls.Add($chkIconoEquipo)

$lblVersionDetectada = New-Object System.Windows.Forms.Label
$lblVersionDetectada.Text = ""
$lblVersionDetectada.Location = New-Object System.Drawing.Point(15, 195)
$lblVersionDetectada.Size = New-Object System.Drawing.Size(460, 20)
$lblVersionDetectada.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$lblVersionDetectada.ForeColor = [System.Drawing.Color]::Gray
$tabGeneral.Controls.Add($lblVersionDetectada)

# ---------- Pestana Disco ----------
$chkTemp = New-Object System.Windows.Forms.CheckBox
$chkTemp.Text = "Limpiar archivos temporales y papelera de reciclaje"
$chkTemp.Location = New-Object System.Drawing.Point(15, 15)
$chkTemp.Size = New-Object System.Drawing.Size(460, 20)
$chkTemp.Checked = $true
$tabDisco.Controls.Add($chkTemp)

$chkCleanmgr = New-Object System.Windows.Forms.CheckBox
$chkCleanmgr.Text = "Ejecutar limpieza de disco nativa (cleanmgr)"
$chkCleanmgr.Location = New-Object System.Drawing.Point(15, 40)
$chkCleanmgr.Size = New-Object System.Drawing.Size(460, 20)
$chkCleanmgr.Checked = $false
$tabDisco.Controls.Add($chkCleanmgr)

$chkCacheDNS = New-Object System.Windows.Forms.CheckBox
$chkCacheDNS.Text = "Limpiar cache DNS (ipconfig /flushdns)"
$chkCacheDNS.Location = New-Object System.Drawing.Point(15, 65)
$chkCacheDNS.Size = New-Object System.Drawing.Size(460, 20)
$chkCacheDNS.Checked = $true
$tabDisco.Controls.Add($chkCacheDNS)

$chkCacheUpdate = New-Object System.Windows.Forms.CheckBox
$chkCacheUpdate.Text = "Limpiar cache de Windows Update (SoftwareDistribution\Download)"
$chkCacheUpdate.Location = New-Object System.Drawing.Point(15, 90)
$chkCacheUpdate.Size = New-Object System.Drawing.Size(460, 20)
$chkCacheUpdate.Checked = $false
$tabDisco.Controls.Add($chkCacheUpdate)

$chkMiniaturas = New-Object System.Windows.Forms.CheckBox
$chkMiniaturas.Text = "Limpiar cache de miniaturas (thumbcache)"
$chkMiniaturas.Location = New-Object System.Drawing.Point(15, 115)
$chkMiniaturas.Size = New-Object System.Drawing.Size(460, 20)
$chkMiniaturas.Checked = $true
$tabDisco.Controls.Add($chkMiniaturas)

$chkSysMain = New-Object System.Windows.Forms.CheckBox
$chkSysMain.Text = "Desactivar SysMain/Superfetch (disco HDD detectado)"
$chkSysMain.Location = New-Object System.Drawing.Point(15, 140)
$chkSysMain.Size = New-Object System.Drawing.Size(460, 20)
$chkSysMain.Checked = $false
$chkSysMain.Visible = $false
$tabDisco.Controls.Add($chkSysMain)

$chkHibernacion = New-Object System.Windows.Forms.CheckBox
$chkHibernacion.Text = "Desactivar hibernacion (libera espacio - disco SSD detectado)"
$chkHibernacion.Location = New-Object System.Drawing.Point(15, 140)
$chkHibernacion.Size = New-Object System.Drawing.Size(460, 20)
$chkHibernacion.Checked = $false
$chkHibernacion.Visible = $false
$tabDisco.Controls.Add($chkHibernacion)

$chkLimpiarRestore = New-Object System.Windows.Forms.CheckBox
$chkLimpiarRestore.Text = "Limpiar puntos de restauracion antiguos (limitar a 5GB)"
$chkLimpiarRestore.Location = New-Object System.Drawing.Point(15, 165)
$chkLimpiarRestore.Size = New-Object System.Drawing.Size(460, 20)
$chkLimpiarRestore.Checked = $false
$tabDisco.Controls.Add($chkLimpiarRestore)

$lblDiscoDeteccion = New-Object System.Windows.Forms.Label
$lblDiscoDeteccion.Text = "Detectando..."
$lblDiscoDeteccion.Location = New-Object System.Drawing.Point(15, 198)
$lblDiscoDeteccion.Size = New-Object System.Drawing.Size(460, 20)
$lblDiscoDeteccion.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$lblDiscoDeteccion.ForeColor = [System.Drawing.Color]::DarkBlue
$tabDisco.Controls.Add($lblDiscoDeteccion)

$lblSaludDisco = New-Object System.Windows.Forms.Label
$lblSaludDisco.Text = ""
$lblSaludDisco.Location = New-Object System.Drawing.Point(15, 222)
$lblSaludDisco.Size = New-Object System.Drawing.Size(460, 40)
$lblSaludDisco.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$tabDisco.Controls.Add($lblSaludDisco)

# ---------- Pestana Apps ----------
$chkOneDrive = New-Object System.Windows.Forms.CheckBox
$chkOneDrive.Text = "Desactivar autoarranque de OneDrive (opcional - hay clientes que SI lo usan)"
$chkOneDrive.Location = New-Object System.Drawing.Point(15, 15)
$chkOneDrive.Size = New-Object System.Drawing.Size(460, 20)
$chkOneDrive.Checked = $false
$tabApps.Controls.Add($chkOneDrive)

$lblAppsTitulo = New-Object System.Windows.Forms.Label
$lblAppsTitulo.Text = "Apps preinstaladas de Windows a quitar (elige cuales):"
$lblAppsTitulo.Location = New-Object System.Drawing.Point(15, 42)
$lblAppsTitulo.Size = New-Object System.Drawing.Size(460, 18)
$tabApps.Controls.Add($lblAppsTitulo)

$btnTodo = New-Object System.Windows.Forms.Button
$btnTodo.Text = "Marcar todo"
$btnTodo.Location = New-Object System.Drawing.Point(15, 63)
$btnTodo.Size = New-Object System.Drawing.Size(100, 22)
$tabApps.Controls.Add($btnTodo)
Aplicar-EstiloBoton $btnTodo $false

$btnNinguno = New-Object System.Windows.Forms.Button
$btnNinguno.Text = "Desmarcar todo"
$btnNinguno.Location = New-Object System.Drawing.Point(123, 63)
$btnNinguno.Size = New-Object System.Drawing.Size(110, 22)
$tabApps.Controls.Add($btnNinguno)
Aplicar-EstiloBoton $btnNinguno $false

$clbApps = New-Object System.Windows.Forms.CheckedListBox
$clbApps.Location = New-Object System.Drawing.Point(15, 88)
$clbApps.Size = New-Object System.Drawing.Size(460, 132)
$clbApps.CheckOnClick = $true
$tabApps.Controls.Add($clbApps)

# Lista: DisplayName visible -> nombre real del paquete Appx
$mapaApps = [ordered]@{
    "Skype"                       = "Microsoft.SkypeApp"
    "Clima (Bing Weather)"        = "Microsoft.BingWeather"
    "Noticias (Bing News)"        = "Microsoft.BingNews"
    "Groove Music"                = "Microsoft.ZuneMusic"
    "Peliculas y TV"              = "Microsoft.ZuneVideo"
    "Solitario de Microsoft"      = "Microsoft.MicrosoftSolitaireCollection"
    "Obtener ayuda"               = "Microsoft.GetHelp"
    "Sugerencias"                 = "Microsoft.Getstarted"
    "Hub de comentarios"          = "Microsoft.WindowsFeedbackHub"
    "Mixed Reality Portal"        = "Microsoft.MixedReality.Portal"
    "3D Builder"                  = "Microsoft.3DBuilder"
    "Visor 3D"                    = "Microsoft.Microsoft3DViewer"
    "Print 3D"                    = "Microsoft.Print3D"
    "Anuncio de Office"           = "Microsoft.MicrosoftOfficeHub"
    "Xbox App"                    = "Microsoft.XboxApp"
    "Xbox Game Bar"               = "Microsoft.XboxGamingOverlay"
    "Xbox Identity Provider"      = "Microsoft.XboxIdentityProvider"
    "--- Depende del cliente ---" = $null
    "Contactos (People)"          = "Microsoft.People"
    "Mapas de Windows"            = "Microsoft.WindowsMaps"
    "Tu Telefono / Phone Link"    = "Microsoft.YourPhone"
    "Correo y Calendario"         = "microsoft.windowscommunicationsapps"
}
$indiceSeparador = -1
$i = 0
foreach ($nombre in $mapaApps.Keys) {
    [void]$clbApps.Items.Add($nombre)
    if ($mapaApps[$nombre] -ne $null) {
        # Premarcadas las de bajo riesgo (antes del separador), desmarcadas las que dependen del cliente
        if ($i -lt 17) { $clbApps.SetItemChecked($i, $true) }
    } else {
        $indiceSeparador = $i
    }
    $i++
}

$btnAdwCleaner = New-Object System.Windows.Forms.Button
$btnAdwCleaner.Text = "Descargar y abrir AdwCleaner (herramienta externa de Malwarebytes)"
$btnAdwCleaner.Location = New-Object System.Drawing.Point(15, 228)
$btnAdwCleaner.Size = New-Object System.Drawing.Size(460, 30)
$tabApps.Controls.Add($btnAdwCleaner)
Aplicar-EstiloBoton $btnAdwCleaner $false

# ---------- Pestana Extras ----------
$chkInicio = New-Object System.Windows.Forms.CheckBox
$chkInicio.Text = "Listar TODOS los programas de inicio (para revision manual)"
$chkInicio.Location = New-Object System.Drawing.Point(15, 15)
$chkInicio.Size = New-Object System.Drawing.Size(460, 20)
$chkInicio.Checked = $true
$tabExtras.Controls.Add($chkInicio)

$chkUltimoAcceso = New-Object System.Windows.Forms.CheckBox
$chkUltimoAcceso.Text = "Avanzado: desactivar marca de 'ultimo acceso' NTFS (SSD, beneficio marginal)"
$chkUltimoAcceso.Location = New-Object System.Drawing.Point(15, 40)
$chkUltimoAcceso.Size = New-Object System.Drawing.Size(460, 20)
$chkUltimoAcceso.Checked = $false
$tabExtras.Controls.Add($chkUltimoAcceso)

$chkSFC = New-Object System.Windows.Forms.CheckBox
$chkSFC.Text = "Ejecutar sfc /scannow en segundo plano (verifica integridad del sistema)"
$chkSFC.Location = New-Object System.Drawing.Point(15, 65)
$chkSFC.Size = New-Object System.Drawing.Size(460, 20)
$chkSFC.Checked = $false
$tabExtras.Controls.Add($chkSFC)

$lblDefender = New-Object System.Windows.Forms.Label
$lblDefender.Text = "Windows Defender: verificando..."
$lblDefender.Location = New-Object System.Drawing.Point(15, 100)
$lblDefender.Size = New-Object System.Drawing.Size(460, 20)
$lblDefender.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$tabExtras.Controls.Add($lblDefender)

$lblActivacion = New-Object System.Windows.Forms.Label
$lblActivacion.Text = "Activacion de Windows: verificando..."
$lblActivacion.Location = New-Object System.Drawing.Point(15, 125)
$lblActivacion.Size = New-Object System.Drawing.Size(460, 45)
$lblActivacion.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$lblActivacion.ForeColor = [System.Drawing.Color]::DimGray
$tabExtras.Controls.Add($lblActivacion)

$btnActivarWin = New-Object System.Windows.Forms.Button
$btnActivarWin.Text = "Activar Windows / Office  (MAS — get.activated.win)"
$btnActivarWin.Location = New-Object System.Drawing.Point(15, 175)
$btnActivarWin.Size = New-Object System.Drawing.Size(460, 26)
$btnActivarWin.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$tabExtras.Controls.Add($btnActivarWin)
Aplicar-EstiloBoton $btnActivarWin $false

$lblTopProcesos = New-Object System.Windows.Forms.Label
$lblTopProcesos.Text = "Top 5 procesos por RAM: analizando..."
$lblTopProcesos.Location = New-Object System.Drawing.Point(15, 207)
$lblTopProcesos.Size = New-Object System.Drawing.Size(460, 72)
$lblTopProcesos.Font = New-Object System.Drawing.Font("Consolas", 8)
$lblTopProcesos.ForeColor = [System.Drawing.Color]::DimGray
$tabExtras.Controls.Add($lblTopProcesos)

$lblUptime = New-Object System.Windows.Forms.Label
$lblUptime.Text = "Tiempo activo del sistema: calculando..."
$lblUptime.Location = New-Object System.Drawing.Point(15, 283)
$lblUptime.Size = New-Object System.Drawing.Size(460, 18)
$lblUptime.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$lblUptime.ForeColor = [System.Drawing.Color]::Gray
$tabExtras.Controls.Add($lblUptime)

# ---------- Pestana Inicio (gestor interactivo) ----------
$lblInicioTitulo = New-Object System.Windows.Forms.Label
$lblInicioTitulo.Text = "Programas que se ejecutan al iniciar Windows"
$lblInicioTitulo.Location = New-Object System.Drawing.Point(15, 10)
$lblInicioTitulo.Size = New-Object System.Drawing.Size(460, 18)
$lblInicioTitulo.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$lblInicioTitulo.ForeColor = $ColorAcento
$tabInicio.Controls.Add($lblInicioTitulo)

$script:lblInicioCount = New-Object System.Windows.Forms.Label
$script:lblInicioCount.Text = "Cargando..."
$script:lblInicioCount.Location = New-Object System.Drawing.Point(15, 30)
$script:lblInicioCount.Size = New-Object System.Drawing.Size(460, 16)
$script:lblInicioCount.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$script:lblInicioCount.ForeColor = [System.Drawing.Color]::Gray
$tabInicio.Controls.Add($script:lblInicioCount)

$script:lvInicio = New-Object System.Windows.Forms.ListView
$script:lvInicio.Location = New-Object System.Drawing.Point(15, 50)
$script:lvInicio.Size = New-Object System.Drawing.Size(460, 190)
$script:lvInicio.View = [System.Windows.Forms.View]::Details
$script:lvInicio.FullRowSelect = $true
$script:lvInicio.CheckBoxes = $true
$script:lvInicio.MultiSelect = $true
$script:lvInicio.GridLines = $false
$script:lvInicio.BorderStyle = "None"
$script:lvInicio.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$col1 = $script:lvInicio.Columns.Add("Nombre", 170)
$col2 = $script:lvInicio.Columns.Add("Ubicacion", 65)
$col3 = $script:lvInicio.Columns.Add("Comando", 215)
$tabInicio.Controls.Add($script:lvInicio)
Set-RoundedRegion $script:lvInicio 8

$btnDeshabilitarInicio = New-Object System.Windows.Forms.Button
$btnDeshabilitarInicio.Text = [char]0x26D4 + "  Deshabilitar seleccionados"
$btnDeshabilitarInicio.Location = New-Object System.Drawing.Point(15, 248)
$btnDeshabilitarInicio.Size = New-Object System.Drawing.Size(220, 28)
$btnDeshabilitarInicio.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
$tabInicio.Controls.Add($btnDeshabilitarInicio)
Aplicar-EstiloBoton $btnDeshabilitarInicio $true

$btnRestaurarInicio = New-Object System.Windows.Forms.Button
$btnRestaurarInicio.Text = [char]0x267B + "  Restaurar deshabilitados"
$btnRestaurarInicio.Location = New-Object System.Drawing.Point(248, 248)
$btnRestaurarInicio.Size = New-Object System.Drawing.Size(227, 28)
$btnRestaurarInicio.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$tabInicio.Controls.Add($btnRestaurarInicio)
Aplicar-EstiloBoton $btnRestaurarInicio $false

$btnActualizarInicio = New-Object System.Windows.Forms.Button
$btnActualizarInicio.Text = [char]0x21BA + "  Actualizar lista"
$btnActualizarInicio.Location = New-Object System.Drawing.Point(15, 282)
$btnActualizarInicio.Size = New-Object System.Drawing.Size(460, 24)
$btnActualizarInicio.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$tabInicio.Controls.Add($btnActualizarInicio)
Aplicar-EstiloBoton $btnActualizarInicio $false

$btnDeshabilitarInicio.Add_Click({ Deshabilitar-InicioSeleccionados })
$btnRestaurarInicio.Add_Click({ Restaurar-InicioDeshabilitados })
$btnActualizarInicio.Add_Click({ Cargar-TablaInicio })

# ---------- Tab Privacidad: contenido ----------
$lblPrivTitulo = New-Object System.Windows.Forms.Label
$lblPrivTitulo.Text = [char]0x2637 + " Opciones de privacidad"
$lblPrivTitulo.Location = New-Object System.Drawing.Point(15, 10)
$lblPrivTitulo.Size = New-Object System.Drawing.Size(460, 22)
$lblPrivTitulo.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$lblPrivTitulo.ForeColor = $ColorAcento
$tabPrivacidad.Controls.Add($lblPrivTitulo)

$lblPrivDesc = New-Object System.Windows.Forms.Label
$lblPrivDesc.Text = "Reduce la recopilacion de datos personales por parte de Windows. Los cambios se aplican via registro y servicios."
$lblPrivDesc.Location = New-Object System.Drawing.Point(15, 34)
$lblPrivDesc.Size = New-Object System.Drawing.Size(460, 30)
$lblPrivDesc.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$lblPrivDesc.ForeColor = [System.Drawing.Color]::Gray
$tabPrivacidad.Controls.Add($lblPrivDesc)

$chkTelemetria = New-Object System.Windows.Forms.CheckBox
$chkTelemetria.Text = "Deshabilitar telemetria de Windows (recopilacion de datos)"
$chkTelemetria.Location = New-Object System.Drawing.Point(15, 72)
$chkTelemetria.Size = New-Object System.Drawing.Size(460, 22)
$tabPrivacidad.Controls.Add($chkTelemetria)

$chkCortana = New-Object System.Windows.Forms.CheckBox
$chkCortana.Text = "Deshabilitar Cortana y busqueda web"
$chkCortana.Location = New-Object System.Drawing.Point(15, 97)
$chkCortana.Size = New-Object System.Drawing.Size(460, 22)
$tabPrivacidad.Controls.Add($chkCortana)

$chkIDPublicidad = New-Object System.Windows.Forms.CheckBox
$chkIDPublicidad.Text = "Deshabilitar ID de publicidad (anuncios personalizados)"
$chkIDPublicidad.Location = New-Object System.Drawing.Point(15, 122)
$chkIDPublicidad.Size = New-Object System.Drawing.Size(460, 22)
$tabPrivacidad.Controls.Add($chkIDPublicidad)

$chkHistorial = New-Object System.Windows.Forms.CheckBox
$chkHistorial.Text = "Deshabilitar historial de actividad y timeline"
$chkHistorial.Location = New-Object System.Drawing.Point(15, 147)
$chkHistorial.Size = New-Object System.Drawing.Size(460, 22)
$tabPrivacidad.Controls.Add($chkHistorial)

$chkSugerencias = New-Object System.Windows.Forms.CheckBox
$chkSugerencias.Text = "Quitar sugerencias y publicidad del menu Inicio"
$chkSugerencias.Location = New-Object System.Drawing.Point(15, 172)
$chkSugerencias.Size = New-Object System.Drawing.Size(460, 22)
$tabPrivacidad.Controls.Add($chkSugerencias)

$chkUbicacion = New-Object System.Windows.Forms.CheckBox
$chkUbicacion.Text = "Deshabilitar seguimiento de ubicacion"
$chkUbicacion.Location = New-Object System.Drawing.Point(15, 197)
$chkUbicacion.Size = New-Object System.Drawing.Size(460, 22)
$tabPrivacidad.Controls.Add($chkUbicacion)

$lblPrivNota = New-Object System.Windows.Forms.Label
$lblPrivNota.Text = "Nota: Algunos cambios requieren reiniciar. Deshabilitar Cortana aplica tras reiniciar Windows."
$lblPrivNota.Location = New-Object System.Drawing.Point(15, 235)
$lblPrivNota.Size = New-Object System.Drawing.Size(460, 35)
$lblPrivNota.Font = New-Object System.Drawing.Font("Segoe UI", 7.5, [System.Drawing.FontStyle]::Italic)
$lblPrivNota.ForeColor = [System.Drawing.Color]::Gray
$tabPrivacidad.Controls.Add($lblPrivNota)

# Panel sombra debajo del area de tabs para efecto de profundidad
$panelSombraTab = New-Object System.Windows.Forms.Panel
$panelSombraTab.Location = New-Object System.Drawing.Point(15, 440)
$panelSombraTab.Size = New-Object System.Drawing.Size(510, 3)
$panelSombraTab.BackColor = [System.Drawing.Color]::FromArgb(225, 228, 235)
$form.Controls.Add($panelSombraTab)

$tabs.Add_SelectedIndexChanged({
    if ($tabs.SelectedTab -eq $tabInicio) { Cargar-TablaInicio }
})

# ---------- Controles compartidos (debajo de las pestanas) ----------
$btnRecomendado = New-Object System.Windows.Forms.Button
$btnRecomendado.Text = [char]0x2611 + "  Marcar todo lo recomendado"
$btnRecomendado.Location = New-Object System.Drawing.Point(15, 448)
$btnRecomendado.Size = New-Object System.Drawing.Size(510, 26)
$btnRecomendado.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$form.Controls.Add($btnRecomendado)
Aplicar-EstiloBoton $btnRecomendado $false

$btnEjecutar = New-Object System.Windows.Forms.Button
$btnEjecutar.Text = [char]0x25B6 + "  Ejecutar optimizaciones seleccionadas"
$btnEjecutar.Location = New-Object System.Drawing.Point(15, 478)
$btnEjecutar.Size = New-Object System.Drawing.Size(510, 35)
$btnEjecutar.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($btnEjecutar)
Aplicar-EstiloBoton $btnEjecutar $true

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(15, 518)
$progressBar.Size = New-Object System.Drawing.Size(510, 20)
$form.Controls.Add($progressBar)
Set-RoundedRegion $progressBar 6

# Panel sombra para efecto de profundidad en el log
$panelLogSombra = New-Object System.Windows.Forms.Panel
$panelLogSombra.Location = New-Object System.Drawing.Point(17, 545)
$panelLogSombra.Size = New-Object System.Drawing.Size(510, 85)
$panelLogSombra.BackColor = [System.Drawing.Color]::FromArgb(215, 218, 225)
$form.Controls.Add($panelLogSombra)
Set-RoundedRegion $panelLogSombra 8

$txtLog = New-Object System.Windows.Forms.TextBox
$txtLog.Multiline = $true
$txtLog.ScrollBars = "Vertical"
$txtLog.ReadOnly = $true
$txtLog.Location = New-Object System.Drawing.Point(15, 543)
$txtLog.Size = New-Object System.Drawing.Size(510, 85)
$txtLog.Font = New-Object System.Drawing.Font("Consolas", 8)
$txtLog.BackColor = [System.Drawing.Color]::FromArgb(248, 249, 252)
$txtLog.ForeColor = [System.Drawing.Color]::FromArgb(30, 70, 160)
$txtLog.BorderStyle = "None"
$form.Controls.Add($txtLog)
Set-RoundedRegion $txtLog 8
$txtLog.BringToFront()

$btnInforme = New-Object System.Windows.Forms.Button
$btnInforme.Text = [char]0x2630 + "  Generar informe del equipo"
$btnInforme.Location = New-Object System.Drawing.Point(15, 640)
$btnInforme.Size = New-Object System.Drawing.Size(165, 30)
$form.Controls.Add($btnInforme)
Aplicar-EstiloBoton $btnInforme $false

$btnReiniciar = New-Object System.Windows.Forms.Button
$btnReiniciar.Text = [char]0x21BA + "  Reiniciar equipo"
$btnReiniciar.Location = New-Object System.Drawing.Point(185, 640)
$btnReiniciar.Size = New-Object System.Drawing.Size(165, 30)
$btnReiniciar.Enabled = $false
$form.Controls.Add($btnReiniciar)
Aplicar-EstiloBoton $btnReiniciar $false

$btnCerrar = New-Object System.Windows.Forms.Button
$btnCerrar.Text = [char]0x2715 + "  Cerrar"
$btnCerrar.Location = New-Object System.Drawing.Point(355, 640)
$btnCerrar.Size = New-Object System.Drawing.Size(170, 30)
$form.Controls.Add($btnCerrar)
Aplicar-EstiloBoton $btnCerrar $false

# ---------- Pie de ventana con links ----------
$lblCreditos = New-Object System.Windows.Forms.Label
$lblCreditos.Text = "ClauNet - Soporte IT y desarrollo web  |  v1.5  |  "
$lblCreditos.Location = New-Object System.Drawing.Point(15, 678)
$lblCreditos.Size = New-Object System.Drawing.Size(230, 18)
$lblCreditos.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$lblCreditos.ForeColor = [System.Drawing.Color]::Gray
$form.Controls.Add($lblCreditos)

$linkWeb = New-Object System.Windows.Forms.LinkLabel
$linkWeb.Text = "claunet.cl"
$linkWeb.Location = New-Object System.Drawing.Point(245, 678)
$linkWeb.Size = New-Object System.Drawing.Size(70, 18)
$linkWeb.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$linkWeb.Add_Click({ try { Start-Process "https://claunet.cl" } catch {} })
$form.Controls.Add($linkWeb)

$linkMail = New-Object System.Windows.Forms.LinkLabel
$linkMail.Text = "claudio@claunet.cl"
$linkMail.Location = New-Object System.Drawing.Point(320, 678)
$linkMail.Size = New-Object System.Drawing.Size(150, 18)
$linkMail.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$linkMail.Add_Click({ try { Start-Process "mailto:claudio@claunet.cl" } catch {} })
$form.Controls.Add($linkMail)

$linkLog = New-Object System.Windows.Forms.LinkLabel
$linkLog.Text = "Ver log"
$linkLog.Location = New-Object System.Drawing.Point(478, 678)
$linkLog.Size = New-Object System.Drawing.Size(55, 18)
$linkLog.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
$linkLog.Add_Click({ try { Start-Process "notepad.exe" -ArgumentList $logPath } catch {} })
$form.Controls.Add($linkLog)

# ---------- StatusStrip ----------
$statusStrip = New-Object System.Windows.Forms.StatusStrip
$statusStrip.BackColor = [System.Drawing.Color]::FromArgb(242, 244, 248)
$statusStrip.SizingGrip = $false
$form.Controls.Add($statusStrip)

$statusLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
$statusLabel.Text = "Listo."
$statusLabel.Spring = $true
$statusLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$statusLabel.ForeColor = $ColorAcento
[void]$statusStrip.Items.Add($statusLabel)

# ---------- ToolTips ----------
$toolTip = New-Object System.Windows.Forms.ToolTip
$toolTip.AutoPopDelay = 8000
$toolTip.InitialDelay = 400
$toolTip.ReshowDelay = 200
$toolTip.SetToolTip($chkRestauracion,    "Crea un punto de restauracion del sistema antes de aplicar cambios.")
$toolTip.SetToolTip($chkVisual,          "Desactiva efectos visuales innecesarios para mejorar rendimiento.")
$toolTip.SetToolTip($chkEnergia,         "Cambia el plan de energia a 'Alto rendimiento'.")
$toolTip.SetToolTip($chkBloquearWin11,   "Bloquea la actualizacion automatica a Windows 11 via registro.")
$toolTip.SetToolTip($chkServicios,       "Deshabilita servicios no criticos (SysMain, Fax, etc.).")
$toolTip.SetToolTip($chkNotificaciones,  "Desactiva el Centro de actividades y notificaciones de apps.")
$toolTip.SetToolTip($chkIconoEquipo,     "Muestra el icono 'Este equipo' en el escritorio si no esta.")
$toolTip.SetToolTip($chkTemp,            "Elimina archivos temporales de usuario y del sistema.")
$toolTip.SetToolTip($chkCleanmgr,        "Ejecuta el Liberador de espacio en disco de Windows.")
$toolTip.SetToolTip($chkCacheDNS,        "Limpia la cache DNS del sistema (ipconfig /flushdns).")
$toolTip.SetToolTip($chkCacheUpdate,     "Detiene el servicio Windows Update y borra los archivos de descarga pendientes.")
$toolTip.SetToolTip($chkMiniaturas,      "Elimina los archivos thumbcache_*.db; se regeneran solos al navegar carpetas.")
$toolTip.SetToolTip($chkLimpiarRestore,  "Limita el espacio de puntos de restauracion a 5 GB y borra los antiguos.")
$toolTip.SetToolTip($chkInicio,          "Lista todos los programas de inicio en el log para revision manual.")
$toolTip.SetToolTip($chkUltimoAcceso,    "Avanzado: desactiva la marca NTFS de ultimo acceso (leve beneficio en SSD).")
$toolTip.SetToolTip($chkSFC,             "Lanza sfc /scannow en segundo plano; resultado en C:\Windows\Logs\CBS\CBS.log.")
$toolTip.SetToolTip($chkOneDrive,        "Desactiva el autoarranque de OneDrive (no lo desinstala).")
$toolTip.SetToolTip($chkTelemetria,      "Detiene los servicios DiagTrack y dmwappushservice, y establece AllowTelemetry=0.")
$toolTip.SetToolTip($chkCortana,         "Deshabilita Cortana y la busqueda web via politica de grupo.")
$toolTip.SetToolTip($chkIDPublicidad,    "Desactiva el identificador de publicidad de Windows para anuncios personalizados.")
$toolTip.SetToolTip($chkHistorial,       "Desactiva el historial de actividad y el timeline de Windows.")
$toolTip.SetToolTip($chkSugerencias,     "Elimina sugerencias, apps preinstaladas silenciosamente y publicidad del menu Inicio.")
$toolTip.SetToolTip($chkUbicacion,       "Deshabilita el seguimiento de ubicacion a nivel de politica del sistema.")

# ---------- Eventos ----------
$btnTodo.Add_Click({
    for ($idx = 0; $idx -lt $clbApps.Items.Count; $idx++) {
        if ($idx -ne $indiceSeparador) { $clbApps.SetItemChecked($idx, $true) }
    }
})

$btnNinguno.Add_Click({
    for ($idx = 0; $idx -lt $clbApps.Items.Count; $idx++) {
        $clbApps.SetItemChecked($idx, $false)
    }
})

$btnAdwCleaner.Add_Click({
    try {
        $urlAdw = "https://downloads.malwarebytes.com/file/adwcleaner"
        $destino = Join-Path $env:TEMP "AdwCleaner.exe"
        Log "Descargando AdwCleaner..."
        Invoke-WebRequest -Uri $urlAdw -OutFile $destino -UseBasicParsing
        Log "AdwCleaner descargado. Abriendo..."
        Start-Process -FilePath $destino
    } catch {
        [System.Windows.Forms.MessageBox]::Show("No se pudo descargar/abrir AdwCleaner. Verifica conexion a internet.`n`nError: $($_.Exception.Message)", "Error", "OK", "Error")
        Log "Error al descargar/abrir AdwCleaner: $($_.Exception.Message)"
    }
})

$btnActivarWin.Add_Click({
    try {
        Log "Lanzando Microsoft Activation Scripts (MAS)..."
        Start-Process -FilePath "powershell.exe" -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command "irm https://get.activated.win | iex"'
        Log "MAS abierto. Sigue las instrucciones en la ventana de PowerShell."
    } catch {
        [System.Windows.Forms.MessageBox]::Show("No se pudo lanzar el activador.`nVerifica conexion a internet.`n`nError: $($_.Exception.Message)", "Error", "OK", "Error")
        Log "Error al lanzar MAS: $($_.Exception.Message)"
    }
})

$btnRecomendado.Add_Click({
    # General
    $chkRestauracion.Checked = $true
    $chkVisual.Checked = $true
    $chkEnergia.Checked = $true
    $chkServicios.Checked = $true
    $chkNotificaciones.Checked = $true
    $chkIconoEquipo.Checked = $true
    # Disco
    $chkTemp.Checked = $true
    $chkCleanmgr.Checked = $true
    $chkCacheDNS.Checked = $true
    $chkCacheUpdate.Checked = $true
    $chkMiniaturas.Checked = $true
    # Extras
    $chkInicio.Checked = $true
    # Privacidad
    $chkTelemetria.Checked = $true
    $chkCortana.Checked = $true
    $chkIDPublicidad.Checked = $true
    $chkHistorial.Checked = $true
    $chkSugerencias.Checked = $true
    $chkUbicacion.Checked = $true
    Log "Todas las opciones recomendadas marcadas."
})

$btnInforme.Add_Click({ Generar-InformeSistema })

$btnEjecutar.Add_Click({
    $btnEjecutar.Enabled = $false
    $tareas = @()
    if ($chkRestauracion.Checked) { $tareas += "restauracion" }
    if ($chkLimpiarRestore.Checked) { $tareas += "limpiarrestore" }
    if ($chkTemp.Checked) { $tareas += "temp" }
    if ($chkVisual.Checked) { $tareas += "visual" }
    if ($chkEnergia.Checked) { $tareas += "energia" }
    if ($chkServicios.Checked) { $tareas += "servicios" }
    if ($chkIconoEquipo.Checked) { $tareas += "iconoequipo" }
    if ($chkSysMain.Checked) { $tareas += "sysmain" }
    if ($chkHibernacion.Checked) { $tareas += "hibernacion" }
    if ($chkCleanmgr.Checked) { $tareas += "cleanmgr" }
    if ($chkBloquearWin11.Checked -and $chkBloquearWin11.Visible) { $tareas += "bloquearwin11" }
    if ($chkOneDrive.Checked) { $tareas += "onedrive" }
    if ($chkInicio.Checked) { $tareas += "inicio" }
    if ($chkUltimoAcceso.Checked) { $tareas += "ultimoacceso" }
    if ($chkNotificaciones.Checked) { $tareas += "notificaciones" }
    if ($chkCacheDNS.Checked) { $tareas += "cachedns" }
    if ($chkCacheUpdate.Checked) { $tareas += "cacheupdate" }
    if ($chkMiniaturas.Checked) { $tareas += "miniaturas" }
    if ($chkSFC.Checked) { $tareas += "sfc" }
    if ($chkTelemetria.Checked) { $tareas += "telemetria" }
    if ($chkCortana.Checked) { $tareas += "cortana" }
    if ($chkIDPublicidad.Checked) { $tareas += "idpublicidad" }
    if ($chkHistorial.Checked) { $tareas += "historial" }
    if ($chkSugerencias.Checked) { $tareas += "sugerencias" }
    if ($chkUbicacion.Checked) { $tareas += "ubicacion" }

    $appsAQuitar = @()
    for ($idx = 0; $idx -lt $clbApps.Items.Count; $idx++) {
        if ($idx -eq $indiceSeparador) { continue }
        if ($clbApps.GetItemChecked($idx)) {
            $nombreVisible = $clbApps.Items[$idx]
            $paquete = $mapaApps[$nombreVisible]
            if ($paquete) { $appsAQuitar += $paquete }
        }
    }

    if ($tareas.Count -eq 0 -and $appsAQuitar.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("No seleccionaste ninguna optimizacion.", "Aviso", "OK", "Warning")
        $btnEjecutar.Enabled = $true
        return
    }

    $progressBar.Maximum = $tareas.Count + $appsAQuitar.Count
    $progressBar.Value = 0
    Log "=== Iniciando optimizaciones seleccionadas ==="

    $metricasAntes = Obtener-Metricas
    Log "Metricas ANTES: Espacio libre = $($metricasAntes.EspacioLibreGB) GB | RAM libre = $($metricasAntes.RamLibreGB) GB"

    if ($tipoDiscoDetectado -eq "SSD") { Verificar-TRIM }

    foreach ($t in $tareas) {
        $statusLabel.Text = "Ejecutando: $t..."
        [System.Windows.Forms.Application]::DoEvents()
        switch ($t) {
            "restauracion"   { Crear-PuntoRestauracion }
            "limpiarrestore" { Limpiar-PuntosRestauracionAntiguos }
            "temp"           { Optimizar-Temporales }
            "visual"         { Aplicar-PerfilVisual-Taller }
            "energia"        { Optimizar-PlanEnergia }
            "servicios"      { Optimizar-Servicios }
            "sysmain"        { Optimizar-SysMain }
            "hibernacion"    { Desactivar-Hibernacion }
            "cleanmgr"       { Optimizar-LimpiezaDisco }
            "bloquearwin11"  { Bloquear-ActualizacionWin11 }
            "iconoequipo"    { Mostrar-IconoEsteEquipo }
            "onedrive"       { Desactivar-OneDrive }
            "inicio"         { Listar-AppsInicio }
            "ultimoacceso"   { Desactivar-UltimoAcceso }
            "notificaciones" { Desactivar-Notificaciones }
            "cachedns"       { Limpiar-CacheDNS }
            "cacheupdate"    { Limpiar-CacheWindowsUpdate }
            "miniaturas"     { Limpiar-Miniaturas }
            "sfc"            { Ejecutar-SFC }
            "telemetria"     { Deshabilitar-Telemetria }
            "cortana"        { Deshabilitar-Cortana }
            "idpublicidad"   { Deshabilitar-IDPublicidad }
            "historial"      { Deshabilitar-HistorialActividad }
            "sugerencias"    { Deshabilitar-SugerenciasInicio }
            "ubicacion"      { Deshabilitar-Ubicacion }
        }
        $progressBar.Value += 1
        [System.Windows.Forms.Application]::DoEvents()
    }

    foreach ($paquete in $appsAQuitar) {
        Quitar-AppPreinstalada $paquete
        $progressBar.Value += 1
        [System.Windows.Forms.Application]::DoEvents()
    }

    $statusLabel.Text = "Completado."
    Log "=== Optimizaciones finalizadas ==="

    $metricasDespues = Obtener-Metricas
    Log "Metricas DESPUES: Espacio libre = $($metricasDespues.EspacioLibreGB) GB | RAM libre = $($metricasDespues.RamLibreGB) GB"

    $mensajeReporte = "Sin datos suficientes para calcular espacio liberado."
    if ($metricasAntes.EspacioLibreGB -ne $null -and $metricasDespues.EspacioLibreGB -ne $null) {
        $espacioLiberado = [math]::Round($metricasDespues.EspacioLibreGB - $metricasAntes.EspacioLibreGB, 2)
        $mensajeReporte = "Espacio en disco liberado: $espacioLiberado GB"
        Log "Resumen: Espacio liberado = $espacioLiberado GB"
    }

    [System.Windows.Forms.MessageBox]::Show("Optimizaciones completadas.`n`n$mensajeReporte`n(RAM libre antes: $($metricasAntes.RamLibreGB) GB / despues: $($metricasDespues.RamLibreGB) GB - valor referencial)`n`nSe recomienda reiniciar el equipo.`nLog: $logPath", "Listo", "OK", "Information")
    $btnReiniciar.Enabled = $true
    $btnEjecutar.Enabled = $true
})

$btnReiniciar.Add_Click({
    $confirm = [System.Windows.Forms.MessageBox]::Show("¿Reiniciar el equipo ahora?", "Confirmar", "YesNo", "Question")
    if ($confirm -eq "Yes") { Restart-Computer -Force }
})

$btnCerrar.Add_Click({ $form.Close() })

# ---------- Deteccion automatica al abrir la ventana ----------
$tipoDiscoDetectado = Detectar-TipoDisco
$tipoEquipoDetectado = Detectar-TipoEquipo
$versionWindowsDetectada = Detectar-VersionWindows
$infoEquipo = Obtener-InfoEquipo

$lblInfoEquipo.Text = "Windows: $($infoEquipo.Windows)  |  RAM: $($infoEquipo.RAM_Texto)  |  CPU: $($infoEquipo.CPU)"
$lblDiscoDeteccion.Text = "Detectado: Disco $tipoDiscoDetectado - Equipo tipo $tipoEquipoDetectado"
$lblVersionDetectada.Text = "Version detectada: $versionWindowsDetectada"

Log "Deteccion automatica: Disco=$tipoDiscoDetectado, Equipo=$tipoEquipoDetectado, Windows=$versionWindowsDetectada"
Log "Info equipo: $($infoEquipo.Windows) | RAM total: $($infoEquipo.RAM_Texto) | CPU: $($infoEquipo.CPU)"

if ($infoEquipo.RAM_GB -ne $null -and $infoEquipo.RAM_GB -lt 8) {
    Log "Oportunidad (uso interno): equipo con RAM baja ($($infoEquipo.RAM_GB) GB) - posible upsell de upgrade de memoria."
}

if ($versionWindowsDetectada -eq "Windows 11") {
    $chkBloquearWin11.Visible = $false
    Log "Windows 11 detectado - se oculta la opcion de bloqueo de actualizacion (ya no aplica)."
} else {
    $chkBloquearWin11.Visible = $true
}

if ($tipoDiscoDetectado -eq "HDD") {
    $chkSysMain.Visible = $true
    $chkSysMain.Checked = $true
    $chkHibernacion.Visible = $false
} elseif ($tipoDiscoDetectado -eq "SSD") {
    $chkHibernacion.Visible = $true
    $chkHibernacion.Checked = ($tipoEquipoDetectado -eq "Escritorio")
    $chkSysMain.Visible = $false
} else {
    $chkSysMain.Visible = $true
    $chkSysMain.Checked = $false
    $chkHibernacion.Visible = $true
    $chkHibernacion.Checked = $false
}

$saludDisco = Verificar-SaludDisco
Log "Salud del disco detectada: $saludDisco"
if ($saludDisco -eq "Healthy") {
    $lblSaludDisco.Text = "●  Salud del disco: OK"
    $lblSaludDisco.ForeColor = [System.Drawing.Color]::DarkGreen
} elseif ($saludDisco -eq "Desconocido") {
    $lblSaludDisco.Text = "●  no se pudo determinar (revisar manualmente)"
    $lblSaludDisco.ForeColor = [System.Drawing.Color]::Gray
} else {
    $lblSaludDisco.Text = "●  ADVERTENCIA - Salud del disco: $saludDisco`r`nConsiderar avisar al cliente antes de seguir."
    $lblSaludDisco.ForeColor = [System.Drawing.Color]::Red
    [System.Windows.Forms.MessageBox]::Show("El disco reporta un estado de salud '$saludDisco', no 'Healthy'.`n`nSe recomienda evaluarlo antes de continuar.", "Advertencia de salud del disco", "OK", "Warning")
}

$estadoDefender = Verificar-Defender
Log "Windows Defender: $estadoDefender"
$lblDefender.Text = "●  Windows Defender: $estadoDefender"
$lblDefender.ForeColor = if ($estadoDefender -eq "Activo") { [System.Drawing.Color]::DarkGreen } else { [System.Drawing.Color]::Red }

$estadoActivacion = Verificar-Activacion
Log "Activacion de Windows: $estadoActivacion"
$lblActivacion.Text = "Activacion de Windows:`r`n$estadoActivacion"

# Top 5 procesos por RAM
try {
    $top5 = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5
    $lineasTop = "Top 5 procesos por RAM:`r`n"
    foreach ($p in $top5) {
        $ramMB = [math]::Round($p.WorkingSet64 / 1MB, 0)
        $lineasTop += "  $($p.Name.PadRight(22))  $ramMB MB`r`n"
    }
    $lblTopProcesos.Text = $lineasTop.TrimEnd()
} catch {
    $lblTopProcesos.Text = "Top 5 procesos: no disponible."
}

# Uptime del sistema
try {
    $bootTime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    $uptime = (Get-Date) - $bootTime
    $dias = [math]::Floor($uptime.TotalDays)
    $horas = $uptime.Hours
    $minutos = $uptime.Minutes
    $lblUptime.Text = "Sistema encendido hace: $dias d $horas h $minutos min  (desde $($bootTime.ToString('dd/MM/yyyy HH:mm')))"
} catch {
    $lblUptime.Text = "Tiempo activo: no disponible."
}

[void]$form.ShowDialog()
