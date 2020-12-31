//
//  OperationQueueDemoVC.swift
//  GCDandMutiThread
//
//  Created by 倪僑德 on 2020/12/6.
//

import UIKit

final class OperationQueueDemoVC: BaseVC {
    
    private var queue: OperationQueue = .init()
    private var progress: Progress?

    override func viewDidLoad() {
        super.viewDidLoad()
        queue.maxConcurrentOperationCount = 5
        queue.progress.resume()
        queue.underlyingQueue = .global()
    }
}

// MARK: - Action functions.
extension OperationQueueDemoVC {
    
    @IBAction private func runDemo() {
        sendFileMessages()
    }
}

// MARK: - Private functions.
extension OperationQueueDemoVC {
    private func sendFileMessages() {
        clearText()
        var previousSendOperation: CustomOperation?
        var operations: [Operation] = []
        
        DispatchQueue.global(qos: .background).async {
            let fileNames = ["🏵", "🧩", "🔮"]
            for i in 0 ..< 3 {
                let fileName: String = fileNames[i]
                let sendOperation = CustomOperation(label: fileName)
                let uploadOperation = CustomOperation(label: fileName + "🐂")
                
                uploadOperation.addAction { _ in
                    StubNetworkService.uploadFile(with: fileName) { [weak self] fileName in
                        DispatchQueue.main.async {
                            self?.printText(fileName + " is uploaded")
                        }
                        uploadOperation.finish()
                    }
                }
                sendOperation.addAction { info in
                    StubNetworkService.sendMessage(with: fileName) {  [weak self] fileName in
                        DispatchQueue.main.async {
                            self?.printText(fileName + " is sended")
                        }
                        sendOperation.finish()
                    }
                }
                
                sendOperation.addDependency(uploadOperation)
                if let previousSendOperation = previousSendOperation {
                    sendOperation.addDependency(previousSendOperation)
                }
                previousSendOperation = sendOperation
                
                operations.append(uploadOperation)
                operations.append(sendOperation)
            }
            previousSendOperation = nil
            self.queue.addOperations(operations, waitUntilFinished: true)
        }
    }
}

// MARK: - Private functions
extension OperationQueueDemoVC {
    
    private func uploadFile(with fileName: String, then handler: @escaping (_ fileName: String) -> Void) {
        StubNetworkService.uploadFile(with: fileName) { fileName in
            handler(fileName)
        }
    }
}

// MARK: - Stub API
fileprivate final class StubNetworkService {
    
    static func uploadFile(with fileName: String, then handler: @escaping (_ fileName: String) -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(Int(arc4random_uniform(3)))) {
            handler(fileName)
        }
    }
    
    static func sendMessage(with fileName: String, then handler: @escaping (_ fileName: String) -> Void) {
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) {
            handler(fileName)
        }
    }
}
