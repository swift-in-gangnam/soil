//
//  SearchResultsTableController.swift
//  Soil
//
//  Created by dykoon on 2022/01/25.
//

import UIKit

enum Section {
  case user
}

private let reuseIdentifier = "UserCell"

class SearchResultsTableController: UITableViewController {

  // MARK: - Properties
  
  private var users = [
    User(
      name: "권동영",
      nickname: "d_oooong",
      bio: "test",
      profileImageURL: "https://soil-bucket.s3.ap-northeast-2.amazonaws.com/2287d308-fabc-44bc-8a92-8ce65b65b28e.jpeg",
      followers: 0,
      following: 0
    ),
    User(
      name: "admin",
      nickname: "admin2",
      bio: "test",
      profileImageURL: "https://soil-bucket.s3.ap-northeast-2.amazonaws.com/2287d308-fabc-44bc-8a92-8ce65b65b28e.jpeg",
      followers: 0,
      following: 0
    ),
    User(
      name: "admin",
      nickname: "admin2",
      bio: "test",
      profileImageURL: "https://soil-bucket.s3.ap-northeast-2.amazonaws.com/2287d308-fabc-44bc-8a92-8ce65b65b28e.jpeg",
      followers: 0,
      following: 0
    )
  ]
  
  var dataSource: UITableViewDiffableDataSource<Section, User>!
  var snapshot: NSDiffableDataSourceSnapshot<Section, User>!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .soilBackgroundColor
    
    tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
    tableView.rowHeight = 64
    
    dataSource = UITableViewDiffableDataSource<Section, User>(tableView: tableView) { tableView, indexPath, _ in
      tableView.deselectRow(at: indexPath, animated: true)
        
      let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
      let user = self.users[indexPath.row]
      cell.viewModel = UserCellViewModel(user: user)
      return cell
    }
    
    snapshot = NSDiffableDataSourceSnapshot<Section, User>() // 현재 스냅샷 만들기
    snapshot.appendSections([.user])  // 섹션 추가
    snapshot.appendItems(users, toSection: .user) // 방금 추가한 섹션에 아이템을 넣기
    
    dataSource.apply(snapshot, animatingDifferences: true)  // 현재 스냅샷을 화면에 보여준다.
  }
  
}

// MARK: - UISearchResultsUpdating
  
extension SearchResultsTableController: UISearchResultsUpdating { 
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text?.lowercased() else { return }
    print(text, type(of: text))
  }
}
