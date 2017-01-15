---
layout: post
title: "Estimating BDBA Probability"
date:   2017-01-15 00:00:00 -0500
categories: math
---

![Indian Point Energy Center]({{ site.url }}/images/indian-point.jpg)

[DBA](https://www.nrc.gov/reading-rm/basic-ref/glossary/design-basis-accident.html) (Design Basis Accident) is an accident that a nuclear facility is designed to withstand.

[BDBA](https://www.nrc.gov/reading-rm/basic-ref/glossary/beyond-design-basis-accidents.html) (Beyond Design Basis Accident) is an accident that was not fully considered in the design process because it was judged to be too unlikely.

Let's try to quantify *how* unlikely.

<!--more-->

There are complex methods to do that based on fault tree analysis, but we'll do rough approximation instead. There were 3 serious accidents ([Three Mile Island](https://en.wikipedia.org/wiki/Three_Mile_Island_accident), [Chernobyl](https://en.wikipedia.org/wiki/Chernobyl_disaster), and [Fukushima](https://en.wikipedia.org/wiki/Fukushima_Daiichi_nuclear_disaster)) in approximately 15,000 reactor-years, corresponding to return period of 5,000 years and probability $$2 \cdot 10^{-4}$$ per year.

So a nuclear power plant like [Indian Point](https://en.wikipedia.org/wiki/Indian_Point_Energy_Center) with two reactors has BDBA probability of about 1% in 25 years. This is actually a pretty high number. For comparison, $$10^{-4}$$ is probability of fatal injury in one year among construction workers.

Apparently this is not the reason [Indian Point will be closed by April 2021](https://www.nytimes.com/2017/01/09/nyregion/cuomo-indian-point-nuclear-plant.html), but it should be.