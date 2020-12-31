//
//  WorkItemFlagsDemoVC.swift
//  GCDandMutiThread
//
//  Created by 倪僑德 on 2020/12/6.
//

import UIKit

final class WorkItemFlagsDemoVC: BaseVC {
    
    let highPriorityQueue: DispatchQueue = .init(
        label: "highPriorityQueue",
        qos: .userInteractive,
        autoreleaseFrequency: .workItem,
        target: .global()
    )
    
    let middlePriorityQueue: DispatchQueue = .init(
        label: "middlePriorityQueue",
        qos: .default,
        autoreleaseFrequency: .workItem,
        target: .global()
    )
        
    let lowPriorityQueue: DispatchQueue = .init(
        label: "lowPriorityQueue",
        qos: .background,
        autoreleaseFrequency: .workItem,
        target: .global()
    )

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Action functions.
extension WorkItemFlagsDemoVC {
    
    @IBAction private func runAssignCurrentContext() {
        run(with: .assignCurrentContext)
    }
    
    @IBAction private func runBarrier() {
        run(with: .barrier)
    }
    
    @IBAction private func runDetached() {
        run(with: .detached)
    }
    
    @IBAction private func runEnforceQoS() {
        run(with: .enforceQoS)
    }
    
    @IBAction private func runInheritQoS() {
        run(with: .inheritQoS)
    }
    
    @IBAction private func runNoQoS() {
        run(with: .noQoS)
    }
}

// MARK: - Private functions.
extension WorkItemFlagsDemoVC {
    
    private func run(with flag: DispatchWorkItemFlags) {
        clearText()
        let firstItem = getItem(with: "🏵", qos: .userInteractive, flag: flag)
        let secondItem = getItem(with: "🧩", qos: .default, flag: flag)
        let thirdItem = getItem(with: "🔮", qos: .background, flag: flag)
        
        lowPriorityQueue.async(execute: thirdItem)
        middlePriorityQueue.async(execute: secondItem)
        highPriorityQueue.async(execute: firstItem)
    }
    
    private func getItem(with text: String, qos: DispatchQoS, flag: DispatchWorkItemFlags) -> DispatchWorkItem {
        let item: DispatchWorkItem = .init(qos: qos, flags: flag, block: {
                for i in 0 ..< 2 {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.printText("\(text)\(i)")
                    }
                }
        })
        return item
    }
}
