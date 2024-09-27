# amro.omp.json
# M365Princess.omp.json
# catppuccin.omp.json
# catppuccin_frappe.omp.json
# material.omp.json

oh-my-posh --init --shell pwsh --config ~/scoop/apps/oh-my-posh/current/themes/M365Princess.omp.json | Invoke-Expression

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null
