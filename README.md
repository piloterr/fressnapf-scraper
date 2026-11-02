<p align="center">
  <a href="https://www.piloterr.com"><img src="images/banner.png" alt="Fressnapf Scraper API by Piloterr – scrape Fressnapf data as JSON" width="100%"></a>
</p>

# Fressnapf Scraper API

[![Discord](https://img.shields.io/badge/Discord-Join%20the%20community-5865F2?logo=discord&logoColor=white)](https://discord.gg/CFj3ph8aHU) [![Get API key](https://img.shields.io/badge/Piloterr-Get%20a%20free%20API%20key-111827)](https://app.piloterr.com) [![API docs](https://img.shields.io/badge/Docs-OpenAPI-0EA5E9)](https://app.piloterr.com/openapi) [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

The **Piloterr Fressnapf Scraper API** lets you extract public data from Fressnapf as **clean, structured JSON** — no proxies, headless browsers or HTML parsing to maintain. Endpoints available in production:

- **Fressnapf Product API** — Read a Fressnapf Germany product sheet from its URL.
- **Fressnapf Search API** — Search Fressnapf Germany by keyword or category URL.

Use it for price monitoring, assortment tracking, competitor analysis, product research or catalog enrichment.

| Endpoint | Path | Credits | What you get |
|---|---|---|---|
| [Fressnapf Product API](#fressnapf-product-api) | `/v2/fressnapf/product` | 1 | Read a Fressnapf Germany product sheet from its URL. Returns sku, GTIN, euro price, unit price, and pack variants. |
| [Fressnapf Search API](#fressnapf-search-api) | `/v2/fressnapf/search` | 1 | Search Fressnapf Germany by keyword or category URL. Returns product cards with euro prices and pagination. |

## Table of contents

- [How it works](#how-it-works)
- [Fressnapf Product API](#fressnapf-product-api)
- [Fressnapf Search API](#fressnapf-search-api)
- [Code examples in other languages](#code-examples-in-other-languages)
- [Practical use cases](#practical-use-cases)
- [Why Piloterr?](#why-piloterr)
- [FAQ](#faq)
- [Related scrapers](#related-scrapers)
- [Support](#support)

## How it works

1. **Create a free Piloterr account** and copy your API key from the [dashboard](https://app.piloterr.com).
2. **Send a `GET` (or `POST`) request** to `https://api.piloterr.com/v2/...` with the header `x-api-key: YOUR_API_KEY`.
3. **Receive structured JSON** — Piloterr handles rendering, proxies, retries and parsing.

```bash
export PILOTERR_API_KEY="your-api-key"
pip install requests        # Python
# TypeScript: Node.js 18+ (native fetch), run with `npx tsx file.ts`
```

> Every endpoint accepts both `GET` (query string) and `POST` (JSON body with the same fields).

## Fressnapf Product API

Read a Fressnapf Germany product sheet from its URL. Returns sku, GTIN, euro price, unit price, and pack variants.

`GET | POST https://api.piloterr.com/v2/fressnapf/product` · **1 credit per request** · [Full reference](https://app.piloterr.com/openapi)

### Request parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `query` | string | ✅ | Product URL on www.fressnapf.de. |
| `return_page_source` | boolean | — | When true, return the raw HTML. The string `false` stays false. |

### Python example

```python
import json
import os
import requests

response = requests.get(
    "https://api.piloterr.com/v2/fressnapf/product",
    headers={"x-api-key": os.environ["PILOTERR_API_KEY"]},
    params={
        "query": "https://www.fressnapf.de/p/royal-canin-maxi-adult-15-kg-1003112004/",
    },
    timeout=60,
)
response.raise_for_status()
data = response.json()

print(json.dumps(data, indent=2, ensure_ascii=False)[:2000])
```

### TypeScript example

```typescript
type FressnapfProduct = {
  sku?: string;
  url?: string;
  gtin?: string;
  brand?: string;
  price?: number;
  title?: string;
  category?: string;
  currency?: string;
  in_stock?: boolean;
  variants?: {
    url?: string;
    name?: string;
    price?: number;
    in_stock?: boolean;
    selected?: boolean;
    unit_price?: number;
    price_display?: string;
    unit_price_display?: string;
  }[];
  brand_url?: string;
  image_url?: string;
  product_id?: string;
  unit_price?: number;
  description?: string;
  delivery_time?: string;
  price_display?: string;
  unit_price_display?: string;
};

const params = new URLSearchParams({
  "query": "https://www.fressnapf.de/p/royal-canin-maxi-adult-15-kg-1003112004/",
});

const response = await fetch(`https://api.piloterr.com/v2/fressnapf/product?${params}`, {
  headers: { "x-api-key": process.env.PILOTERR_API_KEY! },
});
if (!response.ok) throw new Error(`Piloterr error ${response.status}: ${await response.text()}`);

const data = (await response.json()) as FressnapfProduct;

console.log(JSON.stringify(data, null, 2).slice(0, 2000));
```

<details>
<summary><b>POST variant</b></summary>

```http
POST https://api.piloterr.com/v2/fressnapf/product
x-api-key: YOUR_API_KEY
Content-Type: application/json

{"query": "https://www.fressnapf.de/p/royal-canin-maxi-adult-15-kg-1003112004/"}
```
</details>

### Output example

Example response from the API reference, abridged — real values depend on the page you scrape.

```json
{
  "sku": "1003112004",
  "url": "https://www.fressnapf.de/p/royal-canin-maxi-adult-15-kg-1003112004/",
  "gtin": "3182550401937",
  "brand": "ROYAL CANIN",
  "price": 64.49,
  "title": "ROYAL CANIN Maxi Adult 15 kg",
  "category": "Hundefutter",
  "currency": "EUR",
  "in_stock": true,
  "variants": [
    {
      "url": "https://www.fressnapf.de/p/royal-canin-maxi-adult-15-kg-1003112004/",
      "name": "15 kg",
      "price": 64.49,
      "in_stock": true,
      "selected": true,
      "unit_price": 4.3,
      "price_display": "64,49 €",
      "unit_price_display": "4,30 €/kg"
    }
  ],
  "brand_url": "https://www.fressnapf.de/c/marken/royal-canin/",
  "image_url": "https://media.os.fressnapf.com/products-v2/a/b/2/3/ab239d62865ca238b683c5e1ac8c2955e5fbd044_1003112004__2_.jpeg?t=prod_l",
  "product_id": "1003112004",
  "unit_price": 4.3,
  "description": "Art.Nr.: 1003112004 Alleinfuttermittel für Hunde.",
  "delivery_time": "In 1 - 3 Tagen",
  "price_display": "64,49 €",
  "unit_price_display": "4,30 €/kg"
}
```

### Response fields

| Field | Type | Description |
|---|---|---|
| `sku` | string |  |
| `url` | string |  |
| `gtin` | string |  |
| `brand` | string |  |
| `price` | number |  |
| `title` | string |  |
| `category` | string |  |
| `currency` | string |  |
| `in_stock` | boolean |  |
| `variants[]` | object[] |  |
| `variants[].url` | string |  |
| `variants[].name` | string |  |
| `variants[].price` | number |  |
| `variants[].in_stock` | boolean |  |
| `variants[].selected` | boolean |  |
| `variants[].unit_price` | number |  |
| `variants[].price_display` | string |  |
| `variants[].unit_price_display` | string |  |
| `brand_url` | string |  |
| `image_url` | string |  |
| `product_id` | string |  |
| `unit_price` | number |  |
| `description` | string |  |
| `delivery_time` | string |  |
| `price_display` | string |  |

## Fressnapf Search API

Search Fressnapf Germany by keyword or category URL. Returns product cards with euro prices and pagination.

`GET | POST https://api.piloterr.com/v2/fressnapf/search` · **1 credit per request** · [Full reference](https://app.piloterr.com/openapi)

### Request parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `query` | string | ✅ | Keyword or a fressnapf.de search or category URL. |
| `page` | number | — | Page number, starting at 1. Example: 2. |
| `return_page_source` | boolean | — | When true, return the raw HTML. The string false stays false. |

### Python example

```python
import json
import os
import requests

response = requests.get(
    "https://api.piloterr.com/v2/fressnapf/search",
    headers={"x-api-key": os.environ["PILOTERR_API_KEY"]},
    params={
        "query": "halsband",
    },
    timeout=60,
)
response.raise_for_status()
data = response.json()

print(json.dumps(data, indent=2, ensure_ascii=False)[:2000])
```

### TypeScript example

```typescript
type FressnapfSearch = {
  results?: {
    url?: string;
    brand?: string;
    price?: number;
    title?: string;
    rating?: number;
    currency?: string;
    image_url?: string;
    product_id?: string;
    review_count?: number;
    price_display?: string;
  }[];
  pagination?: {
    next?: string;
    page?: number;
    per_page?: number;
    total_pages?: number;
    total_results?: number;
  };
};

const params = new URLSearchParams({
  "query": "halsband",
});

const response = await fetch(`https://api.piloterr.com/v2/fressnapf/search?${params}`, {
  headers: { "x-api-key": process.env.PILOTERR_API_KEY! },
});
if (!response.ok) throw new Error(`Piloterr error ${response.status}: ${await response.text()}`);

const data = (await response.json()) as FressnapfSearch;

console.log(JSON.stringify(data, null, 2).slice(0, 2000));
```

<details>
<summary><b>POST variant</b></summary>

```http
POST https://api.piloterr.com/v2/fressnapf/search
x-api-key: YOUR_API_KEY
Content-Type: application/json

{"query": "halsband"}
```
</details>

### Output example

Example response from the API reference, abridged — real values depend on the page you scrape.

```json
{
  "results": [
    {
      "url": "https://www.fressnapf.de/p/beaphar-reflektierendes-zecken--und-flohschutzhalsband-1280089/",
      "brand": "Beaphar",
      "price": 6.19,
      "title": "reflektierendes Zecken- und Flohschutzhalsband",
      "rating": 2.4,
      "currency": "EUR",
      "image_url": "https://media.os.fressnapf.com/products-v2/4/e/0/6/4e06dfdb341c3e76a5a407dc5cf46fe87be656d9_1280089_0.jpg?f=webp&t=prodtp_s",
      "product_id": "1280089",
      "review_count": 66,
      "price_display": "6,19 €"
    }
  ],
  "pagination": {
    "next": "https://www.fressnapf.de/search/?currentPage=2&text=reflektierendes+halsband",
    "page": 1,
    "per_page": 48,
    "total_pages": 2,
    "total_results": 54
  }
}
```

### Response fields

| Field | Type | Description |
|---|---|---|
| `results[]` | object[] |  |
| `results[].url` | string |  |
| `results[].brand` | string |  |
| `results[].price` | number |  |
| `results[].title` | string |  |
| `results[].rating` | number |  |
| `results[].currency` | string |  |
| `results[].image_url` | string |  |
| `results[].product_id` | string |  |
| `results[].review_count` | integer |  |
| `results[].price_display` | string |  |
| `pagination` | object |  |
| `pagination.next` | string |  |
| `pagination.page` | integer |  |
| `pagination.per_page` | integer |  |
| `pagination.total_pages` | integer |  |
| `pagination.total_results` | integer |  |

## Code examples in other languages

Ready-to-run examples live in the [`examples/`](examples) folder. Each one reads your key from the `PILOTERR_API_KEY` environment variable.

| Language | Product | Search |
|---|---|---|
| cURL (Bash) | [`product`](examples/curl/product.sh) | [`search`](examples/curl/search.sh) |
| PHP | [`product`](examples/php/product.php) | [`search`](examples/php/search.php) |
| C# | [`product`](examples/csharp/Product.cs) | [`search`](examples/csharp/Search.cs) |
| Go | [`product`](examples/go/product.go) | [`search`](examples/go/search.go) |
| Java | [`product`](examples/java/ProductExample.java) | [`search`](examples/java/SearchExample.java) |
| Ruby | [`product`](examples/ruby/product.rb) | [`search`](examples/ruby/search.rb) |
| Node.js | [`product`](examples/nodejs/product.mjs) | [`search`](examples/nodejs/search.mjs) |

## Practical use cases

- **Price monitoring** — Track prices, promotions and availability over time to react to competitors.
- **Assortment & catalog tracking** — Follow new products, delisted items and category changes.
- **Competitor analysis** — Benchmark ranges, brands and positioning across retailers.
- **Product research** — Spot best-sellers and trends from search results.
- **Catalog enrichment** — Pull titles, images and attributes into your PIM or marketplace listings.

## Why Piloterr?

- **No infrastructure** — no proxies, headless browsers or CAPTCHA solving to run yourself.
- **Structured JSON** — stable, documented fields instead of brittle HTML selectors.
- **Pay per request** — transparent credit cost per endpoint, failed requests are retried for you.
- **One API key, hundreds of sources** — Fressnapf plus many other e-commerce, search and company data endpoints in the [Piloterr library](https://www.piloterr.com/library).
- **Any language** — plain HTTPS + JSON, with examples for Python, TypeScript, cURL, PHP, C#, Go, Java, Ruby and Node.js.

## FAQ

### Is it legal to scrape Fressnapf?

Collecting publicly available data is generally allowed in many jurisdictions, but rules depend on your country, the data you collect and how you use it. Avoid personal data unless you have a lawful basis, respect the website's terms where they apply, and get legal advice for your specific use case. This is not legal advice.

### Do I need proxies or a headless browser?

No. Piloterr handles rendering, proxy rotation and retries on its side. You only send an HTTPS request with your `x-api-key` header and receive JSON.

### How much does a request cost?

Credits per call: `/v2/fressnapf/product` **1**, `/v2/fressnapf/search` **1**. See the [Piloterr website](https://www.piloterr.com) for plans.

### What data does the Fressnapf API return?

Each endpoint returns structured JSON: **Fressnapf Product** — `sku`, `url`, `gtin`, `brand`, `price`, `title`; **Fressnapf Search** — `results[]`, `results[].url`, `results[].brand`, `results[].price`, `results[].title`, `results[].rating`.

### How do I paginate Fressnapf results?

Use the `page` parameter and keep requesting while the response indicates more results.

### Can I get the raw HTML instead of JSON?

Yes. Set `return_page_source=true` and the response becomes `{"result": "..."}` with the page source.

### Which languages are supported?

Any language that can make an HTTP request. This README shows Python and TypeScript; the [`examples/`](examples) folder contains cURL, PHP, C#, Go, Java, Ruby and Node.js.

## Related scrapers

- [About You Scraper API](https://github.com/piloterr/aboutyou-scraper)
- [Action Scraper API](https://github.com/piloterr/action-scraper)
- [Aldi Scraper API](https://github.com/piloterr/aldi-scraper)
- [Alibaba Scraper API](https://github.com/piloterr/alibaba-scraper)
- [AliExpress Scraper API](https://github.com/piloterr/aliexpress-scraper)
- [Allegro Scraper API](https://github.com/piloterr/allegro-scraper)
- [All Piloterr scrapers on GitHub](https://github.com/piloterr)

## Support

- 💬 Join the [Piloterr Discord](https://discord.gg/CFj3ph8aHU) to ask questions and share what you build.
- 📚 Browse the [API reference (OpenAPI)](https://app.piloterr.com/openapi) and the [Piloterr library](https://www.piloterr.com/library).
- 🔑 [Get your API key](https://app.piloterr.com).

---

<p align="center">
  <a href="https://www.piloterr.com">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="images/logo-dark.svg">
      <img src="images/logo.svg" alt="Piloterr" height="32">
    </picture>
  </a>
  <br>
  <sub>Built by <a href="https://www.piloterr.com">Piloterr</a> — web scraping APIs for e-commerce, search, real estate and more, one API key.</sub>
</p>

<sub>Fressnapf is a trademark of its respective owner. This repository is not affiliated with or endorsed by Fressnapf. Examples are released under the MIT license.</sub>
