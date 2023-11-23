
//  RingView.swift
//  FitnessApp
//
//  Created by Michela D'Avino on 20/11/23.
//

import SwiftUI


struct RingView: View {
    
    @State var currentPercentage: Double = 0
    
    
    
    var percentage : Double
    
    var backgroundColor: Color
  //  var startColor: Color
    var endColor: Color
    var thickness: CGFloat

    var animation: Animation {
        Animation.easeInOut(duration: 1)
    }
    
    var body: some View {
        
        
  //      let gradient = AngularGradient(gradient: Gradient(colors: [startColor, endColor]), center: .center, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360 * currentPercentage))
        
        return ZStack {
            
            RingBackgroundShape(thickness: thickness)
                .fill(backgroundColor)
               
                
                
            
            RingShape(currentPercentage: currentPercentage, thickness: thickness)
                .fill(Color("ringProgress"))
//            Ruota l'anello di progresso di -90 gradi in senso antiorario, in modo che l'animazione inizi dalla parte superiore anziché dalla parte destra.
                .rotationEffect(.init(degrees: -90))
                .shadow(radius: 2)
                .drawingGroup()
                .onAppear() {
                    //rallentare animazione di un sec
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            l'animazione viene avviata utilizzando withAnimation, e la proprietà currentPercentage viene aggiornata al valore desiderato (self.percentage).
                        withAnimation(self.animation) {
                            self.currentPercentage = self.percentage
                        }
                    }
                    
                }
            
            
            RingTipShape(currentPercentage: currentPercentage, thickness: thickness)
//            Se currentPercentage è maggiore di 1, la punta viene riempita con endColor, altrimenti è resa trasparente (clear)
                .fill(currentPercentage > 1 ? endColor : .clear)
                .rotationEffect(.init(degrees: -90))
                .shadow(radius: 2)
                
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(self.animation) {
                            self.currentPercentage = self.percentage
                        }
                    }
                }
        }
    }
    
}

struct RingShape: Shape {
    
    var currentPercentage: Double
    var thickness: CGFloat
    
//    genera un tracciato di un cerchio in base alla percentuale corrente
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.addArc(
            center: CGPoint(x: rect.width / 2, y: rect.height / 2),
            radius: rect.width / 2 - thickness,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 360 * currentPercentage),
            clockwise: false
        )
        
        return path
            .strokedPath(.init(lineWidth: thickness, lineCap: .round, lineJoin: .round))
    }
    
    var animatableData: Double {
        get { return currentPercentage }
        set { currentPercentage = newValue }
    }
    
}

struct RingTipShape: Shape {
    
    
    var currentPercentage: Double
    var thickness: CGFloat
    
    
// sta generando un punto sulla circonferenza di un cerchio più grande e sta quindi creando un cerchio più piccolo---->punta anello di progresso
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
//        Calcola l'angolo in radianti corrispondente alla percentuale corrente rispetto a un cerchio completo (360 gradi).
        let angle = CGFloat((360 * currentPercentage) * .pi / 180)
//        Calcola il raggio del cerchio più grande, ridotto dallo spessore del tracciato.
        let controlRadius: CGFloat = rect.width / 2 - thickness
//        Calcola il centro del cerchio più grande.
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
//        Calcola la coordinata x del punto sulla circonferenza del cerchio più grande.
        let x = center.x + controlRadius * cos(angle)
        let y = center.y + controlRadius * sin(angle)
//        Crea un punto pointCenter sulla circonferenza del cerchio più grande.
        let pointCenter = CGPoint(x: x, y: y)
//        Aggiunge un'ellisse al percorso, rappresentando il cerchio più piccolo, centrato sul punto pointCenter.
        path.addEllipse(in:
            CGRect(
                x: pointCenter.x - thickness / 2,
                y: pointCenter.y - thickness / 2,
                width: thickness,
                height: thickness
            )
        )
        
        return path
    }
    
    var animatableData: Double {
//        restituisce la percentuale corrente come dato da animare e imposta la percentuale corrente al nuovo valore quando viene modificato durante l'animazione.
        get {
            return currentPercentage
        }
        set {
            currentPercentage = newValue
        }
    }
    
}

struct RingBackgroundShape: Shape {
    
    var thickness: CGFloat
//    definisce la forma di un arco all'interno di un rettangolo specificato. crea un cerchio pieno, poiché l'angolo di inizio è 0 gradi e l'angolo di fine è 360 gradi.
    
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.addArc(
            center: CGPoint(x: rect.width / 2, y: rect.height / 2),
            radius: rect.width / 2 - thickness,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 360),
            clockwise: false //senso orario o antiorario
        
        )
        
        return path
            .strokedPath(.init(lineWidth: thickness, lineCap: .round, lineJoin: .round))
    }
    
    
}

#Preview {
    RingView(percentage: 0.65, backgroundColor: (Color(red: 0.2, green: 0.11, blue: 0.15)), endColor: Color("ringProgress"), thickness: 30)
}
