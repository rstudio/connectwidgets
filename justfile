# Install the required JS dependencies (alias "npm install")
deps:
  npm i

# Build the React components used by connectwidgets (alias "npm run build")
build:
  npm run build

# Lint R and JS
lint:
  Rscript -e 'lintr::lint_package()'
  npm run lint

# Start a development watch server for JS components
dev-watch:
  npm run dev:watch

# Roxygenise (generate connectwidgets docs)
roxygen:
  Rscript -e 'roxygen2::roxygenise()'

# Install package locally
local-install:
  Rscript -e 'devtools::install(upgrade = FALSE)'

# Run R tests
test-r:
  Rscript -e "devtools::test()"

# Run JS tests
test-ui:
  npm run test

# Run all tests
test:
  just test-r
  just test-ui

# Run JS tests in watch mode
test-watch:
  npm run test:watch
