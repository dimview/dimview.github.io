#
# Fixed size vs. early stopping test of proportion
#
alpha <- 0.025 # Probability of finding an effect when there isn't one (either tail)
beta <- 0.2 # Probability of not finding an effect that exists
p0 <- 0.5 # Proportion under null hypothesis
p1 <- 0.4 # Proportion under alternative hypothesis (with minimal detectable effect)
give_up <- 10000  # large number to fail early

# Sample size for regular test, using normal approximation of binomial distribution
z_1_minus_beta <- qnorm(1 - beta)
z_1_minus_alpha <- qnorm(1 - alpha)
n <- round(p0 * (1- p0) * ((z_1_minus_beta + z_1_minus_alpha) / (p1 - p0)) ^ 2)
d <- round(2 * sqrt(n))
sprintf("Approximate fixed size test: n=%d, d=%d", n, d)

# Exact values for fixed size test
b0 <- 1 # Vector of probabilities, null hypothesis
b1 <- 1 # Vector of probabilities, alternative hypothesis, minimal effect size
fixed_obs <- 0
t_minus_c <- 0
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
  for (cutoff in 1:floor((i + 1) / 2)) {
    exact_alpha <- sum(b0[1:cutoff])
    exact_beta <- 1 - sum(b1[1:cutoff])
    if (exact_alpha <= alpha && exact_beta <= beta) {
      fixed_obs <- i
      t_minus_c <- i - 2 * (cutoff - 1)
      break;
    }
  }
  if (fixed_obs) {
    break;
  }
}
sprintf("Exact fixed size test: %d observations, significant if less than %d or more than %d events, alpha=%f, beta=%f", fixed_obs, cutoff, fixed_obs - cutoff, exact_alpha, exact_beta)
sprintf("Closed-form alpha=%f, beta=%f", pbinom(cutoff-1,fixed_obs,p0),1-pbinom(cutoff-1,fixed_obs,p1))

left_prob <- function(n, d, b) {
  p <- rep(0, 2 * d + 1)
  p[d + 1] <- 1
  t <- 0
  c <- 0
  r <- 0 # cumulative probabiliy of hitting left threshold
  for (i in 1:n) {
    x <- 0
    for (j in 1:(2 * d + 1)) {
      if (j == 1) {
        p[j] <- p[j + 1] * (1 - b)
      } else if (j >= (2 * d)) {
        t <- p[j]
        p[j] <- x * b
        x <- t
      } else {
        t <- p[j]
        p[j] <- p[j + 1] * (1 - b) + x * b
        x <- t
      }
    }
    r <- r + p[1];
  }
  r
}

# Start with low numbers, work up 
n <- 2
d <- 1
for (i in 1:give_up) {
  left_false_positive <- left_prob(n, d, p0)
  true_positive <- left_prob(n, d, p1)
  if (left_false_positive > alpha) {
    d <- d + 1
  } else if (true_positive < 1 - beta) {
    n <- n + 1
  } else {
    break
  }
}
sprintf("Exact: n=%d, d=%d", n, d) # expected n = 211, d=33

experiments <- 100000

# Fixed sample size
h0_wins_0_ <- 0
h1_wins_0_ <- 0
h0_wins_1_ <- 0
h1_wins_1_ <- 0

# Early stopping
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
  
  # Without early stopping
  count0 <- sum(t0[1:fixed_obs])
  if (count0 < cutoff) {
    h1_wins_0_ <- h1_wins_0_ + 1
  } else if (count0 > fixed_obs - cutoff) {
    # ignore other tail
  } else {
    h0_wins_0_ <- h0_wins_0_ + 1
  }
  count1 <- sum(t1[1:fixed_obs])
  if (count1 < cutoff) {
    h1_wins_1_ <- h1_wins_1_ + 1
  } else if (count1 > fixed_obs - cutoff) {
    # ignore other tail
  } else {
    h0_wins_1_ <- h0_wins_1_ + 1
  }
  
  # With early stopping
  cw_minus_ccw_0 <- 0
  cw_minus_ccw_1 <- 0
  t0_done <- FALSE
  t1_done <- FALSE
  o0 <- n
  o1 <- n
  for (j in 1:n) {
    cw_minus_ccw_0 <- cw_minus_ccw_0 - (t0[j] * 2 - 1)
    cw_minus_ccw_1 <- cw_minus_ccw_1 - (t1[j] * 2 - 1)
    if (!t0_done) {
      if (cw_minus_ccw_0 >= d) {
        h1_wins_0 <- h1_wins_0 + 1
        t0_done <- TRUE
        o0 <- j
      }
      if (cw_minus_ccw_0 <= -d) {
        # The other tail. Stop the test, but do not record H1 win
        t0_done <- TRUE
        o0 <- j
      }
      if (j == n) {
        h0_wins_0 <- h0_wins_0 + 1
        t0_done <- TRUE
      }
    }
    if (!t1_done) {
      if (cw_minus_ccw_1 >= d) {
        h1_wins_1 <- h1_wins_1 + 1
        t1_done <- TRUE
        o1 <- j
      }
      if (cw_minus_ccw_1 <= -d) {
        # The other tail. Stop the test, but do not record H1 win
        t1_done <- TRUE
        o1 <- j
      }
      if (j == n) {
        h0_wins_1 <- h0_wins_1 + 1
        t1_done <- TRUE
      }
    }
  }
  observations_0 <- observations_0 + o0
  observations_1 <- observations_1 + o1
}
sprintf("Without early stopping ===")
sprintf("With no effect, H0 won %d times, expected %.0f", h0_wins_0_, (1 - 2 * exact_alpha) * experiments)
sprintf("With no effect, H1 won %d times, expected %.0f (one tail)", h1_wins_0_, exact_alpha * experiments)
sprintf("With minimum detectable effect, H0 won %d times, expected %.0f", h0_wins_1_, exact_beta * experiments)
sprintf("With minimum detectable effect, H1 won %d times, expected %.0f (one tail)", h1_wins_1_, (1 - exact_beta) * experiments)
sprintf("With or without effect, %d observations before stopping", fixed_obs)

sprintf("With early stopping ===")
sprintf("With no effect, H0 won %d times, expected %d", h0_wins_0, (1 - 2 * alpha) * experiments)
sprintf("With no effect, H1 won %d times, expected %d (one tail)", h1_wins_0, alpha * experiments)
sprintf("With no effect, %.0f observations before stopping", observations_0 / experiments)
sprintf("With minimum detectable effect, H0 won %d times, expected %d", h0_wins_1, beta * experiments)
sprintf("With minimum detectable effect, H1 won %d times, expected %d (one tail)", h1_wins_1, (1 - beta) * experiments)
sprintf("With minimum detectable effect, on average %.0f observations before stopping", observations_1 / experiments)

svg('chirality.svg', width=7, height=7)
plot(0,0,main='Cat Chirality',sub='Start at (0,0). Move pin right if CW observed, move pin up if CCW observed',type='n',xlim=c(0,(n+d)/2), ylim=c(0,(n+d)/2), xlab='Clockwise', ylab='Counterclockwise')
abline(h=0:n,col = "lightgray")
abline(v=0:n,col = "lightgray")
lines(x=c(d,(n+d)/2), y=c(0,(n-d)/2), col='darkgreen')
lines(x=c(0,(n-d)/2), y=c(d,(n+d)/2), col='darkred')
lines(((n-d)/2+1):((n+d)/2-1), ((n+d)/2-1):((n-d)/2+1), col="orange")
text(5*(n+d)/12, (n+d)/6, 'Clockwise wins', col='darkgreen')
text((n+d)/7, 5*(n+d)/12, 'Counterclockwise wins', col='darkred')
text(11*(n+d)/24, 11*(n+d)/24, 'Draw', col='orange')
dev.off()
