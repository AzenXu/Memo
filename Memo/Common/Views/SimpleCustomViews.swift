//
//  SimpleCustomViews.swift
//  JFoundation
//
//  Created by XuAzen on 16/7/4.
//  Copyright © 2016年 st. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Custom ContentSizeChange Element
public typealias UTravWebViewContentSizeChangeCallBack = (CGSize) -> ()
public class UTravWebView: UIWebView {
    
    var lastContentSize = CGSizeZero
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var contentSizeChangeCallBack :UTravWebViewContentSizeChangeCallBack?
    
    public func setContentSizeCallBack(contentSizeChange :UTravWebViewContentSizeChangeCallBack) {
        contentSizeChangeCallBack = contentSizeChange
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentSize" {
            let contentSize = change!["new"]!.CGSizeValue()
            if contentSize != lastContentSize {
                lastContentSize = contentSize
                if let contentSizeChangeCallBack = contentSizeChangeCallBack {
                    contentSizeChangeCallBack(contentSize)
                }
            }
        }
    }
    
    
    deinit {
        scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
}

public class WebCollectionCell: BasicCollectionCell {
    
    private var webView: UTravWebView = UTravWebView(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 300))
    private var request: NSURLRequest?
    
    private var contentSizeCallBack: ((CGSize) -> ())?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        makeupViews()
    }
    
    public func setContentSizeCallBack(callBack: CGSize -> ()) {
        self.contentSizeCallBack = callBack
        webView.setContentSizeCallBack { (newSize) in
            guard let contentSizeCallBack = self.contentSizeCallBack else {return}
            contentSizeCallBack(newSize)
        }
    }
    /**
     防止每次reloadData都重新加载web
     */
    public func setRequest(request: NSURLRequest) {
        if self.request != request {
            self.request = request
            loadRequest(request)
        }
    }
    
    private func loadRequest(request: NSURLRequest) {
        webView.loadRequest(request)
    }
    
    private func makeupViews() {
        webView.then { (web) in
            addSubview(web)
            web.snp_remakeConstraints(closure: { (make) in
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(0)
                make.top.equalTo(0)
            })
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class UICollectionViewWithContentSizeCallBack: UICollectionView {
    private var lastContentSize = CGSizeZero
    private var contentSizeChangeCallBack :UTravWebViewContentSizeChangeCallBack?
    
    public func setContentSizeCallBack(contentSizeChange :UTravWebViewContentSizeChangeCallBack) {
        contentSizeChangeCallBack = contentSizeChange
    }
    
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentSize" {
            let contentSize = change!["new"]!.CGSizeValue()
            if contentSize != lastContentSize {
                lastContentSize = contentSize
                if let contentSizeChangeCallBack = contentSizeChangeCallBack {
                    contentSizeChangeCallBack(contentSize)
                }
            }
        }
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "contentSize")
    }
}

//MARK:- Basic UI Element
public class CustomColorButton: UIButton {
    public var selectedBorderColor: UIColor?
    public var unSelectedBorderColor: UIColor?
    override public var selected: Bool {
        didSet {
            if self.selected {
                if let selectedBorderColor = self.selectedBorderColor {
                    self.layer.borderColor = selectedBorderColor.CGColor
                }
            } else {
                if let unSelectedBorderColor = self.unSelectedBorderColor {
                    self.layer.borderColor = unSelectedBorderColor.CGColor
                }
            }
        }
    }
    
    public var hightlightedBackgroundColor: UIColor?
    public var normalBackgroundColor: UIColor?
    
    override public var highlighted: Bool {
        didSet {
            if highlighted {
                if let hightlightedBackgroundColor = self.hightlightedBackgroundColor {
                    backgroundColor = hightlightedBackgroundColor
                }
            } else {
                if let normalBackgroundColor = self.normalBackgroundColor {
                    backgroundColor = normalBackgroundColor
                }
            }
        }
    }
    
    public var disableBackgroundColor: UIColor?
    public var disableTextColor: UIColor?
    public var enableBackgroundColor: UIColor?
    public var enableTextColor: UIColor?
    
    public var clickCallBack: ((button: UIButton)->())?
    
    override public var enabled: Bool {
        didSet {
            if enabled {
                if let enableBackgroundColor = self.enableBackgroundColor {
                    backgroundColor = enableBackgroundColor
                }
                if let enableTextColor = self.enableTextColor {
                    setTitleColor(enableTextColor, forState: UIControlState.Normal)
                }
            } else {
                if let disableBackgroundColor = self.disableBackgroundColor {
                    backgroundColor = disableBackgroundColor
                }
                if let disableTextColor = self.disableTextColor {
                    setTitleColor(disableTextColor, forState: UIControlState.Normal)
                }
            }
        }
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        clickCallBack?(button: self)
    }
}

public class RightIconButton: CustomColorButton {
    override public func layoutSubviews() {
        super.layoutSubviews()
        let titleL = titleLabel!
        let imageV = imageView!
        if titleL.x > imageV.x {
            titleL.x = imageV.x
            imageV.x = titleL.width + titleL.x + 7
        }
    }
}