import Kitura
import HeliumLogger
import LoggerAPI

// Initialize HeliumLogger
HeliumLogger.use()

let controller = ServerController(port: 8090)

let checker = WarningController()

checker.run()

Log.verbose("starting")

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8090, with: controller.router)

// Start the Kitura runloop (this call never returns)
Kitura.run()

