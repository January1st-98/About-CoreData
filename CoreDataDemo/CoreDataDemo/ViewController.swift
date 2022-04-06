//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Jaehoon So on 2022/04/05.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //Data for Table
    var items: [Person]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchPeople()
    }
    
    func fetchPeople() {
        // Fetch the data from Core data to display in the tableView
        do {
            self.items = try context.fetch(Person.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
//            print(error)
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Person",
                                      message: "What is their name?",
                                      preferredStyle: .alert)
        alert.addTextField()
        
        let submitButton = UIAlertAction(title: "Add",
                                         style: .default) { (action) in
            let textfield = alert.textFields![0]
            
            //Create a person object
            let newPerson = Person(context: self.context)
            newPerson.name = textfield.text
            newPerson.age = 20
            newPerson.gender = "Male"
            //Save the Button
            do {
                try! self.context.save()
            } catch {
                
            }
            
            //새로운 Person 객체를 추가했으므로 items 배열에 저장한 Person데이터를 불러오는
            //fetchPerson 메서드를 통해 reloadData를 수행해준다
            self.fetchPeople()
        }
        
        alert.addAction(submitButton)
        
        self.present(alert, animated: true, completion: nil)
    }


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        let person = self.items![indexPath.row]
        
        cell.textLabel?.text = person.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = self.items![indexPath.row]

        let alert = UIAlertController(title: "Edit Person",
                                      message: "Edit name",
                                      preferredStyle: .alert)
        alert.addTextField()

        let textField = alert.textFields![0]
        textField.text = person.name

        let saveButton = UIAlertAction(title: "Save",
                                       style: .default) { action in
            let textfield = alert.textFields![0]
        }
        
        alert.addAction(saveButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive,
                                        title: "Delete") { action, view, completionHandler in
            //which person to remove
            let personToRemove = self.items![indexPath.row]
            
            //remove the person
            self.context.delete(personToRemove)
            
            //save the data
            do {
                try! self.context.save()
            } catch {
                print("에러임")
            }
            
            //re-fetch data
            self.fetchPeople()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension ViewController: UITableViewDelegate {
    
}

