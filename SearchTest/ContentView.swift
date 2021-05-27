//
//  ContentView.swift
//  SearchTest
//
//  Created by Essam Orabi on 11/04/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    // animation paramenters
    @State private var startAnimation = false
    @State private var plus1 = false
    @State private var plus2 = false
    @State private var finishAnimation = false
    
    @State private var foundPeople: [People] = []
    var body: some View{
        VStack {
            //Nav Bar...
            HStack(spacing: 10) {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.black)
                    
                })
                Text(finishAnimation ?  "\(peopols.count) People NearBy":"Near by search")
                    .font(.title2)
                    .fontWeight(.bold)
                    .animation(.none)
                Spacer()
                Button(action: verifyAndAddPeople, label: {
                    if finishAnimation{
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.black)
                    }else{
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.black)
                    }
                })
                .animation(.none)
            }
            .padding()
            .padding(.top,getSaveArea().top)
            .background(Color.white)
            ZStack{
                Circle()
                    .stroke(Color.gray.opacity(0.6))
                    .frame(width: 130, height: 130)
                    .scaleEffect(plus1 ? 3.3 : 0)
                    .opacity(plus1 ? 0 : 1)
                
                Circle()
                    .stroke(Color.gray.opacity(0.6))
                    .frame(width: 130, height: 130)
                    .scaleEffect(plus2 ? 3.3 : 0)
                    .opacity(plus2 ? 0 : 1)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 130, height: 130)
                //shadow....
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: 5, y: 5)
                Circle()
                    .stroke(Color.blue,lineWidth: 1.4)
                    .frame(width: finishAnimation ? 70 : 30, height: finishAnimation ? 70 : 30)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                            .opacity(finishAnimation ? 1 : 0)
                    )
                ZStack{
                    
                    Circle()
                        .trim(from: 0, to: 0.4)
                        .stroke(Color.blue,lineWidth: 1.4)
                    Circle()
                        .trim(from: 0, to: 0.4)
                        .stroke(Color.blue,lineWidth: 1.4)
                        .rotationEffect(.init(degrees: -180))
                }
                .frame(width: 70, height: 70)
                //rotating view
                .rotationEffect(.init(degrees: startAnimation ? 360 : 0))
                
                //showing founded people
                ForEach(foundPeople){people in
                    Image(people.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .padding(4)
                        .background(Color.white.clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/))
                        .offset(people.offset)
                }
            }
            .frame(maxHeight: .infinity)
            
            //bottom sheet...
            if finishAnimation{
                VStack{
                    //pull up indicator..
                    Capsule()
                        .fill(Color.gray.opacity(0.7))
                        .frame(width: 50, height: 4)
                        .padding(.vertical, 10)
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        HStack(spacing: 15){
                            ForEach(peopols){people in
                                VStack(spacing: 15){
                                    Image(people.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                    Text(people.name)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                        Text("Choose")
                                            .fontWeight(.semibold)
                                            .padding(.vertical,10)
                                            .padding(.horizontal, 40)
                                            .background(Color.blue)
                                            .foregroundColor(Color.white)
                                            .cornerRadius(10)
                                    })
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding()
                        .padding(.bottom, getSaveArea().bottom)
                    })
                }
                .background(Color.white)
                .cornerRadius(25)
                //bottom slide ...
                .transition(.move(edge: .bottom))
            }
        }
        .ignoresSafeArea()
        .background(Color.black.opacity(0.05).ignoresSafeArea())
        .onAppear(perform: {
            animateView()
        })
    }
    
    func verifyAndAddPeople() {
        if foundPeople.count < 5 {
            withAnimation {
                var people = peopols[foundPeople.count]
                // set offset for people
                people.offset = firstFiveOffsets[foundPeople.count]
                foundPeople.append(people)
            }

        }else {
            withAnimation(Animation.linear(duration: 0.6)){
                finishAnimation.toggle()
                
                //reset all animation
                startAnimation = false
                plus1 = false
                plus2 = false
            }
            //checking animation is finished
            if !finishAnimation{
                withAnimation {foundPeople.removeAll()}
                animateView()
            }
        }
    }
    func animateView() {
        withAnimation(Animation.linear(duration: 1.7).repeatForever(autoreverses: false)){
            startAnimation.toggle()
        }
        withAnimation(Animation.linear(duration: 1.7).delay(-0.1).repeatForever(autoreverses: false)){
            plus1.toggle()
        }
        
        // second animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(Animation.linear(duration: 1.7).delay(-0.1).repeatForever(autoreverses: false)){
                plus2.toggle()
            }
        }
    }
    
}

//extend view to get safearea and screen size..
extension View {
    func getSaveArea() -> UIEdgeInsets{
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

// sample peoplemodel

struct People: Identifiable {
    var id = UUID().uuidString
    var image: String
    var name: String
    var offset: CGSize = CGSize(width: 0, height: 0)
}

var peopols = [ People(image: "pic1", name: "Anas"),
                People(image: "pic2", name: "Essam"),
                People(image: "pic3", name: "Aya"),
                People(image: "pic4", name: "Omar"),
                People(image: "pic5", name: "Ali")
]

//random offset for top 5
fileprivate var firstFiveOffsets: [CGSize] = [
    CGSize(width: 100, height: 100),
    CGSize(width: -100, height: -100),
    CGSize(width: -50, height: 130),
    CGSize(width: 50, height: -130),
    CGSize(width: 120, height: -50)
]
