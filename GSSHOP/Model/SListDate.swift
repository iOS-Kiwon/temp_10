//
//  Date.swift
//  GSSHOP
//
//  Created by admin on 2020/07/03.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit
import ObjectMapper

class SListDate: Mappable {
    var year:Int = 0
    var month:Int = 1
    var day:Int = 1
    var week:String = ""
    var yyyyMMdd:String = ""
    var todayYn:String = "N"
    var selectedYn:String = "N"
    var apiUrl:String = ""
    var apiParm:String = ""

    required init?(map: Map) {
        mapping(map: map)
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        self.year <- map["year"]
        self.month <- map["month"]
        self.day <- map["day"]
        self.week <- map["week"]
        self.yyyyMMdd <- map["yyyyMMdd"]
        self.todayYn <- map["todayYn"]
        self.selectedYn <- map["selectedYn"]
        self.apiUrl <- map["apiUrl"]
        self.apiParm <- map["apiParm"]
    }
}

