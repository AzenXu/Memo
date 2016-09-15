//
//  KnowledgeDetailViewController.swift
//  Starry
//
//  Created by XuAzen on 16/9/8.
//  Copyright © 2016年 azen.Com. All rights reserved.
//

import UIKit

private struct StyleSheet {
    static let cellID = "Cell"
}

class KnowledgeDetailViewController: BaseViewController {
    
}

extension KnowledgeDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        title = "知识详情页"
        view.backgroundColor = UIColor.stec_randomColor()
    }
}
