//
//  Ext.swift
//  hackathon_001
//
//  Created by Максим Скрябин on 05.04.2018.
//  Copyright © 2018 mSkr. All rights reserved.
//

//Отдельный файл с вспомогательными переменными

import UIKit

//Массивы с информацией об участниках команды
let nameList = ["Дмитрий Петухов", "Александр Горностаев", "Максим Скрябин", "Никита Шеховцов"]
let ageList = [20, 18, 20, 19]
let facList = ["РС", "РК", "ИУ", "ИУ"]
let groupList = ["2-61", "9-21", "5-41", "5-41"]
let infoList = ["183, с приборостроительного факультета, 183(!), снимаю с дрона, люблю плюсы, но изменяю им с питоном, езжу на американо и рэдбуле, считаю, что 1984 Оруэлла можно переименовать в 20!8",
                "Имею двух голодных черепах и пузатую кошку; любимые фразы - \"Это фиаско, братан\" и \"Как тебе такое, Илон Маск?\" Предпочитаю научную фантастику, а среди неё Лема и Азимова.",
                "Самый низкий: 176(!). Пишу на Swift'e уже ~2 года. Говорят, что перфекционист, хитрый и упертый.",
                "Администратор группы \"Набег\" в стиме, администратор группы ВКонтакте, амбициозный: во мне так много амбиций!"]
var ratingList: [Double] = []


//Расширение для стандартного класса UIViewController
extension UIViewController {
    //Функция, отображающая пользователю предупреждение
    //Используется при возникновении ошибки при попытке обновления рейтинга на сервере
    func showAlert(title: String?, text: String?, btn: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: btn, style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Функция, отображающая пользователю предупреждение
    //Отличием от предыдущей функции является тот факт, что это предупреждение нелья закрыть
    //Используется при возникновении ошибки при изначальной загрузке рейтинга с сервера
    func showAlertLock(title: String?, text: String?) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}
