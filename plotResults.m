function par = plotResults(clusterModel, r, par,packets)
    nodeArch = clusterModel.nodeArch;
    netArch = clusterModel.netArch;
    
    
    %%%%% number of packets sent from CHs to BS
    if r == 1
        par.packetToBS(r) = packets(1,r);
    else
        par.packetToBS(r) = par.packetToBS(r-1) + packets(1,r);
    end
    % Figure packet to BS
%     fig(par.packetToBS, r, 1, '# of packets sent to BS nodes', ...
%         'Number of packet sent to BS vs. round');
    
    %%%%% Number of dead neurons
    par.numDead(r) = nodeArch.numDead;
    disp('Dead Nodes:')
    nodeArch.numDead
    disp('Total Packets:')
    par.packetToBS(r)
    % Figure number of dead node
%     fig(par.numDead, r, 2, '# of dead nodes', 'Number of dead node vs. round');
    
    %%%%% Energy
    par.energy(r) = 0;
    node = clusterModel.nodeArch;
    for i = find(~node.dead)
        if node.node(i).energy > 0
            par.energy(r) = par.energy(r) + node.node(i).energy;
        end
    end
    disp('Total Energy:')
    par.energy(r)
%     fig(par.energy, r, 3, 'sum of energy', 'Sum of energy of nodes vs. round'); 
    
    createfigure(1:r, par.energy, par.packetToBS, par.numDead);
end
