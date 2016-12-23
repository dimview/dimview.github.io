---
layout: post
title: "Estimating Blast Yield"
date:   2017-06-11 00:00:00 -0500
categories: physics
---

![Trinity photo 1]({{ site.url }}/images/SB27.jpg)

When photos of the [first atomic bomb test](https://en.wikipedia.org/wiki/Trinity_test) were published, its [blast yield](https://en.wikipedia.org/wiki/Nuclear_weapon_yield) was still classified. But there is enough information in this picture to determine it.

<!--more-->

Start with approximate relationship between blast radius R and blast energy E:

$$\gamma \rho R^5 = E t^2$$

| E | blast energy | $$\frac{kg \cdot m}{s^2}$$ |
| $$\gamma$$ | [heat capacity ratio](https://en.wikipedia.org/wiki/Heat_capacity_ratio) | 1.4 |
| t | time | $$s$$ |
| $$\rho$$ | air density | 1.2 $$\frac{kg}{m^3}$$ |

A [kiloton of TNT](https://en.wikipedia.org/wiki/TNT_equivalent) is equivalent to approximately $$4 \cdot 10^{12} J$$, so yield in kilotons is

$$\frac{1.4 \cdot 1.2 \cdot R^5}{t^2 \cdot 4 \cdot 10^{12}}$$

Plugging in the numbers from the released pictures, with radius measured from the thin blast wave line rather than the edge of the fireball:

| t     | R    |   E   |
|:------|-----:|------:|
| 0.016 | 107  |   23  |
| 0.025 | 126  |   21  |
| 0.053 | 164  |   18  |
| 0.062 | 181  |   21  |
| 0.090 | 194  |   14  |

The average over five images is 19 kT, which turns out to be pretty close to the now declassified value.

![Trinity photo 2]({{ site.url }}/images/SB28.jpg)
![Trinity photo 3]({{ site.url }}/images/SB29.jpg)
![Trinity photo 4]({{ site.url }}/images/SB30.jpg)
![Trinity photo 5]({{ site.url }}/images/SB31.jpg)

Source: Sanjoy Mahajan, [The Art of Insight in Science and Engineering](https://mitpress.mit.edu/books/art-insight-science-and-engineering), chapter 5.2.2

Pictures from [Atomic Archive](http://www.atomicarchive.com/Photos/Trinity/)
