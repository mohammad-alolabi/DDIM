function expr = replaceDerivs2(expr,f,q_t,dq_t,t)
    for ii=1:f
        expr = subs(expr,diff(q_t{ii},t),dq_t{ii});
    end
    expr = formula(expr);
end