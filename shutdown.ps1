## Fonction pour lister les tâches planifiées
function Get-ScheduledTasks {
    $tasks = schtasks /query /fo csv | ConvertFrom-Csv
    $tasks | Select-Object TaskName, NextRunTime
}

## Fonction pour créer une tâche d'extinction
function Create-ShutdownTask {
    param(
        [datetime]$TriggerTime
    )

    $action = New-ScheduledTaskAction -Execute "shutdown.exe" -Argument "-s -t 0"
    $trigger = New-ScheduledTaskTrigger -Once -At $TriggerTime
    Register-ScheduledTask -TaskName "ShutdownTask_$($TriggerTime.ToString('HHmm'))" -Action $action -Trigger $trigger -RunLevel Highest
}

## Menu principal
function Show-Menu {
    Clear-Host
    Write-Host "================ Menu ================"
    Write-Host "1. Lister les tâches planifiées"
    Write-Host "2. Créer une tâche d'extinction pour 18h"
    Write-Host "3. Créer une tâche d'extinction pour 21h"
    Write-Host "Q. Quitter"
    Write-Host "======================================"
}

## Boucle principale
do {
    Show-Menu
    $choice = Read-Host "Veuillez faire un choix"

    switch ($choice) {
        '1' {
            Write-Host "Tâches planifiées sur la machine :"
            Get-ScheduledTasks
            Pause
        }
        '2' {
            $shutdownTime = (Get-Date).Date.AddHours(18)
            Create-ShutdownTask -TriggerTime $shutdownTime
        }
        '3' {
            $shutdownTime = (Get-Date).Date.AddHours(21)
            Create-ShutdownTask -TriggerTime $shutdownTime
        }
        'q' {
            return
        }
    }
} until ($choice -eq 'q')
