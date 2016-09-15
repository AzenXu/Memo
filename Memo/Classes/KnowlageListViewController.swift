//
//  KnowledgeListViewController.swift
//  Starry
//
//  Created by XuAzen on 16/9/8.
//  Copyright © 2016年 azen.Com. All rights reserved.
//

import UIKit

private struct StyleSheet {
    static let cellID = "Cell"
}

class KnowledgeListViewController: BaseViewController {
    
    //  basic data
    var datas = ["","","","","","","","","","","","","","","","","","","","","",""]
    
    //  basic UI
    lazy var tableView: UITableView = {return UITableView()}()
}

extension KnowledgeListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupViews()
    }
    
    private func _setupViews() {
        view.backgroundColor = UIColor.stec_randomColor()
        title = "知识列表页"
        tableView.then { (table) in
            view.addSubview(table)
            table.delegate = self
            table.dataSource = self
            table.snp_remakeConstraints(closure: { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(0)
                make.bottom.equalTo(0)
            })
            
            BasicTableCell.registMe(table)
        }
    }
}

extension KnowledgeListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = BasicTableCell.dequeueMe(tableView, indexPath: indexPath)
        cell.backgroundColor = UIColor.stec_randomColor()
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _jumpToKnowledgeDetail()
    }
}

// MARK: - private funcs
extension KnowledgeListViewController {
    private func _jumpToKnowledgeDetail() {
        let detailVC = KnowledgeDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}