return {
  settings = {
    java = {
      -- Включаем декомпилятор FernFlower
      contentProvider = { preferred = 'fernflower' },
      -- Подтягиваем исходники из Maven/Gradle, если есть
      maven = { downloadSources = true },
      gradle = { downloadSources = true },
      -- Авто-импорты без звёздочек
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    }
  }
}
