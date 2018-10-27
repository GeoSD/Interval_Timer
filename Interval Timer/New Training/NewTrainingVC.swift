//
//  MainListTableVC.swift
//  Interval Timer
//
//  Created by Алексей Пархоменко on 19/10/2018.
//  Copyright © 2018 Алексей Пархоменко. All rights reserved.
//

import UIKit



class NewTrainingVC: UITableViewController {

    @IBOutlet weak var labelLapsTraining: UILabel!
    @IBOutlet weak var labelRestBetweenCircles: UILabel!
    @IBOutlet weak var labelRestBetweenExercises: UILabel!
    @IBOutlet weak var labelRepetitionsInTheExercise: UILabel!
    @IBOutlet weak var labelJob: UILabel!
    @IBOutlet weak var labelRelaxation: UILabel!
    @IBOutlet weak var trainingNameTextField: UITextField!
    
    @IBOutlet weak var stepperLapsTraining: UIStepper!
    @IBOutlet weak var stepperRestBetweenCircles: UIStepper!
    @IBOutlet weak var stepperRestBetweenExercises: UIStepper!
    @IBOutlet weak var stepperRepetitionsInTheExercise: UIStepper!
    @IBOutlet weak var stepperJob: UIStepper!
    @IBOutlet weak var stepperRelaxation: UIStepper!
    
    var lapsTraining: Int = 0
    var restBetweenCircles: Int = 0
    var restBetweenExercises: Int = 0
    var repetitionsInTheExercise: Int = 0
    var job: Int = 0
    var relaxation: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // к сожалению придется создавать аутлеты для всех stepper для того, чтобы переменные выше записали их значения сразу при загрузке, а не во время
        // переключения stepper
        lapsTraining = Int(stepperLapsTraining.value)
        restBetweenCircles = Int(stepperRestBetweenCircles.value)
        restBetweenExercises = Int(stepperRestBetweenExercises.value)
        repetitionsInTheExercise = Int(stepperRepetitionsInTheExercise.value)
        job = Int(stepperJob.value)
        relaxation = Int(stepperRelaxation.value)
    }

    @IBAction func stepperAction(_ sender: UIStepper) {
        switch sender.tag {
        case 0:
            labelLapsTraining.text = String(Int(sender.value))
            lapsTraining = Int(sender.value)
        case 1:
            labelRestBetweenCircles.text = "\((Int(sender.value) % 3600) / 60):\((Int(sender.value) % 60) / 10)\(Int(sender.value) % 60 % 10)"
            restBetweenCircles = Int(sender.value)
        case 2:
            labelRestBetweenExercises.text = "\((Int(sender.value) % 3600) / 60):\((Int(sender.value) % 60) / 10)\(Int(sender.value) % 60 % 10)"
            restBetweenExercises = Int(sender.value)
        case 3:
            labelRepetitionsInTheExercise.text = String(Int(sender.value))
            repetitionsInTheExercise = Int(sender.value)
        case 4:
            labelJob.text = "\((Int(sender.value) % 3600) / 60):\((Int(sender.value) % 60) / 10)\(Int(sender.value) % 60 % 10)"
            job = Int(sender.value)
        case 5:
            labelRelaxation.text = "\((Int(sender.value) % 3600) / 60):\((Int(sender.value) % 60) / 10)\(Int(sender.value) % 60 % 10)"
            relaxation = Int(sender.value)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseExercises" {
            let dvc = segue.destination as? NumberOfExercisesVC
            dvc?.trainingName = trainingNameTextField.text ?? ""
            dvc!.lapsTraining = lapsTraining
            dvc!.restBetweenCircles = restBetweenCircles
            dvc!.restBetweenExercises = restBetweenExercises
            dvc!.repetitionsInTheExercise = repetitionsInTheExercise
            dvc!.job = job
            dvc!.relaxation = relaxation
            
        }
    }
    
}

