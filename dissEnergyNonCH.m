function [clusterModel,p] = dissEnergyNonCH(clusterModel, roundArch)
% Calculation of Energy dissipated for CHs
%   Input:
%       clusterModel     architecture of nodes, network
%       roundArch        round Architecture
%   Example:
%       r = 10; % round no = 10
%       clusterModel = newCluster(netArch, nodeArch, 'def', r);
%       clusterModel = dissEnergyCH(clusterModel);
%
% Hossein Dehghan, hd.dehghan@gmail.com
% Ver 1. 2/2013
    p=0;
    nodeArch = clusterModel.nodeArch;
    netArch  = clusterModel.netArch;
    cluster  = clusterModel.clusterNode;
    if cluster.countCHs == 0
        return
    end
    d0 = sqrt(netArch.Energy.freeSpace / ...
              netArch.Energy.multiPath);
    ETX = netArch.Energy.transfer;
    ERX = netArch.Energy.receive;
    EDA = netArch.Energy.aggr;
    Emp = netArch.Energy.multiPath;
    Efs = netArch.Energy.freeSpace;
    %packetLength = roundArch.packetLength;%6400
    packetLength = 200;
    ctrPacketLength = roundArch.ctrPacketLength;%200
    
    locAlive = find(~nodeArch.dead); % find the nodes that are alive
    for i = locAlive % seach in alive nodes
        %find Associated CH for each normal node
        if strcmp(nodeArch.node(i).type, 'N') &&  ...
            nodeArch.node(i).energy > 0
            
            locNode = [nodeArch.node(i).x, nodeArch.node(i).y];
            countCH = length(clusterModel.clusterNode.no); % Number of CHs
            % calculate distance to each CH and find smallest distance
            [minDis, loc] = min(sqrt(sum((repmat(locNode, countCH, 1) - cluster.loc)' .^ 2)));
            minDisCH =  cluster.no(loc);
            if(nodeArch.dead(minDisCH)~=1)
            if (minDis > d0)
                nodeArch.node(i).energy = nodeArch.node(i).energy - ...
                    ctrPacketLength * ETX + Emp * packetLength * (minDis ^ 4);
            else
                nodeArch.node(i).energy = nodeArch.node(i).energy - ...
                    ctrPacketLength * ETX + Efs * packetLength * (minDis ^ 2);
            end
            
            %Energy dissipated
            if(minDis > 0)
                nodeArch.node(minDisCH).energy = nodeArch.node(minDisCH).energy - ...
                    ((ERX + EDA) * packetLength );
            end
            p=p+1;
            end
        end % if
    end % for
    clusterModel.nodeArch = nodeArch;
end