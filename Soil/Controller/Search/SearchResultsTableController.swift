//
//  SearchResultsTableController.swift
//  Soil
//
//  Created by dykoon on 2022/01/25.
//

import UIKit

private let reuseIdentifier = "UserCell"

protocol SearchResultsTableControllerDelegate: AnyObject {
  func didTapUsercell(uid: String)
}

class SearchResultsTableController: UITableViewController {

  // MARK: - Value Types
  
  typealias DataSource = UITableViewDiffableDataSource<Int, UserCellModel>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Int, UserCellModel>
  
  // MARK: - Properties
  
  weak var delegate: SearchResultsTableControllerDelegate?
  private lazy var dataSource = setupDataSource()
  
  private var users = [
    UserCellModel(
      uid: "yGzTdu9xuhbmMGAnT2Y8NCLarHD3",
      name: "권동영",
      nickname: "d_oooong",
      profileImageURL: "https://soil-bucket.s3.ap-northeast-2.amazonaws.com/2287d308-fabc-44bc-8a92-8ce65b65b28e.jpeg"
    ),
    UserCellModel(
      uid: "4gPR3ets2XNwPvIvbmw9tCOEIxq1",
      name: "admin",
      nickname: "admin",
      profileImageURL: "https://soil-bucket.s3.ap-northeast-2.amazonaws.com/2287d308-fabc-44bc-8a92-8ce65b65b28e.jpeg"
    ),
    UserCellModel(
      uid: "x3DRICUgxzOYwmLrz9JCC52xqTr2",
      name: "admin2",
      nickname: "admin2",
      profileImageURL: "https://soil-bucket.s3.ap-northeast-2.amazonaws.com/2287d308-fabc-44bc-8a92-8ce65b65b28e.jpeg"
    )
  ]
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .soilBackgroundColor
    applySnapshot()
  }
  
  // MARK: - Method
  
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
  
  private func applySnapshot() {
    var snapshot = Snapshot()
    snapshot.appendSections([0])
    snapshot.appendItems(users)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}

// MARK: - UITableView

extension SearchResultsTableController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    self.delegate?.didTapUsercell(uid: users[indexPath.row].uid)
  }
  
}

// MARK: - UISearchResultsUpdating
  
extension SearchResultsTableController: UISearchResultsUpdating { 
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text?.lowercased() else { return }
    print(text)
//    let request = SearchRequest(query: text, type: "user")
    
//    SearchService.search(request: request) { response in
//      debugPrint(response)
//    }
    
//    AFManager
//      .shared
//      .session
//      .request(SearchRouter.search(request))
//      .validate(statusCode: 200..<401)
//      .validate(contentType: ["application/json"])
//      .responseJSON { response in
//        debugPrint(response)
//      }
  }
}
