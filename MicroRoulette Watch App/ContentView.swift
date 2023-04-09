//
//  ContentView.swift
//  MicroRoulette Watch App
//
//  Created by Daniil Popov on 07/04/2023.
//

import SwiftUI
import WatchShaker


struct ContentView: View {
    private var numbers = 0...12
    private var data: [Double] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] // 13
    private var slots: [Int] =   [3, 8, 0, 5, 12,1, 4, 9, 6,11, 2, 7,10]
    private var segments = 13
    
    private var weakSpin   = 360 * 3
    private var midSpin    = 360 * 5
    private var strongSpin = 360 * 7
    
    @State private var randDegree = Int.random(in: 1...360)
    
    @State private var oneWin = false
    @State private var doubleWin = false
    @State private var fontSize = 16.0

    @State private var oddEven = ["", "odd", "even"]
    @State private var pickedOddEven: String = ""
    @State private var pickedNumber: Int = 0
    
    @State private var scrollAmount = 0.0
    @State private var progress = 0.0
    
    @State private var spin = false
    
    @State private var shaker:WatchShaker = WatchShaker(shakeSensibility: .shakeSensibilityNormal, delay: 0.2)

    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                Picker("", selection: $pickedOddEven) {
                    ForEach(oddEven, id: \.self) { item in Text(pickedOddEven) }
                }
                .padding()
                .focusable(false)
    
                Picker("", selection: $pickedNumber) {
                    ForEach(numbers, id: \.self) { _ in Text("\(pickedNumber)") }
                }
                .padding()
                .focusable(false)

            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 65)
            .padding(.top, -10)
            
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.2)
                    .foregroundColor(.white)
                    .frame(width: 150, height: 150)
                
                PieChart(data: data, slots: slots)
                    .frame(width: 140)
                    .rotationEffect(Angle (degrees: -progress))
                    .focusable(true)
                    .digitalCrownRotation($scrollAmount, from: 0, through: 360, by: 1, sensitivity: .high, isContinuous: true)
                    .onChange(of: scrollAmount) { value in
                        self.progress = value
                    }

                Circle()
                    .offset(y: -75)
                    .foregroundColor(.white)
                    .frame(width: 10)
                    .rotationEffect(.degrees(spin ? Double((midSpin + randDegree)) : 0))
                    .animation(
                        .spring(response: 2, dampingFraction: 0.9, blendDuration: 0)
                        .repeatCount(1, autoreverses: false)
                        , value: self.spin
                    )
                    .animation(
                        .linear(duration: 3)
                        .delay(Double.random(in: 0...3))
                        .repeatCount(1, autoreverses: false)
                        , value: self.spin
                    )
                    .animation(
                        .easeOut(duration: 0.5)
                        .delay(5.0)
                        .repeatCount(1, autoreverses: false)
                        , value: self.spin
                    )
                    // start spin with Digital Crown
                    .rotationEffect(Angle (degrees: progress))
                    .focusable (true)
                    .digitalCrownRotation($scrollAmount, from: 0, through: 360, by: 1, sensitivity: .high, isContinuous: true)
                    .onChange(of: scrollAmount) { value in
                        self.progress = value
                        
                        if value > 180 {
                            self.spin.toggle()
                        }
                    }

                let randSector = (Double(randDegree) / 27.7).rounded(.up)

                if (pickedOddEven == "even" && slots[Int(randSector - 1)] % 2 == 0) ||
                   (pickedOddEven == "odd"  && slots[Int(randSector - 1)] % 2 != 0)
                {
                    Text("👏🏻")
                        .animatableSystemFont(size: fontSize)
                        .onAppear {
                            withAnimation(
                                .interactiveSpring()
                                .repeatCount(10)
                            ) {
                                fontSize = 32
                            }
                        }
                }

                if slots[Int(randSector - 1)] == pickedNumber {
                    Text("🎉")
                        .animatableSystemFont(size: fontSize)
                        .onAppear {
                            withAnimation(
                                .interactiveSpring()
                                .repeatCount(10)
                            ) {
                                fontSize = 32
                            }
                        }
                }

//                Text("\(pickedNumber)")
//                Text("\(slots[Int(0)])")
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
    let lineWidth: CGFloat = 0
    let slots: [Int]
    
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
                let endAngle = angle(for: data[0..<index].reduce(0, +))
                let midAngle = startAngle + (endAngle - startAngle) / 1.3 // midpoint of the sector
                let labelRadius = 120 / 2.5 // radius for the label to be placed

                ZStack {
//                    @todo: Add proper sectors
//                    Sector(startAngle: startAngle, endAngle: endAngle)
//                        .fill(Color(hue: Double(index) / Double(data.count), saturation: 1, brightness: 0.3))
//                        .overlay(
//                            Sector(startAngle: startAngle, endAngle: endAngle)
//                                .stroke(Color.white, lineWidth: lineWidth)
//                        )

                    if slots[index] % 2 == 0 && slots[index] != 0 {
                        Text("\(slots[index])")
                            .font(.system(size: 10))
                            .fontWeight(Font.Weight.heavy)
                            .foregroundColor(.red)
                            .rotationEffect(midAngle)
                            .offset(x: labelRadius * sin(midAngle.radians),
                                    y: -labelRadius * cos(midAngle.radians))
                    }
                    
                    if slots[index] % 2 != 0 && slots[index] != 0 {
                        // Circular text label
                        Text("\(slots[index])")
                            .font(.system(size: 10))
                            .fontWeight(Font.Weight.heavy)
                            .foregroundColor(.white)
                            .rotationEffect(midAngle)
                            .offset(x: labelRadius * sin(midAngle.radians),
                                    y: -labelRadius * cos(midAngle.radians))
                    }
                    
                    if slots[index] == 0 {
                        Text("\(slots[index])")
                            .font(.system(size: 10))
                            .fontWeight(Font.Weight.heavy)
                            .foregroundColor(.green)
                            .rotationEffect(midAngle)
                            .offset(x: labelRadius * sin(midAngle.radians),
                                    y: -labelRadius * cos(midAngle.radians))
                    }
                }
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

struct AnimatableSystemFontModifier: ViewModifier, Animatable {
    var size: Double
    var weight: Font.Weight
    var design: Font.Design

    var animatableData: Double {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight, design: design))
    }
}

extension View {
    func animatableSystemFont(size: Double, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        self.modifier(AnimatableSystemFontModifier(size: size, weight: weight, design: design))
    }
}
