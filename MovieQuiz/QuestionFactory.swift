<<<<<<< HEAD
import Foundation
final class QuestionFactory: QuestionFactoryProtocol {
    weak var delegate: QuestionFactoryDelegate?
=======
import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
            self.moviesLoader = moviesLoader
            self.delegate = delegate
        }
    
    private var movies: [MostPopularMovie] = []
>>>>>>> sprint_06
    
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else {
                DispatchQueue.main.async {
                    self.delegate?.didFailToLoadData(with: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No movies available"]))
                }
                return
            }
            
            let rating = Float(movie.rating) ?? 0
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            
            // Асинхронная загрузка изображения
            self.loadImage(from: movie.imageURL) { image in
                let question = QuizQuestion(
                    image: image ?? UIImage(named: "placeholder")!, // Используем кастомный плейсхолдер
                    text: text,
                    correctAnswer: correctAnswer
                )
                
                DispatchQueue.main.async {
                    self.delegate?.didReceiveNextQuestion(question: question)
                }
            }
        }
    }

    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Image loading error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data")
                completion(nil)
                return
            }
            
            completion(image)
        }.resume()
    }
}

/* private let questions: [QuizQuestion] = [
   QuizQuestion (
       image: "The Godfather",
       text: "Рейтинг этого фильма больше чем 6?",
       correctAnswer: true),
   QuizQuestion (
       image: "The Dark Knight",
       text: "Рейтинг этого фильма больше чем 6?",
       correctAnswer: true),
   QuizQuestion (
       image: "Kill Bill",
       text: "Рейтинг этого фильма больше чем 6?",
       correctAnswer: true),
   QuizQuestion (
       image: "The Avengers",
       text: "Рейтинг этого фильма больше чем 6?",
       correctAnswer: true),
   QuizQuestion (
       image: "Deadpool",
       text: "Рейтинг этого фильма больше чем 6?",
       correctAnswer: true),
   QuizQuestion (
       image: "The Green Knight",
       text: "Рейтинг этого фильма больше чем 6?",
       correctAnswer: true),
   QuizQuestion (
       image: "Old",
       text: "Рейтинг этого фильма больше чем 6?",
       correctAnswer: false),
   QuizQuestion (
       image: "The Ice Age Adventures of Buck Wild",
       text: "Рейтинг этого фильма больше чем 6?",
       correctAnswer: false),
   QuizQuestion (
       image: "Tesla",
       text: "Рейтинг этого фильма больше чем 6?",
       correctAnswer: false),
   QuizQuestion (
       image: "Vivarium",
       text: "Рейтинг этого фильма больше чем 6?",
       correctAnswer: false)
] */
