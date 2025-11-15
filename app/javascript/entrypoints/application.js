// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>

// If using a TypeScript entrypoint file:
//     <%= vite_typescript_tag 'application' %>
//
// If you want to use .jsx or .tsx, add the extension:
//     <%= vite_javascript_tag 'application.jsx' %>


// Example: Load Rails libraries in Vite.
//
import * as Turbo from '@hotwired/turbo'
Turbo.start()
//
// import ActiveStorage from '@rails/activestorage'
// ActiveStorage.start()
//
// // Import all channels.
// const channels = import.meta.globEager('./**/*_channel.js')
// const controllers = import.meta.globEager('./**/*_controller.js')
import "../controllers/index"
import "../channels/index"

import Rails from "@rails/ujs";
Rails.start();


// Example: Import a stylesheet in app/frontend/index.css
// import '~/index.css'
