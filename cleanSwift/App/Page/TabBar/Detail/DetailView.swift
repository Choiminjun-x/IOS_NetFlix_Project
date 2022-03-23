//
//  DetailView.swift
//  cleanSwift
//
//  Created by 최민준(Minjun Choi) on 2021/08/03.
//

import UIKit
import SDWebImage
import SnapKit
import RxCocoa
import RxSwift

struct DetailMovieViewModel {
    var posterURL: String
    var posterURL2: String
    var title: String
    var discription: String
    var year: String
    var runtime: Int
    var apiType: Int
    var voteAverage: Double
    var genres: [genresModel]
    var tagline: String
}

struct genresModel {
    var name: String
}

enum DetailImageScrollCase {
    case able
    case unable
}

class DetailView: UIView {
    
    //MARK: - Properties
    private let imageScrollView: UIScrollView = .init()
    private let innerView: UIView = .init()
    private let imageStackView: UIStackView = .init()
    private let imagePageControl: UIPageControl = .init()
    
    private let posterImageView: UIImageView = .init()
    private let posterImageView2: UIImageView = .init()
    
    private let titleLabel: UILabel = .init()
    private let detailTitleLabel: UILabel = .init()
    private let discriptionLabel: UILabel = .init()
    private let movieTypeLabel: UILabel = .init()
    private let voteAverageLabel: UILabel = .init()
    private let genresLabel: UILabel = .init()
    private let taglineLabel: UILabel = .init()
    
    private let detailLineStack: UIStackView = .init()
    
    private var imageStatus = 1
    
    private var images: [String] = []
    
    internal var scrollRightEvent: PublishRelay<Void> {
        get {
            return self.scrollViewDelegate.rightEvent
        }
    }
    
    internal var scrollLeftEvent: PublishRelay<Void> {
        get {
            return self.scrollViewDelegate.leftEvent
        }
    }
    private let disposeBag: DisposeBag = .init()
    
    private let scrollViewDelegate: scrollViewDelegate = .init()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    required init() {
        super.init(frame: .zero)
        self.setAppearance()
    }
    
    //스크롤 셋팅 메소드 
    func settingScroll(_ isScroll: DetailImageScrollCase) {
        switch isScroll {
        case .able :
            self.imageScrollView.alwaysBounceHorizontal = true
        case .unable :
            self.imageScrollView.alwaysBounceHorizontal = false
        }
    }
    
    // MARK: - View Method
    func setAppearance() {
        self.backgroundColor = .black
        
        self.imageScrollView.do {
            self.addSubview($0)
            self.settingScroll(.able)
            //Constraint를 코드로 조정해야 할 일이 있을 때 호출
            $0.snp.makeConstraints {
                $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
                $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-411)
                $0.leading.equalTo(safeAreaLayoutGuide.snp.leading)
                $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            }
            //페이지 스크롤로 넘어가게끔
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.delegate = self.scrollViewDelegate
        }
        
        self.imagePageControl.do {
            self.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(30)
                $0.top.equalTo(self.imageScrollView.snp.bottom)
            }
            $0.currentPage = 0
            $0.isUserInteractionEnabled = false
        }
        
        self.innerView.do {
            $0.backgroundColor = .black
            imageScrollView.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(self.imageScrollView.contentLayoutGuide.snp.top)
                $0.bottom.equalTo(self.imageScrollView.contentLayoutGuide.snp.bottom)
                $0.leading.equalTo(self.imageScrollView.contentLayoutGuide.snp.leading)
                $0.trailing.equalTo(self.imageScrollView.contentLayoutGuide.snp.trailing)
                //가로 스크롤을 위해서 
                $0.height.equalTo(self.imageScrollView.frameLayoutGuide.snp.height)
            }
        }
        
        self.imageStackView.do {
            innerView.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.top.bottom.equalToSuperview()
                $0.centerX.equalToSuperview()
            }
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fill
        }
        
        self.posterImageView.do {
            imageStackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalTo(self.frame.width)
                $0.height.equalTo(self.posterImageView.snp.width).multipliedBy(0.56)
            }
        }
        
        self.posterImageView2.do {
            imageStackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalTo(self.frame.width)
                $0.height.equalTo(self.posterImageView2.snp.width).multipliedBy(0.56)
            }
        }
        
        UIScrollView().do {
            $0.backgroundColor = .black
            self.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.height.centerX.equalToSuperview()
                $0.top.equalTo(self.imagePageControl.snp.bottom)
            }
            $0.alwaysBounceVertical = true
        }.do { scrollView in
            
            UIStackView().do {
                scrollView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.centerX.top.bottom.equalToSuperview()
                    $0.width.equalToSuperview().offset(-20)
                }
                $0.backgroundColor = .black
                $0.axis = .vertical
                $0.alignment = .fill
                $0.distribution = .fill
            }.do { vstackView in
                
                self.titleLabel.do
                {
                    vstackView.addArrangedSubview($0)
                    $0.snp.makeConstraints {
                        $0.height.equalTo(45)
                    }
                    $0.textColor = .white
                    $0.font = .boldSystemFont(ofSize: 18)
                }
                
                self.detailLineStack.do {
                    vstackView.addArrangedSubview($0)
                    $0.snp.makeConstraints {
                        $0.height.equalTo(30)
                    }
                    $0.backgroundColor = .black
                    $0.axis = .horizontal
                    $0.alignment = .fill
                    $0.distribution = .fill
                }
                
                self.movieTypeLabel.do {
                    detailLineStack.addArrangedSubview($0)
                    $0.textColor = .white
                    $0.font = .boldSystemFont(ofSize: 14)
                }
                
                self.detailTitleLabel.do {
                    detailLineStack.addArrangedSubview($0)
                    $0.textColor = .white
                    $0.font = .systemFont(ofSize: 14)
                }
                
                self.genresLabel.do {
                    vstackView.addArrangedSubview($0)
                    $0.snp.makeConstraints {
                        $0.height.equalTo(30)
                    }
                    $0.textColor = .white
                    $0.font = .systemFont(ofSize: 14)
                }
                
                self.voteAverageLabel.do {
                    vstackView.addArrangedSubview($0)
                    $0.snp.makeConstraints {
                        $0.height.equalTo(30)
                    }
                    $0.textColor = .white
                    $0.font = .systemFont(ofSize: 14)
                }
                
                self.taglineLabel.do {
                    vstackView.addArrangedSubview($0)
                    $0.snp.makeConstraints {
                        $0.height.equalTo(30)
                    }
                    $0.numberOfLines = 0
                    $0.textColor = .white
                    $0.font = .systemFont(ofSize: 14)
                }
                
                self.discriptionLabel.do {
                    vstackView.addArrangedSubview($0)
                    // line 무제한
                    $0.numberOfLines = 0
                    $0.textColor = .white
                    $0.font = .systemFont(ofSize: 14)
                }
            }
        }
    }
    
    //MARK: - display View
    func displayMovieViewModel(_ model: DetailMovieViewModel){
        
        //사진이 1장일 경우
        if model.posterURL2 == "https://image.tmdb.org/t/p/original" {
            images.removeAll()
            images.append(model.posterURL)
            self.settingScroll(.unable)
            //페이지 컨트롤 개수
            self.imagePageControl.numberOfPages = images.count
            self.posterImageView.sd_setImage(with: URL(string: images[0]), completed: nil)
            //두번째 사진이 들어갈 공간 없애기
            self.posterImageView2.snp.remakeConstraints {
                $0.width.height.equalTo(0)
            }
        }
        else {
            images.removeAll()
            images.append(model.posterURL)
            images.append(model.posterURL2)
            //페이지 컨트롤 개수
            self.imagePageControl.numberOfPages = images.count
            self.posterImageView.sd_setImage(with: URL(string: images[0]), completed: nil)
            
            self.scrollRightEvent.subscribe(onNext: {
                self.imagePageControl.currentPage += 1
                self.posterImageView2.sd_setImage(with: URL(string: self.images[self.imagePageControl.currentPage]), completed: nil)
            }).disposed(by: disposeBag)
            
            self.scrollLeftEvent.subscribe(onNext: {
                self.imagePageControl.currentPage -= 1
            }).disposed(by: disposeBag)
        }
        
        self.titleLabel.text = model.title
        
        let year = model.year.split(separator: "-")
        let hour = model.runtime / 60
        let min = model.runtime % 60
        
        switch model.apiType {
        case 0:
            self.movieTypeLabel.text = "최신 인기 "
            self.movieTypeLabel.textColor = .green
        case 1:
            self.movieTypeLabel.text = "극장 상영중 "
            self.movieTypeLabel.textColor = .systemBlue
        case 2:
            self.movieTypeLabel.text = "최고 평가 "
            self.movieTypeLabel.textColor = .yellow
        case 3:
            self.movieTypeLabel.text = "개봉 예정 "
            self.movieTypeLabel.textColor = .magenta
        default: break
        }
        
        if hour == 0 {
            self.detailTitleLabel.text = year[0] + " \(min)분  "
        }
        else {
            self.detailTitleLabel.text = year[0] + " \(hour)시간 \(min)분"
        }
        
        var i = 0
        var genres: String = ""
        while i < model.genres.count {
            if i + 1 == model.genres.count {
                genres += model.genres[i].name
            }
            else {
                genres += model.genres[i].name + ", "
            }
            i += 1
        }
        
        self.genresLabel.text = "장르: " + genres
        self.voteAverageLabel.text = ("평점: " + "\(model.voteAverage)")
        
        if model.tagline != "" {
            self.taglineLabel.text = " '" + "\(model.tagline)" + "' "
        }
        
        self.discriptionLabel.text = model.discription
    }
}

//Detail Page 메인 사진 스크롤 이벤트 관리
fileprivate class scrollViewDelegate: NSObject, UIScrollViewDelegate {
    
    //오른쪽 방향으로 스크롤 시
    internal let rightEvent: PublishRelay<Void> = .init()
    //왼쪽 방향으로 스크롤 시 
    internal let leftEvent: PublishRelay<Void> = .init()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //Content Offset -> Origin Point / Bounds의 x,y 좌표
        if scrollView.contentOffset.x > 30 {
            self.rightEvent.accept(())
        }
        
        if scrollView.contentOffset.x < 30 {
            self.leftEvent.accept(())
        }
    }
}


