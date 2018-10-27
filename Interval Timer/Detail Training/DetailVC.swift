

import UIKit

class DetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var beginButton: UIButton!
    
    var training: Training?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = training?.trainingName?.capitalized
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(areYou))
        
        myTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    @objc func areYou() {
        print("Yes")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
            
        case 1:
             let array = training?.exercises as! [String]
            return array.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Общая информация"
        case 1:
            return "Упражнения:"
        default:
            break
        }
        return nil
    }
    
     func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailVCCell
            switch indexPath.row {
            case 0:
                cell.keyLabel.text = "Кругов:"
                cell.valueLabel.text = "\(training!.lapsTraining)"
            case 4:
                cell.keyLabel.text = "Работа:"
                cell.valueLabel.text = "\((training!.job % 3600) / 60):\((training!.job % 60) / 10)\(training!.job % 60 % 10)"
            case 3:
                cell.keyLabel.text = "Подходов в упражении:"
                cell.valueLabel.text = "\(training!.repetitionsInTheExercise)"
            case 1:
                cell.keyLabel.text = "Отдых между кругами:"
                cell.valueLabel.text = "\((training!.restBetweenCircles % 3600) / 60):\((training!.restBetweenCircles % 60) / 10)\(training!.restBetweenCircles % 60 % 10)"
            case 2:
                cell.keyLabel.text = "Отдых между упражнениями:"
                cell.valueLabel.text = "\((training!.restBetweenExercises % 3600) / 60):\((training!.restBetweenExercises % 60) / 10)\(training!.restBetweenExercises % 60 % 10)"
            case 5:
                cell.keyLabel.text = "Отдых между подходами:"
                cell.valueLabel.text = "\((training!.relaxation % 3600) / 60):\((training!.relaxation % 60) / 10)\(training!.relaxation % 60 % 10)"
            default:
                break
            }

            return cell
            
        } else {
            let secondCell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath) as! DetailExercisesTableViewCell
            let array = training?.exercises as! [String]
            secondCell.exercisesLabel.text = array[indexPath.row]
            return secondCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTimerSegue" {
            let dvc = segue.destination as? TimerVC
            dvc?.training = training
            
        }
    }

}


