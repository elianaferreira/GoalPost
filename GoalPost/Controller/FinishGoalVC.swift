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
            self.saveGoal(goalDescription, type: goalType.rawValue, completionValue: Int32(pointsTextField.text!)!, progress: Int32(0)) { (goalCreated, complete) in
                if complete {
                    //save goal in Singleton to use in main view
                    GoalCreatedManager.shared.setGoal(goalCreated)
                    self.view.window?.rootViewController?.dismissDetail()
                }
            }
        }
    }
    
    @IBAction func goBackPressed(_ sender: Any) {
        dismissDetail()
    }
}
