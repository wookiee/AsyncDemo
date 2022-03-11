//
//  Downloader.swift
//  AsyncAPOD
//
//  Created by Mikey Ward on 3/10/22.
//

import Foundation


class Downloader {
    
    enum Endpoint: String {
        case giantFile = "https://mw-dropshare.s3.amazonaws.com/random_1GB-1646942998.data"
        case largefile = "https://mw-dropshare.s3.amazonaws.com/random_100MB-1646942974.data"
        case mediumFile = "https://mw-dropshare.s3.amazonaws.com/random_10MB-1646942971.data"
        case smallFile = "https://mw-dropshare.s3.amazonaws.com/empty_1MB-1646944716.data"
        
        var url: URL { URL(string: rawValue)! }
    }
    
    func download(_ endpoint: Endpoint,
                  completion: @escaping (Result<URL,Error>)->Void) {
        
        let task = URLSession.shared.downloadTask(with: endpoint.url) {
            (localURL, response, error) in
            
            // great error handling or *greatest* error handling?
            guard let localURL = localURL else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(localURL))
        }
        
        task.resume()
    }
    
}
