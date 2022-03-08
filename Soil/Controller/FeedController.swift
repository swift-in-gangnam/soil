//
//  FeedController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/03.
//

import UIKit

class FeedController: UIViewController {
  
  // MARK: - Properties
  
  private lazy var searchBarButtonItem = UIBarButtonItem(
    image: UIImage(systemName: "magnifyingglass"),
    style: .plain,
    target: self,
    action: #selector(goToSearchController)
  )
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
  
  // MARK: - Actions
  
  @objc func goToSearchController() {
    let controller = SearchController()
    navigationController?.pushViewController(controller, animated: true)
  }
  
  // MARK: - Helpers
  
  private func configure() {
    view.backgroundColor = .soilBackgroundColor
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.largeTitleTextAttributes = [
      .font: UIFont.montserrat(size: 35, family: .bold)
    ]
    navigationItem.title = "feed"

    navigationItem.rightBarButtonItem = searchBarButtonItem
    
  }
    
}
