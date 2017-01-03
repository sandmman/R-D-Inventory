//
//  DataManager.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/1/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import Foundation

public protocol DataManager {
    
    static func add(assembly: Assembly)
    
    static func add(build: Build)
    
    static func add(part: Part)
    
    static func add(project: Project)

    static func get(assembly: String, onComplete: @escaping (Assembly) -> ())
    
    static func get(build: String, onComplete: @escaping (Build) -> ())
    
    static func get(part: String, onComplete: @escaping (Part) -> ())
    
    static func get(project: String, onComplete: @escaping (Project) -> ())
    
    static func update(assembly: Assembly)
    
    static func update(build: Build)
    
    static func update(part: Part)
    
    static func update(project: Project)
    
    static func delete(assembly: Assembly)
    
    static func delete(build: Build)
    
    static func delete(part: Part)
    
    static func delete(project: Project)
    
    static func getParts(for assembly: Assembly, onComplete: @escaping (Part) -> ())
    
    static func getBuilds(for assembly: Assembly, onComplete: @escaping (Build) -> ())
}
