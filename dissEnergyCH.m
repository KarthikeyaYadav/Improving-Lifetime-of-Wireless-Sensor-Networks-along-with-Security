function clusterModel = dissEnergyCH(clusterModel, roundArch,GlobalBest)
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

    nodeArch = clusterModel.nodeArch;
    netArch  = clusterModel.netArch;
    cluster  = clusterModel.clusterNode;
    
    d0 = sqrt(netArch.Energy.freeSpace / ...
              netArch.Energy.multiPath);
          if cluster.countCHs == 0
             return
         end
    n = length(cluster.no); % Number of CHs
    ETX = netArch.Energy.transfer;
    ERX = netArch.Energy.receive;
    EDA = netArch.Energy.aggr;
    Emp = netArch.Energy.multiPath;
    Efs = netArch.Energy.freeSpace;
    %packetLength = roundArch.packetLength;
    packetLength = 200;
    ctrPacketLength = roundArch.ctrPacketLength;
  for i = 1:clusterModel.clusterNode.countCHs-1
   Path = GlobalBest(i).Path;
   plen = length(Path);
   for j = 1:plen-1
       s1 = Path(j);
       d1 = Path(j+1);
       minDis = clusterModel.nodeArch.dis(s1,d1);

kar = 0;
if (j==1)
    chNo = cluster.no(j);
    energy = nodeArch.node(chNo).energy;
        if(minDis > d0)
             nodeArch.node(chNo).energy = energy - ...
                 ((ETX+EDA) * packetLength + Emp * packetLength * (minDis ^ 4));
        else
             nodeArch.node(chNo).energy = energy - ...
                 ((ETX+EDA) * packetLength + Efs * packetLength * (minDis ^ 2));
        end
        nodeArch.node(chNo).energy = nodeArch.node(chNo).energy - ...
            ctrPacketLength * ERX * round(nodeArch.numNode-1 / clusterModel.numCluster-1);
else
    chNo = cluster.no(j);
    energy = nodeArch.node(chNo).energy;
    if (minDis > d0)
    kar = packetLength * ETX + Emp * packetLength * (minDis ^ 4);
                nodeArch.node(chNo).energy = energy - kar;
                
    else
                kar = packetLength * ETX + Efs * packetLength * (minDis ^ 2);
                nodeArch.node(chNo).energy = energy - kar;
    end
end

% disp('kar:')
% kar
% model.Tenergy = model.Tenergy - kar;
% disp('model.tenergy:')
% model.Tenergy
% if(isempty(model.Tenergy))
%     disp('Abhi kar')
%     kar
% end
% pause;
%             model.node(s1).energy
%             pause;
            %Energy dissipated
            kart = 0;
            if(minDis > 0 && d1 ~= 101 && j~=1)
                kart = ((ERX) * packetLength );
                nodeArch.node(d1).energy = nodeArch.node(d1).energy - kart;
               nodeArch.Tenergy = nodeArch.Tenergy - kart;
%                 model.Tenergy
%                 if(isempty(model.Tenergy))
%     disp('Abhi kart')
%     kart
%     disp('model.node(d1).energy ')
%     model.node(d1).energy 
%     disp('d1')
%     d1
% end
% pause;
            end
       if(nodeArch.node(s1).energy <= 0)
           nodeArch.dead(s1)=1;
       end
       if(nodeArch.node(d1).energy <= 0)
           nodeArch.dead(d1)=1;
       end
%        if(model.Tenergy < 0)
%           model.Tenergy = 0; 
%        end
 end
  end
     clusterModel.nodeArch = nodeArch;
 end