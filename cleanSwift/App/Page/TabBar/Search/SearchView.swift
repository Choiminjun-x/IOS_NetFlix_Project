//
//  SearchView.swift
//  cleanSwift
//
//  Created by 최민준(Minjun Choi) on 2021/08/10.
//

import UIKit
import SnapKit
import SDWebImage
import RxSwift
import RxCocoa

// MARK: - Model
enum SearchViewModel {
    struct SearchList {
        var cellModels: [SearchListCellModel]
        var isFirstPage: Bool
        var isLastPage: Bool
    }
}

class SearchView: UIView {
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    required init() {
        super.init(frame: .zero)
        self.setAppearance()
    }
    
    //MARK: - Properties
    private let searchResultView: UITableView = .init(frame: .zero)
    private let searchListViewDelegate: searchResultViewDelegate = .init()
    
    //onNext가 아니라 accept이다 (accept안에 onNext가 구현되어 있음)
    // -> error랑 complete 보낼 수 없다 오로지 accept만 보낼 수 있다 -> UI는 에러났다고 화면을 안그리면 안되기때문에 UI용으로 만든 것이 RxRelay
    internal var searchListNextEvent: PublishRelay<Void> {
        get {
            return self.searchListViewDelegate.nextEvent
        }
    }
    internal var searchListCellTapEvent: PublishRelay<Int> {
        get {
            return self.searchListViewDelegate.cellTapEvent
        }
    }
    
    // MARK: - View
    func setAppearance() {
        self.searchResultView.do {
            self.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.top.equalToSuperview().offset(100)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-80)
                $0.leading.equalToSuperview().offset(10)
            }
            $0.delegate = self.searchListViewDelegate
            $0.dataSource = self.searchListViewDelegate
            $0.register(SearchListCell.self, forCellReuseIdentifier: "SearchListCell")
            $0.separatorStyle = .none
        }
    }
    
    public func displaySearchList(listModel: SearchViewModel.SearchList) {
        self.searchListViewDelegate.cellModels = {
            if listModel.isFirstPage {
                return listModel.cellModels //view의 딜리게이트에 전달
            } else {
                var arr = self.searchListViewDelegate.cellModels
                arr?.append(contentsOf: listModel.cellModels)
                return arr
            }
        }()
        self.searchListViewDelegate.isLastPage = listModel.isLastPage
        self.searchResultView.reloadData()
    }
    
    public func updateSearchList(){
        self.searchResultView.reloadData()
    }
    
    //아무데나 터치 시 키보드 내리기 설정
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
}


// MARK: - display TableView
fileprivate class searchResultViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var cellModels: [SearchListCellModel]?
    internal let nextEvent: PublishRelay<Void> = .init()
    var isLastPage: Bool = false
    internal let cellTapEvent: PublishRelay<Int> = .init()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return cellTapEvent.accept(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels?.count ?? 0
    }
    
    // 셀들이 생성(메모리에 로드됨)되면서 호출
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "SearchListCell", for: indexPath).do {
            guard let cellModel = self.cellModels?[indexPath.row] else { return }
            ($0 as? SearchListCell)?.displayCellModel(cellModel)
        }
    }
    
    //셀을 사용하여 행을 그리기 직전에 Delegate에게 이 메세지를 보낸다. 즉, Delegate가 셀 객체를 그리기 전에 사용자가 정의할 수 있다
    //willDisplay - > 화면에 셀이 보여지기 직전에 호출
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let count = self.cellModels?.count else { return }
        let isLastCell = (indexPath.row + 1 == count - 7)
        if isLastCell, self.isLastPage == false {
            self.nextEvent.accept(())
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

