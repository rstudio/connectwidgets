# Install the required JS dependencies (alias "npm install")
deps:
  npm i

# Build the React components used by rscpages (alias "npm run build")
build:
  npm run build

# Lint R and JS
lint:
  Rscript -e 'lintr::lint_package()'
  npm run lint

# Start a development watch server for JS components
dev-watch:
  npm run dev:watch

# Roxygenise (generate rscpages docs)
roxygen:
  Rscript -e 'roxygen2::roxygenise()'

# Install package locally
local-install:
  Rscript -e 'devtools::install(upgrade = FALSE)'

# Run tests
test:
  npm run test

# Run JS tests in watch mode
test-watch:
  npm run test:watch
