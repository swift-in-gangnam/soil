//
//  UserStatController.swift
//  Soil
//
//  Created by dykoon on 2021/11/14.
//

import UIKit

private let reuseIdentifier = "UserCell"

final class UserStatController: UITableViewController, UISearchControllerDelegate {

  // MARK: - Value Types
  
  typealias DataSource = UITableViewDiffableDataSource<Int, UserCellModel>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Int, UserCellModel>
  
  // MARK: - Properties
  
  private let uid: String
  private let isFollowingsMode: Bool
  private lazy var dataSource = setupDataSource()
  private var userList = [
    UserCellModel(
      uid: "ONhMtxPDPgYh06dpTPrLxk5FWpS2",
      name: "Admin",
      nickname: "admin",
      profileImageURL: "https://soil-bucket.s3.ap-northeast-2.amazonaws.com/7c6ee948-ce49-4228-a995-9b8bc026df2e.jpeg"
    ),
    UserCellModel(uid: "2", name: "권동영", nickname: "d_oooong", profileImageURL: "A"),
    UserCellModel(uid: "3", name: "권동영", nickname: "d_oooong", profileImageURL: "A")
  ]
  
  private lazy var searchController = UISearchController(searchResultsController: nil).then {
    $0.searchBar.placeholder = "검색"
    $0.hidesNavigationBarDuringPresentation = false
    $0.searchResultsUpdater = self
  }
  
  // MARK: - Lifecycle
  
  init(uid: String, isFollowingsMode: Bool) {
    self.uid = uid
    self.isFollowingsMode = isFollowingsMode
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .soilBackgroundColor
    setupNavigationController()
    self.performQuery(with: nil)
  }
  
  // MARK: - Method

  private func setupNavigationController() {
    self.navigationController?.navigationBar.topItem?.title = ""
    self.navigationItem.title = self.isFollowingsMode ? "followings" : "follower"
    self.navigationItem.largeTitleDisplayMode = .always
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.hidesSearchBarWhenScrolling = false
    self.navigationItem.searchController = self.searchController
  }
    
  private func setupDataSource() -> DataSource {
    tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
    tableView.rowHeight = 64
    
    dataSource = DataSource(
      tableView: tableView,
      cellProvider: { tableView, indexPath, userCell in
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: reuseIdentifier,
          for: indexPath
        ) as? UserCell else { return UITableViewCell() }
        
        cell.viewModel = UserCellViewModel(userCell: userCell)
        
        return cell
    })
    return dataSource
  }
    
  private func performQuery(with filter: String?) {
    let filtered = self.userList.filter {
      $0.nickname.hasPrefix(filter ?? "") ||
      $0.name?.hasPrefix(filter ?? "") ?? false
    }
    
    var snapshot = Snapshot()
    snapshot.appendSections([0])
    snapshot.appendItems(filtered)
    self.dataSource.apply(snapshot, animatingDifferences: true)
  }
  
}

// MARK: - UITableViewDataSource

extension UserStatController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let controller = YouController(uid: userList[indexPath.row].uid)
    self.navigationController?.pushViewController(controller, animated: true)
  }
}

// MARK: - UISearchResultsUpdating

extension UserStatController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text?.lowercased() else { return }
    self.performQuery(with: text)
  }
}
