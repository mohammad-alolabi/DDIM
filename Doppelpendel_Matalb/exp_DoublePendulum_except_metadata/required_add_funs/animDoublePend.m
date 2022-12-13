function FRAMES = animDoublePend(x_fun,t_grid,sys_params)
    n = 4;
    phi_1 = @(t) getComponentVec(n,1)*(x_fun(t));
    phi_2 = @(t) getComponentVec(n,2)*(x_fun(t));

    struct2CallerWS(sys_params)
    rho_1 = m_1/l_1;
    rho_2 = m_2/l_2;
    rho_min = min([rho_1,rho_2]);
    c_lw_1 = log(exp(1)+rho_1/rho_min);
    c_lw_2 = log(exp(1)+rho_2/rho_min);
    pend_lw = 4;

    pause_on = 0;
    pause_time = 0;
    
    l = l_1+l_2;
    axis_min_max = 1.05*l*[-1 1 -1 1];
    c_h = (axis_min_max(2)-axis_min_max(1))/(axis_min_max(4)-axis_min_max(3));
    figHandle = MakeDefaultFig(1000,1000/c_h+150,'Screen',2,'FigUnits','pixels'); 
      
    hold on
    axis(axis_min_max);
    daspect([1 1 1])
    set(gca,'XTick',[],'YTick',[], 'XColor','none','YColor','none') 

    pend_1_start = [0;0];
    p1sx = pend_1_start(1);
    p1sy = pend_1_start(2);

    pend_1_end_x = @(t)  l_1*sin(phi_1(t));
    pend_1_end_y = @(t) -l_1*cos(phi_1(t));

    pend_2_end_x = @(t)  l_1*sin(phi_1(t)) + ...
                         l_2*sin(phi_1(t)+phi_2(t));
    pend_2_end_y = @(t) -l_1*cos(phi_1(t)) + ...
                        -l_2*cos(phi_1(t)+phi_2(t));
   
    for ii=1:length(t_grid)
        t = t_grid(ii);
        title(sprintf('t=%0.2fs',t),'Interpreter','tex')
        
        p1ex = pend_1_end_x(t);
        p1ey = pend_1_end_y(t);
        p2sx = p1ex;
        p2sy = p1ey;
        p2ex = pend_2_end_x(t);
        p2ey = pend_2_end_y(t);
      
        plot([p1sx,p1ex],[p1sy,p1ey],'k-','Linewidth',c_lw_1*pend_lw); %pendulum arm 1
        plot([p2sx,p2ex],[p2sy,p2ey],'k-','Linewidth',c_lw_2*pend_lw); %pendulum arm 2      

        t_line = linspace(max([0,t-1]),t,100);
        plot(pend_2_end_x(t_line),pend_2_end_y(t_line),'r-','LineWidth',1)
    
        FRAMES(ii) = getframe(gcf);
        if pause_on==1
            pause(pause_time)
        end
        drawnow
        if ii ~= length(t_grid)
            cla
        else
            figHandle = [];
        end
    end
end