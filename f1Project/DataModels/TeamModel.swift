//
//  TeamModel.swift
//  f1Project
//
//  Created by Valeriy Trusov on 24.03.2022.
//

import Foundation


struct TeamModel: ModelProtocol {
    
    let name: String
    let position: String
    let points: String
    let wins: String
    
    static func createTeamModelArray(data: Data) -> [TeamModel] {
        
       let decoder = JSONDecoder()
       var teamssArray = [TeamModel]()

       do {
           let teams = try decoder.decode(TeamStandings.self, from: data)
           let standingList = teams.data.standingsTable.standingList.first
           
           
           for teamStanding in standingList!.teamStanding {
               
               let position = teamStanding.position
               let points = teamStanding.points
               let name = teamStanding.constructor.name
               let wins = teamStanding.wins
               
               let teamModel = TeamModel(name: name, position: position, points: points, wins: wins)
               
               teamssArray.append(teamModel)
           }
           
           
       } catch let err {
           print(err)
       }
       return teamssArray
    }
}
