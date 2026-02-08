$ErrorActionPreference = "Stop"

# Paths
$LayerReq = "layer\requirements.txt"
$LayerZip = "infra\artifacts\layer.zip"
$LayerHashFile = "layer\.layer.hash"

$LambdaSrc = "app\src"
$LambdaZip = "infra\artifacts\lambda.zip"
$LambdaHashFile = "app\.lambda.hash"

# Ensure artifacts folder
if (!(Test-Path "infra\artifacts")) {
  New-Item -ItemType Directory -Path "infra\artifacts" | Out-Null
}

function Get-Hash($path) {
  if (Test-Path $path) {
    return (Get-FileHash $path -Algorithm SHA256).Hash
  }
  return ""
}

# ---------- LAYER ----------
$layerHash = Get-Hash $LayerReq
$prevLayerHash = if (Test-Path $LayerHashFile) { Get-Content $LayerHashFile } else { "" }

if ($layerHash -ne $prevLayerHash) {
  Write-Host "🔁 Building Layer..."
  Remove-Item "layer\python" -Recurse -Force -ErrorAction SilentlyContinue
  New-Item -ItemType Directory -Path "layer\python" | Out-Null
  pip install -r $LayerReq -t layer\python
  Compress-Archive -Path layer\python\* -DestinationPath $LayerZip -Force
  $layerHash | Out-File $LayerHashFile -Force
} else {
  Write-Host "✅ Layer unchanged, skipping build"
}

# ---------- LAMBDA ----------
$lambdaHash = (Get-ChildItem $LambdaSrc -Recurse | Get-FileHash -Algorithm SHA256 | ForEach-Object Hash) -join ""
$prevLambdaHash = if (Test-Path $LambdaHashFile) { Get-Content $LambdaHashFile } else { "" }

if ($lambdaHash -ne $prevLambdaHash) {
  Write-Host "🔁 Building Lambda..."
  Compress-Archive -Path "$LambdaSrc\*" -DestinationPath $LambdaZip -Force
  $lambdaHash | Out-File $LambdaHashFile -Force
} else {
  Write-Host "✅ Lambda unchanged, skipping build"
}

Write-Host "🏁 Build completed"
