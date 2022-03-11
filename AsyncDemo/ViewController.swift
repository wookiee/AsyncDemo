//
//  ViewController.swift
//  AsyncAPOD
//
//  Created by Mikey Ward on 3/10/22.
//

import UIKit

class ViewController: UITableViewController {
    
    private let store = NumberStore()
    private let workManager = WorkManager()
    private let downloader = Downloader()
    private var fileNumber = 1
    
    @MainActor private var strings = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func handleTappedDownloadButton(_ sender: UIBarButtonItem) {
        
        let fileNumber = fileNumber
        print("Downloading file #\(fileNumber)")
        downloader.download(.smallFile) { result in
            switch result {
            case .success(let url):
                print("Done downloading file #\(fileNumber) to \(url.lastPathComponent)")
            case .failure(let error):
                print("Error downloading file #\(fileNumber): \(error)")
            }
        }
        
        self.fileNumber += 1
        
    }
    
    @IBAction func handleTappedDoWorkButton(_ sender: UIBarButtonItem) {
        
//        workManager.spawnConcurrentWorkloads(count: 10) { totalOutput in
//            print("Workloads completed with total output: \(totalOutput)")
//        }
        
        Task {
            let totalOutput = await workManager.spawnConcurrentWorkloads(count: 10)
            await self.store.addNumber(Double.random(in: -1.0 ... 1.0))
            
            self.strings = totalOutput
        }
        
    }
    
    // MARK: - UITableView content
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
}

