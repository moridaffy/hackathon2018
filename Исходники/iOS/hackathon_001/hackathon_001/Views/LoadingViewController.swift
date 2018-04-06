//
//  LoadingViewController.swift
//  hackathon_001
//
//  Created by Максим Скрябин on 05.04.2018.
//  Copyright © 2018 mSkr. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Parse

//ViewController для загрузки актуального рейтинга с сервера (БД)
//После успешной загрузки данных приложение отправляет пользователя на основной экран - MainViewController
class LoadingViewController: UIViewController, NVActivityIndicatorViewable {
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.doServer()
        })
    }
    
    //Функция, занимающаяся "общением" с сервером
    //Настройки сервера прописаны в AppDelegate
    func doServer() {
        //Начало анимации (UIBlocker)
        startAnimating()
        
        //Начало "общения" с сервером. Если хоть одна из операций из блока do{} завершится неудачно, то приложение перейдет к блоку catch{}, который выведет сообщение об ошибке -> приложение не вылетит
        do {
            //Получение объектов с сервера и извлечение рейтинга из них
            let memberQuery = PFQuery(className: "damn")
            let memberObjects = try memberQuery.findObjects()
            
            //Добавление уже обработанного рейтинга (тип данных: Double) в массив рейтингов для последующего отображения в MainViewController
            for object in memberObjects {
                let tempRating = object.value(forKey: "rating") as! Double
                ratingList.append(tempRating)
            }
            
            //Отключение анимации загрузки (UIBlocker) и отправление пользователя на главный экран
            stopAnimating()
            self.performSegue(withIdentifier: "showApp", sender: nil)
        } catch let error as NSError {
            //Обрабокта возможных ошибок из блока do{} и отображение сообщения об ошибке
            stopAnimating()
            showAlertLock(title: "Ошибка!", text: "К сожалению, подключиться к серверу для загрузки данных не удалось. Проверьте Ваше соединение с интернетом и/или попробуйте позже.\nКод ошибки: \(error.code)")
        }
    }
}
