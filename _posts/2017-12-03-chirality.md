---
layout: post
title: "Determining Cat Chirality"
date:   2017-12-03 00:00:00 -0000
categories: math
---

![Chirality example]({{ site.url }}/images/chirality.jpg)

Does your cat prefer to sleep like this &#10227; (clockwise), like this &#10226; (counterclockwise), or has no preference? Let's science it out.
<!--more-->
Start with experimental design using ancient and much maligned null hypothesis significance testing framework.

Null hypothesis is that the cat does not care, and curls in either direction with probability p<sub>0</sub>=0.5.

Alternative hypothesis is that the cat does have a preference, and probability of curling in one particular direction is p<sub>1</sub>=0.4 or less.

We want to be able to detect effect of this magnitude or higher (provided that it exists) with probability 1-&beta;=0.8. This is statistical power.

If there is no effect, we want to (erroneoulsy) find it with probability no more than 0.05. In this example we have two tails, left and right, each with &alpha;=0.025. This is significance level.

We can calculate necessary number of observations (sample size, in this case 199) and critical values (86 and 113), but it requires us to wait until the test is over before drawing a conclusion. Even if we observe 100 consecutive &#10227; and no &#10226;, we still have to keep going, otherwise the result won't have the nice statistical properties.

A better approach is to use sequential test design with early stopping [described by Evan Miller](http://www.evanmiller.org/sequential-ab-testing.html). We don't have a control so can't use that calculator or tables directly, but it's not difficult to [do it from scratch in R]({{ site.url }}/code/chirality.R) and also Monte-Carlo to make sure the math works out.

Algorithm:

* Keep two counters, initially zero: *cw* and *ccw*
* When &#10227; is observed, increment *cw*
* When &#10226; is observed, increment *ccw*
* If *cw - ccw == 33*, stop the test. Cat prefers &#10227;
* If *ccw - cw == 33*, stop the test. Cat prefers &#10226;
* If *cw + ccw == 211*, stop the test. No preference detected

If there is a strong effect, this test stops sooner. With minimum detectable effect size it takes on average 155 observations instead of 199, and even less if effect is stronger. There is no free lunch, though. The downside is that if the effect is very small, the test takes longer (on average, 209 instead of 199 observations). Not 211 because of the false positives.

To keep track of the experiment, the following chart can be useful. 

![Chirality chart]({{ site.url }}/images/chirality.svg)

Print it out, put a pin or a dot in the lower left corner (at coordinates (0,0)).

* When you observe &#10227;, move the pin right by one
* When you observe &#10226;, move the pin up by one
* If the pin reaches the red line, stop the test. Cat prefers &#10226;
* If the pin reaches the green line, stop the test. Cat prefers &#10227;
* If the pin reaches the yellow line, stop the test. No preference detected
