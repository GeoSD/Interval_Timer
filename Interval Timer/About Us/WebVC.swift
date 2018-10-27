//
//  WebVC.swift
//  Eateries
//
//  Created by Алексей Пархоменко on 17/10/2018.
//  Copyright © 2018 Алексей Пархоменко. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var url: URL!
    var progressView: UIProgressView!
    
    
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView // заменили наш view на webVC
        // чтобы загрузить какую либо страницу нам нужен запрос или request
        let request = URLRequest(url: url)
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true // чтобы юзер мог ходить по страничкам т.е. при помощи жестов смахивать историю
        
        // сделаем progressView чтобы мы видели прогресс загрузки нашего сайта
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit() // чтобы progressView занимал предоставленное ему место
        
        // размещаем progressButton вместо одной из кнопок нашего tabBar
        // кнопка отвечающая за обновление экрана
        let progressButton = UIBarButtonItem(customView: progressView)
        
        // позволяет раскидывать элементы до тех пор пока это позволяет рамки
        // двигает все на сколько это возможно
        let flexibleSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // кнопка обновляет наш target: webView
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        // добавим наши кнопки в один массив
        toolbarItems = [progressButton, flexibleSpacer, refreshButton]
        navigationController?.isToolbarHidden = false
        
        // чтобы была возможность отслеживать процесс загрузки добавим обзервер или наблюдатель за свойсвом
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // что делать когда у нас происходит наблюдение?
        // если путь для отслеживания свойсва равен estimatedProgress то му говорим что свойство progressView которое меняется от
        // 0 до 1 присвоить значение webView.estimatedProgress, причем webView.estimatedProgress меняется от 0 до 1 тоже
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
        
    }
    
    // после того как страничка загрузилась сверху отбразим title webView
    // не работает
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
}
