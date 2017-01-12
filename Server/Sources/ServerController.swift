//
//  ServerController.swift
//  Server
//
//  Created by Aaron Liberatore on 1/11/17.
//
//

import Foundation
import Kitura
import KituraNet
import SwiftyJSON
import FirebaseSwift
import HeliumLogger

public class ServerController {
    
    public let router = Router()
    
    private let firebase = Firebase(baseURL: "https://r-dinventory.firebaseio.com/")
    
    public init(port: UInt) {
        setupRoutes()
    }
    
    private func setupRoutes() {
        router.get("/", handler: onGet)
    }
    
    private func onGet(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let result = firebase.get(path: "builds") else {
            response.send("Failure")
            next()
            return
        }

        response.send(String(describing: result))

        next()
    }

}
