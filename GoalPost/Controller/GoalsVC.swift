//
//  GoalsVC.swift
//  GoalPost
//
//  Created by eferreira. on 11/29/20.
//

import UIKit
import CoreData

class GoalsVC: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    
    var goals: [Goal] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTableView.delegate = self
        mTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        mTableView.reloadData()
    }
    
    func fetchData() {
        self.fetch { (complete) in
            if complete {
                if goals.count >= 1 {
                    mTableView.isHidden = false
                } else {
                    mTableView.isHidden = true
                }
            }
        }
    }

    @IBAction func createNewGoal(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(identifier: "CreateGoalVCID") else { return }
        presentDetail(createGoalVC)
    }
    
}

extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else {
            return UITableViewCell()
        }
        let goal = goals[indexPath.row]
        cell.configureCell(goal: goal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "DELETE") { (conextualAction, viewParam, boolValue) in
            self.remove(atIndexPath: indexPath)
            self.fetchData()
            self.mTableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.368627451, blue: 0.3254901961, alpha: 1)
        
        let addAction = UIContextualAction(style: .normal, title: "ADD 1") { (conextualAction, viewParam, boolValue) in
            self.setProgress(atIndexpath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        addAction.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, addAction])

        return swipeActions
    }
}

extension GoalsVC {
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        do {
            goals = try managedContext.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint("Could not fetch \(error.localizedDescription)")
            completion(false)
        }
    }
    
    
    func remove(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedContext.delete(goals[indexPath.row])
        
        do {
            try managedContext.save()
        } catch {
            debugPrint("Could not delete \(error.localizedDescription)")
        }
    }
    
    func setProgress(atIndexpath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let chosenGoal = goals[indexPath.row]
        if  chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress += 1
        } else {
            return
        }
        
        do {
            try managedContext.save()
        } catch {
            debugPrint("Could not set progress \(error.localizedDescription)")
        }
        
    }
}

