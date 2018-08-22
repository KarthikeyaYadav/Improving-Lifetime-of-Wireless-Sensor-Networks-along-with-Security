function cost = CostFunction(Path, clusterModel)
wdis = 0.3;
wratio = 0.2;
wsave = 0.1;
totaldis = 0;
n = length(Path);
saveenergy = (n-2)/clusterModel.clusterNode.countCHs;
totalenergy = 0;
hopsenergy =0;
for i=1:clusterModel.clusterNode.countCHs-1
    totalenergy = totalenergy + clusterModel.nodeArch.node(clusterModel.clusterNode.no(i)).energy;
end

for i=1:n-1
   totaldis = totaldis + clusterModel.nodeArch.dis(Path(i),Path(i+1));
   if(i ~=1)
      hopsenergy = hopsenergy + clusterModel.nodeArch.node((Path(i))).energy; 
   end
end
energyratio = totalenergy/hopsenergy;
cost = (wdis * totaldis) + (wratio * energyratio) + (wsave * saveenergy);
%cost = (wsave * saveenergy);
end