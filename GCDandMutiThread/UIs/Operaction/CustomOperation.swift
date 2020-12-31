//
//  CustonOperation.swift
//  GCDandMutiThread
//
//  Created by 倪僑德 on 2020/12/8.
//

import UIKit

final class CustomOperation: Operation {
    
    override var isAsynchronous: Bool { true }
    
    private var lock: NSLock = .init()
    
    private var _isExecuting: Bool = false
    override private(set) var isExecuting: Bool {
        get { return lockQueue.sync { _isExecuting } }
        set {
            print(label, "isExecuting change from \(isExecuting) -> \(newValue)")
            willChangeValue(for: \.isExecuting)
            lockQueue.sync { _isExecuting = newValue }
            didChangeValue(for: \.isExecuting)
        }
    }
    
    private var _isFinished: Bool = false
    override private(set) var isFinished: Bool {
        get { lockQueue.sync { _isFinished } }
        set {
            print(label, "isFinished change from \(isFinished) -> \(newValue)")
            willChangeValue(for: \.isFinished)
            lockQueue.sync { _isFinished = newValue }
            didChangeValue(for: \.isFinished)
        }
    }
    
    private let lockQueue = DispatchQueue(label: "CustomOperation", attributes: .concurrent)
    
    var action: ((_ info: String) -> Void)?
    let label: String
    
    var info: String?
    
    init(label: String) {
        self.label = label
    }
    
    override func start() {
        print(label, "start")
        isFinished = false
        isExecuting = true
        main()
    }
    
    override func main() {
        print(label, "main")
        guard let info = info else { return }
        action?(info)
    }
    
    func addAction(_ action: @escaping (_ info: String) -> Void) {
        self.action = action
    }
    
    func setInfo(_ info: String) {
        self.info = info
    }
    
    func finish() {
        print(label, "finish")
        isExecuting = false
        isFinished = true
        action = nil
    }
}
