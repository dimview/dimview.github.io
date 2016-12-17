---
layout: post
title: "Comparing Logs"
date:   2017-02-12 00:00:00 -0500
categories: math
---

What is greater, $$log_2 3$$ or $$log_3 5$$?

<!--more-->

The trick here is to compare both to $$\frac{3}{2}$$ rather than to each other. Start
by comparing $$log_2 3$$ to $$\frac{3}{2}$$. Function $$f(x)=2^x$$ is monotonic so we 
can apply it to both sides to get

$$2^{log_2 3} \Leftrightarrow 2^{\frac{3}{2}}$$

Function $$f(x)=x^2$$ is also monotonic so we can apply it to both sides

$$3^2 \Leftrightarrow 2^3$$

and see that

$$9>8$$

therefore

$$log_2 3>\frac{3}{2}$$

Now compare $$\frac{3}{2}$$ to $$log_3 5$$. Function $$f(x)=3^x$$ is monotonic so we can apply it to both sides

$$3^{\frac{3}{2}} \Leftrightarrow 3^{log_3 5}$$

Function $$f(x)=x^2$$ is also monotonic so we can apply it to both sides

$$3^3 \Leftrightarrow 5^2$$

$$27 > 25$$

therefore

$$\frac{3}{2} > log_3 5$$

Finally

$$log_2 3 > \frac{3}{2} > log_3 5$$

Source: problem 17 in [https://arxiv.org/pdf/1110.1556v2.pdf](https://arxiv.org/pdf/1110.1556v2.pdf)