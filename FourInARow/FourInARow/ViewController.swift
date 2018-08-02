//
//  ViewController.swift
//  FourInARow
//
//  Created by Vo Huy on 7/31/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
    
    @IBOutlet var columnsStackView: UIStackView!
    @IBOutlet var columnButtons: [UIButton]!
    @IBOutlet var modeButtons: [UIButton]!
    @IBOutlet var modeStackView: UIStackView!
    
    var placedChips = [[UIView]]()
    var board: Board!
    var strategist: GKMinmaxStrategist!
    var isAIEnabled: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<Board.width {
            placedChips.append([UIView]())
        }
        
        strategist = GKMinmaxStrategist()
        strategist.maxLookAheadDepth = 7
        // just return the first best move
        strategist.randomSource = nil
        
        resetBoard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func vsHumanChosen(_ sender: UIButton) {
        startGame(withAI: false)
    }
    
    @IBAction func vsBotChosen(_ sender: UIButton) {
        startGame(withAI: true)
    }
    
    @IBAction func makeMove(_ sender: UIButton) {
        let column = sender.tag
        
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column)
            addChip(inColumn: column, row: row, color: board.currentPlayer.color)
            continueGame()
        }
    }
}

// MARK: - Layout
extension ViewController {
    
    func updateUI() {
        title = "\(board.currentPlayer.name)'s Turn"
        
        if board.currentPlayer.chip == .black && isAIEnabled {
            startAIMove()
        }
    }
}

// MARK: - Game Logic
extension ViewController {
    
    func resetBoard() {
        title = ""
//        columnsStackView.layer.zPosition = -1
        UIView.animate(withDuration: 0.2, animations: { [unowned self] in
            self.modeStackView.alpha = 1
            self.columnsStackView.alpha = 0
        }) { [unowned self] (finished) in
            self.modeStackView.layer.zPosition = 1
            self.modeStackView.isHidden = !finished
            self.columnsStackView.isHidden = finished
        }
    }
    
    func startGame(withAI: Bool) {
        
        isAIEnabled = withAI
        columnsStackView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: { [unowned self] in
            self.modeStackView.alpha = 0
            self.columnsStackView.alpha = 1
        }, completion: { [unowned self] (finished) in
//            columnsStackView.layer.zPosition = 1
            self.modeStackView.layer.zPosition = -1
            self.modeStackView.isHidden = finished
//            self.modeButtons.forEach{ $0.isHidden = finished }
        })
        board = Board()
        strategist.gameModel = board
        
        updateUI()
        for i in 0..<placedChips.count {
            for chip in placedChips[i] {
                chip.removeFromSuperview()
            }
            
            placedChips[i].removeAll(keepingCapacity: true)
        }
    }
    
    func addChip(inColumn column: Int, row: Int, color: UIColor) {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / 6)
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        
        if(placedChips[column].count < row + 1) {
            let newChip = UIView()
            newChip.frame = rect
            newChip.isUserInteractionEnabled = false
            newChip.backgroundColor = color
            newChip.layer.cornerRadius = size / 2
            newChip.center = positionForChip(inColumn: column, row: row, size: size)
            newChip.transform = CGAffineTransform(translationX: 0, y: -800)
            view.addSubview(newChip)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                // clears any pre-defined transform
                newChip.transform = CGAffineTransform.identity
            })
            
            placedChips[column].append(newChip)
        }
    }
    
    func continueGame() {
        var gameOverTitle: String? = nil
        
        if board.isWin(for: board.currentPlayer) {
            gameOverTitle = "\(board.currentPlayer.name) Wins!"
        } else if board.isFull() {
            gameOverTitle = "Draw!"
        }
        
        if gameOverTitle != nil {
            let ac = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Play Again", style: .default) {
                [unowned self] (action) in
                self.resetBoard()
            }
            
            ac.addAction(alertAction)
            present(ac, animated: true)
        }
        
        board.currentPlayer = board.currentPlayer.opponent
        updateUI()
    }
    
    func columnForAIMove() -> Int? {
        if let aiMove = strategist.bestMove(for: board.currentPlayer) as? Move {
            return aiMove.column
        }
        
        return nil
    }
    
    func makeAIMove(in column: Int) {
        columnButtons.forEach{ $0.isEnabled = true }
        navigationItem.leftBarButtonItem = nil
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column)
            addChip(inColumn: column, row: row, color: board.currentPlayer.color)
            
            continueGame()
        }
    }
    
    func startAIMove() {
        
        columnButtons.forEach { $0.isEnabled = false }
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)
        
        DispatchQueue.global().async {
            [unowned self] in
            let strategistTime = CFAbsoluteTimeGetCurrent()
            guard let column = self.columnForAIMove() else { return }
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime
            
            let aiTimeCeling = 1.0
            let delay = aiTimeCeling - delta
            
            DispatchQueue.main.asyncAfter(deadline: .now() +  delay) {
                self.makeAIMove(in: column)
            }
        }
    }
}

// MARK: - Additional Helpers
extension ViewController {
    func positionForChip(inColumn column: Int, row: Int, size: CGFloat) -> CGPoint {
        let button = columnButtons[column]
        
        let xOffset = button.frame.midX
        var yOffset = button.frame.maxY - size / 2
        yOffset -= size * CGFloat(row)
        return CGPoint(x: xOffset, y: yOffset)
    }
}



