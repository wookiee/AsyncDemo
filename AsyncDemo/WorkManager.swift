//
//  WorkManager.swift
//  AsyncAPOD
//
//  Created by Mikey Ward on 3/10/22.
//

import Foundation

class WorkManager {
    
    private let worker = Worker()
    
    private(set) var answers = [Double]()
    
    /// Spawns `count` concurrent workloads, each of which will take 3.5 to 6.5 seconds to complete, at random.
    /// - Parameters:
    ///   - count: The number of concurrent workloads to spawn.
    ///   - completion: A completion handler to be executed on the main queue to process the cumulative workload output.
//    func spawnConcurrentWorkloads(count: Int, completion: @escaping ([String])->Void) {
//        print("Beginning \(count) workers")
//
//        let group = DispatchGroup()
//        for i in 1...count {
//            group.enter()
//            let duration = 5.0 + Double.random(in: -1.5 ... 1.5)
//            worker.doBackgroundWork(for: duration) { answer in
//                print("Finished worker \(i), with output \(answer)")
//                self.answers.append(answer)
//                group.leave()
//            }
//        }
//
//        group.notify(queue: .main) {
//            let answerTotal = self.answers.map {"\(floor($0 * 1000) / 10)%"}
//            completion(answerTotal)
//        }
//    }
    
    func spawnConcurrentWorkloads(count: Int) async -> [String] {
        let finalAnswers = await withTaskGroup(of: String.self,
                                               returning: [String].self) { taskGroup in
            for _ in 0..<count {
                taskGroup.addTask {
                    let output = await self.worker.doBackgroundWork(for: 5.0)
                    return "\(floor(output * 1000) / 10)%"
                }
            }
            
            var answers = [String]()
            for await answer in taskGroup {
                answers.append(answer)
            }
            
            return answers
        }
        
        return finalAnswers
    }
    
//    private var pairInProgress = (0.0,0.0)
//    func spawnWorkloadPair(completion: @escaping ((Double,Double))->Void) {
//        let group = DispatchGroup()
//
//        group.enter()
//        group.enter()
//
//        worker.doBackgroundWork(for: 4.0) { answer in
//            self.pairInProgress.0 = answer
//            group.leave()
//        }
//
//        worker.doBackgroundWork(for: 3.0) { answer in
//            self.pairInProgress.1 = answer
//            group.leave()
//        }
//
//        group.notify(queue: .main) {
//            let output = self.pairInProgress
//            completion(output)
//        }
//    }
    
    func spawnWorkloadPair() async -> (Double, Double) {
        async let resultOne = worker.doWork(for: 3.0)
        async let resultTwo = worker.doWork(for: 4.0)
        let pair = await (resultOne, resultTwo)
        return pair
    }

}

