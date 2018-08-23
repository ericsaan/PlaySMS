//
//  PDFPageViewController.swift
//  PlaySMS
//
//  Created by Eric Sullivan on 1/14/17.
//  Copyright © 2017 Sully. All rights reserved.
//

import UIKit

class PDFPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    //variable that can store result of functions
    private (set) lazy var myViewControllers : [UIViewController] =
        {
            return            [
                self.myViewConrollersFunc("ViewController_PDFViewController"),
                self.myViewConrollersFunc("PDFAfternoon"),
            ]
    }()
    
        
        
    override func viewDidLoad() {
        super.viewDidLoad()

        //let us access data source protocols
        self.dataSource = self
        
        //setting initial view controller of pageviewctonroller
        if let initialViewController = myViewControllers.first
        {
            self.setViewControllers([initialViewController], direction: .forward, animated: true, completion: nil)
        }
        
     
        
        
        //custom dots
        let dots = UIPageControl.appearance()
        dots.pageIndicatorTintColor = .blue
        dots.currentPageIndicatorTintColor = .green
        dots.backgroundColor = UIColor.groupTableViewBackground
        //dots.backgroundColor = .white
        
    }

    
    
    private func myViewConrollersFunc (_ identifier : String ) -> UIViewController
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    //returns previous view controller (i.e., morning or nothing) from current or shown view controller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        //get index of current view controller
        guard let index = myViewControllers.index(of: viewController) else
        {
            return nil
        }
        
        // get index of previous
        let previousIndex = index - 1
        
        //avoiding crashes
        guard previousIndex >= 0 else
        {
            //return myViewControllers.last   //commented out so as to add dots
            return nil
        }
        
        guard myViewControllers.count  > previousIndex else
        {
            return nil
        }
        
        return myViewControllers[previousIndex]
    }
 
    //return next view controller from current or shown viewcontroller
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        //get index of current view controller
        guard let index = myViewControllers.index(of: viewController) else
        {
            return nil
        }
        
        //get index of next view controller
        let nextIndex = index + 1
        
        guard myViewControllers.count != nextIndex else
        {
            //return myViewControllers.first  //commented out so as to handle dots
            return nil
        }
        
         guard myViewControllers.count > nextIndex else
         {
          return myViewControllers.last
          }
        
        return myViewControllers[nextIndex]
        
        
    }

    //total dots
    func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return myViewControllers.count
    }
    
    //current highlighted dot
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        //get index of view controller
        guard let firstViewController = viewControllers?.first , let current = myViewControllers.index(of: firstViewController) else
        {
            return 0
        }
        return current
    }
    
    
}





