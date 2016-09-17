//
//  KnowledgeListViewController.swift
//  Starry
//
//  Created by XuAzen on 16/9/8.
//  Copyright © 2016年 azen.Com. All rights reserved.
//

import UIKit
import RealmSwift
import React

class KnowledgeListViewController: BaseViewController {
    
    //  basic data
    var newKnowledges: Results<Knowledge>?
    var oldKnowledges: Results<Knowledge>?
    
    var showOldKnowledge = false
    let realm = Bootstrap.cachedDataRealm
    
    var newToken: NotificationToken?
    var oldToken: NotificationToken?
    var reloadControl = StyleReloadControl()
    
    //  basic UI
    lazy var backgroundView: UIImageView = {return UIImageView()}()
    lazy var tableView: UITableView = {return UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)}()
    
    enum ListStyle: Int {
        case AddKnowledge, ShowOldKnowledge
        
        static let count = 2
    }
    
    struct StyleReloadControl {
        var addKnowledgeAction: (()->())?
        var showOldKnowledgeAction: (()->())?
    }
    
    deinit {
        print("析构成功")
    }
}

extension KnowledgeListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupViews()
        _setupDatas()
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
            guard let newKnowledges = newKnowledges else { return 0 }
            return newKnowledges.count
        case .ShowOldKnowledge:
            if showOldKnowledge {
                guard let oldKnowledges = oldKnowledges else { return 0 }
                return oldKnowledges.count
            } else {
                return 0
            }
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = KnowledgeListCardCell.dequeueMe(tableView, indexPath: indexPath) as! KnowledgeListCardCell
        
        guard let style = ListStyle(rawValue: indexPath.section) else { return cell }
        switch style {
        case .AddKnowledge:
            let newKnowledge = newKnowledges?[indexPath.row]
            cell.config(newKnowledge)
            cell.checkButtonClick = { [weak self] isSelected in
                guard let `self` = self, newKnowledge = newKnowledge else {return}
                let addNumber = isSelected ? 1 : -1
                self._updateKnowledge(withTitle: newKnowledge.title, mCount: newKnowledge.memoryCount + addNumber)
            }
        case .ShowOldKnowledge:
            let oldKnowledge = oldKnowledges?[indexPath.row]
            cell.config(oldKnowledge)
            cell.checkButtonClick = { [weak self] isSelected in
                guard let `self` = self, oldKnowledge = oldKnowledge else {return}
                let addNumber = isSelected ? 1 : -1
                self._updateKnowledge(withTitle: oldKnowledge.title, mCount: oldKnowledge.memoryCount + addNumber)
            }
        }
//        cell.clickCallBack = { [weak self] in
//            guard let `self` = self else {return}
//            self._jumpToKnowledgeDetail()
//        }
        return cell
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let style = ListStyle(rawValue: section) else { return nil }
        switch style {
        case .AddKnowledge:
            let header = AddKnowledgeHeader()
            header.writeCompleteCallBack = { [weak self] content in
                guard let `self` = self, content = content else { return }
                self._updateKnowledge(content, desc: nil)
                print(content)
            }
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
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let style = ListStyle(rawValue: indexPath.section) else { return }
        switch style {
        case .AddKnowledge:
            _removeKnowledge(newKnowledges?[indexPath.row])
        case .ShowOldKnowledge:
            _removeKnowledge(oldKnowledges?[indexPath.row])
        }
    }
}

// MARK: - private funcs
extension KnowledgeListViewController {
    private func _jumpToKnowledgeDetail() {
        let detailVC = KnowledgeDetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func _setupDatas() {
        newKnowledges = _loadKnowledgesFromDB(true)
        oldKnowledges = _loadKnowledgesFromDB(false)
        
        newToken = newKnowledges?.addNotificationBlock({ [weak self] (changes: RealmCollectionChange) in
            guard let `self` = self else { return }
            self._reloadDataFromDBNofity(changes, forStyle: KnowledgeListViewController.ListStyle.AddKnowledge)
        })
        oldToken = oldKnowledges?.addNotificationBlock({ [weak self] (changes: RealmCollectionChange) in
            guard let `self` = self else { return }
            self._reloadDataFromDBNofity(changes, forStyle: KnowledgeListViewController.ListStyle.ShowOldKnowledge)
        })
    }
    
    private func _reloadTableView(style: ListStyle, action: (()->())) {
        
        func reload() {
            tableView.beginUpdates()
            reloadControl.addKnowledgeAction?()
            reloadControl.showOldKnowledgeAction?()
            tableView.endUpdates()
            reloadControl.addKnowledgeAction = nil
            reloadControl.showOldKnowledgeAction = nil
        }
        
        func judgeToReload() {
            if reloadControl.addKnowledgeAction != nil && reloadControl.showOldKnowledgeAction != nil {
                reload()
            } else {
                //  有一个没有，则等1秒再调
                delay(0.1, work: {
                    reload()
                })
            }
        }
        
        switch style {
        case .AddKnowledge:
            reloadControl.addKnowledgeAction = action
        case .ShowOldKnowledge:
            reloadControl.showOldKnowledgeAction = action
        }
        judgeToReload()
    }
}

// MARK: - private for DB
extension KnowledgeListViewController {
    private func _updateKnowledge(title: String, desc: String?) {
        let know = Knowledge()
        know.title = title
        know.desc = desc ?? ""
        know.updateTime = NSDate().timeIntervalSince1970
        try! realm?.write({
            realm?.add(know, update: true)
        })
    }
    
    private func _updateKnowledge(withTitle title: String, mCount: Int) {
        try! realm?.write({ 
            realm?.create(Knowledge.self, value: ["title":title, "memoryCount":mCount, "updateTime":NSDate().timeIntervalSince1970], update: true)
        })
    }
    
    private func _removeKnowledge(knowedge: Knowledge?) {
        guard let knowedge = knowedge else { return }
        try! realm?.write({
            realm?.delete(knowedge)
        })
    }
    
    private func _loadKnowledgesFromDB(isNew: Bool?) -> Results<Knowledge>? {
        func getPredicate(isNew: Bool) -> NSPredicate {
            if isNew {
                return NSPredicate(format: "memoryCount = %d", argumentArray: [0])
            } else {
                return NSPredicate(format: "memoryCount > %d", argumentArray: [0])
            }
        }
        var knows = realm?.objects(Knowledge.self).sorted("updateTime", ascending: false)
        if isNew != nil && knows != nil {
            knows = knows!.filter(getPredicate(isNew!))
        }
        return knows
    }
    
    private func _reloadDataFromDBNofity(changes: RealmCollectionChange<Results<Knowledge>>, forStyle: ListStyle) {
        switch changes {
        case .Initial:
            // Results 现在已经填充完毕，可以不需要阻塞 UI 就可以被访问
            self.tableView.reloadSections(NSIndexSet.init(index: ListStyle.AddKnowledge.rawValue), withRowAnimation: UITableViewRowAnimation.None)
            break
        case .Update(_, let deletions, let insertions, let modifications):
            // 检索结果被改变，因此将它们应用到 UITableView 当中
            if forStyle == ListStyle.ShowOldKnowledge && showOldKnowledge == false { return }
            self._reloadTableView(forStyle, action: { 
                self.tableView.insertRowsAtIndexPaths(insertions.map { NSIndexPath(forRow: $0, inSection: forStyle.rawValue) },
                    withRowAnimation: .Automatic)
                self.tableView.deleteRowsAtIndexPaths(deletions.map { NSIndexPath(forRow: $0, inSection: forStyle.rawValue) },
                    withRowAnimation: .Automatic)
                self.tableView.reloadRowsAtIndexPaths(modifications.map { NSIndexPath(forRow: $0, inSection: forStyle.rawValue) },
                    withRowAnimation: .Automatic)
            })
            break
        case .Error(let error):
            // 如果在后台工作线程中打开 Realm 文件的时候，就会发生错误
            fatalError("\(error)")
            break
        }
    }
}