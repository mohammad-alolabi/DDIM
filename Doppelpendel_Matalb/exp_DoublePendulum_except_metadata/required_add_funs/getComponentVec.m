function e = getComponentVec(n,i)
    if i<1 || i>n
        error('Choose 1<=i<=n.')
    end
    e = [zeros(1,i-1), 1, zeros(1,n-(i-1)-1)];
end