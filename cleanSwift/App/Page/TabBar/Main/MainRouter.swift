//
//  MainRouter.swift
//  cleanSwift
//
//  Created by 최민준(Minjun Choi) on 2021/07/28.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol MainRoutingLogic
{
    func routeToMainBannerDetail(index: Int)
    func routeToPopularDetail(index: Int)
    func routeToNowPlayingDetail(index: Int)
    func routeToTopRatedDetail(index: Int)
    func routeToUpComingDetail(index: Int)
}

protocol MainDataPassing
{
    var dataStore: MainDataStore? { get }
}

class MainRouter: NSObject, MainRoutingLogic, MainDataPassing {
    weak var viewController: MainViewController?
    weak var mainView: MainView?
    var dataStore: MainDataStore?
    
    //MARK: - routeToDetailPage
    func routeToMainBannerDetail(index: Int) {
        let prevVC = self.viewController
        let prevDataStore = self.dataStore
        
        let nextVC = DetailViewController()
        var nextDataStore = nextVC.router?.dataStore
        
        nextDataStore?.movieId = prevDataStore?.mainBannerResultList?[index].id
        nextDataStore?.apiType = 0
        
        prevVC?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func routeToPopularDetail(index: Int) {
        let prevVC = self.viewController
        let prevDataStore = self.dataStore
        
        let nextVC = DetailViewController()
        var nextDataStore = nextVC.router?.dataStore
        
        //Detail Page에서 MovieId로 다시 API 통신을 해서 필요한 데이터 값을 가져오기 위해 넘겨준다.
        nextDataStore?.movieId = prevDataStore?.popularResultList?[index].id
        nextDataStore?.apiType = 0
        
        prevVC?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func routeToNowPlayingDetail(index: Int) {
        let prevVC = self.viewController
        let prevDataStore = self.dataStore
        
        let nextVC = DetailViewController()
        var nextDataStore = nextVC.router?.dataStore
        
        nextDataStore?.movieId = prevDataStore?.nowplayingResultList?[index].id
        nextDataStore?.apiType = 1
        
        prevVC?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func routeToTopRatedDetail(index: Int){
        let prevVC = self.viewController
        let prevDataStore = self.dataStore
        
        let nextVC = DetailViewController()
        var nextDataStore = nextVC.router?.dataStore
        
        nextDataStore?.movieId = prevDataStore?.topratedResultList?[index].id
        nextDataStore?.apiType = 2
        
        prevVC?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func routeToUpComingDetail(index: Int){
        let prevVC = self.viewController
        let prevDataStore = self.dataStore
        
        let nextVC = DetailViewController()
        
        var nextDataStore = nextVC.router?.dataStore
        
        nextDataStore?.movieId = prevDataStore?.upcomingResultList?[index].id
        nextDataStore?.apiType = 3
        
        prevVC?.navigationController?.pushViewController(nextVC, animated: true)
    }
}