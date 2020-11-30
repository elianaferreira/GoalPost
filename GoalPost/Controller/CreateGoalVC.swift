//
//  CreateGoalVC.swift
//  GoalPost
//
//  Created by eferreira on 11/29/20.
//

import UIKit

class CreateGoalVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var shortTermBtn: UIButton!
    @IBOutlet weak var longTermBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var goalType: GoalType = .shortTerm
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.bindToKeyBoard()
        shortTermBtn.setSelectedColor()
        longTermBtn.setDeselectedColor()
        goalTextView.delegate = self
    }

    @IBAction func shortTermWasPresed(_ sender: Any) {
        goalType = .shortTerm
        shortTermBtn.setSelectedColor()
        longTermBtn.setDeselectedColor()
    }
    
    @IBAction func longTermWasPressed(_ sender: Any) {
        goalType = .longTerm
        shortTermBtn.setDeselectedColor()
        longTermBtn.setSelectedColor()
    }
    
    @IBAction func nextWasPRessed(_ sender: Any) {
        
        if goalTextView.text != "" && goalTextView.text != "What is your goal?" {
            guard let finishVC = storyboard?.instantiateViewController(identifier: "FinishGoalVCID") as? FinishGoalVC else {
                return
            }
            finishVC.initData(description: goalTextView.text!, type: goalType)
            presentDetail(finishVC)
        }
    }
    
    @IBAction func goBackWasPressed(_ sender: Any) {
        dismissDetail()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        goalTextView.text = ""
        goalTextView.textColor = UIColor.black
    }
}
