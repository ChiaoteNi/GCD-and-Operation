//
//  WorkItemDemo.swift
//  GCDandMutiThread
//
//  Created by 倪僑德 on 2020/12/6.
//

import UIKit

final class WorkItemDemoVC: BaseVC {
    
    private var items: [DispatchWorkItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Action functions.
extension WorkItemDemoVC {
    
    @IBAction private func runDemo() {
        demoWorkItem()
    }
}

// MARK: - Private functions.
extension WorkItemDemoVC {
    
    private func demoWorkItem() {
        DispatchQueue.global().async {
            for i in 0 ..< 10 {
                let item = self.getItem(with: i)
                self.items.append(item)
//                DispatchQueue.global(qos: .default).async(execute: item)
            }
            
            for i in 0 ..< 10 {
                guard let item = self.items[safe: i],
                      let nextItem = self.items[safe: i + 1] else { break }
                item.notify(queue: .main, execute: nextItem)
            }
            self.items[0].perform()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.items[3].cancel()
            //            }
        }
    }
    
    private func getItem(with id: Int) -> DispatchWorkItem {
        let item: DispatchWorkItem = .init() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.printText("\(id)")
            }
        }
        return item
    }
}
