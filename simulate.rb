require 'prime'

def roll(n, verbose=false)
  rand(n)+1
end  

def gm(m, n) # Greatest multiple of m beneath n
  n - (n % m)
end

def lp(m, n) # Smallest power of n above m
  (Math.log(m)/Math.log(n)).ceil
end

def reroll_down(m, n)
  while (a=roll(m)) > m
  end
  a
end

def divide_down(m, n)
  ((m*roll(n))/(n.to_f)).ceil
end

def power_up(n, k)
  a = roll(n)
  (k-1).times do |i|
    a += (n**(i+1))*(roll(n)-1)
  end
  a
end

def prime_factors(m)
  primes = Prime.prime_division(m)
  pf = []
  for p in primes do 
    p[1].times do
      pf += [p[0]]
    end
  end
  pf
end

def largest_prime_factor_beneath?(m,n)
  largest_prime = Prime.prime_division(m)[-1][0]
  largest_prime <= n
end

def prime_up(m, n)
  p = prime_factors(m)
  k = p.count
  a = reroll_down(p[0], n)
  (k-1).times do |i|
    t = (reroll_down(p[i+1], n) - 1)
    c = 1
    (i+1).times do |j|
      c *= p[j]
    end
    a += t*c
  end
  a
end

def simulate(m, n, verbose=false)
  if m == n
    puts "Trivial method" if verbose
    puts "E=1" if verbose
    roll(n)
  elsif n % m == 0
    puts "Divide Down method" if verbose
    puts "E=1" if verbose
    divide_down(m,n)
  elsif m < n
    puts "Roll Down method" if verbose
    eff = m.to_f/n
    puts "E=#{eff}" if verbose
    ma = gm(m,n)
    v_ma = reroll_down(ma,n)
    divide_down(m,v_ma)
  elsif m > n
    if largest_prime_factor_beneath?(m,n)
      puts "Prime Up method" if verbose
      pc = prime_factors(m).count
      eff_pr = m.to_f/(pc * (n**pc))
      puts "E=#{eff_pr}" if verbose
      prime_up(m,n)
    else
      puts "Power Up method" if verbose
      k = lp(m,n)
      ma = gm(m,n**k)
      eff_po = ma.to_f/(k*(n**k))
      puts "E=#{eff_po}" if verbose
      v_n_k = power_up(n,k)
      v_ma = reroll_down(ma,n)
      divide_down(m,v_ma)
    end
  end
end

if ARGV[-1] == "-v"
  verbose = true
else
  verbose = false
end
p simulate(ARGV[0].to_i, ARGV[1].to_i, verbose)
