param(
    [int[]]$Versions = @(14, 16, 18, 20, 22, 24, 26)
)

$ErrorActionPreference = "Stop"

$variants = @{
    "14" = "bullseye"
    "16" = "bookworm"
    "18" = "bookworm"
    "20" = "trixie"
    "22" = "trixie"
    "24" = "trixie"
    "26" = "trixie"
}

foreach ($version in $Versions) {
    $variant = if ($variants.ContainsKey("$version")) { $variants["$version"] } else { "trixie" }
    $tag = "pterodactyl-node:$version"

    Write-Host ""
    Write-Host "========================================"
    Write-Host " Building Node.js $version"
    Write-Host " Base: $variant"
    Write-Host " Tag:  $tag"
    Write-Host "========================================"

    docker build `
        --build-arg "NODE_VERSION=$version" `
        --build-arg "NODE_VARIANT=$variant" `
        -t $tag `
        -f docker/node/Dockerfile .

    if ($LASTEXITCODE -ne 0) {
        throw "Build failed for Node.js $version"
    }

    docker run --rm $tag node --version

    if ($LASTEXITCODE -ne 0) {
        throw "Runtime test failed for Node.js $version"
    }
}