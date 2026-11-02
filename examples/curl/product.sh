#!/usr/bin/env bash
# Fressnapf Product API – cURL example
# Usage: PILOTERR_API_KEY=your-key ./product.sh
set -euo pipefail

curl -sS -G "https://api.piloterr.com/v2/fressnapf/product" \
  -H "x-api-key: ${PILOTERR_API_KEY}" \
  --data-urlencode query=https://www.fressnapf.de/p/royal-canin-maxi-adult-15-kg-1003112004/
