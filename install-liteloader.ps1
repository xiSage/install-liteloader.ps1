# 确认目录
if (Test-Path -Path "versions") {
    $QQNTDir = Join-Path -Path ".\versions\" (ConvertFrom-Json -InputObject (Get-Content '.\versions\config.json' -Raw)).curVersion "\resources\app"
} else {
    $QQNTDir = ".\resources\app"
}

# 下载LiteLoader
Remove-Item -Path ".\LiteLoaderQQNT.zip" -ErrorAction SilentlyContinue
Invoke-WebRequest -Uri "https://github.com/LiteLoaderQQNT/LiteLoaderQQNT/releases/latest/download/LiteLoaderQQNT.zip" -OutFile ".\LiteLoaderQQNT.zip"
Expand-Archive -Path ".\LiteLoaderQQNT.zip" -DestinationPath ".\liteloader" -Force
Remove-Item -Path ".\LiteLoaderQQNT.zip"

# 创建启动文件
$launchFile = (Join-Path $QQNTDir "app_launcher\liteloader.js")
$liteloaderPath = Convert-Path ".\liteloader"
Remove-Item -Path $launchFile -ErrorAction SilentlyContinue
New-Item -Path $launchFile
Set-Content -Path $launchFile -Force -Value "require(String.raw``$liteloaderPath``)"
$packagePath = Join-Path $QQNTDir "package.json"
$packageContent = Get-Content $packagePath -Raw | ConvertFrom-Json
$packageContent.main = "./app_launcher/liteloader.js"
Set-Content $packagePath -Value (ConvertTo-Json $packageContent) -Force