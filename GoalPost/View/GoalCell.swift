//
//  GoalCell.swift
//  GoalPost
//
//  Created by eferreira on 11/29/20.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var completionView: UIView!
    
    func configureCell(goal: Goal) {
        self.descriptionLabel.text = goal.goalDescription
        self.typeLabel.text = goal.goalType
        self.progressLabel.text = String(describing: goal.goalProgress)
        
        if goal.goalCompletionValue == goal.goalProgress {
            self.completionView.isHidden = false
        } else {
            self.completionView.isHidden = true
        }
    }
}
