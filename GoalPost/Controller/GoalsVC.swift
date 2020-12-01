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
    @IBOutlet weak var undoView: UIView!
    @IBOutlet weak var undoLabel: UILabel!
    
    var goals: [Goal] = []
    var snackBarTimer: Timer!
    var currentGoal: Goal?
    var undoAction: UndoAction?
    
    //auxData for undo delete
    var auxDescription:String?
    var auxType: String?
    var auxCompletionValue: Int32 = 0
    var auxProgress: Int32 = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTableView.delegate = self
        mTableView.dataSource = self
        undoView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        mTableView.reloadData()
        
        //this is called when is presented again after the creation of new goal
        currentGoal = GoalCreatedManager.shared.getGoal()
        if currentGoal != nil {
            undoAction = .create
            GoalCreatedManager.shared.setGoal(nil)
            startTimer()
        }
    }
    
    func startTimer() {
        self.undoView.isHidden = false
        switch undoAction {
        case .create:
            self.undoLabel.text = "Goal created"
        case .delete:
            self.undoLabel.text = "Goal deleted"
        default: break
        }
        snackBarTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { (_) in
            self.undoView.isHidden = true
        })
    }
    
    func stopTimer() {
        undoView.isHidden = true
        snackBarTimer.invalidate()
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
    
    @IBAction func undoWasPressed(_ sender: Any) {
        switch undoAction {
        case .create:
            if currentGoal != nil {
                remove(currentGoal!)
                self.refreshTableView()
            }
        case .delete:
            //create again the goal
            if auxDescription != nil && auxType != nil {
                self.saveGoal(auxDescription!, type: auxType!, completionValue: auxCompletionValue, progress: auxProgress) { (_, complete) in
                    if complete {
                        self.refreshTableView()
                    }
                }
            }
        default: break
        }
        
    }
    
    func refreshTableView() {
        fetchData()
        stopTimer()
        mTableView.reloadData()
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
            let aux = self.goals[indexPath.row]
            //this is needed because the var is passed by reference and cause NPE
            self.auxDescription = aux.goalDescription
            self.auxType = aux.goalType
            self.auxCompletionValue = aux.goalCompletionValue
            self.auxProgress = aux.goalProgress
            self.remove(atIndexPath: indexPath)
            self.fetchData()
            self.mTableView.deleteRows(at: [indexPath], with: .automatic)
            self.undoAction = .delete
            self.startTimer()
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
        remove(goals[indexPath.row])
    }
    
    func remove(_ goal: Goal) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedContext.delete(goal)
        
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

