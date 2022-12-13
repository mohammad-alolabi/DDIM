function [Mass,tf,f] = ODEviaLagrange(L,f,q_t,dq_t,t,q,dq,ddq,params,F_mat,r_mat,u)
    %%
    arguments
    % mandatory
        L
        f
        q_t
        dq_t
        t 
        q
        dq
        ddq
    % optional
        params = {}
        F_mat  = [] % as a function of q and u
        r_mat  = [] % as a function of q
        u      = []
    end

    %% execute Lagrange Formalism
    dyn = sym('dyn',[f,1]);
    for ii=1:f
        dyn(ii,1) = diff(diff(L,dq_t{ii}),t) - diff(L,q_t{ii});
    end
    dyn = replaceDerivs(dyn,f,q_t,dq_t,t,q,dq,ddq);
    
    
    %% compute mass matrix (works if M_ only depends on q (and dq) which is always the case (here))
    % -1*(Mass(q)*ddq - dyn) = rhs_L(q,dq)
    Mass_ = sym('M_',[f,f]);
    for ii=1:f
        for jj=1:f
            Mass_(ii,jj) = diff(dyn(ii),ddq(jj));
        end
    end
    rhs_L_ = -1*simplify(dyn-Mass_*ddq);
    
    
    %% rescale mass matrix if necessary
    % Mass_ = diag([1,cos(q(2))])*Mass_
    
    rescaleMass = symmetricTest(Mass_);
    if rescaleMass==1
        warning('Mass matrix not symmetric. Trying to rescale.')
        inds = [2:f;1:f-1];
        coeffs = sym('coeffs',[1,f-1]);
        for ii=1:f-1
            inds_now = inds(:,ii)';
            coeffs(ii) = Mass_(inds_now(1),inds_now(2))/Mass_(inds_now(2),inds_now(1));
        end
    %     T = diag([1,1./coeffs]);
        T = diag([coeffs,1]);
        rescaleMass = symmetricTest(T*Mass_);
        if rescaleMass==0
            fprintf('Rescaling mass matrix succesfull.\n')
            Mass_  = T*Mass_;
            rhs_L_ = T*rhs_L_;
        else
            warning('Rescaling mass matrix NOT succesfull. Matrix still not symmetric.')
        end
    end

    %%
    Q = 0*sym('Q',[f,1]);
    if ~isempty(F_mat)==1
        n_F = size(F_mat,2);
        for ii=1:f
            for jj=1:n_F 
                Q(ii) = Q(ii)  +  F_mat(:,jj)' * diff(r_mat(:,jj),q(ii));
            end
        end
    end
    tf_ = rhs_L_ + Q;
    
    
    %% convert to matlabFunctions
    if ~isempty(u)==1
        % Mass(q)*ddq = rhs_L(q,dq) + Q(q,u) = tf(q,dq,u)
            tf   = matlabFunction(tf_,  'Vars',{q,dq,params{:},u});
            Mass = matlabFunction(Mass_,'Vars',{q,   params{:}  });        
        % ddq = Mass(q)^-1 * tf(q,dq,u) = f(q,dq,u)
            f = matlabFunction(inv(Mass_)*tf_,'Vars',{q,dq,params{:},u});
    else
        % Mass(q)*ddq = rhs_L(q,dq) + Q(q) = tf(q,dq)
            tf   = matlabFunction(tf_,  'Vars',{q,dq,params{:}});
            Mass = matlabFunction(Mass_,'Vars',{q,   params{:}});       
        % ddq = Mass(q)^-1 * tf(q,dq) = f(q,dq)
            f = matlabFunction(inv(Mass_)*tf_,'Vars',{q,dq,params{:}});
    end


end