//
//  MonthTimelineController+CompositionalLayout.swift
//  Soil
//
//  Created by dykoon on 2022/05/03.
//

import UIKit

extension MonthTimelineController {
  func setupCompositionalLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(70+16)
      )
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 0)
      
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(70+16)
      )
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
      
      let section = NSCollectionLayoutSection(group: group)
      
      let sectionHeaderSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(45)
      )
      let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: sectionHeaderSize,
          elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
      )
      
      if case .year = self.sectionList[sectionIndex] {
        section.boundarySupplementaryItems = [sectionHeader]
      }
      
      section.contentInsets = .init(top: 0, leading: 13, bottom: 20, trailing: 13)
      
      return section
    }
    return layout
  }
}
