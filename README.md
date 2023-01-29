# PDF to image web-based converter

## What?

A simple webpage where a user can convert a multi-page PDF file to one JPEG per page.

## Why?

Other web converters will upload the PDF to the server or have various limits
based on upload size, pages, ...

This converter is fully client-side and doesn't require any uploads.

## How?

The converter is using [pdf.js](https://github.com/mozilla/pdf.js) to render each
page to a `canvas` element and uses it to convert the page to a JPEG. The user
can then click the images to initiate the download with a filename based on the
original PDF filename and the page number.

## Usage

### Development

Clone the project, install dependencies and run it:

```sh
git clone https://github.com/strayer/pdf-to-image-web-converter.git
cd pdf-to-image-web-converter

pnpm install
pnpm run dev
```

Then access the webpage at http://localhost:5173/.

### Production

Run the Docker container:

`docker run -d -p 8000:80 ghcr.io/strayer/pdf-to-image-web-converter:latest`

Then access the webpage at http://localhost:8000/.
