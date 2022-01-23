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
    
  }
     
}
