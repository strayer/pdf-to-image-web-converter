<script setup lang="ts">
const emit = defineEmits<{
  (e: "newFile", file: File): void;
}>();
const onChange = (e: Event) => {
  const input = e.target as HTMLInputElement;
  const file = input.files && input.files[0];

  if (file) {
    emit("newFile", file);
  }
};
</script>

<template>
  <div class="row mb-3">
    <div class="col">
      <p class="lead">
        Um ein PDF in ein Bild zu konvertieren, wähle die zu konvertierende Datei unten aus.
      </p>
    </div>
  </div>

  <div class="row gy-3" style="max-width: 970px">
    <label class="col-auto col-form-label" for="file">
      PDF-Datei auswählen
    </label>
    <div class="col-auto col-md">
      <input
        class="form-control"
        type="file"
        @change="onChange"
        accept="application/pdf"
      />
    </div>
  </div>
</template>
