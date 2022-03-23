//
//  KNWNoticesDataDto.swift
//  KonaNetworks
//
//  Created by 최민준(Minjun Choi) on 2022/03/10.
//  Copyright © 2022 Konai. All rights reserved.
//

import Foundation

public struct KNWNoticeDataDto: Codable {
    public var totalCnt: Int?
    public var notices: [KNWNoticeDto]?
    public var topNotices: [KNWTopNoticeDto]?
    
    enum CodingKeys: String, CodingKey {
        case totalCnt = "totalCnt"
        case notices = "notices"
        case topNotices = "topNotices"
    }
    
    public struct KNWTopNoticeDto: Codable {
        public var pageSize: Int?
        public var chargeNo: Int?
        public var answerNo: Int?
        public var bbsNo: Int?
        public var modId: Int?
        public var ctgryCd: String?
        public var rdCnt: Int?
        public var bbsNm: String?
        public var typeCd: String?
        public var regDt: Int64?
        public var rnum: Int?
        public var aregId: Int?
        public var bregId: Int?
        public var preNum: Int?
        public var regId: Int?
        public var fileNo: Int?
        public var subject: String?
        public var isNew: String?
        public var sortNo: Int?
        public var totalCnt: Int?
        public var pageNum: Int?
        public var sn: Int?
        public var nextNum: Int?
        public var bbsCd: String?
        
        enum CodingKeys: String, CodingKey {
            case pageSize = "pageSize"
            case chargeNo = "chargeNo"
            case answerNo = "answerNo"
            case bbsNo = "bbsNo"
            case modId = "modId"
            case ctgryCd = "ctgryCd"
            case rdCnt = "rdCnt"
            case bbsNm = "bbsNm"
            case typeCd = "typeCd"
            case regDt = "regDt"
            case rnum = "rnum"
            case aregId = "aregId"
            case bregId = "bregId"
            case preNum = "preNum"
            case regId = "regId"
            case fileNo = "fileNo"
            case subject = "subject"
            case isNew = "isNew"
            case sortNo = "sortNo"
            case totalCnt = "totalCnt"
            case pageNum = "pageNum"
            case sn = "sn"
            case nextNum = "nextNum"
            case bbsCd = "bbsCd"
        }
    }
    
    public struct KNWNoticeDto: Codable {
        public var pageSize: Int?
        public var chargeNo: Int?
        public var answerNo: Int?
        public var bbsNo: Int?
        public var modId: Int?
        public var ctgryCd: String?
        public var rdCnt: Int?
        public var regIp: String?
        public var bbsNm: String?
        public var typeCd: String?
        public var regDt: Int64?
        public var rnum: Int?
        public var useYn: String?
        public var aregId: Int?
        public var bregId: Int?
        public var preNum: Int?
        public var platformYn: String?
        public var regId: Int?
        public var fileNo: Int?
        public var subject: String?
        public var sortNo: Int?
        public var partnerYn: String?
        public var totalCnt: Int?
        public var pageNum: Int?
        public var sn: Int?
        public var nextNum: Int?
        public var isNew: String?
        public var bbsCd: String?
        public var userYn: String?
        
        enum CodingKeys: String, CodingKey {
            case pageSize = "pageSize"
            case chargeNo = "chargeNo"
            case answerNo = "answerNo"
            case bbsNo = "bbsNo"
            case modId = "modId"
            case ctgryCd = "ctgryCd"
            case rdCnt = "rdCnt"
            case regIp = "regIp"
            case bbsNm = "bbsNm"
            case typeCd = "typeCd"
            case regDt = "regDt"
            case rnum = "rnum"
            case useYn = "useYn"
            case aregId = "aregId"
            case bregId = "bregId"
            case preNum = "preNum"
            case platformYn = "platformYn"
            case regId = "regId"
            case fileNo = "fileNo"
            case subject = "subject"
            case sortNo = "sortNo"
            case partnerYn = "partnerYn"
            case totalCnt = "totalCnt"
            case pageNum = "pageNum"
            case sn = "sn"
            case nextNum = "nextNum"
            case isNew = "isNew"
            case bbsCd = "bbsCd"
            case userYn = "userYn"
        }
    }
    
    
}
