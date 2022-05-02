-- Helper function that checkes whether m1 | m2 since m2 % m1 == 0 is forbidden
monomialDividesP = (m1, m2) -> (
        e1 := (exponents(m1))#0;
        e2 := (exponents(m2))#0;
        -- transposition converts the two vectors into a list of pairs
        -- second argument to all is a lambda fucntion which compares exponents
        return all(transpose({e1, e2}), e -> e#0 <= e#1);
);

-- function which devides m2 by m1 given m1 | m2
monomialDivide = (m1, m2) -> (
    e1 := (exponents(m1))#0;
    e2 := (exponents(m2))#0;
    c1 := leadCoefficient(m1);
    c2 := leadCoefficient(m2);
    e := e2 - e1;
    theRing := ring(m1);
    c2 / c1 * theRing_e
);

-- take the polynomial f and a list l of polynomials
-- and return a list of coefficients qs and a remainder r such that
-- \sum_i f = qs#i * l#i + r
-- and none of the leading terms of the l_i divide any term of r
division_alg = (f, l) -> (
    s := length l;
    -- Initialize coefficients and remainder to 0
    qs := new MutableList from apply(toList(1..s), i -> 0);
    r := 0;
    while f != 0 do (
        i := 0;
        -- remember whether we divide out a term
        divOccurred := false;
        while i < s and (not divOccurred) do (
            -- the current l_i divides the leading monomial of f
            -- so we subtract a multiple of f and add it to the q_i
            if monomialDividesP(leadMonomial(l#i), leadMonomial(f)) then (
              qs#i = qs#i + monomialDivide(leadTerm(l#i), leadTerm(f));
              f = f - monomialDivide(leadTerm(l#i), leadTerm(f)) * l#i;
              divOccurred = true;
            ) else (
              i = i + 1;
            );
        );
        -- None of the leading monomials of the ls divide the leading monomial of f anymore
        -- So the leading term of f gets added to the remainder
        -- We subtract it from f and continue with theh algorithm (unless f is 0)
        if (not divOccurred) then (
            r = r + leadTerm(f);
            f = f - leadTerm(f);
        );
    );
    { toList qs, r }
);

-- These two examples give the same result as in the book pg. 62–63
QQ[x,y,MonomialOrder=>Lex];
f = x*y^2 + 1;
gs = {x*y + 1, y + 1};
division_alg(f, gs)

f = x^2*y + x*y^2 + y^2;
gs = { x*y - 1, y^2 - 1 };
division_alg(f, gs)
