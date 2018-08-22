clc, clear all, close all

numNodes = 125; % number of nodes
p = 0.1;

netArch  = newNetwork2(100, 100, 50, 50);
nodeArch = newNodes2(netArch, numNodes);
roundArch = newRound2(50);

plot1

par = struct;
packets=zeros(1,roundArch.numRound);

for r = 1:roundArch.numRound
    r
    clusterModel = newCluster(netArch, nodeArch, 'leach', r, p);
    clusterModel.clusterNode.countCHs=clusterModel.clusterNode.countCHs+1;
    clusterModel.clusterNode.no(clusterModel.clusterNode.countCHs)=numNodes+1;
    clusterModel.clusterNode.loc(clusterModel.clusterNode.countCHs, 1)   = 50;
    clusterModel.clusterNode.loc(clusterModel.clusterNode.countCHs, 2)   = 50;
    dista=zeros(clusterModel.clusterNode.countCHs,clusterModel.clusterNode.countCHs);
    for i=1:clusterModel.clusterNode.countCHs
       for j=i+1:clusterModel.clusterNode.countCHs
          dista(i,j) = nodeArch.dis(clusterModel.clusterNode.no(i),clusterModel.clusterNode.no(j));
          dista(j,i) = dista(i,j);
       end
    end
    for i=1:clusterModel.clusterNode.countCHs
        dista(i,i) = inf;
    end
    clusterModel.clusterNode.dista = dista;
    GlobalBest=pso2(clusterModel);
%     disp('hello')
%     for i=1:clusterModel.clusterNode.countCHs-1
%         GlobalBest(i).Path
%     end
    clusterModel = dissEnergyCH(clusterModel, roundArch,GlobalBest);
    %disp('karthik')
    [clusterModel,packets(1,r)] = dissEnergyNonCH(clusterModel, roundArch);
    nodeArch     = clusterModel.nodeArch; % new node architecture after select CHs
    
    par = plotResults(clusterModel, r, par,packets);
    if nodeArch.numDead == nodeArch.numNode
        break
    end
end


