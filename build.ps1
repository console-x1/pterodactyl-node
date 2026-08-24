$ErrorActionPreference = "Stop"

$versions = @(
    20,
    22,
    26
)

$variants = @{
    "20" = "trixie"
    "22" = "trixie"
    "26" = "trixie"
}

foreach ($version in $versions) {
    $variant = $variants["$version"]
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