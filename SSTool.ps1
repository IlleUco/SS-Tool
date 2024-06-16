
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
    Write-Host "2. Soon"
    Write-Host "3. Soon"
    Write-Host "4. Soon"
    Write-Host "5. Soon"
    Write-Host "6. Salir"
    Write-Host "===================="
}

function Process-Menu {
    param (
        [string]$Eleccion
    )
    switch($Eleccion) {
        '1' {
            Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
            Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/IlleUco/ScreenShare/main/BamRobadoIlleUco.ps1)
        }
        '6' {
            Write-Host "Saliendo..."
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