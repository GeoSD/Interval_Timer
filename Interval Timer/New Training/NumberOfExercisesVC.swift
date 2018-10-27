

import UIKit
import CoreData

var NumberOfExercises = 1
var exercises = ["Упражнение \(NumberOfExercises)"]

class NumberOfExercisesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var labelNumberOfExercises: UILabel!
    @IBOutlet weak var myStepper: UIStepper!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var trainingName: String = ""
    var lapsTraining: Int = 0
    var restBetweenCircles: Int = 0
    var restBetweenExercises: Int = 0
    var repetitionsInTheExercise: Int = 0
    var job: Int = 0
    var relaxation: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myStepper.value = Double(exercises.count)
        labelNumberOfExercises.text = String(Int(myStepper.value))
        
        myTableView.tableFooterView = UIView(frame: CGRect.zero)
        myTableView.setEditing(true, animated: true)
    }
    
    @IBAction func stepperTapped(_ sender: UIStepper) {
        labelNumberOfExercises.text = String(Int(sender.value))
        
        
        if Int(sender.value) > NumberOfExercises {
            
            let newIndexPath = IndexPath(row: exercises.count, section: 0)
            exercises.append("Упражнение \(NumberOfExercises + 1)")
            myTableView.insertRows(at: [newIndexPath], with: .fade)
            
        } else {
            
            exercises.remove(at: exercises.count - 1)
            let lastIndexPath = IndexPath(row: exercises.count, section: 0)
            myTableView.deleteRows(at: [lastIndexPath], with: .fade)
            
        }
        NumberOfExercises = Int(sender.value)
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        if trainingName == "" {
            let al = UIAlertController(title: nil, message: "Укажите наименование тренировки!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Хорошо", style: .cancel, handler: nil)
            al.addAction(ok)
            present(al, animated: true, completion: nil)
        } else {

            
            performSegue(withIdentifier: "saveTappedUnwindSegue", sender: self)
            
            // работа с контекстом (добираемся до контекста в котором будем с вам работать)
            // дернем свойство appDelegate lazy var coreDataStack = CoreDataStack()
            // затем в CoreDataStack обратимся к свойству lazy var persistentContainer: NSPersistentContainer
            // и в нем достанем open var viewContext: NSManagedObjectContext { get } что и будет нашим контекстом
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            // создадим сущность
            let entity = NSEntityDescription.entity(forEntityName: "Training", in: context)
            
            // создаем сам объект который хотим сохранить
            let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! Training
            
            // установим значение для taskObject
            taskObject.trainingName = trainingName
            taskObject.lapsTraining = Int32(lapsTraining)
            taskObject.restBetweenCircles = Int32(restBetweenCircles)
            taskObject.restBetweenExercises = Int32(restBetweenExercises)
            taskObject.repetitionsInTheExercise = Int32(repetitionsInTheExercise)
            taskObject.job = Int32(job)
            taskObject.relaxation = Int32(relaxation)
            taskObject.exercises = exercises as NSObject
            
            // сохранить контекст чтобы сохранился наш объект
            do {
                try context.save()
                print("Saved!")
            } catch {
                print(error.localizedDescription)
            }
            // теперь нужно отобразить объекты в таблице

        }

    }
    
    // фиксируем изменения в названиях упражнений
    @IBAction func textEdditingChanged(_ sender: UITextField) {
        
        var  isEnabled : Bool = true
        for i in 0...exercises.count - 1 {
            
            let indexPath = IndexPath(row: i, section: 0)
            let cell = myTableView.cellForRow(at: indexPath) as? ExercisesTableViewCell
            exercises[i] = cell?.myTextField.text ?? ""
            if cell?.myTextField.text == nil || cell?.myTextField.text == "" {
                isEnabled = false
            }
            
        }
        
        saveButton.isEnabled = isEnabled
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exercesesCell", for: indexPath) as! ExercisesTableViewCell
        
        cell.myTextField.text = "\(exercises[indexPath.row])"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // тот эмоджи с которого мы двигаем
        let movedExercise = exercises.remove(at: sourceIndexPath.row)
        // вставляем мы в новое место
        exercises.insert(movedExercise, at: destinationIndexPath.row)
        
        tableView.reloadData()
        
    }
    
    
    
    
    
    
}
