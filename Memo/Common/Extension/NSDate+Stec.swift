//
//  NSDate+Stec.swift
//  UTraveler
//
//  Created by Tony on 16/3/24.
//  Copyright © 2016年 Beijing Yimay Holiday Information Science & Technology Co.,Ltd. All rights reserved.
//

import Foundation

public extension NSDate {
    
    public class func stec_stringFromTimeinterval(timeinterval: Int) -> String {
        let date: NSDate = NSDate.init(timeIntervalSince1970: Double(timeinterval / 1000))
        let dateformatter: NSDateFormatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.stringFromDate(date)
    }
    
    public class func stec_timeStampToString(timeStamp:String)->String {
        let string = NSString(string: timeStamp)
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd"
        let date = NSDate(timeIntervalSince1970: timeSta)
        return dfmatter.stringFromDate(date)
    }
    
    public class func stec_timeStampToIMDetailString(timeStamp:String, isListCell:Bool)->String {
        //  realDate
        let string = NSString(string: timeStamp)
        let timeSta:NSTimeInterval = string.doubleValue
        let realDate = NSDate(timeIntervalSince1970: timeSta)
        //  todayDate
        let todayDate = NSDate()
        //  dateDetail
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yy/MM/dd HH:mm"
        //  dateNotDetail
        let dfmatterNotDetail = NSDateFormatter()
        dfmatterNotDetail.dateFormat = "yy/MM/dd"
        //  todayFormatter
        let dfmatterToday = NSDateFormatter()
        dfmatterToday.dateFormat = "HH:mm"
        
        let realDateString = dfmatterNotDetail.stringFromDate(realDate)
        let todayDateString = dfmatterNotDetail.stringFromDate(todayDate)
        
        if realDateString == todayDateString {
            return dfmatterToday.stringFromDate(realDate)
        } else {
            if isListCell {
                return dfmatterNotDetail.stringFromDate(realDate)
            } else {
                return dfmatter.stringFromDate(realDate)
            }
        }
    }
    
    public class func stec_stringFromTimeintervalForDoubleValue(timeintervalForDoubleValue: NSTimeInterval) -> String {
        let date: NSDate = NSDate.init(timeIntervalSince1970: Double(timeintervalForDoubleValue / 1000))
        let dateformatter: NSDateFormatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.stringFromDate(date)
    }
}