//
//  ContentView.swift
//  AnimatedButton
//
//  Created by SHRADDHA on 20/12/20.
//  Copyright © 2020 shraddha. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    // MARK:- variables
    @State var rotationAngle: Angle = .degrees(0)
    @State var circleScale: CGFloat = 1
    @State var isAnimating: Bool = false
    @State var submitScale: CGFloat = 1
    @State var isCompleted: Bool = false
    @State var tickPath: Double = 0
    @State var tickScale: CGFloat = 0.4
    
    var body: some View {
        ZStack {
            if isAnimating {
                Circle()
                    .trim(from: 0, to: 0.85)
                    .stroke(Color.purple, lineWidth: 7)
                    .frame(width: 100, height: 100)
                    .rotationEffect(rotationAngle)
                    .scaleEffect(circleScale)
                    .onAppear(perform: {
                        withAnimation(Animation.linear(duration: 1)) {
                            self.rotationAngle = Angle.init(degrees: 360)
                        }
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                            withAnimation(Animation.easeOut(duration: 0.2)) {
                                self.circleScale = 0
                            }
                        }
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                            withAnimation(Animation.easeOut(duration: 0.2)) {
                                self.resetValues()
                            }
                        }
                    })
            }
            if isCompleted {
                Tick(scaleFactor: tickScale)
                    .trim(from: 0, to: CGFloat(tickPath))
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .foregroundColor(Color.white)
                    .frame(width: 100, height: 100)
                    .background(Color.green)
                    .cornerRadius(50)
                    .scaleEffect(tickScale, anchor: .center)
                    .onAppear {
                        withAnimation(Animation.linear(duration: 0.5)) {
                            self.tickPath = 1
                        }
                        withAnimation(Animation.linear(duration: 0.8)) {
                            self.tickScale = 0.7
                        }
                }
            } else {
                Button.init(action: {
                    self.shrinkButton()
                }) {
                    Text("Animate")
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.white)
                }
                .padding()
                .background(Color.purple)
                .cornerRadius(5)
                .scaleEffect(submitScale, anchor: .center)
            }
        }
    }
    
    func shrinkButton() {
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            self.isAnimating = true
        }
        withAnimation(Animation.linear(duration: 0.3)) {
            self.submitScale = 0
        }
    }
    
    func resetValues() {
        self.submitScale = 1
        self.isAnimating = false
        self.rotationAngle = Angle.init(degrees: 0)
        self.circleScale = 1
        self.isCompleted = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Tick: Shape {
    let scaleFactor: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let cX = rect.midX + 8
        let cY = rect.midY
        
        var path = Path()
        //        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
        path.move(to: CGPoint(x: cX - (35 * scaleFactor), y: cY))
        path.addLine(to: CGPoint(x: cX - (scaleFactor * 18), y: cY + (scaleFactor * 20)))
        path.addLine(to: CGPoint(x: cX + (scaleFactor * 20), y: cY - (scaleFactor * 20)))
        return path
    }
}
