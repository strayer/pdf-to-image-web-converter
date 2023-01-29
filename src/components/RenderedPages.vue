<script setup lang="ts">
const props = defineProps<{
  filename: string,
  renderedPages: Array<string>;
}>();

const pageFilename = (filename: string, pageNumber: number) => {
  return `${filename.replace(/\.[^/.]+$/, "")}-${pageNumber}.jpg`;
};
</script>

<template>
  <template v-if="renderedPages.length > 0">
    <div class="row mb-3">
      <div class="col">
        <p class="lead">
          <span v-if="renderedPages.length == 1"
            >Es wurde eine Seite konvertiert.</span
          >
          <span v-else>
            Es wurden
            <span v-text="renderedPages.length"></span>
            Seiten konvertiert.
          </span>
          Ein Klick auf ein Bild startet den Download.
        </p>
      </div>
    </div>

    <template v-for="(page, index) in renderedPages">
      <img style="width: 100%" />
      <div class="row">
        <div class="col">
          <h3 v-text="pageFilename(filename, index + 1)"></h3>
        </div>
      </div>
      <div class="row">
        <div class="col">
          <a :href="page" :download="pageFilename(filename, index + 1)">
            <img :src="page" class="img-fluid" />
          </a>
        </div>
      </div>
    </template>
  </template>
</template>
