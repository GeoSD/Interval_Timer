//
//  AboutUsTableVC.swift
//  Eateries
//
//  Created by Алексей Пархоменко on 17/10/2018.
//  Copyright © 2018 Алексей Пархоменко. All rights reserved.
//

import UIKit

class AboutUsTableVC: UITableViewController {
    
    let sectionsHeaders = ["Мы в социальных сетях", "Наши сайты"]
    let sectionsContent = [["facebook", "vk"], ["cyber-russia.ru"]]
    let firstSectionLinks = ["https://www.facebook.com/GoCyberRussia", "https://vk.com/gocyberrussia"]
    let secondSectionLinks = ["https://cyber-russia.ru/coworking"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero) // избавляемся от лишних секций
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionsHeaders.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionsContent[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsHeaders[section]
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = sectionsContent[indexPath.section][indexPath.row]
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0..<firstSectionLinks.count:
                performSegue(withIdentifier: "showWebPageSegue", sender: nil)
                
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0..<secondSectionLinks.count:
                performSegue(withIdentifier: "showWebPageSegue", sender: nil)
                
            default:
                break
            }
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true) // должен быть вызван после всего
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebPageSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! WebVC
                if indexPath.section == 1 {
                    dvc.url = URL(string: secondSectionLinks[indexPath.row])
                } else {
                    dvc.url = URL(string: firstSectionLinks[indexPath.row])
                }
                
                
            }
        }
    }
}
