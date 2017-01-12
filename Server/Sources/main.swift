import Kitura
import HeliumLogger

// Initialize HeliumLogger
HeliumLogger.use()

let controller = ServerController(port: 8090)


// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8090, with: controller.router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
