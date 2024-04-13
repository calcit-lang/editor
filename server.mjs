#!/usr/bin/env node --no-warnings=ExperimentalWarning

import { main_$x_, reload_$x_ } from "./js-out/app.server.mjs"

main_$x_()

// if (import.module.hot) {
//   import.module.hot.accept('./js-out/app.server.mjs', (main) => {
//     console.log("Reload server")
//     reload_$x_()
//   })
// }
