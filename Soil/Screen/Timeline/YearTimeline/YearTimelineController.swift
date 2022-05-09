//
//  YearTimelineController.swift
//  Soil
//
//  Created by dykoon on 2022/05/04.
//

import UIKit

final class YearTimelineController: UIViewController {

  // MARK: - Properties
  
  private var dataSource: UICollectionViewDiffableDataSource<YearTimelineSection, YearTimelineItem>?
  
  private(set) var loaderMode: Bool = true
  private var itemList: [YearTimelineItem] = []
  
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: setupCompositionalLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.register(
      TimelineSectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: String(describing: TimelineSectionHeaderView.self)
    )
    $0.register(TimelineCell.self, forCellWithReuseIdentifier: String(describing: TimelineCell.self))
    $0.register(
      TimelineLoaderCollectionViewCell.self,
      forCellWithReuseIdentifier: String(describing: TimelineLoaderCollectionViewCell.self)
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
      self.fetchYearList()
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
  
  private func setupDiffableDataSource() {
    dataSource = YearTimelineSection.diffableDataSource(collectionView: collectionView)
    guard let dataSource = dataSource else { return }
    
    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
      guard kind == UICollectionView.elementKindSectionHeader else { return nil }
      
      guard let view = collectionView.dequeueReusableSupplementaryView(
         ofKind: kind,
         withReuseIdentifier: String(describing: TimelineSectionHeaderView.self),
         for: indexPath
      ) as? TimelineSectionHeaderView else { return nil }
      
      return view
    }
    
    var snapshot = NSDiffableDataSourceSnapshot<YearTimelineSection, YearTimelineItem>()
    snapshot.appendSections([.loader])
    snapshot.appendItems([.bottomLoader])
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  private func fetchYearList() {
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
      Calendar.current.date(byAdding: .month, value: -22, to: currentDate)!,
      Calendar.current.date(byAdding: .year, value: -4, to: currentDate)!,
      Calendar.current.date(byAdding: .year, value: -6, to: currentDate)!
    ]
    
    fetching
      .sorted { $0 > $1 }  // 연도 내림차순 정렬
      .forEach {
        // year 중복 체크
        if itemList.contains(.year(record: $0.formatted(.iso8601.year()))) == false {
          itemList.append(.year(record: $0.formatted(.iso8601.year())))
        }
      }
    
    self.loaderMode = false
    
    var snapshot = NSDiffableDataSourceSnapshot<YearTimelineSection, YearTimelineItem>()
    snapshot.appendSections([.main])
    snapshot.appendItems(itemList)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}

// MARK: - UICollectionViewDelegate

extension YearTimelineController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(2)
  }
}
