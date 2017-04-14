---
layout: post
title: "Square from Four Points"
date:   2017-04-16 00:00:00 -0000
categories: chess
---

![Square from 4 points]({{ site.url }}/images/square-from-4-points.svg)

You are given one point from each side of a square. Reconstruct the square with compass and straightedge.

<!--more-->

Connect two opposite points (in this example B and D):

![Step 1]({{ site.url }}/images/square-from-4-points-1.svg)

Drop perpendicular from A onto BD:

![Step 1]({{ site.url }}/images/square-from-4-points-2.svg)

Mark point E on this perpendicular such that AE = BD. Point E will fall on the side of the square with C (or its extension):

![Step 1]({{ site.url }}/images/square-from-4-points-3.svg)

Once you have the orientation of one side of the square (line EC), drop the remaining perpendiculars to find the corners. 

Source: problem 20 in [https://arxiv.org/pdf/1110.1556v2.pdf](https://arxiv.org/pdf/1110.1556v2.pdf)
