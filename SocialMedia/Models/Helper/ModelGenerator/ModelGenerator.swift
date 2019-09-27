//
//  ModelGenerator.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 12/09/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation

class ModelGenerator {

    static func generateRequestModel() -> [RequestModel] {
        var array = [RequestModel]()
        
        let object1 = RequestModel(name: "Dexter", mutalFriends: 5)
        let object2 = RequestModel(name: "Rick Grimes", mutalFriends: 7)
        let object3 = RequestModel(name: "James Moriarty", mutalFriends: 9)
        let object4 = RequestModel(name: "Tony Stark", mutalFriends: 11)
        
        array.append(object1)
        array.append(object2)
        array.append(object3)
        array.append(object4)

        return array
    }

    static func generateNotificationModel() -> [NotificationModel] {
        var array = [NotificationModel]()
        
        let object1 = NotificationModel(name: "Ally jhon", notificationText: "I would love to have you for dinner", time: Date())
        let object2 = NotificationModel(name: "James bond", notificationText: "This is not your design", time: Date())
            
        array.append(object1)
        array.append(object2)
        
        return array
    }
    
    static func generateActivityModel() -> [ActivityLogModel] {
        var array = [ActivityLogModel]()
        
        let object1 = ActivityLogModel(activity: "You liked some picture", time: Date())
        let object2 = ActivityLogModel(activity: "You liked some video, i guess", time: Date())

        array.append(object1)
        array.append(object2)
        
        return array
    }
    
    static func generateStoryModel() -> [StoryModel] {
        var array = [StoryModel]()
     
        let object1 = StoryModel(name: "JAMES")
        let object2 = StoryModel(name: "JOHN")
        let object3 = StoryModel(name: "ROBERT")
        let object4 = StoryModel(name: "MICHAEL")
        let object5 = StoryModel(name: "WILLIAM")

        array.append(object1)
        array.append(object2)
        array.append(object3)
        array.append(object4)
        array.append(object5)

        return array
    }

    static func generateMessengerModel() -> [MessengerModel] {
        var array = [MessengerModel]()
        
        let object1 = MessengerModel(name: "Star Lord", message: "Who?", time: Date())
        let object2 = MessengerModel(name: "Tony Stark", message: "I am Iron Man", time: Date())
        let object3 = MessengerModel(name: "Batman", message: "I'm Batman", time: Date())
        let object4 = MessengerModel(name: "Joker", message: "Why So Serious?", time: Date())
        
        array.append(object1)
        array.append(object2)
        array.append(object3)
        array.append(object4)
        
        return array
    }

    
}

