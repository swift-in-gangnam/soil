//
//  YearTimelineSection.swift
//  Soil
//
//  Created by dykoon on 2022/05/04.
//

import UIKit

enum YearTimelineSection: Hashable {
  case main
}

extension YearTimelineSection {
  static func diffableDataSource(
    collectionView: UICollectionView
  ) -> UICollectionViewDiffableDataSource<YearTimelineSection, YearTimelineItem> {
    return UICollectionViewDiffableDataSource<YearTimelineSection, YearTimelineItem>(
      collectionView: collectionView,
      cellProvider: { collectionView, indexPath, item in
        switch item {
        case .year(let record):
          guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: TimelineCell.self), for: indexPath
          ) as? TimelineCell else { return UICollectionViewCell() }
          
          cell.titleLabel.text = record
          
          return cell
        case .bottomLoader:
          guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: TimelineLoaderCollectionViewCell.self), for: indexPath
          ) as? TimelineLoaderCollectionViewCell else { return UICollectionViewCell() }
          cell.startAnimating()
          return cell
        }
      }
    )
  }
}
