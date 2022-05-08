//
//  SearchController.swift
//  Soil
//
//  Created by dykoon on 2022/01/24.
//

import UIKit

class SearchController: UIViewController {
  
  // MARK: - Value Types
  
  typealias DataSource = UITableViewDiffableDataSource<Int, Search>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Search>
  
  // MARK: - Properties
  
  private let tableView = UITableView().then {
    $0.backgroundColor = .clear
    $0.rowHeight = 50
    $0.register(SearchRecentTableViewCell.self, forCellReuseIdentifier: SearchRecentTableViewCell.identifier)
  }
  
  private lazy var dataSource = setupDataSource()
  
  var searchArray: [Search] { // UserDefault에 저장
    get {
      var array: [Search]?
      if let data = UserDefaults.standard.value(forKey: "searchArray") as? Data {
        array = try? PropertyListDecoder().decode([Search].self, from: data)
      }
      return array ?? []
    }
    set {
      UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "searchArray")
    }
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    setupSearchController()
    setConstraint()
    updateDatasource()
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
    searchController.searchBar.delegate = self
    navigationItem.hidesSearchBarWhenScrolling = false
    navigationItem.searchController = searchController
    tableView.tableFooterView = UIView() // 존재하는 cell만 표시
  }
  
  private func setConstraint() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
      make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
      make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
    }
  }
  
  private func setupDataSource() -> DataSource {
     dataSource = UITableViewDiffableDataSource<Int, Search>(
       tableView: tableView,
       cellProvider: { tableView, indexPath, model -> UITableViewCell? in
         guard let cell = tableView.dequeueReusableCell(
           withIdentifier: SearchRecentTableViewCell.identifier,
           for: indexPath
         ) as? SearchRecentTableViewCell else { return UITableViewCell() }
         
         // x버튼 클릭 시 cell 삭제
         cell.xButton.addTarget(
           self,
           action: #selector(self.deleteCell),
           for: .touchUpInside
         )
         cell.label.text = model.word
         
         return cell
     })
     return dataSource
   }
  
  @objc private func deleteCell(_ sender: UIButton) {
    let contentView = sender.superview
    guard let cell = contentView?.superview as? UITableViewCell else { return }
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    searchArray.remove(at: indexPath.row) // 검색한 텍스트 삭제
    updateDatasource()
  }
  
  private func updateDatasource() {
    var snapshot = Snapshot()
    snapshot.appendSections([0])
    snapshot.appendItems(searchArray)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}

// MARK: - SearchResultsTableControllerDelegate

extension SearchController: SearchResultsTableControllerDelegate {
  func didTapUsercell(uid: String) {
    let controller = YouController(uid: uid)
    self.navigationController?.pushViewController(controller, animated: true)
  }
}

// MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate {
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    if let searchBarText = searchBar.text, searchBarText.isEmpty == false {
        let search: Search = Search(word: searchBarText)
        searchArray.insert(search, at: 0)
        updateDatasource()
    }
  }
}
