//
//  LockDemoVC.swift
//  GCDandMutiThread
//
//  Created by 倪僑德 on 2020/12/6.
//

import UIKit

final class LockDemoVC: BaseVC {

    private var semaphore: DispatchSemaphore = .init(value: 1)
    private var list: [Int] = [1, 2, 3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Action functions.
extension LockDemoVC {
    
    @IBAction private func runDemo() {
        for _ in 0 ..< 30 {
            DispatchQueue.global().async {
                self.doSomething()
            }
        }
    }
}

// MARK: - Private functions.
extension LockDemoVC {
    private func doSomething() {
        semaphore.wait()
        let element = list.removeFirst()
        list.insert(element, at: 0)
        DispatchQueue.main.async {
            self.printText("HI")
        }
        semaphore.signal()
    }
}
