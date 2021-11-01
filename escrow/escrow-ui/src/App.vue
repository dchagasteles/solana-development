<template>
  <router-view />
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=PT+Serif:wght@400;700&display=swap');

html, body {
  font-family: 'PT Serif', serif;
  margin: 0;
}

.bg {
  margin: 0;
  margin-top: .5rem;
  padding: .1rem 1rem;
  border-radius: 0.4rem;
  background-color: #f0f4f8;
}

.title {
  font-weight: bold;
}

.mb-1 {
    margin-bottom: 1rem;
}

.display-block {
    display:block
}

.cursor-pointer {
    cursor: pointer
}

.border-none {
  border: none;
}

.bg-btn {
  background-color: #ededed;
  transition: .3s;
}

.bg-btn:hover {
  background-color: #02b57b;
}

.normal-font-size {
  font-size: .85rem;
}
</style>
