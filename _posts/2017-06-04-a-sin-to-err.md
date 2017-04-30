---
layout: post
title: "A Sin to Err"
date:   2017-06-04 00:00:00 -0000
categories: math
---

A toy pen and paper cipher

<!--more-->

1. Pick a page from the book that has not yet been used;
2. First three digits of ciphertext is page number, with leading zeroes; 
3. Keystream is third letter of each line;
4. Convert keystream to decimal digits;
5. Convert plaintext to decimal digits;
6. Add plaintext and keystream digit by digit modulo 10 (without carry);

Use [straddling checkerboard](https://en.wikipedia.org/wiki/VIC_cipher#Straddling_checkerboard) 
to convert text to digits and back.

|       | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |
|-------|---|---|---|---|---|---|---|---|---|---|
|       | A |   | S | I | N |   | T | O | E | R |
| **1** | B | C | D | F | G | H | J | K | L | M |
| **5** | P | Q | U | V | W | X | Y | Z | . | / |

Letters in the unmarked row are represented by one digit (column number), e.g., N becomes 4. 

Letters in the other two rows are represented by two digits (row, then column), e.g., W becomes 54.

Numbers are enclosed in / symbols (59), then each digit is repeated twice, e.g., 42 becomes 59442259.

Example encoding of text as stream of digits using straddling checkerboard:

| Plaintext | H | E | L | L | O | W | O | R | L | D |
|-----------|---|---|---|---|---|---|---|---|---|---|
| Encoded   | 15|  8| 18| 18|  7| 54|  7|  9| 18| 12|
