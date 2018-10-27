//
//  TimerVC.swift
//  Interval Timer
//
//  Created by Алексей Пархоменко on 23/10/2018.
//  Copyright © 2018 Алексей Пархоменко. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class TimerVC: UIViewController {

    // MARK: - Properties
    
    var training: Training?
    var toHistory: ToHistory?
    
    var arrayOfAllActions = [[String:Int]]() // сделал зачем то массив словарей, надо было сделать массив кортежей (тюплов), усложнил себе жизнь
    var timer = Timer()
    var seconds: Int = 0
    var audioPlayer = AVAudioPlayer()
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var trainingPickerView: UIPickerView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = training?.trainingName?.capitalized
        
        createTraining() // математическими преобразованиями засовываем все действия в правильной последовательности в массив
        
        trainingPickerView.delegate = self
        trainingPickerView.dataSource = self
        trainingPickerView.isUserInteractionEnabled = false
        
        timeLabel.text = "\((seconds % 3600) / 60):\((seconds % 60) / 10)\(seconds % 60 % 10)"
        
        do {
            let audioPath = Bundle.main.path(forResource: "mySound", ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            
        } catch {
            // error
        }
        
    }
    
    // только ради того, чтобы музыка подгрузилась заранее, ибо иначе идет секундное подвисание во время таймера
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        audioPlayer.prepareToPlay()
    }
    
    // MARK: - @IBActions
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if sender.image(for: .normal) == UIImage(named: "play with") {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
            sender.setImage(UIImage(named: "pause with"), for: .normal)
        } else { // эффект паузы
            timer.invalidate()
            sender.setImage(UIImage(named: "play with"), for: .normal)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let index = trainingPickerView.selectedRow(inComponent: 0) // берем индекс текущей строки
        trainingPickerView.selectRow(index + 1, inComponent: 0, animated: true) // переходим на следующую строку
        seconds = 0
    }
    
    @IBAction func soundButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            audioPlayer.volume = 0
        } else {
            audioPlayer.volume = 1
        }
    }
    
    // MARK: - Functions
    
    // метод таймера по которому он определяет сколько чего кого секунд надо пропикать
    @objc func counter() {
        let index = trainingPickerView.selectedRow(inComponent: 0) // берем индекс текущей строки
        if index == arrayOfAllActions.count - 1 {
            timer.invalidate() // если пришли к финишу
            self.performSegue(withIdentifier: "timerDone", sender: self)
            endAlert()
        }
        let nowObject = arrayOfAllActions[index].values.first // количество времени у текущей строки
        
        // пока секунды не станут равны nowObject + 2 делать:
        timeLabel.text = "\((seconds % 3600) / 60):\((seconds % 60) / 10)\(seconds % 60 % 10)"
        timeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        seconds += 1
        
        // звуки включаются если:
        if ((seconds == nowObject! + 2 - 11) && nowObject! > 10) || ((nowObject! + 2 - seconds) < 5 && (nowObject! + 2 - seconds) > 0 && nowObject! > 0) {
            audioPlayer.play()
            timeLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        
        if seconds == nowObject! + 2 {
            
            trainingPickerView.selectRow(index + 1, inComponent: 0, animated: true) // переходим на следующую строку
            seconds = 0
            counter() // рекурсивно вызываем этот же метод
        }
    }
    
    func saveToHistory() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ToHistory", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! ToHistory
        
        taskObject.trainingName = training?.trainingName
        taskObject.lapsTraining = (training?.lapsTraining)!
        taskObject.restBetweenCircles = (training?.restBetweenCircles)!
        taskObject.restBetweenExercises = (training?.restBetweenExercises)!
        taskObject.repetitionsInTheExercise = (training?.repetitionsInTheExercise)!
        taskObject.job = (training?.job)!
        taskObject.relaxation = (training?.relaxation)!
        taskObject.exercises = (training?.exercises)! as NSObject
        taskObject.currentDate = currentDate()

        do {
            try context.save()
            print("Saved to history!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func endAlert() {
        let al = UIAlertController(title: "Сохранить в историю?", message: nil, preferredStyle: .alert)
        let yes = UIAlertAction(title: "Да", style: .default) { (action) in
            self.saveToHistory()
        }
        let no = UIAlertAction(title: "Нет", style: .cancel) { (action) in
            print("No")
        }
        al.addAction(yes)
        al.addAction(no)
        present(al, animated: true, completion: nil)
    }
    
    func currentDate() -> String {
        var str = ""
        let date = Date()
        let calendar = Calendar.current
        
        let min = calendar.component(.minute, from: date)
        let hour = calendar.component(.hour, from: date)
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        str = "\(day).\(month).\(year), \(hour / 10)\(hour % 10):\(min / 10)\(min % 10)"
        return str
    }
    
    // MARK: - CreateTraining
    
    // грубо говоря тренировка это круги, круги это упражения, упражнения это повторы
    func createTraining() {
        // костыль который вставляет подготовку
        var dictionary = [String:Int]()
        dictionary["Подготовка : \((prep % 3600) / 60):\((prep % 60) / 10)\(prep % 60 % 10)"] = prep
        arrayOfAllActions.append(dictionary)
        // конец костыля
        let allCases = training!.lapsTraining + training!.lapsTraining - 1 // общее число действий
        for i in 1...allCases {
            if i % 2 == 1 {
                createCircle(exercises: training?.exercises as! [String])
            } else {
                var dictionary = [String:Int]()
                dictionary["Отдых между кругами : \((training!.restBetweenCircles % 3600) / 60):\((training!.restBetweenCircles % 60) / 10)\(training!.restBetweenCircles % 60 % 10)"] = Int(training!.restBetweenCircles)
                arrayOfAllActions.append(dictionary)
            }
        }
        // костыль который вставляет слово "Финиш"
        var dictionaryFinish = [String:Int]()
        dictionaryFinish["Финиш"] = 0
        arrayOfAllActions.append(dictionaryFinish)
        // конец костыля
        
    }
    
    // если не хотите знать как в мелких деталях создается последовательность действий то лучше не вникайте
    func createCircle(exercises: [String]) {
        let allCases = exercises.count + exercises.count - 1
        for i in 1...allCases {
            if i % 2 == 1 {
                let currentApproach = i / 2 + 1 // текущее упражнение
                createExercise(exercise: exercises[currentApproach - 1]) // - 1 так как в массиве счет начинается с 0
            } else {
                var dictionary = [String:Int]()
                dictionary["Отдых между упражнениями : \((training!.restBetweenExercises % 3600) / 60):\((training!.restBetweenExercises % 60) / 10)\(training!.restBetweenExercises % 60 % 10)"] = Int(training!.restBetweenExercises)
                arrayOfAllActions.append(dictionary)
            }
        }
        
    }
    
    func createExercise(exercise: String) {
        let allCases = training!.repetitionsInTheExercise + training!.repetitionsInTheExercise - 1 // общее число действий в упражнение
        for i in 1...allCases {
            if i % 2 == 1 {
                let currentApproach = i / 2 + 1 // текущий подход
                var dictionary = [String:Int]()
                dictionary["\(exercise): (\(currentApproach)/\(training!.repetitionsInTheExercise), \((training!.job % 3600) / 60):\((training!.job % 60) / 10)\(training!.job % 60 % 10))"] = Int(training!.job)
                arrayOfAllActions.append(dictionary)
            } else {
                var dictionary = [String:Int]()
                dictionary["Отдых между подходами: \((training!.relaxation % 3600) / 60):\((training!.relaxation % 60) / 10)\(training!.relaxation % 60 % 10)"] = Int(training!.relaxation)
                arrayOfAllActions.append(dictionary)
            }
        }
        
    }
    
// MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cancelPressed" {
            timer.invalidate()
        }
        
    }
    
}

// MARK: - Extensions

extension TimerVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayOfAllActions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
}

extension TimerVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let info = arrayOfAllActions[row].keys.first
        return info
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let info = arrayOfAllActions[row].values.first {
            if row == arrayOfAllActions.count - 1 {
                timeLabel.text = "Финиш!"
            } else {
                timeLabel.text = "\((info % 3600) / 60):\((info % 60) / 10)\(info % 60 % 10)"
            }
            
        }
        
    }
    
}
