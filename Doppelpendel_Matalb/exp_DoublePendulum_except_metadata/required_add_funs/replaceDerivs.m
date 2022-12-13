function expr = replaceDerivs(expr,f,q_t,dq_t,t,q,dq,ddq)
    for ii=1:f
        % 1) replace q_i's and dq_i's that are differentiated w.r.t. t
            expr = subs(expr,diff(q_t{ii},t),dq(ii));
            expr = subs(expr,diff(dq_t{ii},t),ddq(ii));
        % 2) replace q_i's and dq_i's that are NOT differentiated w.r.t. t
            expr = subs(expr,q_t{ii},q(ii));
            expr = subs(expr,dq_t{ii},dq(ii));
    end
    expr = formula(expr);
end