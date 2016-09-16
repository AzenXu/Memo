//
//  CustomTableCells.swift
//  Memo
//
//  Created by XuAzen on 16/9/15.
//  Copyright © 2016年 azen. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

/// cells
class KnowledgeListCardCell: BasicTableCell {
    
    lazy var boxArea: UIView = {return UIView()}()
    lazy var checkButton: CustomColorButton = {return CustomColorButton()}()
    lazy var titleLabel: UILabel = {return UILabel()}()
    
    var checkButtonClick: ((isSelected: Bool)->())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        func setupViews() {
            
            backgroundColor = UIColor.clearColor()
            selectionStyle = UITableViewCellSelectionStyle.None
            
            boxArea.then { (area) in
                addSubview(area)
                area.snp_remakeConstraints(closure: { (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.top.equalTo(0)
                    make.bottom.equalTo(-1)
                })
                area.layer.cornerRadius = 5
                area.backgroundColor = UIColor.whiteColor()
                
                checkButton.then({
                    area.addSubview($0)
                    $0.snp_remakeConstraints(closure: { (make) in
                        make.left.equalTo(15)
                        make.centerY.equalTo(0)
                        make.size.equalTo(16)
                    })
                    $0.setImage(UIImage(named: "knowledge_list_checkBox_uncheck"), forState: UIControlState.Normal)
                    $0.setImage(UIImage(named: "knowledge_list_checkBox_checked"), forState: UIControlState.Selected)
                    $0.clickCallBack = { [weak self] button in
                        guard let `self` = self else {return}
                        button.selected = !button.selected
                        self.checkButtonClick?(isSelected: button.selected)
                    }
                })
                
                titleLabel.then({
                    area.addSubview($0)
                    $0.text = "哈哈"
                    $0.numberOfLines = 0
                    $0.snp_remakeConstraints(closure: { (make) in
                        make.left.equalTo(checkButton.snp_right).offset(15)
                        make.right.equalTo(-15)
                        make.top.equalTo(15)
                        make.bottom.equalTo(-15)
                    })
                })
            }
        }
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KnowledgeListCardCell {
    func config(info: Knowledge?) {
        guard let info = info else { return }
        titleLabel.text = info.title
        checkButton.selected = info.memoryCount > 0
    }
}

/// supplements
class AddKnowledgeHeader: UIView {
    lazy var boxArea: UIView = {return UIView()}()
    lazy var addImage: UILabel = {return UILabel()}()
    lazy var textField: UITextField = {return UITextField()}()
    
    var writeCompleteCallBack: ((string: String?)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        func setupViews() {
            boxArea.then { (area) in
                addSubview(area)
                area.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
                area.layer.cornerRadius = 5
                area.snp_remakeConstraints(closure: { (make) in
                    make.left.equalTo(15)
                    make.right.equalTo(-15)
                    make.height.equalTo(60)
                    make.centerY.equalTo(0)
                })
                
                addImage.then({
                    area.addSubview($0)
                    $0.textColor = UIColor.whiteColor()
                    $0.font = UIFont.systemFontOfSize(26)
                    $0.text = "+"
                    $0.textAlignment = NSTextAlignment.Center
                    $0.snp_remakeConstraints(closure: { (make) in
                        make.left.equalTo(15)
                        make.centerY.equalTo(0).offset(-4)
                        make.size.equalTo(30)
                    })
                })
                
                textField.then({
                    area.addSubview($0)
                    $0.attributedPlaceholder = "添加记忆豆...".attriString.setAtt({ (maker) in
                        maker.color = UIColor.whiteColor()
                    })
                    $0.tintColor = UIColor.whiteColor()
                    $0.textColor = UIColor.whiteColor()
                    $0.snp_remakeConstraints(closure: { (make) in
                        make.left.equalTo(addImage.snp_right).offset(10)
                        make.right.equalTo(-15)
                        make.top.equalTo(0)
                        make.bottom.equalTo(0)
                    })
                    $0.delegate = self
                })
            }
        }
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddKnowledgeHeader: UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        guard let text = textField.text where text.trimmed() != "" else {
            textField.text = nil
            return
        }
        writeCompleteCallBack?(string: text)
        textField.text = nil
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

class ShowOldKnowledgeHeader: UIView {
    
    lazy var titleButton: UIButton = {return UIButton()}()
    var selectedCallBack: ((isSelected: Bool)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleButton.then {
            addSubview($0)
            $0.addTarget(self, action: #selector(titleButtonSelected), forControlEvents: UIControlEvents.TouchUpInside)
            $0.setTitle("显示已记住豆子", forState: UIControlState.Normal)
            $0.setTitle("隐藏已记住豆子", forState: UIControlState.Selected)
            $0.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            $0.titleLabel?.font = UIFont.systemFontOfSize(14)
            $0.titleLabel?.textAlignment = NSTextAlignment.Center
            $0.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            $0.layer.cornerRadius = 5
            $0.snp_remakeConstraints(closure: { (make) in
                make.center.equalTo(0)
                make.width.equalTo(120)
                make.height.equalTo(30)
            })
        }
    }
    
    func titleButtonSelected() {
        titleButton.selected = !titleButton.selected
        selectedCallBack?(isSelected: titleButton.selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

