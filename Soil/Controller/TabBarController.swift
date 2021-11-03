//
//  TabBarController.swift
//  Soil
//
//  Created by Jinyoung Kim on 2021/11/02.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurController()
        configureTabBar()
    }
    
    // MARK: - Helpers
    private func configurController() {
        view.backgroundColor = .white
        delegate = self
    }
    
    private func configureTabBar() {
        tabBar.tintColor = .black
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.isTranslucent = false
        tabBarAppearance.barTintColor = UIColor.soilBackgroundColor
        tabBarAppearance.backgroundColor = UIColor.soilBackgroundColor
        
        let feedNavController = initVC(ofType: FeedController.self,
                                       title: "feed",
                                       tabBarFont: UIFont.montserrat(size: 25, family: .medium),
                                       navBarFont: UIFont.montserrat(size: 25, family: .bold))

        let dummyVC = NewPostController()
        dummyVC.tabBarItem.image = UIImage(named: "PlusButton")!.withRenderingMode(.alwaysOriginal)
        dummyVC.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
        let youNavController = initVC(ofType: YouController.self,
                                      title: "you",
                                      tabBarFont: UIFont.montserrat(size: 25, family: .medium),
                                      navBarFont: UIFont.montserrat(size: 25, family: .bold))
        
        viewControllers = [feedNavController, dummyVC, youNavController]
    }
    
    private func initVC<T: UIViewController>(ofType: T.Type,title: String, tabBarFont: UIFont, navBarFont: UIFont) -> UINavigationController {
        let vc = T.init()
        vc.navigationItem.title = title
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.title = title
        navController.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: tabBarFont], for: .normal)
        navController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -14)
        // Navigation Bar의 모습을 iOS 15 이전 처럼 하기 위해 추가.
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.soilBackgroundColor
        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
        // backbutton 색깔 .black으로 설정.
        navController.navigationBar.tintColor = UIColor.black
        // largeTitles 켜기.
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: navBarFont]
        return navController
    }
}

// MARK: - UITabBarController Delegate
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let isModalView = viewController is NewPostController
        
        if isModalView {
            let vc = NewPostController()
            self.present(vc, animated: true, completion: nil)
            return false
        }
        
        return true
    }
}

