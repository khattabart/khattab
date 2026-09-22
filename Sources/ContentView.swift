import SwiftUI

enum CalcButton: String {
    case zero = "0", one = "1", two = "2", three = "3", four = "4"
    case five = "5", six = "6", seven = "7", eight = "8", nine = "9"
    case dot = "."
    case equals = "="
    case add = "+", subtract = "-", multiply = "×", divide = "÷"
    case clear = "AC"
    case negative = "+/-"
    case percent = "%"

    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equals:
            return .orange
        case .clear, .negative, .percent:
            return Color(white: 0.7)
        default:
            return Color(white: 0.2)
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, none
}

struct ContentView: View {
    @State var display = "0"
    @State var currentNumber: Double = 0
    @State var runningNumber: Double = 0
    @State var currentOperation: Operation = .none

    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .dot, .equals]
    ]

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            GridBackground()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 12) {
                Spacer()
                HStack {
                    Spacer()
                    Text(display)
                        .foregroundColor(.white)
                        .font(.system(size: 72))
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                }
                .padding(.horizontal)

                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.tap(button: item)
                            }) {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(
                                        width: item == .zero ? 168 : 78,
                                        height: 78
                                    )
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(39)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 24)
        }
    }

    func tap(button: CalcButton) {
        switch button {
        case .add, .subtract, .multiply, .divide, .equals:
            if button == .add { currentOperation = .add }
            if button == .subtract { currentOperation = .subtract }
            if button == .multiply { currentOperation = .multiply }
            if button == .divide { currentOperation = .divide }

            if button != .equals {
                runningNumber = Double(display) ?? 0
                display = "0"
            } else {
                let secondNumber = Double(display) ?? 0
                switch currentOperation {
                case .add: display = formatted(runningNumber + secondNumber)
                case .subtract: display = formatted(runningNumber - secondNumber)
                case .multiply: display = formatted(runningNumber * secondNumber)
                case .divide:
                    display = secondNumber == 0 ? "Error" : formatted(runningNumber / secondNumber)
                case .none: break
                }
            }
        case .clear:
            display = "0"
            runningNumber = 0
            currentOperation = .none
        case .negative:
            let value = Double(display) ?? 0
            display = formatted(value * -1)
        case .percent:
            let value = Double(display) ?? 0
            display = formatted(value / 100)
        case .dot:
            if !display.contains(".") {
                display += "."
            }
        default:
            let number = button.rawValue
            if display == "0" {
                display = number
            } else {
                display += number
            }
        }
    }

    func formatted(_ value: Double) -> String {
        if value == value.rounded() && abs(value) < 1e15 {
            return String(Int(value))
        }
        return String(value)
    }
}

struct GridBackground: View {
    let spacing: CGFloat = 60
    let lineColor = Color.white.opacity(0.35)

    var body: some View {
        GeometryReader { geo in
            Path { path in
                var x: CGFloat = 0
                while x <= geo.size.width {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geo.size.height))
                    x += spacing
                }
                var y: CGFloat = 0
                while y <= geo.size.height {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geo.size.width, y: y))
                    y += spacing
                }
            }
            .stroke(lineColor, lineWidth: 1)
        }
    }
}
