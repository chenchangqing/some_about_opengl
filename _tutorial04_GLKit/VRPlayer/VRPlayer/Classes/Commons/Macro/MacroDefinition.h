//
//  MacroDefinition.h
//  Pods
//
//  Created by green on 16/5/26.
//
//

#ifndef MacroDefinition_h
#define MacroDefinition_h

//----------------------颜色类---------------------------

#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]    
#define RGBAColor(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]         
#define RandColor RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

//----------------------颜色类--------------------------- 


#endif /* MacroDefinition_h */
