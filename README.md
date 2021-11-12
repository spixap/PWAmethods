# PWA methods for 2 variables # 
 This repository contains the scripts :scroll: for implementing PieceWise Approximations :triangular_ruler:.
 
 * The  methods are based on the [paper](https://www.sciencedirect.com/science/article/pii/S0167637709001072/ "Named link title"):

_D’Ambrosio, C., Lodi, A., Martello, S., 2010. "Piecewise linear approximation of functions of two variables in MILP models". Operations Research Letters 38, 39–46._ 


 ###  INPUTS ### 
  * `I` &nbsp; set of discretization points
  * `funSlct` &nbsp; function selection to test % {1,2,3,4,5,6}
  * `varRanges` &nbsp; x, y ranges % {'physical','paper'}
  * `activeCstrX` &nbsp; activate constraint on x % {0,1}
  * `varRanges` &nbsp; activate constraint on y % {0,1}

 
 ## METHODS :books: ## 
 
  1. __One-dimensional__
       * `oneDimensionalPWA.m` &nbsp;

  2. __Triangles__  
       * `trianglesPWA.m` 
