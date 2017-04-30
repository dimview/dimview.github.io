---
layout: post
title: "Look and Say Polynomial"
date:   2017-10-05 00:00:00 -0000
categories: math
---

1, 11, 21, 1211, 111221, 312211, 13112221, ...

And the next element of the sequence is...

<!--more-->

...1113213211.

Just read 13112221 as "one 1, one 3, two 1s, three 2s, one 1".  This is look-and-say sequence 
([A005150](https://oeis.org/A005150) in the OEIS).

Each next number is about 30% longer. More precisely, if $$L_i$$ denotes the number of digits of the $$i$$-th member of the sequence, then

$$\lim_{n\rightarrow\infty}\frac{L_{n+1}}{L_n} = \lambda \approx 1.303577$$

One can enumerate 92 possible subsequences, construct a transition matrix, interpret it is a 
recurrence relation for the length of terms in the look-and-say sequence, recall that limiting 
ratio of terms in the sequence is equal to the spectral radius of the transition matrix,
and finally find $$\lambda$$, the only positive rational root of [Conway's polynomial](https://oeis.org/A137275)

$$x^{71}\\
-x^{69}-2x^{68}-x^{67}+2x^{66}+2x^{65}+x^{64}-x^{63}-x^{62}-x^{61}-x^{60}\\
-x^{59}+2x^{58}+5x^{57}+3x^{56}-2x^{55}-10x^{54}-3x^{53}-2x^{52}+6x^{51}+6x^{50}\\
+x^{49}+9x^{48}-3x^{47}-7x^{46}-8x^{45}-8x^{44}+10x^{43}+6x^{42}+8x^{41}-5x^{40}\\
-12x^{39}+7x^{38}-7x^{37}+7x^{36}+x^{35}-3x^{34}+10x^{33}+x^{32}-6x^{31}-2x^{30}\\
-10x^{29}-3x^{28}+2x^{27}+9x^{26}-3x^{25}+14x^{24}-8x^{23}-7x^{21}+9x^{20}\\
+3x^{19}-4x^{18}-10x^{17}-7x^{16}+12x^{15}+7x^{14}+2x^{13}-12x^{12}-4x^{11}-2x^{10}\\
+5x^{9}+x^{7}-7x^{6}+7x^{5}-4x^{4}+12x^{3}-6x^{2}+3x-6$$\\

using a computer algebra system like wxMaxima:

    float(realroots(x^71
    -x^69-2*x^68-x^67+2*x^66+2*x^65+x^64-x^63-x^62-x^61-x^60
    -x^59+2*x^58+5*x^57+3*x^56-2*x^55-10*x^54-3*x^53-2*x^52+6*x^51+6*x^50
    +x^49+9*x^48-3*x^47-7*x^46-8*x^45-8*x^44+10*x^43+6*x^42+8*x^41-5*x^40
    -12*x^39+7*x^38-7*x^37+7*x^36+x^35-3*x^34+10*x^33+x^32-6*x^31-2*x^30
    -10*x^29-3*x^28+2*x^27+9*x^26-3*x^25+14*x^24-8*x^23-7*x^21+9*x^20
    +3*x^19-4*x^18-10*x^17-7*x^16+12*x^15+7*x^14+2*x^13-12*x^12-4*x^11-2*x^10
    +5*x^9+x^7-7*x^6+7*x^5-4*x^4+12*x^3-6*x^2+3*x-6, 1e-8));

Source: [Nathaniel Johnston](http://www.njohnston.ca/2010/10/a-derivation-of-conways-degree-71-look-and-say-polynomial/)
