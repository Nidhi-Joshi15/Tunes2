//
//  SearchScreenViewModel.swift
//  TUNESDemo
//
//  Created by Nidhi Joshi on 27/04/2021.
//

import Foundation
class SearchScreenViewModel: SearchScreenViewModelProtocol {
    var didLoad: (() -> Void)?
    var selectedList: [String]?
    var searchList: [String]?
    var serviceManager: ServiceManager?
    init() {
        serviceManager = ServiceManager()
        selectedList = [String]()
    }
    func getList() -> [String]? {
        return selectedList.map({$0.map({$0.camelized})})
    }
    
    func getListCount() -> Int {
        return selectedList?.count ?? 0
    }
    
    func getItemAt(index: Int) -> String? {
        return selectedList?[index]
    }
}

protocol SearchScreenViewModelProtocol {
    var searchList: [String]? { get set}
    
    func getList() -> [String]?
    func getListCount() -> Int
    func getItemAt(index: Int) -> String?
    
    var didLoad: (() -> Void)? { get set }
}
