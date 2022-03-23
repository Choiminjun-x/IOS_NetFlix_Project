//
//  DetailRouter.swift
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

@objc protocol DetailRoutingLogic { }

protocol DetailDataPassing {
    var dataStore: DetailDataStore? { get }
}

class DetailRouter: NSObject, DetailRoutingLogic, DetailDataPassing
{
    weak var viewController: DetailViewController?
    var dataStore: DetailDataStore?
    
}
