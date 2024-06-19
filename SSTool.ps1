
function Menu {
    param (
        [string]$Title = @'
 ______     ______        ______   ______     ______     __        
/\  ___\   /\  ___\      /\__  _\ /\  __ \   /\  __ \   /\ \       
\ \___  \  \ \___  \     \/_/\ \/ \ \ \/\ \  \ \ \/\ \  \ \ \____  
 \/\_____\  \/\_____\       \ \_\  \ \_____\  \ \_____\  \ \_____\ 
  \/_____/   \/_____/        \/_/   \/_____/   \/_____/   \/_____/ 
'@
    )
    Clear-Host
    Write-Host "===================="
    Write-Host "       $Title       "
    Write-Host "===================="
    Write-Host "1. BAM"
    Write-Host "2. Recycle Bin"
    Write-Host "3. Check Services"
    Write-Host "4. Usb-Events"
    Write-Host "5. Soon"
    Write-Host "6. Salir"
    Write-Host "===================="
}
function Get-RecycleBinLastModified {
    # Crear una instancia de Shell.Application
    $shell = New-Object -ComObject Shell.Application
    $recycleBin = $shell.Namespace(10)  # 10 es el identificador de la Papelera de reciclaje
    
    # Obtener todos los elementos en la Papelera de reciclaje
    $items = @()
    for ($i = 0; $i -lt $recycleBin.Items().Count; $i++) {
        $item = $recycleBin.Items().Item($i)
        $items += [pscustomobject]@{
            Name = $item.Name
            Path = $item.Path
            LastModified = $item.ModifyDate
        }
    }

    if ($items.Count -gt 0) {
        $lastModified = $items | Sort-Object LastModified -Descending | Select-Object -First 1
        
        if ($lastModified) {
            Write-Host "El archivo más recientemente modificado en la Papelera de reciclaje es:"
            Write-Host "Nombre: $($lastModified.Name)"
            Write-Host "Ruta: $($lastModified.Path)"
            Write-Host "Fecha de modificación: $($lastModified.LastModified)"
        } else {
            Write-Host "No se encontraron archivos en la Papelera de reciclaje."
        }
    } else {
        Write-Host "No se encontraron archivos en la Papelera de reciclaje."
    }
}
# Definir la función para obtener los eventos de dispositivos USB

function Get-USBEvents {
    # Establecer el rango de fechas para la consulta (últimos 7 días, por ejemplo)
    $startDate = (Get-Date).AddDays(-7)
    $endDate = Get-Date

    # Filtrar eventos relacionados con USB en el registro de eventos del sistema
    $usbEvents_System = Get-WinEvent -FilterHashtable @{
        LogName = 'System'
        StartTime = $startDate
        EndTime = $endDate
    } | Where-Object {
        $_.Message -like '*USB*' -or $_.Message -like '*Device connected*' -or $_.Message -like '*Device disconnected*'
    } | Select-Object TimeCreated, Id, Message

    # Filtrar eventos relacionados con USB en el registro de eventos del DriverFrameworks
    $usbEvents_Driver = Get-WinEvent -FilterHashtable @{
        LogName = 'Microsoft-Windows-DriverFrameworks-UserMode/Operational'
        StartTime = $startDate
        EndTime = $endDate
    } | Where-Object {
        $_.Message -like '*USB*' -or $_.Message -like '*Device connected*' -or $_.Message -like '*Device disconnected*'
    } | Select-Object TimeCreated, Id, Message

    # Combinar y ordenar los eventos por fecha y hora
    $events = $usbEvents_System + $usbEvents_Driver | Sort-Object TimeCreated

    # Mostrar los eventos
    $events | ForEach-Object {
        [PSCustomObject]@{
            Tiempo = $_.TimeCreated
            Evento = $_.Id
            Mensaje = $_.Message
        }
    } | Format-Table -AutoSize
}






function Process-Menu {
    param (
        [string]$Eleccion
    )
    switch($Eleccion) {
        '1' {
            Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
            Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/IlleUco/ScreenShare/main/BamRobadoIlleUco.ps1)ç
            Clear-Host
            Menu
            $selection = Read-Host "Seleccione una opción"
            Process-Menu -Eleccion $selection
        }
        '2'{
            
            Get-RecycleBinLastModified
                Start-Sleep 15
            Clear-Host
            Menu
$selection = Read-Host "Seleccione una opción"
Process-Menu -Eleccion $selection
        }
        '4'{
            Get-USBEvents
                Start-Sleep 15
                Clear-Host
                Menu
                $selection = Read-Host "Seleccione una opción"
                Process-Menu -Eleccion $selection
        }
        '3'{
            $ErrorActionPreference = "SilentlyContinue"  
            Get-Service | findstr -i "pcasvc"; get-service | findstr -i "DPS"; Get-Service | findstr -i "sysmain"; get-service |findstr -i "eventlog"; get-service | findstr -i "bam"; get-service | findstr -i "Appinfo"; get-service | findstr -i "DusmSvc"; get-service | findstr -i "DiagTrack"; get-service | -i "SgrmBroker"; get-service | findstr -i "DcomLaunch"; get-service | findstr -i "BFE"; get-service | findstr -i "Dnscache"; get-service | findstr -i "WSearch"; get-service | findstr -i "Schedule"; get-service | findstr "StorSvc"
            Start-Sleep 15
                Clear-Host
                Menu
                $selection = Read-Host "Seleccione una opción"
                Process-Menu -Eleccion $selection
        }
        '6' {
            Clear-Host
            Write-Host -ForegroundColor Green "Saliendo... Gracias por confiar en mi tool - IlleUco"
            Start-Sleep 3
            exit
        }
        default {
            Write-Host "Opción no válida, intente nuevamente."
        }
    }
}

# Llamar al menú y procesar la entrada del usuario
Menu
$selection = Read-Host "Seleccione una opción"
Process-Menu -Eleccion $selection
