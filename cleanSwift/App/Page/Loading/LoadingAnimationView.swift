//
//  LoadingAnimationView.swift
//  cleanSwift
//
//  Created by 최민준(Minjun Choi) on 2021/08/05.
//

import Foundation
import UIKit
import SwiftyGif
import SnapKit

class LoadingAnimationView: UIView {
    
    let logoGifImageView: UIImageView = {
        guard let gifImage = try? UIImage(gifName: "netflix_GIF") else { return UIImageView() }
        return UIImageView(gifImage: gifImage, loopCount: Int(2.0))
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor(white: 246.0 / 255.0, alpha: 1)
        addSubview(logoGifImageView)
        logoGifImageView.translatesAutoresizingMaskIntoConstraints = false
        
        logoGifImageView.snp.makeConstraints { (make) in
            make.top.equalTo(250)
            make.height.equalTo(250)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.centerX.equalTo(UIScreen.main.bounds.size.width*0.5)
        }
    }
}
