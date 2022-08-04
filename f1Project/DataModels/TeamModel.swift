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
    
    static func createTeamModelArray(teamStandings: TeamStandings) -> [TeamModel] {
        
        var teamsArray = [TeamModel]()
           
        for teamStanding in teamStandings.data.standingsTable.standingList.first!.teamStanding {
               
               let position = teamStanding.position
               let points = teamStanding.points
               let name = teamStanding.constructor.name
               let wins = teamStanding.wins
               
               let teamModel = TeamModel(name: name, position: position, points: points, wins: wins)
               
               teamsArray.append(teamModel)
           }

       return teamsArray
    }
}
