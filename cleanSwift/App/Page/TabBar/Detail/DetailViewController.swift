//
//  2DetailViewController.swift
//  cleanSwift
//
//  Created by 최민준(Minjun Choi) on 2021/08/03.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DetailDisplayLogic: AnyObject {
    func displayMovieDetail(viewModel: Detail.RequestMovieDetail.ViewModel)
}

class DetailViewController: UIViewController, DetailDisplayLogic {
    var interactor: DetailBusinessLogic?
    var router: (NSObjectProtocol & DetailRoutingLogic & DetailDataPassing)?
    
    //MARK: - Properties
    private let pageView: DetailView = .init()
    
    // MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        print("--Memory Deallocation--")
    }
    
    // MARK: - Setup
    private func setup() {
        let viewController = self
        let interactor = DetailInteractor()
        let presenter = DetailPresenter()
        let router = DetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: - View lifecycle
    override func loadView() {
        self.view = self.pageView
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.requestMovieDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - View Method
    func requestMovieDetail(){
        self.interactor?.requestMovieDetail(request: .init())
    }
    
    func displayMovieDetail(viewModel: Detail.RequestMovieDetail.ViewModel){
        self.pageView.displayMovieViewModel(viewModel.detailModel)
    }
    
}
