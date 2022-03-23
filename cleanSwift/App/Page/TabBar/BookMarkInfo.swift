//
//  BookMarkInfo.swift
//  cleanSwift
//
//  Created by 최민준(Minjun Choi) on 2021/08/25.
//

import UIKit

struct BookMarkInfoModel {
    var id: Int
    var posterURL: String
    var title: String
}

class BookMarkInfo {
    static let shared = BookMarkInfo()
    
    var id: Int?
    var posterURL: String?
    var title: String?
    
    //외부에서 함부로 객체를 생성하지 못하게끔
    private init() { }
}
