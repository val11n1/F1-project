//
//  RaceInfoParams.swift
//  f1Project
//
//  Created by Valeriy Trusov on 25.04.2022.
//

import Foundation
import UIKit

struct RaceInfoParams {
    
    static  let raceInfoDict: [String: (image: UIImage, laps: Int,lapDistance: Int, distance: Float)] =
    ["Bahrain Grand Prix": (UIImage(named: "bahrain")!, 57, 5412, 308.238),
     "Saudi Arabian Grand Prix": (UIImage(named: "jeddah")!, 50, 6174, 308.450),
     "Australian Grand Prix": (UIImage(named: "australian")!, 58, 5303, 307.574),
     "Emilia Romagna Grand Prix": (UIImage(named: "Imola")!, 63, 4909, 309.049),
     "Miami Grand Prix": (UIImage(named: "miami")!, 57, 5410, 308.370),
     "Spanish Grand Prix": (UIImage(named: "spain")!, 66, 4655, 307.104),
     "Monaco Grand Prix": (UIImage(named: "monaco")!, 78, 3337, 260.286),
     "Azerbaijan Grand Prix": (UIImage(named: "az")!, 51, 6003, 306.049),
     "Canadian Grand Prix": (UIImage(named: "canada")!, 70, 4361, 305.270),
     "British Grand Prix": (UIImage(named: "uk")!, 52, 5891, 306.198),
     "Austrian Grand Prix": (UIImage(named: "austria")!, 71, 4318, 306.452),
     "French Grand Prix": (UIImage(named: "france")!, 53, 5842, 309.626),
     "Hungarian Grand Prix": (UIImage(named: "hungaroring")!, 70, 4381, 306.663),
     "Belgian Grand Prix": (UIImage(named: "spa")!, 44, 7004, 308.176),
     "Dutch Grand Prix": (UIImage(named: "nederland")!, 70, 4180, 292.600),
     "Italian Grand Prix": (UIImage(named: "italian")!, 53, 5793, 306.720),
     "Singapore Grand Prix": (UIImage(named: "singapore")!, 61, 5065, 308.828),
     "Japanese Grand Prix": (UIImage(named: "japanese")!, 53, 5807, 307.471),
     "United States Grand Prix": (UIImage(named: "usaAustin")!, 56, 5513, 308.405),
     "Mexico City Grand Prix": (UIImage(named: "mexico")!, 71, 4304, 305.354),
     "Brazilian Grand Prix": (UIImage(named: "brazil")!, 71, 4309, 305.909),
     "Abu Dhabi Grand Prix": (UIImage(named: "abudabi")!, 58, 5281, 306.183)]
}
