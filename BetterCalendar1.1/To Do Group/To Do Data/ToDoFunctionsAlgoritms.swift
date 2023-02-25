//
//  ToDoFunctionsAlgoritms.swift
//  BetterCalendar1.1
//
//  Created by Delvin Cockroft on 2/23/23.
//

import Foundation
import SwiftUI

extension ToDoData {
    func activateNewTaskView() {
        accessToNewTaskView.toggle()
    }
    
    func addTaskToGroup(groupID: Int, givenTask: TaskItem) {
        groupOfTasks[groupID].taskItems.append(givenTask)
    }
    
    func activate(givenItem: TaskItem, groupID: Int, action: String) {
        for (index, item) in groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == givenItem.id {
                if action == "item" {
                    groupOfTasks[groupID].taskItems[index].changeActive()
                } else if action == "position" {
                    groupOfTasks[groupID].taskItems[index].deletingPosition = -190
                } else if action == "details" {
                    groupOfTasks[groupID].taskItems[index].changeDetails()
                }
            }
        }
    }
    
    func deactivate(givenItem: TaskItem, groupID: Int, action: String) {
        for (index, item) in groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == givenItem.id {
                if action == "item" {
                    groupOfTasks[groupID].taskItems[index].resetActive()
                } else if action == "position" {
                    groupOfTasks[groupID].taskItems[index].deletingPosition = 0
                }
            }
        }
    }
        
    func holdItem(givenItem: TaskItem, groupID: Int) {
        for (index, item) in groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == givenItem.id {
                groupOfTasks[groupID].taskItems[index].holdActive()
            }
        }
    }
    
    func sortArrayOfTaskItems(groupID: Int) {
        var AMArray = groupOfTasks[groupID].taskItems
        var PMArray = groupOfTasks[groupID].taskItems
        
        AMArray.removeAll(where: {$0.startTime.timeOfDay == "PM"})
        PMArray.removeAll(where: {$0.startTime.timeOfDay == "AM"})

        var sortedAMArray = AMArray.sorted{$0.startTime.hour < $1.startTime.hour}
        var sortedPMArray = PMArray.sorted{$0.startTime.hour < $1.startTime.hour}
        
        for (index,item) in sortedAMArray.enumerated() {
            if item.startTime.hour == 12 {
                let tempItem = item
                sortedAMArray.remove(at: index)
                sortedAMArray.insert(tempItem, at: 0)
            }
        }
        
        for (index,item) in sortedPMArray.enumerated() {
            if item.startTime.hour == 12 {
                let tempItem = item
                sortedPMArray.remove(at: index)
                sortedPMArray.insert(tempItem, at: 0)
            }
        }

        let sortedItems : [TaskItem] = sortedAMArray + sortedPMArray
        groupOfTasks[groupID].taskItems = sortedItems
    }
    
    func setSubTaskName(item: TaskItem, groupID: Int, bind: String) {
        for (index, task) in self.groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == task.id {
                let subID = self.groupOfTasks[groupID].taskItems[index].subtasks.count - 1
                self.groupOfTasks[groupID].taskItems[index].subtasks[subID].name = bind
                self.groupOfTasks[groupID].taskItems[index].subtasks[subID].isNamed = true
            }
        }
    }
    
    // Details functions
    func detailsOnAppearConfigureFrameSize(givenItem: TaskItem, groupID: Int) {
        for (index, task) in self.groupOfTasks[groupID].taskItems.enumerated() {
            if givenItem.id == task.id {
                if task.subtasks.count == 0 {
                    self.groupOfTasks[groupID].taskItems[index].frameSize = 180
                } else {
                    self.groupOfTasks[groupID].taskItems[index].frameSize = CGFloat(210 + givenItem.subtasks.count * 41)
                }
            }
        }
    }
    
    func detailsActivateSubtask(item: TaskItem,subTask: TaskItem.SubTask, groupID: Int) {
        for (index, task) in self.groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == task.id {
                for (subIndex, sub) in self.groupOfTasks[groupID].taskItems[index].subtasks.enumerated() {
                    if sub.id == subTask.id {
                        self.groupOfTasks[groupID].taskItems[index].subtasks[subIndex].changeActive()
                        if self.groupOfTasks[groupID].taskItems[index].subtasks.allSatisfy({$0.isActive}) {
                            withAnimation(Animation.spring()) {
                                self.groupOfTasks[groupID].taskItems[index].isActive = 2
                            }
                        } else if self.groupOfTasks[groupID].taskItems[index].subtasks.allSatisfy({$0.isActive == false}){
                            withAnimation(Animation.spring()) {
                                self.groupOfTasks[groupID].taskItems[index].isActive = 0
                            }
                        } else {
                            withAnimation(Animation.spring()) {
                                self.groupOfTasks[groupID].taskItems[index].isActive = 1
                            }
                        }
                    }
                }
            }
        }

    }
    
    func detailsDeleteSubtask(item: TaskItem,subTask: TaskItem.SubTask, groupID: Int) {
        for (index, task) in self.groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == task.id {
                withAnimation(Animation.spring()) {
                    self.groupOfTasks[groupID].taskItems[index].subtasks.removeAll(where: {$0.id == subTask.id})
                    if self.groupOfTasks[groupID].taskItems[index].subtasks.count == 0 {
                        self.groupOfTasks[groupID].taskItems[index].frameSize = 180
                    } else {
                        self.groupOfTasks[groupID].taskItems[index].frameSize -= 40
                    }
                }
            }
        }
    }
    
    func detailsAddSubTask(item: TaskItem, groupID: Int,bind: Binding<String>) {
        for (index, task) in self.groupOfTasks[groupID].taskItems.enumerated() {
            if item.id == task.id {
                if bind.wrappedValue != "" {
                    self.setSubTaskName(item: item, groupID: groupID, bind: bind.wrappedValue)
                    bind.wrappedValue = ""
                }
                self.groupOfTasks[groupID].taskItems[index].subtasks.removeAll(where: {$0.name == ""})
                self.groupOfTasks[groupID].taskItems[index].addSubTask()
                withAnimation(Animation.spring()) {
                    if self.groupOfTasks[groupID].taskItems[index].subtasks.count == 0 {
                        self.groupOfTasks[groupID].taskItems[index].frameSize = 180
                    } else {
                        self.groupOfTasks[groupID].taskItems[index].frameSize += 40
                    }
                }
            }
        }
    }
}
