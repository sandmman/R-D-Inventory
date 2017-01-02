//
//  DataManager.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/1/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import Foundation

public protocol DataManager {
    
    func add(assembly: Assembly)
    
    func add(build: Build)
    
    func add(part: Part)
    
    func get(assembly: String, onComplete: @escaping (Assembly) -> ())
    
    func get(build: String, onComplete: @escaping (Build) -> ())
    
    func get(part: String, onComplete: @escaping (Part) -> ())
    
    func update(assembly: Assembly)
    
    func update(build: Build)
    
    func update(part: Part)
    
    func delete(assembly: Assembly)
    
    func delete(build: Build)
    
    func delete(part: Part)
    
    func getParts(for assembly: Assembly, onComplete: @escaping (Part) -> ())
    
    func getBuilds(for assembly: Assembly, onComplete: @escaping (Build) -> ())

}
