//
//  YearTimelineController+CompositionalLayout.swift
//  Soil
//
//  Created by dykoon on 2022/05/04.
//

import UIKit

extension YearTimelineController {
  func setupCompositionalLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { [weak self] _, _ in
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
        heightDimension: .absolute(65)
      )
      let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: sectionHeaderSize,
          elementKind: UICollectionView.elementKindSectionHeader, alignment: .top
      )
      
      // 처음 로딩일 때는 sectionHeader가 없는 상태로 Loading Cell 보여줌
      if self?.loaderMode == false {
        section.boundarySupplementaryItems = [sectionHeader]
      }
      
      section.contentInsets = .init(top: 0, leading: 13, bottom: 0, trailing: 13)
      
      return section
    }
    return layout
  }
}
