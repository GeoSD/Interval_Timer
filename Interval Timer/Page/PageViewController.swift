//
//  PageViewController.swift
//  Eateries
//
//  Created by Алексей Пархоменко on 16/10/2018.
//  Copyright © 2018 Алексей Пархоменко. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var headersArray = ["Тренируйся","Начни"]
    var subheadersArray = ["Создавай тренировки, занимайся, отслеживай результаты", "Ты можешь покорить любую вершину и достичь невероятных спортивных успехов"]
    var imagesArray = ["sport","sport3"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        if let firstVC = displayVC(atIndex: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    //  Для того чтобы понять какой VC нам нужно подгрузить нам нужно использовать метод
    // проверяем какой индекс нам передается
    func displayVC(atIndex index: Int) -> ContentViewController? {
        guard index >= 0 else { return nil }
        guard index < headersArray.count else { return nil }
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController else { return nil }
        contentVC.imageFile = imagesArray[index]
        contentVC.header = headersArray[index]
        contentVC.subheader = subheadersArray[index]
        contentVC.index = index
        return contentVC
        
    }
    func nextVC(atIndex index: Int) {
        //  пробуем получить VC
        if let contentVC = displayVC(atIndex: index + 1) {
            setViewControllers([contentVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

// так как PageVC  позволяет нам перемещаться между VC то нужно подписаться под протокол
extension PageViewController: UIPageViewControllerDataSource {
    // чтобы VC знал откуда ему брать информацию
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index -= 1
        // отоброжаем тот VC чей index мы получили
        return displayVC(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index += 1
        // отоброжаем тот VC чей index мы получили
        return displayVC(atIndex: index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return headersArray.count
    }
    
}
