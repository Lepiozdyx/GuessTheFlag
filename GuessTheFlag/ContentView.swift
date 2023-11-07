//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Alex on 25.10.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionCount = 0
    
    @State private var animationAmount = [0.0, 0.0, 0.0]
    @State private var opacityAmount = [1.0, 1.0, 1.0]
    @State private var scaleAmount = [1.0, 1.0, 1.0]
    
    let maxQuestions = 8
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .cyan, location: 0.3),
                .init(color: .mint, location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .titleStyle()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            withAnimation(.spring(duration: 0.6, bounce: 0.3)) {
                                flagTapped(number)
                                animationAmount[number] += 360
                                
                                for index in 0..<3 {
                                    opacityAmount[index] = number == index ? 1 : 0.25
                                    scaleAmount[index] = number == index ? 1 : 0.9
                                }
                            }
                        } label: {
                            FlagImage(countryName: countries[number])
                        }
                        .opacity(opacityAmount[number])
                        .scaleEffect(scaleAmount[number])
                        .rotation3DEffect(.degrees(animationAmount[number]), axis: (x: 0, y: 1, z: 0))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        
        .alert("Game Over", isPresented: $showingFinalScore) {
            Button("Restart", role: .cancel, action: reset)
        } message: {
            Text("Your final score is \(score)")
        }
    }
    
    private func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
        }
        
        questionCount += 1
        
        if questionCount < maxQuestions {
            showingScore = true
        } else {
            showingFinalScore = true
        }
        
    }
    
    private func askQuestion() {
        withAnimation {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            animationAmount = [0, 0, 0]
            opacityAmount = [1, 1, 1]
            scaleAmount = [1.0, 1.0, 1.0]
        }
    }
    
    private func reset() {
        score = 0
        questionCount = 0
        askQuestion()
    }
}

#Preview {
    ContentView()
}

// MARK: - FlagImage view
struct FlagImage: View {
    let countryName: String
    
    var body: some View {
        Image(countryName)
            .clipShape(.rect(cornerRadius: 20))
            .shadow(radius: 5)
    }
}

// MARK: - Custom modifier
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .font(.largeTitle.bold())
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}
