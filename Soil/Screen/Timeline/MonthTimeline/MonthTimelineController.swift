//
//  MonthTimelineController.swift
//  Soil
//
//  Created by dykoon on 2021/11/11.
//

import UIKit

final class MonthTimelineController: UIViewController {
  
  // MARK: - Properties
  
  private var dataSource: UICollectionViewDiffableDataSource<MonthTimelineSection, MonthTimelineItem>?
  
  private(set) var sectionList: [MonthTimelineSection] = [.bottomLoader]
  private var sectionItemsDict: [MonthTimelineSection: [MonthTimelineItem]] = [:]
  
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: setupCompositionalLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.register(TimelineCell.self, forCellWithReuseIdentifier: String(describing: TimelineCell.self))
    $0.register(
      TimelineLoaderCollectionViewCell.self,
      forCellWithReuseIdentifier: String(describing: TimelineLoaderCollectionViewCell.self)
    )
    $0.register(
      MonthTimelineSectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: String(describing: MonthTimelineSectionHeaderView.self)
    )
    $0.delegate = self
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .soilBackgroundColor
    configureUI()
    setupDiffableDataSource()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.fetchMonthList()
    }
  }
  
  // MARK: - Method
  
  private func configureUI() {
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.size.equalToSuperview()
    }
  }
  
  /// ViewModel로 이동예정
  private func setupDiffableDataSource() {
    dataSource = MonthTimelineSection.diffableDataSource(collectionView: collectionView)
    guard let dataSource = dataSource else { return }

    dataSource.supplementaryViewProvider = { [self] collectionView, kind, indexPath in
      guard kind == UICollectionView.elementKindSectionHeader else { return nil }
      guard let view = collectionView.dequeueReusableSupplementaryView(
         ofKind: kind,
         withReuseIdentifier: String(describing: MonthTimelineSectionHeaderView.self),
         for: indexPath
       ) as? MonthTimelineSectionHeaderView else { return nil }
      
      if case let .year(year) = self.sectionList[indexPath.section] {
        view.label.text = year
      }
      
      return view
    }
    
    var snapshot = NSDiffableDataSourceSnapshot<MonthTimelineSection, MonthTimelineItem>()
    snapshot.appendSections([.bottomLoader])
    snapshot.appendItems([.bottomLoader])

    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  /// ViewModel로 이동예정
  private func fetchMonthList() {
    guard let dataSource = dataSource else { return }

    // API 통신 코드 추가 예정
    let currentDate = Date()
    let fetching: [Date] = [
      Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!,
      Calendar.current.date(byAdding: .month, value: -13, to: currentDate)!,
      Calendar.current.date(byAdding: .month, value: -2, to: currentDate)!,
      Calendar.current.date(byAdding: .month, value: -14, to: currentDate)!,
      Calendar.current.date(byAdding: .month, value: -5, to: currentDate)!,
      Calendar.current.date(byAdding: .month, value: -4, to: currentDate)!,
      Calendar.current.date(byAdding: .month, value: -22, to: currentDate)!
    ]
    
    fetching
      .sorted { $0 > $1 }
      .forEach {
        // year 중복 체크
        if sectionList.contains(.year(record: $0.formatted(.iso8601.year()))) == false {
          sectionList.append(.year(record: $0.formatted(.iso8601.year())))
          sectionItemsDict[.year(record: $0.formatted(.iso8601.year()))] = [.month(record: $0)]
        } else {
          sectionItemsDict[.year(record: $0.formatted(.iso8601.year()))]?.append(.month(record: $0))
        }
      }
    
    var snapshot = NSDiffableDataSourceSnapshot<MonthTimelineSection, MonthTimelineItem>()
    snapshot.appendSections(sectionList)
  
    for key in sectionItemsDict.keys {
      snapshot.appendItems(sectionItemsDict[key]!, toSection: key)
    }

    dataSource.apply(snapshot, animatingDifferences: true)
  }
}

// MARK: - UICollectionViewDelegate

extension MonthTimelineController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(1)
  }
}
