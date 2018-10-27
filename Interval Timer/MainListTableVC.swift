//
//  MainListTableVC.swift
//  Interval Timer
//
//  Created by Алексей Пархоменко on 22/10/2018.
//  Copyright © 2018 Алексей Пархоменко. All rights reserved.
//

import UIKit
import CoreData

class MainListTableVC: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Properties
    
     var trainingArray = [Training]()
     var fetchResultsController: NSFetchedResultsController<Training>!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.shadowImage = UIImage()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        getTheData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userDefaults = UserDefaults.standard
        let wasIntroWatched = userDefaults.bool(forKey: "wasIntroWatched")
        guard !wasIntroWatched else { return } // если wasIntroWatched false то продолжаем наш код
        
        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? PageViewController {
            present(pageVC, animated: true, completion: nil)
        }
    }

    // MARK: - Functions
    
     func getTheData() {
        
        // если хотим получить данные значит должны создать запрос
        // <Training> - указываем тип
        // Training.fetchRequest() - указываем сам класс
        let fetchRequest: NSFetchRequest<Training> = Training.fetchRequest()
        
        // мы можем получать данные в разном порядке по каким то фильтрам
        // другими словами это дискриптор
        // создадим дискриптор где попросим вывести нам данные отсортированные  по name
        // ascending - в порядке увеличения?
        let sortDescriptor = NSSortDescriptor(key: "trainingName", ascending: true)
        // для получения данных будем использовать контроллер NSFetchedResultsController который очень здорого работает с tableVC
        // применим sortDescriptor для нашего fetchRequest
        fetchRequest.sortDescriptors = [sortDescriptor]
        // cоздаем контекст
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = appDelegate?.persistentContainer.viewContext {
            //  инициализируем наш fetchResultsController
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self // относится к mark: - Fetch results controller delegate
            // теперь пробуем получить наши объекты
            do {
                try fetchResultsController.performFetch()
                // если все успешно то наполняем наш trainingArray объектами которые получаем через
                // fetchResultsController
                trainingArray = fetchResultsController.fetchedObjects!
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Fetch results controller delegate
    // воспользуемся методами делегата fetchResultsController которые позволят отслеживать за инзменениями
    // нашего VC и отоброжать новые результаты
    // будем реализовывать методы делегата, нужно подписаться на него
    
    // вызывается прямо перед тем как наш контроллер поменяет свой контент
    // предупреждаем tableView что сейчас начнется череда изменений
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // метод предупреждает наш tableView что у нас будут сейчас обновления
        tableView.beginUpdates()
        // делаем для того чтобы не перегружать целиком каждый раз весь tableView но мы
        // будем перегружать конкретный indexPath
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { break }
            // добавляем новый элемент
            tableView.insertRows(at: [indexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { break }
            // удаляем элемент
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath else { break }
            // обновляем элемент
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            // перегружаем весь наш tableView
            tableView.reloadData()
        }
        
        // хотим чтобы массив обновился согласно тому что у нас находится в нашем контроллере или в
        // fetchResultsController контроллере
        trainingArray = controller.fetchedObjects as! [Training]
    }
    
    
    // аналогичный методу controllerWillChangeContent
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Table view

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return trainingArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)

        let training = trainingArray[indexPath.row]
        cell.textLabel?.text = "\(training.trainingName!.capitalized)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexpath) in
            self.trainingArray.remove(at: indexPath.row)
           
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            if let context = appDelegate?.persistentContainer.viewContext {
                
                let objectToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(objectToDelete)
                do {
                    try context.save()
                    print("Deleted!")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        return [delete]
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailVCSegue" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let dvc = segue.destination as? DetailVC
                let training = trainingArray[indexPath.row]
                dvc?.training = training
                
            }
            
        }
    }
    
    
    @IBAction func unwindToMainList(segue: UIStoryboardSegue) {
        
    }

}
