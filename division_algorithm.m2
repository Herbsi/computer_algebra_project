QQ[x]

-- set f, g for testing
f = x^4 -1
g = 3*x^3 +x^2 +1

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
