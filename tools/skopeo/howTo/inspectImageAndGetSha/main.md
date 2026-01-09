# Skopeo How To - Inspect Image and Get Sha

## Abstract
Especially for use with [[nix-package-manager]] and likely in other places as well this also requries [[jq]]

### Example
```bash
skopeo inspect --raw docker://mcr.microsoft.com/dotnet/aspnet:8.0 \
| jq -r '.manifests[] | select(.platform.architecture=="arm64" and .platform.os=="linux") | .digest'
```
### Expected output


## Directory

## Useful Links

## Tags
