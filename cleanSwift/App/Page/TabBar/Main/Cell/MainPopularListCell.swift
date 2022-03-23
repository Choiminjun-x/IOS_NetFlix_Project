//
//  MoviePopularListCell.swift
//  cleanSwift
//
//  Created by 최민준(Minjun Choi) on 2021/07/29.
//

import UIKit
import SnapKit
import SDWebImage

struct MainPopularListCellModel {
    var imageURL: String
}

class MainPopularListCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let imageView: UIImageView = .init()

    // MARK: - Object lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Method
    private func setAppearance() {
        self.imageView.do {
            //masksToBounds -> layer의 프로퍼티로 뷰를 기준으로 바깥에 있는 것은 짤림
            //layer view에 일을 시키면 layer 객체에서 이 일들을 직접 수행
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 5
            self.addSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalToSuperview()
                $0.width.equalTo(self.imageView.snp.height).multipliedBy(0.66)
                $0.center.equalToSuperview()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.sd_cancelCurrentImageLoad()
    }
    
    //MARK: - displayCell in CollectionView
    func displayCellModel(_ model: MainPopularListCellModel) {
        self.imageView.sd_setImage(with: URL(string: model.imageURL))
    }
}
