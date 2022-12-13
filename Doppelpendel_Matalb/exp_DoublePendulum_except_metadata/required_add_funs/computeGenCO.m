function [q_t,dq_t,t,q,dq,ddq] = computeGenCO(f)
    syms t real
    for ii=1:f
        % time-dep. function
            evalc(sprintf('syms q_%d(t)',ii));
            evalc(sprintf('q_t(%d,1) = {q_%d}',ii,ii));
    
            evalc(sprintf('syms dq_%d(t)',ii));
            evalc(sprintf('dq_t(%d,1) = {dq_%d}',ii,ii));
    
        % "regular" variables
            evalc(sprintf('syms q_%d real',ii));
            evalc(sprintf('q(%d,1) = q_%d',ii,ii));
    
            evalc(sprintf('syms dq_%d real',ii));
            evalc(sprintf('dq(%d,1) = dq_%d',ii,ii));
    
            evalc(sprintf('syms ddq_%d real',ii));
            evalc(sprintf('ddq(%d,1) = ddq_%d',ii,ii));
    end
end