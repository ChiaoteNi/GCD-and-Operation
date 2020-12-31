//
//  BaseVC.swift
//  SemaphoreDemo
//
//  Created by 倪僑德 on 2020/10/25.
//  Copyright © 2020 倪僑德. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var runButton: UIButton!
    
    private var content: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.textView.text = self.content
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func printText(_ text: String) {
        content += ("\n" + text)
    }
    
    func clearText() {
        content = ""
    }
}

// MARK: - Private functions
extension BaseVC {
    
    private func setupUI() {
        navigationItem.leftBarButtonItem = .init(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(handleTapClose)
        )
        
        runButton.setTitle("Run", for: .normal)
    }
    
    @objc
    private func handleTapClose() {
        dismiss(animated: true, completion: nil)
    }
}
