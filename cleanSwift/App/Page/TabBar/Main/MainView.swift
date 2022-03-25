//
//  MainView.swift
//  cleanSwift
//
//  Created by 최민준(Minjun Choi) on 2021/07/29.
//

import UIKit
import SnapKit
import SDWebImage
import RxSwift
import RxCocoa
import Alamofire

enum MainViewModel {
    struct PopularList {
        var cellModels: [MainPopularListCellModel]
        var isFirstPage: Bool
        var isLastPage: Bool
    }
    struct NowPlayingList {
        var cellModels: [MainNowPlayingListCellModel]
        var isFirstPage: Bool
        var isLastPage: Bool
    }
    struct TopRatedList  {
        var cellModels: [MainTopRatedListCellModel]
        var isFirstPage: Bool
        var isLastPage: Bool
    }
    struct UpComingList {
        var cellModels: [MainUpComingListCellModel]
        var isFirstPage: Bool
        var isLastPage: Bool
    }
}

protocol MainPageView where Self: MainView {
    
}
class MainView: UIView, MainPageView {
    
    //MARK: - Properties
    
    static func create() -> MainView {
        let bundle = Bundle(for: MainView.self)
        let nib = bundle.loadNibNamed("MainView", owner: nil)
        let view = nib?.first
        return view as! MainView
    }
    
    var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    @IBOutlet weak var popularListView: UICollectionView!
    @IBOutlet weak var nowplayingListView: UICollectionView!
    @IBOutlet weak var topratedListView: UICollectionView!
    @IBOutlet weak var upcomingListView: UICollectionView!
    
    private let disposeBag: DisposeBag = .init()
    
    //메인 버튼 클릭 이벤트
    internal let infoBtnTapEvent: PublishRelay<Int> = .init()
    
    internal let favoriteBtnTapEvent: PublishRelay<Int> = .init()
    
    private var randomNumber: Int = 0
    
    private let popularListDelegate: popularListDelegate = .init()
    internal var popularListNextEvent: PublishRelay<Void> {
        get {
            return self.popularListDelegate.nextEvent
        }
    }
    internal var popularListCellTapEvent: PublishRelay<Int> {
        get {
            return self.popularListDelegate.cellTapEvent
        }
    }
    internal var popularListContextMenuClickEvent: PublishRelay<Int> {
        get {
            return self.popularListDelegate.contextMenuClickEvent
        }
    }
  
    private let nowplayingListDelegate: nowplayingListDelegate = .init()
    internal var nowplayingListNextEvent: PublishRelay<Void> {
        get {
            return self.nowplayingListDelegate.nextEvent
        }
    }
    internal var nowplayingListCellTapEvent: PublishRelay<Int> {
        get {
            return self.nowplayingListDelegate.cellTapEvent
        }
    }
    internal var nowplayingListContextMenuClickEvent: PublishRelay<Int> {
        get {
            return self.nowplayingListDelegate.contextMenuClickEvent
        }
    }
    
    private let topratedListDelegate: topratedListDelegate = .init()
    internal var topratedListNextEvent: PublishRelay<Void> {
        get {
            return self.topratedListDelegate.nextEvent
        }
    }
    internal var topratedListCellTapEvent: PublishRelay<Int> {
        get {
            return self.topratedListDelegate.cellTapEvent
        }
    }
    internal var topratedListContextMenuClickEvent: PublishRelay<Int> {
        get {
            return self.topratedListDelegate.contextMenuClickEvent
        }
    }
   
    private let upcomingListDelegate: upcomingListDelegate = .init()
    internal var upcomingListNextEvent: PublishRelay<Void> {
        get {
            return self.upcomingListDelegate.nextEvent
        }
    }
    internal var upcomingListCellTapEvent: PublishRelay<Int> {
        get {
            return self.upcomingListDelegate.cellTapEvent
        }
    }
    internal var upcomingListContextMenuClickEvent: PublishRelay<Int> {
        get {
            return self.upcomingListDelegate.contextMenuClickEvent
        }
    }
    
    // MARK: - Object lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }
    
    // MARK: - View Method

    private func configure() {
        self.popularListView.do {
            $0.delegate = self.popularListDelegate
            $0.dataSource = self.popularListDelegate
            $0.register(MainPopularListCell.self, forCellWithReuseIdentifier: "MainPopularListCell")
            ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.do {
                $0.itemSize = .init(width: 188.55, height: 290)
                $0.scrollDirection = .horizontal
            }
        }
        
        self.nowplayingListView.do {
            $0.delegate = self.nowplayingListDelegate
            $0.dataSource = self.nowplayingListDelegate
            $0.register(MainNowPlayingListCell.self, forCellWithReuseIdentifier: "MainNowPlayingListCell")
            ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.do {
                $0.itemSize = .init(width: 110.5, height: 170)
                $0.scrollDirection = .horizontal
            }
        }
        
        self.topratedListView.do {
            $0.delegate = self.topratedListDelegate
            $0.dataSource = self.topratedListDelegate
            $0.register(MainTopRatedListCell.self, forCellWithReuseIdentifier: "MainTopRatedListCell")
            ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.do {
                $0.itemSize = .init(width: 110.5, height: 170)
                $0.scrollDirection = .horizontal
            }
        }
        
        self.upcomingListView.do {
            $0.delegate = self.upcomingListDelegate
            $0.dataSource = self.upcomingListDelegate
            $0.register(MainUpComingListCell.self, forCellWithReuseIdentifier: "MainUpComingListCell")
            ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.do {
                $0.itemSize = .init(width: 110.5, height: 170)
                $0.scrollDirection = .horizontal
            }
        }
        
    }
    
    //MARK: - display View
    public func displayPopularList(listModel: MainViewModel.PopularList) {
        //메인 화면에 스트레치 헤더뷰 이미지 관리하는 부분
        let randomNum = Int.random(in: 0 ..< 20)
        self.randomNumber = randomNum
        let mainImage = listModel.cellModels[randomNum]
        //스트레치 이미지 뷰에 랜덤으로 이미지 삽입
        self.bannerImageView.sd_setImage(with: URL(string: mainImage.imageURL), completed: nil)
        
        self.popularListDelegate.cellModels = {
            if listModel.isFirstPage {
                return listModel.cellModels
            } else {
                var arr = self.popularListDelegate.cellModels
                arr?.append(contentsOf: listModel.cellModels)
                return arr
            }
        }()
        self.popularListDelegate.isLastPage = listModel.isLastPage
        //테이블뷰를 업데이트 할 때 -> 테이블뷰의 전체 영역을 업데이트
        self.popularListView.reloadData()
    }
    
    public func displayNowPlayingList(listModel: MainViewModel.NowPlayingList) {
        
        self.nowplayingListDelegate.cellModels = {
            if listModel.isFirstPage {
                return listModel.cellModels
            } else {
                var arr = self.nowplayingListDelegate.cellModels
                arr?.append(contentsOf: listModel.cellModels)
                return arr
            }
        }()
        self.nowplayingListDelegate.isLastPage = listModel.isLastPage
        self.nowplayingListView.reloadData()
    }
    
    
    public func displayTopRatedList(listModel: MainViewModel.TopRatedList){
        self.topratedListDelegate.cellModels = {
            if listModel.isFirstPage {
                return listModel.cellModels
            } else {
                var arr = self.topratedListDelegate.cellModels
                arr?.append(contentsOf: listModel.cellModels)
                return arr
            }
        }()
        self.topratedListDelegate.isLastPage = listModel.isLastPage
        self.topratedListView.reloadData()
    }
    
    
    public func displayUpComingList(listModel: MainViewModel.UpComingList){
        self.upcomingListDelegate.cellModels = {
            if listModel.isFirstPage {
                return listModel.cellModels
            } else {
                var arr = self.upcomingListDelegate.cellModels
                arr?.append(contentsOf: listModel.cellModels)
                return arr
            }
        }()
        self.upcomingListDelegate.isLastPage = listModel.isLastPage
        self.upcomingListView.reloadData()
    }
}


// MARK: - display CollectionView
//fileprivate - > 접근제어자(소속 소스 파일 내에서만 접근이 가능하다)
fileprivate class popularListDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var cellModels: [MainPopularListCellModel]?
    internal let nextEvent: PublishRelay<Void> = .init()
    var isLastPage: Bool = false
    internal let cellTapEvent: PublishRelay<Int> = .init()
    internal let contextMenuClickEvent: PublishRelay<Int> = .init()
    
    //컨텍스트 메뉴 method
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            //버튼이 클릭 되었을 때
            let action = UIAction(title: "찜하기", image: UIImage(systemName: "star.fill")) { action in
                self.contextMenuClickEvent.accept(indexPath.row)
            }
            let action2 = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: [.disabled]) { action2 in
                
            }
            return UIMenu(title: "Menu", children: [action, action2])
        }
        return configuration
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cellTapEvent.accept(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "MainPopularListCell", for: indexPath).do {
            guard let cellModel = self.cellModels?[indexPath.row] else { return }
            ($0 as? MainPopularListCell)?.displayCellModel(cellModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = self.cellModels?.count else { return }
        let isLastCell = indexPath.row + 1 == count - 1
        if isLastCell, self.isLastPage == false {
            self.nextEvent.accept(())
        }
    }
}


fileprivate class nowplayingListDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var cellModels: [MainNowPlayingListCellModel]?
    internal let nextEvent: PublishRelay<Void> = .init()
    var isLastPage: Bool = false
    internal let cellTapEvent: PublishRelay<Int> = .init()
    internal let contextMenuClickEvent: PublishRelay<Int> = .init()
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let action = UIAction(title: "찜하기", image: UIImage(systemName: "star.fill")) { action in
                //버튼이 클릭 되었을 때
                self.contextMenuClickEvent.accept(indexPath.row)
            }
            let action2 = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: [.disabled]) { action2 in
            }
            return UIMenu(title: "Menu", children: [action, action2])
        }
        return configuration
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cellTapEvent.accept(indexPath.row)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "MainNowPlayingListCell", for: indexPath).do {
            guard let cellModel = self.cellModels?[indexPath.row] else { return }
            ($0 as? MainNowPlayingListCell)?.displayCellModel(cellModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = self.cellModels?.count else { return }
        let isLastCell = indexPath.row + 1 == count - 5
        if isLastCell, self.isLastPage == false {
            self.nextEvent.accept(())
        }
    }
}


fileprivate class topratedListDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var cellModels: [MainTopRatedListCellModel]?
    internal let nextEvent: PublishRelay<Void> = .init()
    var isLastPage: Bool = false
    internal let cellTapEvent: PublishRelay<Int> = .init()
    internal let contextMenuClickEvent: PublishRelay<Int> = .init()
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let action = UIAction(title: "찜하기", image: UIImage(systemName: "star.fill")) { action in
                //버튼이 클릭 되었을 때
                self.contextMenuClickEvent.accept(indexPath.row)
            }
            let action2 = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: [.disabled]) { action2 in
            }
            return UIMenu(title: "Menu", children: [action, action2])
        }
        return configuration
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cellTapEvent.accept(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "MainTopRatedListCell", for: indexPath).do {
            guard let cellModel = self.cellModels?[indexPath.row] else { return }
            ($0 as? MainTopRatedListCell)?.displayCellModel(cellModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = self.cellModels?.count else { return }
        let isLastCell = indexPath.row + 1 == count - 5
        if isLastCell, self.isLastPage == false {
            self.nextEvent.accept(())
        }
    }
}


fileprivate class upcomingListDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var cellModels: [MainUpComingListCellModel]?
    internal let nextEvent: PublishRelay<Void> = .init()
    var isLastPage: Bool = false
    internal let cellTapEvent: PublishRelay<Int> = .init()
    internal let contextMenuClickEvent: PublishRelay<Int> = .init()
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let action = UIAction(title: "찜하기", image: UIImage(systemName: "star.fill")) { action in
                //버튼이 클릭 되었을 때
                self.contextMenuClickEvent.accept(indexPath.row)
            }
            let action2 = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: [.disabled]) { action2 in
            }
            return UIMenu(title: "Menu", children: [action, action2])
        }
        return configuration
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cellTapEvent.accept(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "MainUpComingListCell", for: indexPath).do {
            guard let cellModel = self.cellModels?[indexPath.row] else { return }
            ($0 as? MainUpComingListCell)?.displayCellModel(cellModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = self.cellModels?.count else { return }
        let isLastCell = indexPath.row + 1 == count - 5
        if isLastCell, self.isLastPage == false {
            self.nextEvent.accept(())
        }
    }
}
