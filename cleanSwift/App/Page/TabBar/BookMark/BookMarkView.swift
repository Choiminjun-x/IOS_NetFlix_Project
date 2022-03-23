//
//  BookMarkView.swift
//  cleanSwift
//
//  Created by 최민준(Minjun Choi) on 2021/08/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class BookMarkView: UIView {
    
    //MARK: - Properties
    private let bookMarkListView: UITableView = .init(frame: .zero)
    private let bookMarkListViewDelegate: bookMarkTableViewDelegate = .init()
    
    internal var bookMarkListCellTapEvent: PublishRelay<Int> {
        get {
            return self.bookMarkListViewDelegate.cellTapEvent
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
    
    //MARK: - View Method
    private func setAppearance() {
      
        self.bookMarkListView.do {
            self.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.top.equalToSuperview().offset(100)
                
                $0.bottom.equalToSuperview().offset(-80)
                $0.leading.equalToSuperview().offset(10)
            }
            $0.delegate = self.bookMarkListViewDelegate
            $0.dataSource = self.bookMarkListViewDelegate
            $0.register(BookMarkListCell.self, forCellReuseIdentifier: "BookMarkListCell")
            $0.separatorStyle = .none
        }
    }
    
    public func displayBookMarkList(cellModel: [BookMarkListCellModel]) {
        self.bookMarkListViewDelegate.cellModels = {
            return cellModel
        }()
        self.bookMarkListView.reloadData()
    }
}

fileprivate class bookMarkTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var cellModels: [BookMarkListCellModel]?
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
        return tableView.dequeueReusableCell(withIdentifier: "BookMarkListCell", for: indexPath).do {
            guard let cellModel = self.cellModels?[indexPath.row] else { return }
            ($0 as? BookMarkListCell)?.displayCellModel(cellModel)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
}
