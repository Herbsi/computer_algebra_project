QQ[x]

-- set f, g for testing
f = x^4 -1
g = 3*x^3 +x^2 +1

-- calculate S-polynomials
S_pol=(f, g) -> (
    gamma = lcm(leadMonomial(f), leadMonomial(g));
    return f * gamma // leadTerm(f) - g * gamma // leadTerm(g);
    )


division_alg = (f, g) -> (
  q = 0;
  while degree(f) >= degree(g) do (
    h = leadTerm(f) // leadTerm(g);
    f = f - h * g;
    q = q + h;
  );
  return (q,f);
)

division_alg(f,g)

-- take the polynomial f and a list l of polynomials
division_alg = (f, l) -> (
    expvec = exponents(f);
    n = #expvec;
    for i from 0 to n-1 (
    	-- compare exponent vectors
	for j from 0 to #l-1 (
	    expvecg = exponents(leadMonomial(l#j));
	    if expvec#i - expvecg >= 0 ( -- replace condition by own written comparation function
		-- create polynomial by difference of exponent vectors
	    );
	);
    );
);
