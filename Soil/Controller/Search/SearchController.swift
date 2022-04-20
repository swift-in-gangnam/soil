//
//  SearchController.swift
//  Soil
//
//  Created by dykoon on 2022/01/24.
//

import UIKit

class SearchController: UIViewController {
  
  // MARK: - Properties
  private let tableView = UITableView().then {
    $0.backgroundColor = .clear
    $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
  }
  var searchArray = [String]()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    setupSearchController()
    setConstraint()
    
    tableView.tableFooterView = UIView() // tableView 존재하는 셀만 표시
    searchArray = UserDefaults.standard.array(forKey: "SearchArray") as? [String] ?? [] // 검색 기록 array
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
  
  @objc func deleteCell(_ sender: UIButton) {
    let contentView = sender.superview
    guard let cell = contentView?.superview as? UITableViewCell else { return }
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    
    searchArray.remove(at: indexPath.row) // 검색한 텍스트 삭제
    UserDefaults.standard.set(searchArray, forKey: "SearchArray")
    tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
    tableView.reloadData()
  }
}

// MARK: - SearchResultsTableControllerDelegate

extension SearchController: SearchResultsTableControllerDelegate {
  func didTapUsercell(uid: String) {
    let controller = YouController(uid: uid)
    self.navigationController?.pushViewController(controller, animated: true)
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchArray.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath)
            as? SearchTableViewCell else { return UITableViewCell() }
    cell.backgroundColor = UIColor(named: "E5E5E5")
    cell.selectionStyle = .none
    cell.label.text = searchArray[indexPath.row]
    cell.xButton.addTarget(self, action: #selector(deleteCell), for: .touchUpInside) // x버튼 클릭 시 cell 삭제
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}

// MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate {
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    if let searchBarText = searchBar.text {
      if searchBarText != "" {
        searchArray.insert(searchBarText, at: 0)
        UserDefaults.standard.set(searchArray, forKey: "SearchArray") // 검색한 텍스트 저장
        tableView.reloadData()
      }
    }
  }
}
