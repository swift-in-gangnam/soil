//
//  SearchResultsTableController.swift
//  Soil
//
//  Created by dykoon on 2022/01/25.
//

import UIKit

protocol SearchResultsTableControllerDelegate: AnyObject {
  func didTapUsercell(uid: String)
}

class SearchResultsTableController: UIViewController {
  
  // MARK: - Value Types
  
  typealias UserDataSource = UITableViewDiffableDataSource<Int, UserCellModel>
  typealias UserSnapshot = NSDiffableDataSourceSnapshot<Int, UserCellModel>
  typealias TagDataSource = UITableViewDiffableDataSource<Int, TagCellModel>
  typealias TagSnapshot = NSDiffableDataSourceSnapshot<Int, TagCellModel>

  // MARK: - Properties
  
  private let userTableView = UITableView().then {
    $0.rowHeight = 64
    $0.backgroundColor = .clear
  }
  
  private let tagTableView = UITableView().then {
    $0.rowHeight = 64
    $0.backgroundColor = .clear
  }
  
  private let containerView = UIView().then {
    $0.backgroundColor = .soilBackgroundColor
  }
  
  private var searchUserView = UIView().then {
    $0.backgroundColor = .clear
  }
  
  private var searchTagView = UIView().then {
    $0.backgroundColor = .clear
  }
  private var searchSegmentedControl = UISegmentedControl()
  weak var delegate: SearchResultsTableControllerDelegate?
  
  private let userCellIdentifier = "UserCell"
  private let tagCellIdentifier = "TagCell"
  
  private lazy var userDataSource = setupUserDataSource()
  private var userList = [UserCellModel]()
  private lazy var tagDataSource = setupTagDataSource()
  private var tagList = [TagCellModel]()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .soilBackgroundColor
    
    setSegmentedControl()
    setConstraint()
    applyTagSnapshot()
  }
  
  // MARK: - Method
  
  private func setSegmentedControl() {
    let items = ["People", "Tag"]
    searchSegmentedControl = UISegmentedControl(items: items)
    searchSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    searchSegmentedControl.backgroundColor = .systemGray5
    searchSegmentedControl.tintColor = .white
    searchSegmentedControl.selectedSegmentIndex = 0
  }
  
  private func setConstraint() {
    view.addSubview(searchSegmentedControl)
    searchSegmentedControl.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
      make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(15)
      make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-15)
      make.height.equalTo(30)
    }
    
    view.addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.top.equalTo(searchSegmentedControl.snp.bottom).offset(10)
      make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
      make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
    
    containerView.addSubview(searchTagView)
    searchTagView.snp.makeConstraints { make in
      make.top.equalTo(containerView.snp.top)
      make.leading.equalTo(containerView.snp.leading)
      make.trailing.equalTo(containerView.snp.trailing)
      make.bottom.equalTo(containerView.snp.bottom)
    }
    
    containerView.addSubview(searchUserView)
    searchUserView.snp.makeConstraints { make in
      make.top.equalTo(containerView.snp.top)
      make.leading.equalTo(containerView.snp.leading)
      make.trailing.equalTo(containerView.snp.trailing)
      make.bottom.equalTo(containerView.snp.bottom)
    }
    
    searchUserView.addSubview(userTableView)
    userTableView.snp.makeConstraints { make in
      make.top.equalTo(searchUserView.snp.top)
      make.leading.equalTo(searchUserView.snp.leading)
      make.trailing.equalTo(searchUserView.snp.trailing)
      make.bottom.equalTo(searchUserView.snp.bottom)
    }
    
    searchTagView.addSubview(tagTableView)
    tagTableView.snp.makeConstraints { make in
      make.top.equalTo(searchTagView.snp.top)
      make.leading.equalTo(searchTagView.snp.leading)
      make.trailing.equalTo(searchTagView.snp.trailing)
      make.bottom.equalTo(searchTagView.snp.bottom)
    }
    
    searchUserView.alpha = 1.0
    searchTagView.alpha = 0.0
  }
  
  @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0 :
      searchTagView.alpha = 0.0
      searchUserView.alpha = 1.0
    default:
      searchUserView.alpha = 0.0
      searchTagView.alpha = 1.0
    }
  }
  
  private func setupUserDataSource() -> UserDataSource {
    userTableView.delegate = self
    userTableView.register(UserCell.self, forCellReuseIdentifier: userCellIdentifier)
    userDataSource = UserDataSource(
      tableView: userTableView,
      cellProvider: { tableView, indexPath, userCell in
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: self.userCellIdentifier,
          for: indexPath
        ) as? UserCell else { return UITableViewCell() }

        cell.viewModel = UserCellViewModel(userCell: userCell)

        return cell
    })
    return userDataSource
  }
  
  private func setupTagDataSource() -> TagDataSource {
    tagTableView.delegate = self
    tagTableView.register(TagCell.self, forCellReuseIdentifier: tagCellIdentifier)
    tagDataSource = TagDataSource(
      tableView: tagTableView,
      cellProvider: { tableView, indexPath, _ in
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: self.tagCellIdentifier,
          for: indexPath
        ) as? TagCell else { return UITableViewCell() }

        cell.tagLabel.text = self.tagList[indexPath.row].tagName
        cell.tagCountLabel.text = String(self.tagList[indexPath.row].tagCnt)

        return cell
    })
    return tagDataSource
  }
  
  private func applyUserSnapshot() {
    var snapshot = UserSnapshot()
    snapshot.appendSections([0])
    snapshot.appendItems(userList)
    userDataSource.apply(snapshot, animatingDifferences: false)
  }
  
  private func applyTagSnapshot() {
    var snapshot = TagSnapshot()
    snapshot.appendSections([0])
    snapshot.appendItems(tagList)
    tagDataSource.apply(snapshot, animatingDifferences: false)
  }
  
}

// MARK: - UISearchResultsUpdating
  
extension SearchResultsTableController: UISearchResultsUpdating { 
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text?.lowercased() else { return }
    if !text.isEmpty {
       let userRequest = SearchRequest(query: text, type: "user")
       
       SearchService.searchUser(request: userRequest) { response in
         guard let userList = response.value?.data else { return }
         self.userList = userList
         self.applyUserSnapshot()
       }
      let tagRequest = SearchRequest(query: text, type: "tag")
      
      SearchService.searchTag(request: tagRequest) { response in
        guard let tagList = response.value?.data else { return }
        self.tagList = tagList
        self.applyTagSnapshot()
      }
    }
  }
}

// MARK: - UITableView

extension SearchResultsTableController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    self.delegate?.didTapUsercell(uid: userList[indexPath.row].uid)
  }
}
