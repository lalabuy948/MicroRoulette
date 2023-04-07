//
//  ContentView.swift
//  MicroRoulette Watch App
//
//  Created by Daniil Popov on 07/04/2023.
//

import SwiftUI


struct ContentView: View {
    private var numbers = 0...14

    @State private var oddEven = ["", "odd", "even"]
    @State private var number: Int = 0
    
    @State private var scrollAmount = 0.0
    @State private var progress = 0.0
    
    let data: [Double] = [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1]
//    let labels = []

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Picker("", selection: $oddEven) {
                    ForEach(oddEven, id: \.self) { item in Text(item) }
                }
                .padding()
                .focusable()
    
                Picker("", selection: $number) {
                    ForEach(numbers, id: \.self) { _ in Text("\(number)") }
                }
                .padding()
                .focusable()

            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 65)
            .padding(.top, -20)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.2)
                    .foregroundColor(.white)
                    .frame(width: 120)
                
                PieChart(data: data)
                    .frame(width: 110)
                    .rotationEffect(Angle (degrees: -progress))
                    .focusable(true)
                    .digitalCrownRotation($scrollAmount, from: 0, through: 360, by: 1, sensitivity: .high, isContinuous: true)
                    .onChange(of: scrollAmount) { value in
                        self.progress = value
                    }

                Circle()
                    .offset(y: -60)
                    .foregroundColor(.white)
                    .frame(width: 10)
                    .rotationEffect(Angle (degrees: progress))
                    .focusable (true)
                    .digitalCrownRotation($scrollAmount, from: 0, through: 360, by: 1, sensitivity: .high, isContinuous: true)
                    .onChange(of: scrollAmount) { value in
                        self.progress = value
                    }
            }
            .padding(.top, 10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PieChart: View {
    let data: [Double]
    let lineWidth: CGFloat = 1
    
    private var total: Double {
        data.reduce(0, +)
    }
    
    private func angle(for value: Double) -> Angle {
        let fraction = value / total
        return .degrees(fraction * 360)
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<data.count, id: \.self) { index in
                let startAngle = index == 0 ? .zero : angle(for: data[0..<index].reduce(0, +))
                let endAngle = angle(for: data[0...index].reduce(0, +))
                
                Sector(startAngle: startAngle, endAngle: endAngle)
                    .fill(Color(hue: Double(index) / Double(data.count), saturation: 1, brightness: 0.3))
                    .overlay(Sector(startAngle: startAngle, endAngle: endAngle)
                                .stroke(Color.black, lineWidth: lineWidth))
            }
        }
    }
}

struct Sector: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                    radius: rect.width / 2,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false)
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}
