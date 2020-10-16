//
//  Extension+Date.swift
//  LearnDiscover
//
//  Created by Lynch Wong on 10/31/16.
//  Copyright © 2016 LearnDiscover. All rights reserved.
//

import Foundation

extension Date {
    
    /**
     input:
     [dateFormatter setDateFormat:@"'公元前/后:'G  '年份:'u'='yyyy'='yy '季度:'q'='qqq'='qqqq '月份:'M'='MMM'='MMMM '今天是今年第几周:'w '今天是本月第几周:'W  '今天是今天第几天:'D '今天是本月第几天:'d '星期:'c'='ccc'='cccc '上午/下午:'a '小时:'h'='H '分钟:'m '秒:'s '毫秒:'SSS  '这一天已过多少毫秒:'A  '时区名称:'zzzz'='vvvv '时区编号:'Z "];
     NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
     
     output 美国:
     公元前/后:AD  年份:2013=2013=13 季度:3=Q3=3rd quarter 月份:8=Aug=August 今天是今年第几周:32 今天是本月第几周:2  今天是今天第几天:219 今天是本月第几天:7 星期:4=Wed=Wednesday 上午/下午:AM 小时:1=1 分钟:24 秒:32 毫秒:463  这一天已过多少毫秒:5072463  时区名称:China Standard Time=China Standard Time 时区编号:+0800
     
     output 中国：
     公元前/后:公元  年份:2013=2013=13 季度:3=三季度=第三季度 月份:8=8月=8月 今天是今年第几周:32 今天是本月第几周:2  今天是今天第几天:219 今天是本月第几天:7 星期:4=周三=星期三 上午/下午:上午 小时:1=1 分钟:44 秒:30 毫秒:360  这一天已过多少毫秒:6270360  时区名称:中国标准时间=中国标准时间 时区编号:+0800
     
     desc:
     a:  AM/PM
     A:  0~86399999 (Millisecond of Day)
     
     c/cc:   1~7 (Day of Week)
     ccc:    Sun/Mon/Tue/Wed/Thu/Fri/Sat
     cccc: Sunday/Monday/Tuesday/Wednesday/Thursday/Friday/Saturday
     
     d:  1~31 (0 padded Day of Month)
     D:  1~366 (0 padded Day of Year)
     
     e:  1~7 (0 padded Day of Week)
     E~EEE:  Sun/Mon/Tue/Wed/Thu/Fri/Sat
     EEEE: Sunday/Monday/Tuesday/Wednesday/Thursday/Friday/Saturday
     
     F:  1~5 (0 padded Week of Month, first day of week = Monday)
     
     g:  Julian Day Number (number of days since 4713 BC January 1)
     G~GGG:  BC/AD (Era Designator Abbreviated)
     GGGG:   Before Christ/Anno Domini
     
     h:  1~12 (0 padded Hour (12hr))
     H:  0~23 (0 padded Hour (24hr))
     
     k:  1~24 (0 padded Hour (24hr)
     K:  0~11 (0 padded Hour (12hr))
     
     L/LL:   1~12 (0 padded Month)
     LLL:    Jan/Feb/Mar/Apr/May/Jun/Jul/Aug/Sep/Oct/Nov/Dec
     LLLL: January/February/March/April/May/June/July/August/September/October/November/December
     
     m:  0~59 (0 padded Minute)
     M/MM:   1~12 (0 padded Month)
     MMM:    Jan/Feb/Mar/Apr/May/Jun/Jul/Aug/Sep/Oct/Nov/Dec
     MMMM: January/February/March/April/May/June/July/August/September/October/November/December
     
     q/qq:   1~4 (0 padded Quarter)
     qqq:    Q1/Q2/Q3/Q4
     qqqq:   1st quarter/2nd quarter/3rd quarter/4th quarter
     Q/QQ:   1~4 (0 padded Quarter)
     QQQ:    Q1/Q2/Q3/Q4
     QQQQ:   1st quarter/2nd quarter/3rd quarter/4th quarter
     
     s:  0~59 (0 padded Second)
     S:  (rounded Sub-Second)
     
     u:  (0 padded Year)
     
     v~vvv:  (General GMT Timezone Abbreviation)
     vvvv:   (General GMT Timezone Name)
     
     w:  1~53 (0 padded Week of Year, 1st day of week = Sunday, NB: 1st week of year starts from the last Sunday of last year)
     W:  1~5 (0 padded Week of Month, 1st day of week = Sunday)
     
     y/yyyy: (Full Year)
     yy/yyy: (2 Digits Year)
     Y/YYYY: (Full Year, starting from the Sunday of the 1st week of year)
     YY/YYY: (2 Digits Year, starting from the Sunday of the 1st week of year)
     
     z~zzz:  (Specific GMT Timezone Abbreviation)
     zzzz:   (Specific GMT Timezone Name)
     Z:  +0000 (RFC 822 Timezone)
     */
    func dateString(_ formatter: String) -> String {
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: self)
    }
    
    /// 日期字符串转化为Date类型
    ///
    /// - Parameters:
    ///   - string: 日期字符串
    ///   - dateFormat: 格式化样式，默认为“yyyy-MM-dd HH:mm:ss”
    /// - Returns: Date类型
    static func stringConvertDate(string:String, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: string)
        return date!
            
    }
    
    
    // MARK: 当月开始日期
    
    static func startOfCurrentMonth(startDate:Date) -> Date {
        
        let date = startDate
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(
            Set<Calendar.Component>([.year, .month]), from: date)
        let startOfMonth = calendar.date(from: components)!
        return startOfMonth
    }
    
    // MARK: 本月结束日期
    static func endOfCurrentMonth(startDate:Date) -> Date {
        let calendar = NSCalendar.current
        var components = DateComponents()
        components.month = 1
        components.day = -1
        
        let endOfMonth =  calendar.date(byAdding: components, to: startOfCurrentMonth(startDate: startDate))!
        return endOfMonth
    }
    
    // MARK: 上月开始日期
    static func startOfLastMonth(startDate:Date) -> Date {
        let currentStartDate = Date.startOfCurrentMonth(startDate: startDate)
        return Date.startOfCurrentMonth(startDate: Date.init(timeInterval: -24*60*60, since: currentStartDate))
    }
    
    // MARK: 上月结束日期
    static func endOfLastMonth(startDate:Date) -> Date {
        let currentStartDate = Date.startOfCurrentMonth(startDate: startDate)
        return Date.init(timeInterval: -24*60*60, since: currentStartDate)
    }
    
    // MARK: 下月结束日期
    static func endOfNextMonth(startDate:Date) -> Date {
        let currentEndDate = Date.endOfCurrentMonth(startDate: startDate)
        return Date.endOfCurrentMonth(startDate: Date.init(timeInterval: 24*60*60, since: currentEndDate))
    }
    
    // MARK: 是否为今天
    func jwIsToday() -> Bool {
        return self.dateString("yyyyMMdd") == Date().dateString("yyyyMMdd")
    }
    
    // MARK: 明天
    func jwTomorrow() -> Date {
        let tempTime: TimeInterval = (24*60*60) // 加上一天的秒数，明天
        return self.addingTimeInterval(tempTime)
    }
    
    // MARK: 昨天
    func jwYesterday() -> Date {
        let tempTime: TimeInterval = -(24*60*60) // 往前减去一天的秒数，昨天
        return self.addingTimeInterval(tempTime)
    }
    
    // MARK: +几天
    func jwAddDays(days:Int) -> Date {
        let tempTime: TimeInterval = (TimeInterval(24*60*60*days)) // 加上N天的秒数
        return self.addingTimeInterval(tempTime)
    }
    
    // MARK: 差几天
    func jwDatesDistance(date:Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let temp1 = dateFormatter.date(from: self.dateString("yyyyMMdd"))
        let temp2 = dateFormatter.date(from: date.dateString("yyyyMMdd"))
        
        return (Int((temp1?.timeIntervalSince1970)!) - Int((temp2?.timeIntervalSince1970)!) ) / (60*60*24)

    }
    
    
    // 获取星期几
    
    func weekDay() -> String {
        
        
        
        let weekDays = [NSNull.init(),"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"] as [Any]
        
        
        
        let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
        
        let timeZone = NSTimeZone.init(name: "Asia/Shanghai")
        
        calendar?.timeZone = timeZone! as TimeZone
        
        
        
        let calendarUnit = NSCalendar.Unit.weekday
        
        
        
        let theComponents = calendar?.components(calendarUnit, from: self)
        
        
        
        
        
        return weekDays[(theComponents?.weekday)!] as! String
        
        
        
    }
    
}
