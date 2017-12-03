// Monte-Carlo simulation of Penney's game
#include <iostream>
#include <random>

int main(void)
{
  unsigned games = 10000000;
  std::default_random_engine gen(42);
  std::uniform_int_distribution<unsigned long long> dist;
  std::cout << "a_seq\tb_seq\tb:a\n";
  for (unsigned a_seq = 0; a_seq < 8; a_seq++) { // Possible choices of player A
    unsigned b_seq = ((~a_seq & 2) >> 1)  // not-second
                   | (( a_seq & 1) << 1)  // first
                   | (( a_seq & 2) << 1); // second
    unsigned a_won = 0; // Number of times player A won
    unsigned b_won = 0; // Number of times player B won
    for (unsigned game = 0; game < games; game++) {
      unsigned long long x = dist(gen);
      for (unsigned flip = 0; flip < sizeof(x) * 8; flip++) {
        if ((x & 7) == a_seq) {
          a_won++;
          break;
        }
        if ((x & 7) == b_seq) {
          b_won++;
          break;
        }
        x >>= 1;
      }
    }
    std::cout << ((a_seq & 1) ? 'H' : 'T') 
              << ((a_seq & 2) ? 'H' : 'T')
              << ((a_seq & 4) ? 'H' : 'T') << "\t" 
              << ((b_seq & 1) ? 'H' : 'T')
              << ((b_seq & 2) ? 'H' : 'T')
              << ((b_seq & 4) ? 'H' : 'T') << "\t" 
              << (double)b_won / a_won << "\n";
  }
  return 0;
}
