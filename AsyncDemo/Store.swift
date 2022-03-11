//
//  Store.swift
//  AsyncAPOD
//
//  Created by Mikey Ward on 3/10/22.
//

import Foundation
import Combine

actor NumberStore: ObservableObject {
    
    @Published private(set) var isStoreLoaded = false
    @Published private(set) var numbers = [Double]()
    
    private let fileURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("DeleteMe")
    
//    init()  {
//        Task {
//            do {
//                let numbers = try await load()
//                self.numbers = numbers
//                isStoreLoaded = true
//            }
//        }
//    }
    
    func addNumber(_ newNumber: Double) {
        numbers.append(newNumber)
    }
    
    func save() async throws {
        Task {
            let data = try JSONEncoder().encode(numbers)
            try data.write(to: fileURL)
        }
    }
    
    func load() async throws -> [Double] {
        let task = Task<[Double],Error> {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([Double].self, from: data)
        }
        return try await task.value
    }
    
}

