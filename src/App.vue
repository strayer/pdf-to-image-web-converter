<script setup lang="ts">
import { ref } from "vue";

import UploadPrompt from "./components/UploadPrompt.vue";
import RenderedPages from "./components/RenderedPages.vue";

// @ts-ignore
import * as pdfjs from "pdfjs-dist/build/pdf";

import pdfjsWorker from "pdfjs-dist/build/pdf.worker?worker";

(window as any).pdfjsWorker = pdfjsWorker;
pdfjs.GlobalWorkerOptions.workerSrc = `https://cdnjs.cloudflare.com/ajax/libs/pdf.js/${pdfjs.version}/pdf.worker.js`;

const uploadedFile = ref<File | null>(null);
const renderedPages = ref<Array<string>>([]);
const converting = ref<boolean>(false);

const processFile = async (file: File) => {
  uploadedFile.value = file;
  converting.value = true;

  const fileReader = new FileReader();
  fileReader.onload = async () => {
    const pdf = await pdfjs.getDocument(fileReader.result).promise;
    const totalPages = pdf.numPages;
    const newRenderedPages = [];

    for (let pageNumber = 1; pageNumber <= totalPages; pageNumber++) {
      const page = await pdf.getPage(pageNumber);

      const scale = 4;
      const viewport = page.getViewport({ scale });

      const canvas = document.createElement("canvas");

      const context = canvas.getContext("2d");
      canvas.height = viewport.height;
      canvas.width = viewport.width;

      const renderContext = {
        canvasContext: context,
        viewport,
        intent: "print",
      };

      const renderTask = page.render(renderContext);
      await renderTask.promise;

      const png = canvas.toDataURL("image/jpeg");
      newRenderedPages.push(png);
    }

    renderedPages.value = newRenderedPages;
    converting.value = false;
  };
  fileReader.readAsArrayBuffer(file);
};
</script>

<template>
  <div class="container">
    <div class="row mb-1">
      <div class="col">
        <h1 class="display-1">PDF-Datei in Bild umwandeln</h1>
      </div>
    </div>

    <UploadPrompt
      @new-file="processFile"
      v-if="!converting && (!renderedPages || renderedPages.length === 0)"
    />

    <div class="row mb-1">
      <div class="col">
        <h2 v-text="uploadedFile?.name"></h2>
      </div>
    </div>

    <div class="row mb-3" v-if="converting">
      <div class="col">
        <p class="lead">Datei wird konvertiert...</p>
      </div>
    </div>

    <RenderedPages :renderedPages="renderedPages" :filename="uploadedFile.name" v-if="uploadedFile" />
  </div>
</template>
