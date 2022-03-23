//
//  LoadingController.swift
//  cleanSwift
//
//  Created by 최민준(Minjun Choi) on 2021/08/05.
//
import UIKit

class LoadingViewController: UIViewController {
    
    let pageView: LoadingAnimationView = .init()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        self.view = self.pageView
        self.view.backgroundColor = .black
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        //메인 스레드를 현재시간부터 3.3초 후에 화면 전환 
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.3, execute: {
            let tabPage = TabBarController()
            tabPage.modalPresentationStyle = .fullScreen
            self.present(tabPage, animated: true, completion: nil)
        })
    }
}
