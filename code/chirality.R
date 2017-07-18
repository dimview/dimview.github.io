#
# Fixed size vs. early stopping test of proportion
#
alpha <- 0.05 # Probability of finding an effect (in either left or right tail) when there isn't one
beta <- 0.2 # Probability of not finding an effect that exists
p0 <- 0.5 # Proportion under null hypothesis
p1 <- 0.4 # Proportion under alternative hypothesis (with minimal detectable effect)
give_up <- 10^4  # Large number to stop iterating and fail early, before exhausing computer memory and experimenter's patience 
experiments <- 10^5 # Number of Monte-Carlo simulations

#1#################################################################################################
# Use normal approximation of binomial distribution
z_1_minus_beta <- qnorm(1 - beta)
z_1_minus_alpha_2 <- qnorm(1 - alpha / 2)
approx_n <- round(p0 * (1 - p0) * ((z_1_minus_beta + z_1_minus_alpha_2) / (p1 - p0)) ^ 2)
approx_d <- round(z_1_minus_alpha_2 * sqrt(approx_n))
sprintf("1) Fixed size, approximate thresholds approx_n=%d, approx_d=%d", approx_n, approx_d)
h0_wins_0 <- 0
h1_wins_0 <- 0
h0_wins_1 <- 0
h1_wins_1 <- 0
for (i in 1:experiments) {
  # Simulated test data for null hypothesis (no effect)
  t0 <- rbinom(approx_n, 1, p0)
  
  # Simulated test data for alternative hypothesis (minimal detectable effect)
  t1 <- rbinom(approx_n, 1, p1)
  
  count0 <- sum(t0)
  if (count0 < (approx_n - approx_d) / 2) {
    h1_wins_0 <- h1_wins_0 + 1
  } else if (count0 > (approx_n + approx_d) / 2) {
    # ignore other tail
  } else {
    h0_wins_0 <- h0_wins_0 + 1
  }
  count1 <- sum(t1)
  if (count1 < (approx_n - approx_d) / 2) {
    h1_wins_1 <- h1_wins_1 + 1
  } else if (count1 > (approx_n + approx_d) / 2) {
    # ignore other tail
  } else {
    h0_wins_1 <- h0_wins_1 + 1
  }
}
sprintf("With no effect, H0 won %d times, expected approximately %.0f", h0_wins_0, (1 - alpha) * experiments)
sprintf("With no effect, H1 won %d times, expected approximately %.0f", h1_wins_0, alpha * experiments / 2)
sprintf("With minimum detectable effect, H0 won %d times, expected approximately %.0f", h0_wins_1, beta * experiments)
sprintf("With minimum detectable effect, H1 won %d times, expected approximately %.0f", h1_wins_1, (1 - beta) * experiments)

svg('chirality1.svg', width=7, height=7)
plot(0,0,main='Fixed Size, Approximate Thresholds',type='n',xlim=c(0,250), ylim=c(0,250), xlab='Clockwise', ylab='Counterclockwise')
lines(x=c((approx_n+approx_d)/2+1,approx_n), y=c((approx_n-approx_d)/2-1,0), col='darkgreen')
lines(x=c((approx_n-approx_d)/2-1,0), y=c((approx_n+approx_d)/2+1,approx_n), col='red')
lines(x=c((approx_n+approx_d)/2,(approx_n-approx_d)/2), y=c((approx_n-approx_d)/2,(approx_n+approx_d)/2), col="orange")
text(0.75*250, 0.2*250, 'Clockwise wins', col='darkgreen')
text(0.3*250, 0.7*250, 'Counterclockwise wins', col='red')
text(0.45*250, 0.45*250, 'Draw', col='orange')
dev.off()

#2#################################################################################################
# Exact values for fixed size test
b0 <- 1 # Vector of probabilities, null hypothesis
b1 <- 1 # Vector of probabilities, alternative hypothesis, minimal effect size
fixed_obs <- 0
cutoff <- 0
for (i in 1:give_up) {
  b0[i + 1] <- p0 * b0[i]
  b1[i + 1] <- p1 * b1[i]
  if (i > 1) {
    for (j in i:2) {
      b0[j] <- p0 * b0[j - 1] + (1 - p0) * b0[j]
      b1[j] <- p1 * b1[j - 1] + (1 - p1) * b1[j]
    }
  }  
  b0[1] <- (1 - p0) * b0[1]
  b1[1] <- (1 - p1) * b1[1]
  for (k in 1:floor((i + 1) / 2)) {
    exact_alpha_2 <- sum(b0[1:k])
    exact_beta <- 1 - sum(b1[1:k])
    if (exact_alpha_2 <= alpha / 2 && exact_beta <= beta) {
      fixed_obs <- i
      cutoff <- k
      break;
    }
  }
  if (fixed_obs) { # Keep increasing number of observations unless both alpha and beta conditions are satisfied
    break;
  }
}
sprintf("2) Fixed Size, Exact Thresholds: %d observations, significant if less than %d or more than %d events", fixed_obs, cutoff, fixed_obs - cutoff)
sprintf("Exact alpha=%f, beta=%f. Closed-form alpha=%f, beta=%f", 2 * exact_alpha_2, exact_beta, 2*pbinom(cutoff-1,fixed_obs,p0),1-pbinom(cutoff-1,fixed_obs,p1))
h0_wins_0 <- 0
h1_wins_0 <- 0
h0_wins_1 <- 0
h1_wins_1 <- 0
for (i in 1:experiments) {
  # Simulated test data for null hypothesis (no effect)
  t0 <- rbinom(fixed_obs, 1, p0)
  
  # Simulated test data for alternative hypothesis (minimal detectable effect)
  t1 <- rbinom(fixed_obs, 1, p1)
  
  count0 <- sum(t0)
  if (count0 < cutoff) {
    h1_wins_0 <- h1_wins_0 + 1
  } else if (count0 > fixed_obs - cutoff) {
    # ignore other tail
  } else {
    h0_wins_0 <- h0_wins_0 + 1
  }
  count1 <- sum(t1)
  if (count1 < cutoff) {
    h1_wins_1 <- h1_wins_1 + 1
  } else if (count1 > fixed_obs - cutoff) {
    # ignore other tail
  } else {
    h0_wins_1 <- h0_wins_1 + 1
  }
}
sprintf("With no effect, H0 won %d times, expected %.0f, required %.0f or more", h0_wins_0, (1 - 2 * exact_alpha_2) * experiments, (1 - alpha) * experiments)
sprintf("With no effect, H1 won %d times, expected %.0f, required less than %.0f", h1_wins_0, exact_alpha_2 * experiments, alpha * experiments / 2)
sprintf("With minimum detectable effect, H0 won %d times, expected %.0f, required less than %.0f", h0_wins_1, exact_beta * experiments, beta * experiments)
sprintf("With minimum detectable effect, H1 won %d times, expected %.0f, required %.0f or more", h1_wins_1, (1 - exact_beta) * experiments, (1 - beta) * experiments)
svg('chirality2.svg', width=7, height=7)
plot(0,0,main='Fixed Size Test',type='n',xlim=c(0,250), ylim=c(0,250), xlab='Clockwise', ylab='Counterclockwise')
lines(x=c(fixed_obs-cutoff+1,fixed_obs), y=c(cutoff-1,0), col='darkgreen')
lines(x=c(cutoff-1,0), y=c(fixed_obs-cutoff+1,fixed_obs), col='red')
lines(x=c(fixed_obs-cutoff,cutoff), y=c(cutoff,fixed_obs-cutoff), col="orange")
text(0.75*250, 0.2*250, 'Clockwise wins', col='darkgreen')
text(0.3*250, 0.7*250, 'Counterclockwise wins', col='red')
text(0.45*250, 0.45*250, 'Draw', col='orange')
dev.off()

#3#################################################################################################
# Brute force search for thresholds.
# Start with low numbers, increase until error rates are below alpha and beta
for (d in 1:give_up) {
  b0 <- numeric(2 * d + 1) # Vector of probabilities under null hypothesis
  b0[d + 1] <- 1
  b1 <- numeric(2 * d + 1) # Vector of probabilities under alternative hypothesis
  b1[d + 1] <- 1
  for (n in 1:give_up) {
    b0 <- c(b0[1], 0, b0[2:(length(b0)-1)]*p0) + c(b0[2:(length(b0)-1)]*(1-p0), 0, b0[length(b0)])
    b1 <- c(b1[1], 0, b1[2:(length(b1)-1)]*p1) + c(b1[2:(length(b1)-1)]*(1-p1), 0, b1[length(b1)])
    if ((b0[1] > alpha / 2) || (b1[1] >= 1 - beta)) {
      break;
    }
  }
  if ((b0[1] <= alpha / 2) && (b1[1] >= 1 - beta)) {
    break;
  }
}
fp <- b0[1]
tp <- b1[1]
m <- (n - d) / 2 + 1
sprintf("3) Early stopping, n=%d, m=%d, d=%d, fp=%f, tp=%f", n, m, d, fp, tp) # expected n = 211, d=33
h0_wins_0 <- 0
h1_wins_0 <- 0
h0_wins_1 <- 0
h1_wins_1 <- 0
observations_0 <- 0
observations_1 <- 0
for (i in 1:experiments) {
  # Simulated test data for null hypothesis (no effect)
  t0 <- rbinom(n, 1, p0)
  
  # Simulated test data for alternative hypothesis (minimal detectable effect)
  t1 <- rbinom(n, 1, p1)
  
  cw_minus_ccw_0 <- 0
  cw_minus_ccw_1 <- 0
  o0 <- 0                # Number of observations when the test stopped, no effect
  o1 <- 0                # Number of observations when the test stopped, minimal detectable effect
  cw0 <- cumsum(t0)      # Cumulative number of clockwise curls, no effect
  ccw0 <- cumsum(1 - t0) # Cumulative number of clockwise curls, no effect
  cw1 <- cumsum(t1)      # Cumulative number of clockwise curls, minimal detectable effect
  ccw1 <- cumsum(1 - t1) # Cumulative number of counterclockwise curls, minimal detectable effect
  for (j in 1:n) {
    
    if (o0 == 0) {
      if (cw0[j] - ccw0[j] >= d) {
        # The other tail. Stop the test, but do not record H1 win
        o0 <- j
      }
      if (cw0[j] - ccw0[j] <= -d) {
        h1_wins_0 <- h1_wins_0 + 1
        o0 <- j
      }
      if (cw0[j] >= m && ccw0[j] >= m) {
        h0_wins_0 <- h0_wins_0 + 1
        o0 <- j
      }
    }
    if (o1 == 0) {
      if (cw1[j] - ccw1[j] >= d) {
        # The other tail. Stop the test, but do not record H1 win
        o1 <- j
      }
      if (cw1[j] - ccw1[j] <= -d) {
        h1_wins_1 <- h1_wins_1 + 1
        o1 <- j
      }
      if (cw1[j] >= m && ccw1[j] >= m) {
        h0_wins_1 <- h0_wins_1 + 1
        o1 <- j
      }
    }
    if (o0 && o1) {
      break
    }
  }
  observations_0 <- observations_0 + o0
  observations_1 <- observations_1 + o1
}
sprintf("With no effect, H0 won %d times, expected %.0f, required %.0f or more", h0_wins_0, (1 - 2 * fp) * experiments, (1 - alpha) * experiments)
sprintf("With no effect, H1 won %d times, expected %.0f, required less than %.0f", h1_wins_0, fp * experiments, alpha * experiments / 2)
sprintf("With no effect, on average %.0f observations before stopping", observations_0 / experiments)
sprintf("With minimum detectable effect, H0 won %d times, expected %.0f, required less than %.0f", h0_wins_1, (1 - tp) * experiments, beta * experiments)
sprintf("With minimum detectable effect, H1 won %d times, expected %.0f, required %.0f or more", h1_wins_1, tp * experiments, (1 - beta) * experiments)
sprintf("With minimum detectable effect, on average %.0f observations before stopping", observations_1 / experiments)

svg('chirality3.svg', width=7, height=7)
plot(0,0,main='Early Stopping',type='n',xlim=c(0,250), ylim=c(0,250), xlab='Clockwise', ylab='Counterclockwise')
lines(x=c(d,(n+d)/2), y=c(0,(n-d)/2), col='darkgreen')
lines(x=c(0,(n-d)/2), y=c(d,(n+d)/2), col='red')
lines(c((n-d)/2+1,(n-d)/2+1,(n+d)/2-1), c((n+d)/2-1,(n-d)/2+1,(n-d)/2+1), col="orange")
text(90, 20, 'Clockwise wins', col='darkgreen')
text(40, 120, 'Counterclockwise wins', col='red')
text(106,100, 'Draw', col='orange')
dev.off()

###################################################################################################
# Printable chart
svg('chirality.svg', width=7, height=7)
plot(0,0,main='Cat Chirality',type='n',xlim=c(0,125), ylim=c(0,125), xlab='Clockwise', ylab='Counterclockwise')
segments(0:((n+d)/2-1),
         c(rep(0,d),0:((n-d)/2-1)),
         0:((n+d)/2-1),
         c(d:((n+d)/2),rep((n-d)/2+1,d-1)),
         col = c('gray','lightgray','lightgray','lightgray','lightgray'))
segments(c(rep(0,d),0:((n-d)/2-1)),
         0:((n+d)/2-1),
         c(d:((n+d)/2),rep((n-d)/2+1,d-1)),
         0:((n+d)/2-1),
         col = c('gray','lightgray','lightgray','lightgray','lightgray'))
lines(x=c(d,(n+d)/2), y=c(0,(n-d)/2), col='darkgreen')
lines(x=c(0,(n-d)/2), y=c(d,(n+d)/2), col='red')
lines(c((n-d)/2+1,(n-d)/2+1,(n+d)/2-1), c((n+d)/2-1,(n-d)/2+1,(n-d)/2+1), col="orange")
text(90, 20, 'Clockwise wins', col='darkgreen')
text(40, 110, 'Counterclockwise wins', col='red')
text(100,100, 'Draw', col='orange')
dev.off()

#4#################################################################################################
# Greedy early stopping
print("4) Greedy early stopping")
w <- 1000 # Exact value is not important, but should be >d, so just pick a large number.
b0 <- numeric(2 * w + 1) # Vector of probabilities under null hypothesis
b0[w + 1] <- 1
b1 <- numeric(2 * w + 1) # Vector of probabilities under alternative hypothesis
b1[w + 1] <- 1
under_left_tail_0 <- 0
under_left_tail_1 <- 0
left_edge <- w
qx <- numeric() # x coordinates of cutoff points
qy <- numeric() # y coordinates of cutoff points
q <- 0 # number of cutoff points
for (i in 1:w) {
  b0 <- c(0, b0[1:(length(b0)-1)]*p0) + c(b0[2:(length(b0))]*(1-p0), 0)
  b1 <- c(0, b1[1:(length(b1)-1)]*p1) + c(b1[2:(length(b1))]*(1-p1), 0)
  if (b0[left_edge]/b1[left_edge] <= (alpha / 2) / (1 - beta)) {
    under_left_tail_0 <- under_left_tail_0 + b0[left_edge]
    b0[left_edge] <- 0
    under_left_tail_1 <- under_left_tail_1 + b1[left_edge]
    b1[left_edge] <- 0
    q <- q + 1
    qx[q] <- (i+left_edge-w-1)/2
    qy[q] <- (i-left_edge+w+1)/2
    left_edge <- left_edge + 1
    if (left_edge > w || (under_left_tail_0 <= alpha / 2 && under_left_tail_1 >= 1 - beta)) {
      print(sprintf("under_left_tail_0=%f, under_left_tail_1=%f", under_left_tail_0, under_left_tail_1))
      break;
    }
  } else {
    left_edge <- left_edge - 1
  }
}
h0_wins_0 <- 0
h1_wins_0 <- 0
h0_wins_1 <- 0
h1_wins_1 <- 0
observations_0 <- 0
observations_1 <- 0
n <- qx[q] + qy[q]
for (i in 1:experiments) {
  # Simulated test data for null hypothesis (no effect)
  t0 <- rbinom(n, 1, p0)
  
  # Simulated test data for alternative hypothesis (minimal detectable effect)
  t1 <- rbinom(n, 1, p1)
  
  cw_minus_ccw_0 <- 0
  cw_minus_ccw_1 <- 0
  o0 <- 0                # Number of observations when the test stopped, no effect
  o1 <- 0                # Number of observations when the test stopped, minimal detectable effect
  cw0 <- cumsum(t0)      # Cumulative number of clockwise curls, no effect
  ccw0 <- cumsum(1 - t0) # Cumulative number of clockwise curls, no effect
  cw1 <- cumsum(t1)      # Cumulative number of clockwise curls, minimal detectable effect
  ccw1 <- cumsum(1 - t1) # Cumulative number of counterclockwise curls, minimal detectable effect
  for (j in 1:n) {
    if (o0 == 0) {
      if (cw0[j] < q && ccw0[j] >= qy[cw0[j]+1]) {
        h1_wins_0 <- h1_wins_0 + 1
        o0 <- j
      }
      if (ccw0[j] < q && cw0[j] >= qy[ccw0[j]+1]) {
        # The other tail. Stop the test, but do not record H1 win
        o0 <- j
      }
      if (cw0[j] > q && ccw0[j] > q) {
        h0_wins_0 <- h0_wins_0 + 1
        o0 <- j
      }
    }
    if (o1 == 0) {
      if (cw1[j] < q && ccw1[j] >= qy[cw1[j]+1]) {
        h1_wins_1 <- h1_wins_1 + 1
        o1 <- j
      }
      if (ccw1[j] < q && cw1[j] >= qy[ccw1[j]+1]) {
        # The other tail. Stop the test, but do not record H1 win
        o1 <- j
      }
      if (cw0[j] > q && ccw0[j] > q) {
        h0_wins_1 <- h0_wins_1 + 1
        o1 <- j
      }
    }
    if (o0 && o1) {
      break
    }
  }
  observations_0 <- observations_0 + o0
  observations_1 <- observations_1 + o1
}
sprintf("With no effect, H0 won %d times, expected %.0f, required %.0f or more", h0_wins_0, (1 - 2 * under_left_tail_0) * experiments, (1 - alpha) * experiments)
sprintf("With no effect, H1 won %d times, expected %.0f, required less than %.0f", h1_wins_0, under_left_tail_0 * experiments, alpha * experiments / 2)
sprintf("With no effect, on average %.0f observations before stopping", observations_0 / experiments)
sprintf("With minimum detectable effect, H0 won %d times, expected %.0f, required less than %.0f", h0_wins_1, (1 - under_left_tail_1) * experiments, beta * experiments)
sprintf("With minimum detectable effect, H1 won %d times, expected %.0f, required %.0f or more", h1_wins_1, under_left_tail_1 * experiments, (1 - beta) * experiments)
sprintf("With minimum detectable effect, on average %.0f observations before stopping", observations_1 / experiments)

svg('chirality4.svg', width=7, height=7)
plot(0,0,main='Greedy Early Stopping',type='n',xlim=c(0,250), ylim=c(0,250), xlab='Clockwise', ylab='Counterclockwise')
lines(x=qx, y=qy, col='red')
lines(x=qy, y=qx, col='darkgreen')
lines(c(qx[q]+1,qx[q]+1,qy[q]-1), c(qy[q]-1,qx[q]+1,qx[q]+1), col="orange")
text(90, 20, 'Clockwise wins', col='darkgreen')
text(40, 130, 'Counterclockwise wins', col='red')
text(126,120, 'Draw', col='orange')
dev.off()
