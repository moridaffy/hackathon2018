//
//  MainViewController.swift
//  hackathon_001
//
//  Created by Максим Скрябин on 05.04.2018.
//  Copyright © 2018 mSkr. All rights reserved.
//

import UIKit
import Cosmos
import NVActivityIndicatorView
import Parse

class MainViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var facultyLbl: UILabel!
    @IBOutlet weak var groupLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var userpic: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var dBtnOut: UIButton!
    @IBOutlet weak var aBtnOut: UIButton!
    @IBOutlet weak var mBtnOut: UIButton!
    @IBOutlet weak var nBtnOut: UIButton!
    @IBOutlet weak var selector: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    
    //Функция, обрабатывающая нажатия на кнопки (D, A, M и N)
    @IBAction func contentSwitched(_ sender: UIButton) {
        //Установка малой прозрачности всех кнопок (сброс состояния)
        dBtnOut.alpha = 0.5
        aBtnOut.alpha = 0.5
        mBtnOut.alpha = 0.5
        nBtnOut.alpha = 0.5
        
        //Определение ID выбранного участника команды
        switch sender {
        case dBtnOut:
            selectedMember = 0
        case aBtnOut:
            selectedMember = 1
        case mBtnOut:
            selectedMember = 2
        case nBtnOut:
            selectedMember = 3
        default:
            print("error")
        }
        
        //Анимация: передвижение стрелочки и установка стандартной прозрачности выбранной кнопки (sender)
        UIView.animate(withDuration: 0.3, animations: {
            self.updateContent()
            sender.alpha = 1.0
            self.selector.frame.origin.x = sender.frame.minX
        })
    }

    //Вспомогательная переменная, хранящая ID выбранного участника команды
    var selectedMember: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateContent()
        
        //Настройка элемента рейтинга (указание функции, которая должна выполнятсья при изменении рейтинга)
        ratingView.didFinishTouchingCosmos = { rating in
            self.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.doServer(rating: rating)
            })
        }
        
        //Настройка расположения элементов (размеры и координаты)
        dBtnOut.frame.size.width = 50.0
        dBtnOut.frame.size.height = 50.0
        dBtnOut.frame.origin.x = 20.0
        dBtnOut.frame.origin.y = UIApplication.shared.statusBarFrame.maxY + 16.0
        
        aBtnOut.frame.size.width = 50.0
        aBtnOut.frame.size.height = 50.0
        aBtnOut.frame.origin.x = dBtnOut.frame.maxX + (UIScreen.main.bounds.width - 40.0 - 100.0 - 100.0) / 3
        aBtnOut.frame.origin.y = UIApplication.shared.statusBarFrame.maxY + 16.0
        
        mBtnOut.frame.size.width = 50.0
        mBtnOut.frame.size.height = 50.0
        mBtnOut.frame.origin.x = aBtnOut.frame.maxX + (UIScreen.main.bounds.width - 40.0 - 100.0 - 100.0) / 3
        mBtnOut.frame.origin.y = UIApplication.shared.statusBarFrame.maxY + 16.0
        
        nBtnOut.frame.size.width = 50.0
        nBtnOut.frame.size.height = 50.0
        nBtnOut.frame.origin.x = UIScreen.main.bounds.width - 20.0 - 50.0
        nBtnOut.frame.origin.y = UIApplication.shared.statusBarFrame.maxY + 16.0
        
        selector.frame.size.width = 50.0
        selector.frame.size.height = 25.5
        selector.frame.origin.x = dBtnOut.frame.minX
        selector.frame.origin.y = nameLbl.frame.minY - 15.5
        
        //Настройка стиля элементов (прозрачность, закругленные углы, цвета)
        aBtnOut.alpha = 0.5
        mBtnOut.alpha = 0.5
        nBtnOut.alpha = 0.5
        dBtnOut.layer.cornerRadius = 25.0
        aBtnOut.layer.cornerRadius = 25.0
        mBtnOut.layer.cornerRadius = 25.0
        nBtnOut.layer.cornerRadius = 25.0
        nameLbl.layer.cornerRadius = 10.0
        nameLbl.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10.0
        userpic.layer.cornerRadius = 10.0
        userpic.layer.masksToBounds = true
        ratingView.settings.fillMode = .half
        ratingView.settings.emptyColor = UIColor.clear
        ratingView.settings.filledColor = UIColor.lightGray
        ratingView.settings.filledBorderColor = UIColor.clear
        ratingView.settings.emptyBorderColor = UIColor.lightGray
        ratingView.settings.emptyBorderWidth = 1.0
    }
    
    //Функция, обновляющая рейтинг участника команды на сервере
    func doServer(rating: Double) {
        //Начало "общения" с сервером. Если хоть одна из операций из блока do{} завершится неудачно, то приложение перейдет к блоку catch{}, который выведет сообщение об ошибке -> приложение не вылетит
        do {
            //Получение необходимого объекта с сервера
            let usernameID = selectedMember + 1
            let memberQuery = PFQuery(className: "damn")
            memberQuery.whereKey("username_id", equalTo: usernameID)
            let object = try memberQuery.getFirstObject()
            
            //Обновление рейтинга в объекте и его сохранение на сервере
            object.setValue(rating, forKey: "rating")
            try object.save()
            
            //Изменение рейтинга в массиве рейтингов и отключение анимации загрузки (UIBlocker)
            ratingList[selectedMember] = rating
            stopAnimating()
        } catch let error as NSError {
            //Обрабокта возможных ошибок из блока do{} и отображение сообщения об ошибке
            stopAnimating()
            showAlert(title: "Ошибка!", text: "Что-то пошло не так! Не удалось обновить значение рейтинга на сервере. Проверьте Ваше соединение с интернетом и/или попробуйте позже.\nКод ошибки: \(error.code)", btn: "Ок")
        }
        
    }
    
    //Функция, обновляющая содержание элементов (имя, фотография, возраст, группа, факультет, информация об участнике, рейтинг)
    func updateContent() {
        nameLbl.text = nameList[selectedMember]
        userpic.image = UIImage(named: "userpic_\(selectedMember + 1)")
        ageLbl.text = "Возраст: \(ageList[selectedMember])"
        facultyLbl.text = "Фак.: \(facList[selectedMember])"
        groupLbl.text = "Группа: \(groupList[selectedMember])"
        infoLbl.text = infoList[selectedMember]
        ratingView.rating = ratingList[selectedMember]
    }
}
