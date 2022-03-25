//
//  SearchListCell.swift
//  cleanSwift
//
//  Created by 최민준(Minjun Choi) on 2021/08/10.
//

import UIKit
import SnapKit
import SDWebImage

struct SearchListCellModel: Codable {
    var imageURL: String
    var title: String
}

class SearchListCell: UITableViewCell {
    //MARK: - Properties
    private let vstackView: UIStackView = .init()
    private let posterView: UIImageView = .init()
    private let movieTitle: UILabel = .init()
    
    // MARK: - Object lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Method
    private func setAppearance() {
        
        self.vstackView.do {
            $0.backgroundColor = .black
            self.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.height.equalToSuperview()
                $0.centerX.equalToSuperview()
            }
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        self.posterView.do {
            //masksToBounds -> layer의 프로퍼티로 뷰를 기준으로 바깥에 있는 것은 짤림
            //layer view에 일을 시키면 layer 객체에서 이 일들을 직접 수행
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 5
            vstackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalTo(self.posterView.snp.height).multipliedBy(0.66)
                $0.height.equalToSuperview().offset(-10)
            }
        }
        vstackView.setCustomSpacing(20, after: vstackView.arrangedSubviews.last!)
        
        self.movieTitle.do {
            $0.textColor = .white
            vstackView.addArrangedSubview($0)
            $0.font = .systemFont(ofSize: 14)
            $0.numberOfLines = 0
        }
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterView.sd_cancelCurrentImageLoad()
    }
    
    //MARK: - displayCell in tableView
    func displayCellModel(_ model: SearchListCellModel) {
        self.posterView.sd_setImage(with: URL(string: model.imageURL))
        self.movieTitle.text = model.title
    }
}

