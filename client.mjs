
import { main_$x_ } from "./out-page/app.client.mjs"

import "cirru-color/assets/cirru.css"

main_$x_()

if (import.meta.hot) {
  import.meta.hot.accept('./out-page/app.client.mjs', (main) => {
    main.reload_$x_()
  })
}
