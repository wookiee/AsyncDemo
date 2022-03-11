//
//  ThingDoer.swift
//  AsyncAPOD
//
//  Created by Mikey Ward on 3/10/22.
//

import Foundation

class Worker {
    
    /// Asynchronously perform `duration` seconds of work in the background.
    /// - Parameters:
    ///   - duration: Number of seconds to work for
    ///   - completion: A background-executed completion handler. The output of the completed work will be passed as its argument.
    func doBackgroundWork(for duration: TimeInterval) async -> Double {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                let output = self.doWork(for: duration)
                continuation.resume(returning: output)
            }
        }
    }
    
    
    
//    func doBackgroundWork(for duration: TimeInterval) async -> Double {
//        let task = Task<Double,Never> {
//            let output = self.doWork(for: duration)
//            return output
//        }
//        return await task.value
//    }
    
    
    
    /// Synchronously perform `duration` seconds of work on the calling thread.
    /// - Parameter duration: Number of seconds to work for
    /// - Returns: The output of the work completed.
    @discardableResult func doWork(for duration: TimeInterval) -> Double {
        let startTime = DispatchWallTime.now()
        var result = 0.0
        while (DispatchWallTime.now() - duration) < startTime {
            result = sin(sin(sin(sin(sin(sin(sin(Double.random(in: 0...1))))))))
        }
        return result
    }
    
}
