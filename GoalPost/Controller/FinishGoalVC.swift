//
//  FinishGoalVC.swift
//  GoalPost
//
//  Created by eferreira on 11/29/20.
//

import UIKit

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class FinishGoalVC: UIViewController {

    @IBOutlet weak var createGoalBtn: UIButton!
    @IBOutlet weak var pointsTextField: UITextField!
    
    var goalDescription: String!
    var goalType: GoalType!
    var goalCreated: Goal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGoalBtn.bindToKeyBoard()
        
    }
    
    func initData(description: String, type: GoalType) {
        self.goalDescription = description
        self.goalType = type
    }

    @IBAction func createGoal(_ sender: Any) {
        //pass data to CoreData
        if pointsTextField.text != "" {
            self.save { (complete) in
                if complete {
                    //seteamos el goal en el singleton
                    GoalCreatedManager.shared.setGoal(goalCreated)
                    self.view.window?.rootViewController?.dismissDetail()
                }
            }
        }
    }
    
    @IBAction func goBackPressed(_ sender: Any) {
        dismissDetail()
    }
    
    
    func save(completion: (_ finished: Bool) -> ()) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        goalCreated = Goal(context: manageContext)
        goalCreated.goalDescription = goalDescription
        goalCreated.goalType = goalType.rawValue
        goalCreated.goalCompletionValue = Int32(pointsTextField.text!)!
        goalCreated.goalProgress = Int32(0)
        
        do {
            try manageContext.save()
            completion(true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func undoCreate(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.delete(goalCreated)
        
        do {
            try managedContext.save()
            completion(true)
        } catch {
            debugPrint("Could not delete \(error.localizedDescription)")
            completion(false)
        }
    }
    
}
