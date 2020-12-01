//
//  UIViewControllerExt.swift
//  GoalPost
//
//  Created by eferreira on 11/29/20.
//

import UIKit

extension UIViewController {
    
    //this methods are for navigation controller animation simulate
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false, completion: nil) //false because a custom transition is setted
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil) ////false because a custom transition is setted
    }
    
    func saveGoal(_ description: String, type: String, completionValue: Int32, progress: Int32, completion: (_ goalCreated: Goal?, _ finished: Bool) -> ()) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        let goal = Goal(context: manageContext)
        goal.goalDescription = description
        goal.goalType = type
        goal.goalCompletionValue = completionValue
        goal.goalProgress = progress
        
        do {
            try manageContext.save()
            completion(goal, true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(nil, false)
        }
    }
}
