//
//  NewTaskData.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/17/23.
//

import Foundation
import SwiftUI

class NewTaskData: ObservableObject {
    /// Here is a changing task that can be added to the 'To Do' list
    @Published var dynamicTask = Item(
        name: "",
        startTime: Item.StartTime(hour: 0, minute: 0, timeOfDay: "AM"), endTime: Item.EndTime(hour: 0, minute: 0, timeOfDay: "PM"), dateTime: Item.DateTime(day: 0, month: 0, year: 2023),
        urgency: "", location: "", description: "", isActive: 0, deletingPosition: 0, detailsActive: false
    )
    /// this is a published variable to define the animatable data for the black seperator on the 'new task view
    @Published var backgroundSeperator: DataForAnimation = DataForAnimation(frameWidth: 0, frameHeight: 0, offsetX: 0, offsetY: 0, opacity: 0)
    /// this is a published variable to define the animatable data for the white rectangle in the 'new task' view
    @Published var backgroundCard: DataForAnimation = DataForAnimation(frameWidth: 0, frameHeight: 0, offsetX: 0, offsetY: 500, opacity: 0)
    
    func backgroundSeperatorAnimation(isActive: Bool) {
        if isActive{
            withAnimation(Animation.spring()) {
                backgroundSeperator.opacity = 0.6
            }
        } else {
            withAnimation(Animation.spring()) {
                backgroundSeperator.opacity = 0
            }
        }
    }
    func backgroundCardAnimation(isActive: Bool) {
        if isActive {
            withAnimation(Animation.spring()) {
                backgroundCard.offsetY -= 500
            }
        } else {
            withAnimation(Animation.spring()) {
                backgroundCard.offsetY += 500
            }
        }
    }
    
    func backgroundCardActiveAnimation(active: Bool) {
        if active {
            withAnimation(Animation.spring()) {
                backgroundCard.offsetY = -300
            }
        } else {
            withAnimation(Animation.spring()) {
                backgroundCard.offsetY += 300
            }
        }
        
    }
    
    func resetDynamicTaskItem() {
        dynamicTask = Item(
            name: "",
            startTime: Item.StartTime(hour: 0, minute: 0, timeOfDay: "AM"), endTime: Item.EndTime(hour: 0, minute: 0, timeOfDay: "PM"), dateTime: Item.DateTime(day: 0, month: 0, year: 2023),
            urgency: "", location: "", description: "", isActive: 0, deletingPosition: 0, detailsActive: false
        )
    }
}
