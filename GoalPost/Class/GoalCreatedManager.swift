//
//  GoalCreatedManager.swift
//  GoalPost
//
//  Created by Codium S.A. on 11/30/20.
//

import Foundation

class GoalCreatedManager {
    static let shared = GoalCreatedManager()
    
    var goal: Goal?
    
    private init() {}
    
    func setGoal(_ goal: Goal?) {
        self.goal = goal
    }
    
    func getGoal() -> Goal? {
        return self.goal
    }
}
