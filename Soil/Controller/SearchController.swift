//
//  SearchController.swift
//  Soil
//
//  Created by dykoon on 2022/01/24.
//

import UIKit

class SearchController: UIViewController {
  
  // MARK: - Properties
    
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
  
  // MARK: - Helpers
  
  private func configure() {
    view.backgroundColor = .soilBackgroundColor
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.title = "search"
    
    let searchResultsTVC = SearchResultsTableController()
    let searchController = UISearchController(searchResultsController: searchResultsTVC)
    searchController.searchResultsUpdater = searchResultsTVC
    searchController.searchBar.placeholder = "검색하기"
    searchController.hidesNavigationBarDuringPresentation = false  // 검색 활성시 navigation title 숨김 방지
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = searchController
  }
}
