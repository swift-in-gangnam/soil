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
  private var userList = [UserCellModel]()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .soilBackgroundColor
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
    snapshot.appendItems(userList)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

// MARK: - UITableView

extension SearchResultsTableController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    self.delegate?.didTapUsercell(uid: userList[indexPath.row].uid)
  }
  
}

// MARK: - UISearchResultsUpdating
  
extension SearchResultsTableController: UISearchResultsUpdating { 
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text?.lowercased() else { return }
    
    if !text.isEmpty {
      let request = SearchRequest(query: text, type: "user")
      
      SearchService.search(request: request) { response in
        guard let userList = response.value?.data else { return }
        self.userList = userList
        self.applySnapshot()
      }
    }
  }
}
