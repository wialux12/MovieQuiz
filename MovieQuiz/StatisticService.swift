import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    //MARK: - Private
    
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case totalQuestions
    }
    
    private func save(bestGame record: GameResult) {
        if let encoded = try? JSONEncoder().encode(record) {
            storage.set(encoded, forKey: Keys.bestGame.rawValue)
        }
    }
   
    //MARK: Init Protocol
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            guard let data = storage.data(forKey: Keys.bestGame.rawValue),
                         let record = try? JSONDecoder().decode(GameResult.self, from: data) else {
                       return GameResult(correct: 0, total: 10, date: Date())
                   }
                   return record
        }
        set {
            storage.set(newValue, forKey: "bestGame")
        }
    }
    
    var totalAccuracy: Double {
        let correct = storage.integer(forKey: Keys.correct.rawValue)
                let total = storage.integer(forKey: Keys.totalQuestions.rawValue)
                return total > 0 ? (Double(correct) / Double(total)) * 100 : 0
    }
    
    func store(correct count: Int, total amount: Int) {
        // 1. Обновляем количество игр (ТОЛЬКО ОДИН РАЗ ЗА ИГРУ)
                storage.set(gamesCount + 1, forKey: Keys.gamesCount.rawValue)
                
                // 2. Обновляем общую статистику
                let currentCorrect = storage.integer(forKey: Keys.correct.rawValue)
                storage.set(currentCorrect + count, forKey: Keys.correct.rawValue)
                
                let currentTotal = storage.integer(forKey: Keys.totalQuestions.rawValue)
                storage.set(currentTotal + amount, forKey: Keys.totalQuestions.rawValue)
                
                // 3. Проверяем рекорд
                let currentGame = GameResult(correct: count, total: amount, date: Date())
                if currentGame.isBetterThan(bestGame) {
                    save(bestGame: currentGame)
                }
    }
}
