//
//  WarningController.swift
//  Server
//
//  Created by Aaron Liberatore on 1/18/17.
//
//

import Foundation
import Dispatch
import HeliumLogger
import LoggerAPI

public class WarningController {
    
    let queue: DispatchQueue = DispatchQueue(label: "com.firebase.timer", attributes: .concurrent)
    var timer: DispatchSourceTimer? = nil
    var updatedTimer: DispatchSourceTimer? = nil

    public func run() {
        
        Log.verbose("Initiating Timer")
        
        timer = DispatchSource.makeTimerSource(queue: queue)
        updatedTimer = DispatchSource.makeTimerSource(queue: queue)
        
        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(10))
        
        timer?.setEventHandler { [weak self] in
            
            Log.verbose("Running")
            
            for project in FirebaseDataManager.getProjects() {
                self?.queue.async {
                    self?.check(project: project)
                }
            }
    
            var parts: [String: Part] = FirebaseDataManager.getParts().reduce([:]) {
                dict, part in
                
                var dict = dict
                dict[part.key] = part
                return dict
            }

            var builds = FirebaseDataManager.getBuilds()
            
            builds.sort {
                $0.scheduledDate < $1.scheduledDate
            }
            
            for build in builds {
                for (partKey, count) in build.partsNeeded {
                    if let part = parts[partKey], part.countInStock <= count {
                        FirebaseDataManager.postPartsNeeded(part: part, projectID: "")
                    }
                }
            }
    
        }

        timer?.resume()
    }
    
    public func stop() {
        timer?.cancel()
        timer = nil
    }
}

extension WarningController {
    
    fileprivate func check(project: Project) {
        
        Log.verbose("hello")
        
        /* parts = [String: Part]()
        
        for id in project.parts {
            if let part = FirebaseDataManager.get(part: id) {
                parts[id] = part
            }
        }*/
    }
}
