//
//  Appearance.swift
//  USD_Test
//
//  Created by Gina Adamova on 2025-04-12.
//

public struct Appearance: Codable, Equatable {
    
    var face: [FaceShape: Double]
    var skinTone: BodyColor
    var hairColor: HairColor
    var eyeColor: EyeColor
    
    static var defaultAppearance: Appearance {
        return Appearance(face: Appearance.defaultFaceShape, skinTone: .tan, hairColor: .brown, eyeColor: .darkBrown)
    }
    
    static var defaultFaceShape: [FaceShape: Double] = [
           .pout: 0.0,
           .eyelidPuff: 0.0,
           .noseSize: 0.0,
           .noseUpperWide: 0.0,
           .eyeHorizontal: 0.0,
           .jawSquare: 0.0,
           .eyesRound: 0.8849557638168335,
           .browsInLower: 0.0,
           .eyeMonolid: 0.0,
           .browsOutLower: 0.0,
           .frown: 0.0,
           .noseTipThick: 0.0,
           .smile: 0.0,
           .eyesDroopy: 0.0,
           .nostrilsUpper: -0.08259594440460205,
           .lipsHeart: 0.3805309534072876,
           .nostrilsLower: -0.6076698005199432,
           .front: -0.36283183097839355,
           .lipsLarge: 0.07079648971557617,
           .blink: 0.0,
           .jawOpen: 0.0,
           .noseBumb: 0.0,
           .nostrilsInner: 0.0,
           .chinShort: 0.9115043878555298,
           .eyeShapeRound: 0.0,
           .jawOval: 0.539823055267334,
           .noseTipUp: 0.6666665077209473,
           .lipsWide: -0.3097345232963562,
           .jawRound: 0.0,
           .eyeSize: 0.0,
           .nostrilsThick: -0.02359902858734131,
           .nosetipLong: -0.04424780607223511,
           .lipsThinUpper: 0.0,
           .squareChin: 0.0,
           .lipsThinLower: 0.0
       ]
}
