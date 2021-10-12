//
//  TinyTown.swift
//  TinyScan
//
//  Created by Dan Huynh on 12/29/20.
//  Copyright © 2020 Dan Huynh. All rights reserved.
//

import Foundation

class TinyTown {
    
    //board is a 2D array of Squares, used to represent the game board
    var board = [[Square?]](
        repeating: [Square?](repeating: Square(name: "empty"), count: 5),
     count: 5)
    
    //create the board 5x5 with empty name squares
    init(){
        board[0][0] = Square(name: "yellow")
        board[0][1] = Square(name: "blue")
        board[0][2] = Square(name: "blue")
        board[1][2] = Square(name: "grey")
        board[1][0] = Square(name: "red")
        board[1][1] = Square(name: "red")
        print( board[0][0]?.type ?? "testing")
        print( board[1][1]?.type ?? "testing")
        print( board[2][2]?.type ?? "testing") // should be empty

    }
    
    var victoryPoints = 0
    
    var redCounter = 0
    var orangeCounter = 0
    var yellowCounter = 0
    var greenCounter = 0
    var blueCounter = 0
    var greyCounter = 0
    var blackCounter = 0
    var emptyCounter = 0

    
    func calculate(town: [[Square?]]){
        //loop through array
        //manually place x and y beacause we know array is always 5x5
        //count all types of squares
        for col in 0..<5{
            for row in 0..<5{
                if(town[row][col]?.type == "red" ){
                    redCounter+=1
                }
                else if (town[row][col]?.type == "blue"){
                    blueCounter+=1
                }
                else if (town[row][col]?.type == "orange"){
                    orangeCounter+=1
                }
                else if (town[row][col]?.type == "green"){
                    greenCounter+=1
                }
                else if (town[row][col]?.type == "grey"){
                    greyCounter+=1
                    //adding up adjacent blue squares for wells
                    if(town[row+1][col]?.type == "blue"){
                        victoryPoints+=1
                    }
                    if(town[row][col+1]?.type == "blue"){
                        victoryPoints+=1
                    }
                    if(town[row-1][col]?.type == "blue"){
                        victoryPoints+=1
                    }
                    if(town[row][col-1]?.type == "blue"){
                        victoryPoints+=1
                    }
                }
                else if (town[row][col]?.type == "yellow"){
                    let yellowDict = TheaterDict()
                    yellowCounter+=1
                    //go through all squares in same row
                    for yellowCol in 0..<5{
                        if(town[row][yellowCol]?.type != "empty" && yellowCol != col){
                            let checktype = town[row][yellowCol]?.type
                            yellowDict.list[checktype!] = true
                        }
                    }
                    for yellowRow in 0..<5{
                        if(town[yellowRow][col]?.type != "empty" && yellowRow != row){
                            let checktype = town[yellowRow][col]?.type
                            yellowDict.list[checktype!] = true
                        }
                    }
                    //calculate point from each Theater
                    victoryPoints+=yellowDict.list.count
//                    for colorkeys in yellowDict.list.keys {
//                       print(colorkeys)
//                        victoryPoints+=1
//                    }
                }
                else if (town[row][col]?.type == "black"){
                    blackCounter+=1
                }
                else if (town[row][col]?.type == "empty"){
                    emptyCounter+=1
                }
            }
        }
        print("initial vp", victoryPoints)
        //calculate points from Cottages
        var feedCounter = redCounter * 4
        var cottageCounter = blueCounter
        print("feedCounter", feedCounter)
        print("blueCounter", blueCounter)
        while(feedCounter > 0 && cottageCounter > 0){
            feedCounter-=1
            cottageCounter-=1
            victoryPoints+=3
        }
        print("after houses", victoryPoints)
        //calculate points from Chapels
        victoryPoints+=((blueCounter-cottageCounter) * yellowCounter)
        

        
        //calculate points from Taverns
        switch greenCounter{
        case 1:
            victoryPoints+=2
        case 2:
            victoryPoints+=5
        case 3:
            victoryPoints+=9
        case 4:
            victoryPoints+=14
        case 5:
            victoryPoints+=20
        default:
            break
        }
            
        //calculate subtraction of points bc empty plots
        victoryPoints-=emptyCounter
        
        print("Total Victory Points:", victoryPoints)
    
}

}
