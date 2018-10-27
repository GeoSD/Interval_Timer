//
//  HistoryTableVC.swift
//  Interval Timer
//
//  Created by Алексей Пархоменко on 26/10/2018.
//  Copyright © 2018 Алексей Пархоменко. All rights reserved.
//

import UIKit
import CoreData

class HistoryTableVC: UITableViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Properties
    var fetchResultsController: NSFetchedResultsController<ToHistory>!
    var trainingHistoryArray = [ToHistory]()
   
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "История"
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        getTheData()
    }
    
    // MARK: - Functions
    
    func getTheData() {
        
        let fetchRequest: NSFetchRequest<ToHistory> = ToHistory.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "trainingName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let context = appDelegate?.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            
            do {
                try fetchResultsController.performFetch()
                trainingHistoryArray = fetchResultsController.fetchedObjects!
            } catch let error as NSError{
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Fetch results controller delegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
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
        
        trainingHistoryArray = controller.fetchedObjects as! [ToHistory]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return trainingHistoryArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell

        cell.nameLabel.text = trainingHistoryArray[indexPath.row].trainingName?.capitalized
        cell.dateLabel.text = trainingHistoryArray[indexPath.row].currentDate
        

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
