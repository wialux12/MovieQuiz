import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    
    private let statisticService: StatisticServiceProtocol = StatisticService()
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    private var correctAnswers = 0
    private lazy var alertPresenter = AlertPresenter(viewController: self)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
<<<<<<< HEAD
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
        
        imageView.layer.cornerRadius = 20
=======
        showLoadingIndicator()
        questionFactory?.loadData()
        
>>>>>>> sprint_06
        yesButton.layer.cornerRadius = 15
        noButton.layer.cornerRadius = 15
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
<<<<<<< HEAD
        guard let question else { return }
=======
        guard let question = question else {
            showNetworkError(message: "Не удалось загрузить вопрос")
            return
        }
>>>>>>> sprint_06

        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
            self?.activityIndicator.stopAnimating() // Остановка индикатора
        }
    }
    
    // MARK: - Private Methods
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = model.image
        
        return QuizStepViewModel(
            image: image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
        highlightImageBorder(isCorrect: isCorrect)
    }
    
    private func highlightImageBorder(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    private func showNextQuestionOrResults() {
        imageView.layer.borderWidth = 0
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте еще раз!"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    private func showQuizResults() {
        let text = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let viewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть ещё раз"
        )
        show(quiz: viewModel)
        
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        if currentQuestionIndex == questionsAmount - 1 {
            // ВЫЗЫВАЕТСЯ ТОЛЬКО ОДИН РАЗ В КОНЦЕ ИГРЫ
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let bestGame = statisticService.bestGame
            let message = """
                   Ваш результат: \(correctAnswers)/\(questionsAmount)
                   Количество сыгранных квизов: \(statisticService.gamesCount)
                   Рекорд: \(bestGame.correct)/\(bestGame.total) (\(dateFormatter.string(from: bestGame.date)))
                   Средняя точность: \(String(format: "%.1f", statisticService.totalAccuracy))%
                   """
            
            let alert = UIAlertController(
                title: result.title,
                message: message,
                preferredStyle: .alert)
            
            let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                self.questionFactory?.requestNextQuestion()
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            currentQuestionIndex += 1
            showNextQuestionOrResults()
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
<<<<<<< HEAD
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy HH:mm"
        return formatter
    }()
=======

    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String) {
        activityIndicator.stopAnimating() // скрываем индикатор загрузки
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробуйте ещё раз") { [weak self] in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter.show(alert: model)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
            questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
>>>>>>> sprint_06
    
    // MARK: - IBAction
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true

        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        } 
        let givenAnswer = false

        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
