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
    setupSearchController()
  }
  
  // MARK: - Method
  
  private func setupSearchController() {
    view.backgroundColor = .soilBackgroundColor
    navigationItem.title = "search"
    navigationItem.largeTitleDisplayMode = .always
    
    let searchResultsTVC = SearchResultsTableController()
    searchResultsTVC.delegate = self
    let searchController = UISearchController(searchResultsController: searchResultsTVC)
    searchController.searchResultsUpdater = searchResultsTVC
    searchController.searchBar.placeholder = "검색하기"
    searchController.hidesNavigationBarDuringPresentation = false  // 검색 활성시 navigation title 숨김 방지
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = searchController
  }
}

// MARK: - SearchResultsTableControllerDelegate

extension SearchController: SearchResultsTableControllerDelegate {
  func didTapUsercell(uid: String) {
    let controller = YouController(uid: uid)
    self.navigationController?.pushViewController(controller, animated: true)
  }
}
