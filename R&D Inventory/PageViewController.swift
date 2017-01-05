//
//  PageViewController.swift
//  R&D Inventory
//
//  Created by Aaron Liberatore on 1/4/17.
//  Copyright © 2017 Aaron Liberatore. All rights reserved.
//

import UIKit

class MyPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    
    var project: Project!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        guard let page1 = UIStoryboard(name: "Assemblies", bundle: nil).instantiateViewController(withIdentifier: "AssemblyTableViewController") as? AssemblyTableViewController else {
            return
        }
        guard let page2 = UIStoryboard(name: "Builds", bundle: nil).instantiateViewController(withIdentifier: "BuildTableViewController") as? BuildTableViewController else {
            return
        }
        guard let page3 = UIStoryboard(name: "Inventory", bundle: nil).instantiateViewController(withIdentifier: "InventoryTableViewController") as? InventoryTableViewController else {
            return
        }
        
        page1.project = project
        page2.project = project
        page3.project = project

        pages.append(page1)
        pages.append(page2)
        pages.append(page3)

        setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        self.edgesForExtendedLayout = []
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
