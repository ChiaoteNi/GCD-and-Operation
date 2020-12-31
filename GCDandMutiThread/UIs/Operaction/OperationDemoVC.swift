//
//  OperationDemoVC.swift
//  GCDandMutiThread
//
//  Created by 倪僑德 on 2020/12/6.
//

import UIKit

final class OperationDemoVC: BaseVC {
    
    private let queue: OperationQueue = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Action functions.
extension OperationDemoVC {
    
    @IBAction private func runDemo() {
        clearText()
        let firstOperation = getOperation(with: "🏵")
        let secondOperation = getOperation(with: "🧩")
        let thirdOperation = getOperation(with: "🔮")
//        thirdOperation.start()
//        secondOperation.start()
//        firstOperation.start()
        
        thirdOperation.addDependency(secondOperation)
//        thirdOperation.addDependency(firstOperation)
        secondOperation.addDependency(firstOperation)
        
        firstOperation.queuePriority = .high
        secondOperation.queuePriority = .normal
        thirdOperation.queuePriority = .low
        
        queue.maxConcurrentOperationCount = 1
//        queue.addOperations([thirdOperation, secondOperation, firstOperation], waitUntilFinished: true)
        
        queue.addOperation(thirdOperation)
        queue.addOperation(secondOperation)
        queue.addOperation(firstOperation)
    }
}

// MARK: - Private functions.
extension OperationDemoVC {
    
    private func getOperation(with text: String) -> BlockOperation {
        let operation: BlockOperation = .init {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                for i in 0 ..< 3 {
                    self.printText(text)
                }
            }
        }
        return operation
    }
}
