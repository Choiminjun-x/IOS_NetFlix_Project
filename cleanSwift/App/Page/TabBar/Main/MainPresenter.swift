//
//  MainPresenter.swift
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

protocol MainPresentationLogic
{
    func presentPopularList(response: Main.RequestPopularList.Response)
    func presentNowPlayingList(response: Main.RequestNowPlayingList.Response)
    func presentTopRatedList(response: Main.RequestTopRatedList.Response)
    func presentUpComingList(response: Main.RequestUpComingList.Response)
}

class MainPresenter: MainPresentationLogic
{
    weak var viewController: MainDisplayLogic?
    
    // MARK: - Controller에  ViewModel 생성해서 전달
    func presentPopularList(response: Main.RequestPopularList.Response) {
        let results = response.dto.results
        let imgResourceUrl = response.imgResourceUrl
        
        //compactMap -> 2차원 배열을 1차원 배열로 리턴 MainPopularListCellModel 타입의 배열로 return (result에서 필요한 값만 꺼내서)
        let cellModels: [MainPopularListCellModel] = results?.compactMap {
            guard let path = $0.posterPath else { return nil }
            return .init(imageURL: imgResourceUrl + path)
        } ?? []
        
        let isFirstPage: Bool = {
            let boolean = response.dto.page == 1 //첫 페이지
            return boolean
        }()
        
        let isLastPage: Bool = {
            let boolean = response.dto.page == response.dto.totalPages //맨 끝
            return boolean
        }()
        
        self.viewController?.displayPopularList(viewModel: .init(
            listModel: .init(
                cellModels: cellModels,
                isFirstPage: isFirstPage,
                isLastPage: isLastPage
            )
        ))
        
        let bookMarkModel: [BookMarkInfoModel] = results?.compactMap {
            guard let id = $0.id else { return nil}
            guard let posterURL = $0.posterPath else { return nil }
            guard let title = $0.title else { return nil }
            return .init(id: id, posterURL: imgResourceUrl + posterURL, title: title)
        } ?? []
        self.viewController?.popularBookMarkList(model: bookMarkModel)
        self.viewController?.mainBannerBookMarkList(model: bookMarkModel)
    }
    
    
    func presentNowPlayingList(response: Main.RequestNowPlayingList.Response) {
        let results = response.dto.results
        let imgResourceUrl = response.imgResourceUrl
        
        let cellModels: [MainNowPlayingListCellModel] = results?.compactMap {
            guard let path = $0.posterPath else { return nil }
            return .init(imageURL: imgResourceUrl + path)
        } ?? []
        
        let isFirstPage: Bool = {
            let boolean = response.dto.page == 1
            return boolean
        }()
        
        let isLastPage: Bool = {
            let boolean = response.dto.page == response.dto.totalPages
            return boolean
        }()
        
        self.viewController?.displayNowPlayingList(viewModel: .init(
            listModel: .init(cellModels: cellModels,
                             isFirstPage: isFirstPage,
                             isLastPage: isLastPage)
        ))
        
        let bookMarkModel: [BookMarkInfoModel] = results?.compactMap {
            guard let id = $0.id else { return nil}
            guard let posterURL = $0.posterPath else { return nil }
            guard let title = $0.title else {return nil}
            return .init(id: id, posterURL: imgResourceUrl + posterURL, title: title)
        } ?? []
        self.viewController?.nowplayingBookMarkList(model: bookMarkModel)
    }
    
    
    func presentTopRatedList(response: Main.RequestTopRatedList.Response){
        let results = response.dto.results
        let imgResourceUrl = response.imgResourceUrl
        
        let cellModels: [MainTopRatedListCellModel] = results?.compactMap {
            guard let path = $0.posterPath else { return nil }
            return .init(imageURL: imgResourceUrl + path)
        } ?? []
        
        let isFirstPage: Bool = {
            let boolean = response.dto.page == 1
            return boolean
        }()
        
        let isLastPage: Bool = {
            let boolean = response.dto.page == response.dto.totalPages
            return boolean
        }()
        
        self.viewController?.displayTopRatedList(viewModel: .init(
            listModel: .init(
                cellModels: cellModels,
                isFirstPage: isFirstPage,
                isLastPage: isLastPage
            )
        ))
        
        let bookMarkModel: [BookMarkInfoModel] = results?.compactMap {
            guard let id = $0.id else { return nil}
            guard let posterURL = $0.posterPath else { return nil }
            guard let title = $0.title else {return nil}
            return .init(id: id, posterURL: imgResourceUrl + posterURL, title: title)
        } ?? []
        self.viewController?.topratedBookMarkList(model: bookMarkModel)
    }
    
    
    func presentUpComingList(response: Main.RequestUpComingList.Response){
        let results = response.dto.results
        let imgResourceUrl = response.imgResourceUrl
        
        let cellModels: [MainUpComingListCellModel] = results?.compactMap {
            guard let path = $0.posterPath else { return nil }
            return .init(imageURL: imgResourceUrl + path)
        } ?? []
        
        let isFirstPage: Bool = {
            let boolean = response.dto.page == 1
            return boolean
        }()
        
        let isLastPage: Bool = {
            let boolean = response.dto.page == response.dto.totalPages
            return boolean
        }()
        
        self.viewController?.displayUpComingList(viewModel: .init(
            listModel: .init(
                cellModels: cellModels,
                isFirstPage: isFirstPage,
                isLastPage: isLastPage
            )
        ))
        
        let bookMarkModel: [BookMarkInfoModel] = results?.compactMap {
            guard let id = $0.id else { return nil}
            guard let posterURL = $0.posterPath else { return nil }
            guard let title = $0.title else {return nil}
            return .init(id: id, posterURL: imgResourceUrl + posterURL, title: title)
        } ?? []
        self.viewController?.upcomingBookMarkList(model: bookMarkModel)
    }
}

