//
//  MonthTimelineSection.swift
//  Soil
//
//  Created by dykoon on 2022/05/02.
//

import UIKit

enum MonthTimelineSection: Hashable {
  case bottomLoader
  case year(record: String)
}

extension MonthTimelineSection {
  static func diffableDataSource(
    collectionView: UICollectionView
  ) -> UICollectionViewDiffableDataSource<MonthTimelineSection, MonthTimelineItem> {
    return UICollectionViewDiffableDataSource<MonthTimelineSection, MonthTimelineItem>(
      collectionView: collectionView,
      cellProvider: { collectionView, indexPath, item in
        switch item {
        case .month(let record):
          guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: TimelineCell.self), for: indexPath
          ) as? TimelineCell else { return UICollectionViewCell() }
          
          if #available(iOS 15.0, *) {
            cell.titleLabel.text = record.formatted(.dateTime.month(.wide).locale(Locale(identifier: "en_US"))).lowercased()
          }
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
