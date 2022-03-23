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

class MainView: UIView {
    
    //MARK: - Properties
    
    var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
    
    private let disposeBag: DisposeBag = .init()
    
    private let scrollView: UIScrollView = .init()
    private let vstackView: UIStackView = .init()
    
    private let stretchyheaderView: UIView = .init()
    private let stretchyheaderImageView: UIImageView = .init()
    
    private let buttonView: UIView = .init()
    private let buttonStackView: UIStackView = .init()
    
    //메인 버튼 클릭 이벤트
    internal let infoBtnTapEvent: PublishRelay<Int> = .init()
    
    internal let favoriteBtnTapEvent: PublishRelay<Int> = .init()
    
    private var randomNumber: Int = 0
    
    private let popularTitleLabel: UILabel = .init()
    private let popularListView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
    
    private let nowplayingTitleLabel: UILabel = .init()
    private let nowplayingListView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
    
    private let topratedTitleLabel: UILabel = .init()
    private let topratedListView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
    
    private let upcomingTitleLabel: UILabel = .init()
    private let upcomingListView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
    required init?(coder: NSCoder) {
        fatalError()
    }
    required init() {
        super.init(frame: .zero)
        self.setAppearance()
    }
    
    // MARK: - View Method 
    private func setAppearance() {
        //전체 ScrollView
        scrollView.do {
            self.addSubview($0)
            $0.snp.makeConstraints {
                //                $0.top.equalTo(safeAreaLayoutGuide.snp.top)
                $0.width.height.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-80)
                $0.centerX.centerY.equalToSuperview()
            }
            $0.backgroundColor = .black
            $0.alwaysBounceVertical = true
            //스크롤뷰 스크롤바 숨김 
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
        }
        //영화 리스트 StackView
        vstackView.do {
            scrollView.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.top.equalTo(scrollView.snp.top).offset(570)
            }
            $0.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
            $0.isLayoutMarginsRelativeArrangement = true
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        //stretchy Header
        stretchyheaderView.do {
            
            scrollView.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.left.right.equalTo(self)
                $0.bottom.equalTo(self.vstackView.snp.top).offset(-10).priority(900)
            }
            /*
             //NSLayout
             let headerContainerViewBottom : NSLayoutConstraint!
            //AutoResizingMask와 충돌을 막기 위해서
            $0.translatesAutoresizingMaskIntoConstraints = false
            //동적으로 Constraint가 변경될 수 있도록
            NSLayoutConstraint.activate([ //한번에 여러 제약 조건을 업데이트 해주는 NSLayoutConstraint의 메소드
                $0.topAnchor.constraint(equalTo: self.topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
            headerContainerViewBottom = $0.bottomAnchor.constraint(equalTo: self.vstackView.topAnchor, constant: -10)
            //제약 조건 우선 순위
            headerContainerViewBottom.priority = UILayoutPriority(900)
            //제약 조건의 활성 상태 설정
            headerContainerViewBottom.isActive = true
            */
        }
        
        stretchyheaderImageView.do {
            stretchyheaderView.addSubview($0)
            $0.clipsToBounds = true
            
            //짤리더라도 비율을 유지하면서 꽉 채운다
            $0.contentMode = .scaleAspectFill
    
            $0.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalTo(self).priority(900)
//                $0.top.equalToSuperview().priority(900)
                $0.height.greaterThanOrEqualTo(400)
            }
            /*
            //AutoResizingMask와 충돌을 막기 위해서
            stretchyheaderImageView.translatesAutoresizingMaskIntoConstraints = false
          
            NSLayoutConstraint.activate([ //한번에 여러 제약 조건을 업데이트 해주는 NSLayoutConstraint의 메소드
                self.stretchyheaderImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 400), // 400이하로 작아지지 않는다.
                self.stretchyheaderImageView.leadingAnchor.constraint(equalTo: self.stretchyheaderView.leadingAnchor),
                self.stretchyheaderImageView.trailingAnchor.constraint(equalTo: self.stretchyheaderView.trailingAnchor),
                self.stretchyheaderImageView.bottomAnchor.constraint(equalTo: self.stretchyheaderView.bottomAnchor)
            ])
            let imageViewTopConstraint : NSLayoutConstraint!
            imageViewTopConstraint = self.stretchyheaderImageView.topAnchor.constraint(equalTo: self.topAnchor)
            imageViewTopConstraint.priority = UILayoutPriority(900)
            imageViewTopConstraint.isActive = true
             */
        }
        
        buttonView.do {
            vstackView.addArrangedSubview($0)
            $0.backgroundColor = .black
            $0.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(40)
            }
        }
        
        buttonStackView.do {
            $0.backgroundColor = .black
            buttonView.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.height.equalToSuperview()
                $0.left.equalTo(-10)
            }
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fill
            //뷰와 뷰 사이의 간격을 일정하게 만들어주는 역할
        }
        
        UIButton().do {
            $0.backgroundColor = .black
            buttonStackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalToSuperview()
                $0.width.equalTo(120)
            }
            $0.tintColor = .white
            $0.setImage(UIImage(systemName: "plus"), for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 12)
            $0.setTitle("찜하기", for: .normal)
            $0.imageEdgeInsets.left = -17
            
            $0.rx.tap
                .asDriver() //Main Scheduler에서 동작한다
                .asObservable()
                .subscribe(onNext:{ [weak self] _ in
                    self?.favoriteBtnTapEvent.accept((self?.randomNumber)!)
                }).disposed(by: self.disposeBag)
        }
        
        UIButton().do {
            $0.backgroundColor = .white
            buttonStackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(buttonStackView.snp.height)
                $0.width.equalTo(100)
                $0.centerX.centerY.equalToSuperview()
            }
            $0.tintColor = .black
            $0.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
            $0.imageEdgeInsets.left = -20
            $0.setTitle("정보", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.layer.cornerRadius = 5
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.white.cgColor
            $0.rx.tap
                .asDriver()
                .asObservable()
                .subscribe(onNext:{ [weak self] _ in
                    self?.infoBtnTapEvent.accept((self?.randomNumber)!)
                }).disposed(by: self.disposeBag)
        }
        
        UIButton().do {
            $0.backgroundColor = .black
            buttonStackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalToSuperview()
                $0.width.equalTo(120)
            }
            $0.setTitle("더 보기", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 12)
            
            $0.rx.tap
                .asDriver()
                .asObservable()
                .subscribe(onNext:{
                    print("Btn3 Click")
                }).disposed(by: self.disposeBag)
        }
        
        self.popularTitleLabel.do {
            vstackView.addArrangedSubview($0)
            $0.text = "인기 콘텐츠"
            $0.font = .boldSystemFont(ofSize: 17)
            $0.textColor = .white
            $0.snp.makeConstraints {
                $0.height.equalTo(20)
            }
        }
        
        self.popularListView.do {
            vstackView.addArrangedSubview($0)
            $0.backgroundColor = .clear
            $0.snp.makeConstraints {
                $0.height.equalTo(300)
                $0.width.centerX.equalToSuperview()
            }
            $0.delegate = self.popularListDelegate
            $0.dataSource = self.popularListDelegate
            $0.register(MainPopularListCell.self, forCellWithReuseIdentifier: "MainPopularListCell")
            ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.do {
                $0.itemSize = .init(width: 188.55, height: 290)
                $0.scrollDirection = .horizontal
            }
        }
        
        vstackView.setCustomSpacing(5, after: vstackView.arrangedSubviews.last!)
        
        self.nowplayingTitleLabel.do {
            vstackView.addArrangedSubview($0)
            $0.backgroundColor = .black
            $0.text = "극장 상영 컨텐츠"
            $0.font = .boldSystemFont(ofSize: 17)
            $0.textColor = .white
            $0.snp.makeConstraints {
                $0.height.equalTo(20)
            }
        }
        
        self.nowplayingListView.do {
            vstackView.addArrangedSubview($0)
            $0.backgroundColor = .black
            $0.snp.makeConstraints {
                $0.height.equalTo(180)
            }
            
            $0.delegate = self.nowplayingListDelegate
            $0.dataSource = self.nowplayingListDelegate
            $0.register(MainNowPlayingListCell.self, forCellWithReuseIdentifier: "MainNowPlayingListCell")
            ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.do {
                $0.itemSize = .init(width: 110.5, height: 170)
                $0.scrollDirection = .horizontal
            }
        }
        vstackView.setCustomSpacing(5, after: vstackView.arrangedSubviews.last!)
        
        self.topratedTitleLabel.do {
            vstackView.addArrangedSubview($0)
            $0.backgroundColor = .black
            $0.text = "오직 넷플릭스에서"
            $0.font = .boldSystemFont(ofSize: 17)
            $0.textColor = .white
            $0.snp.makeConstraints {
                $0.height.equalTo(20)
            }
        }
        
        self.topratedListView.do {
            vstackView.addArrangedSubview($0)
            $0.backgroundColor = .black
            $0.snp.makeConstraints {
                $0.height.equalTo(180)
            }
            
            $0.delegate = self.topratedListDelegate
            $0.dataSource = self.topratedListDelegate
            $0.register(MainTopRatedListCell.self, forCellWithReuseIdentifier: "MainTopRatedListCell")
            ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.do {
                $0.itemSize = .init(width: 110.5, height: 170)
                $0.scrollDirection = .horizontal
            }
        }
        vstackView.setCustomSpacing(5, after: vstackView.arrangedSubviews.last!)
        
        self.upcomingTitleLabel.do {
            vstackView.addArrangedSubview($0)
            $0.backgroundColor = .black
            $0.text = "개봉 예정 컨텐츠"
            $0.font = .boldSystemFont(ofSize: 17)
            $0.textColor = .white
            $0.snp.makeConstraints {
                $0.height.equalTo(20)
            }
        }
        
        self.upcomingListView.do {
            vstackView.addArrangedSubview($0)
            $0.backgroundColor = .black
            $0.snp.makeConstraints {
                $0.height.equalTo(180)
            }
            
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
        self.stretchyheaderImageView.sd_setImage(with: URL(string: mainImage.imageURL), completed: nil)
        
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
