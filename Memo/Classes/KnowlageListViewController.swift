//
//  KnowledgeListViewController.swift
//  Starry
//
//  Created by XuAzen on 16/9/8.
//  Copyright © 2016年 azen.Com. All rights reserved.
//

import UIKit

class KnowledgeListViewController: BaseViewController {
    
    //  basic data
    var datas = ["","",""]
    var oldKnowledge = ["","","","","","","","","","","","","","","","","","",""]
    var showOldKnowledge = false
    
    //  basic UI
    lazy var backgroundView: UIImageView = {return UIImageView()}()
    lazy var tableView: UITableView = {return UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)}()
    
    enum ListStyle: Int {
        case AddKnowledge, ShowOldKnowledge
        
        static let count = 2
    }
    
    deinit {
        print("析构成功")
    }
}

extension KnowledgeListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupViews()
    }
    
    private func _setupViews() {
        view.backgroundColor = UIColor.stec_randomColor()
        title = "记忆豆"
        
//        navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        backgroundView.then {
            view.addSubview($0)
            $0.image = UIImage(named: "knowledge_list_background_2")
            $0.contentMode = UIViewContentMode.ScaleAspectFill
            $0.clipsToBounds = true
            $0.snp_remakeConstraints(closure: { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(0)
                make.bottom.equalTo(0)
            })
        }
        tableView.then { (table) in
            view.addSubview(table)
            table.backgroundColor = UIColor.clearColor()
            table.delegate = self
            table.dataSource = self
            table.estimatedRowHeight = 100
            table.separatorStyle = UITableViewCellSeparatorStyle.None
            
            table.snp_remakeConstraints(closure: { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.top.equalTo(65)
                make.bottom.equalTo(0)
            })
            
            BasicTableCell.registMe(table)
            KnowledgeListCardCell.registMe(table)
        }
    }
}

extension KnowledgeListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ListStyle.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let style = ListStyle(rawValue: section) else { return 0 }
        switch style {
        case .AddKnowledge:
            return datas.count
        case .ShowOldKnowledge:
            if showOldKnowledge {
                return oldKnowledge.count
            } else {
                return 0
            }
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = KnowledgeListCardCell.dequeueMe(tableView, indexPath: indexPath) as! KnowledgeListCardCell
        cell.clickCallBack = { [weak self] in
            guard let `self` = self else {return}
            self._jumpToKnowledgeDetail()
        }
        return cell
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let style = ListStyle(rawValue: section) else { return nil }
        switch style {
        case .AddKnowledge:
            let header = AddKnowledgeHeader()
            return header
        case .ShowOldKnowledge:
            let header = ShowOldKnowledgeHeader()
            header.titleButton.selected = showOldKnowledge
            header.selectedCallBack = { [weak self] isSelected in
                guard let `self` = self else {return}
                print(isSelected)
                self.showOldKnowledge = isSelected
                self.tableView.reloadSections(NSIndexSet.init(index: ListStyle.ShowOldKnowledge.rawValue), withRowAnimation: UITableViewRowAnimation.Fade)
            }
            return header
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let style = ListStyle(rawValue: section) else { return 0 }
        switch style {
        case .AddKnowledge:
            return 80
        case .ShowOldKnowledge:
            return 60
        }

    }
}

// MARK: - private funcs
extension KnowledgeListViewController {
    private func _jumpToKnowledgeDetail() {
        let detailVC = KnowledgeDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func _saveKnowledge() {
        
    }
}