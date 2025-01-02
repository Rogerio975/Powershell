# Solicita o IP ou nome do computador
$computerName = Read-Host "Digite o IP ou nome do computador"

# Exibe mensagem inicial
Write-Host "Listando os produtos instalados no computador $computerName..." -ForegroundColor Cyan

# Executa o comando WMIC no computador especificado
$output = wmic /node:$computerName product get name,version 2>&1

# Verifica se houve erro de conexão
if ($output -match "ERROR" -or $output -match "Acesso negado") {
    Write-Host "Erro ao conectar ao computador $computerName. Verifique o nome/IP ou permissões." -ForegroundColor Red
} else {
    # Verifica se a saída contém dados válidos
    if ($output -is [string] -and $output -match '\S') {
        # Filtra e exibe o resultado, ignorando linhas vazias
        $output.Split("`n") | ForEach-Object {
            $line = $_.Trim()
            if ($line -match '\S' -and $line -notmatch "Name  Version") {
                Write-Output $line
            }
        }
        # Mensagem final
        Write-Host "Estes são os programas instalados no computador $computerName." -ForegroundColor Green
    } else {
        Write-Host "Erro ao obter a lista de programas instalados. Nenhuma saída válida foi retornada." -ForegroundColor Red
    }
}
