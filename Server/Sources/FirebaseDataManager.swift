//
//  FirebaseDataManager.swift
//  Server
//
//  Created by Aaron Liberatore on 1/18/17.
//
//

import Foundation
import FirebaseSwift

class FirebaseDataManager {
    
    static fileprivate let firebase = Firebase(baseURL: "https://r-dinventory.firebaseio.com/")

    static func getParts() -> [Part] {
        guard let result = firebase.get(path: "parts"), let res = result as? [String: Any] else {
            return []
        }

        return res.reduce([], convert)
    }
    
    static func getProjects() -> [Project] {
        guard let result = firebase.get(path: "builds"), let res = result as? [String: Any] else {
            return []
        }
        return res.reduce([], convert)
    }
    
    static func getBuilds() -> [Build] {
        guard let result = firebase.get(path: "builds"), let res = result as? [String: Any] else {
            return []
        }
        return res.reduce([], convert)
    }
    
    static func getAssemblies() -> [Assembly] {
        guard let result = firebase.get(path: "assemblies"), let res = result as? [String: Any] else {
            return []
        }
       return res.reduce([], convert)
    }
    
    static func get(part: String) -> Part? {
        return get(objID: part, pathToID: "parts/")
    }
    
    static func get(project: String) -> Part? {
        return get(objID: project, pathToID: "projects/")
    }
    
    static func get(assembly: String) -> Part? {
        return get(objID: assembly, pathToID: "assemblies/")
    }
    
    static func get(build: String) -> Part? {
        return get(objID: build, pathToID: "builds/")
    }
}

extension FirebaseDataManager {
    static func postPartsNeeded(part: Part, projectID: String) {
        let _ = firebase.put(path: "projects/\(projectID)/NeedsParts/\(part.key)", value: true)
    }
}

extension FirebaseDataManager {
    
    fileprivate static func get<T: FIRDataObject>(objID: String, pathToID: String) -> T? {
        guard let result = firebase.get(path: "\(pathToID)\(objID)"), let res = result as? [String: Any], let key = res.keys.first, let data = res[key] as? [String: Any] else {
            return nil
        }

        return T(key: key, value: data)
    }

    fileprivate static func convert<T: FIRDataObject>(arr: [T], obj: (key: String, value: Any)) -> [T] {
        var arr = arr
        
        guard let obj = T(key: obj.0, value: obj.1) else {
            return arr
        }

        arr.append(obj)
        
        return arr
    }
}
