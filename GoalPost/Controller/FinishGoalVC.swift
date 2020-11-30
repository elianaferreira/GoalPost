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
        let goal = Goal(context: manageContext)
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue
        goal.goalCompletionValue = Int32(pointsTextField.text!)!
        goal.goalProgress = Int32(0)
        
        do {
            try manageContext.save()
            print(">>> data saved")
            completion(true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }
    
}
