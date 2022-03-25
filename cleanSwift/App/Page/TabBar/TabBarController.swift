//
//  TabBarController.swift
//  cleanSwift
//
//  Created by 최민준(Minjun Choi) on 2021/08/06.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //인스턴스화
        let vc1 = MainViewController()
        let vc2 = SearchViewController()
        let vc3 = BookMarkViewController()
        
        vc3.notificationEvent()
        
        //각 tab bar 타이틀 설정
        vc1.tabBarItem.title = "홈"
        vc1.tabBarItem.image = UIImage(systemName: "house")
        
        vc2.tabBarItem.title = "검색"
        vc2.tabBarItem.image = UIImage(systemName: "paperplane")
        
        vc3.tabBarItem.title = "찜목록"
        vc3.tabBarItem.image = UIImage(systemName: "bookmark")
        
        
        //navigationController의 root view 설정
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
 
        //tab bar에 올리기
        setViewControllers([nav1,nav2, nav3], animated: false)
        
        UITabBar.appearance().tintColor = UIColor.gray
        UITabBar.appearance().barTintColor = UIColor.black
    }
}
