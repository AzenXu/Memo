//
//  GroupListViewController.swift
//  Starry
//
//  Created by XuAzen on 16/9/8.
//  Copyright © 2016年 azen.Com. All rights reserved.
//

import UIKit

private struct StyleSheet {
    static let cellID = "Cell"
}

class GroupListViewController: BaseViewController {
    
    //  basic data
    var datas = ["","","","","","","","","","","","","","","","","","","","","",""]
    
    //  basic UI
    lazy var tableView: UITableView = {return UITableView()}()

}

extension GroupListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupViews()
    }
    
    private func _setupViews() {
        view.backgroundColor = UIColor.stec_randomColor()
        title = "分组列表页"
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
            
            table.registerClass(UITableViewCell.self, forCellReuseIdentifier: StyleSheet.cellID)
        }
    }
}

extension GroupListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StyleSheet.cellID)!
        cell.backgroundColor = UIColor.stec_randomColor()
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _jumpToKnowledgeList()
    }
}

// MARK: - private funcs
extension GroupListViewController {
    private func _jumpToKnowledgeList() {
        let knowledgeListVC = KnowledgeListViewController()
        navigationController?.pushViewController(knowledgeListVC, animated: true)
    }
}
