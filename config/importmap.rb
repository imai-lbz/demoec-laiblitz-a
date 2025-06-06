# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "card", to: "card.js"
pin "condition_search", to: "condition_search.js"
pin "order_price_calculator", to: "order_price_calculator.js"
pin "search_scroll", to: "search_scroll.js"

