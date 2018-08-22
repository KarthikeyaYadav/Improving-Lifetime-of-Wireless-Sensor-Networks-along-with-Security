function [Path] = gen2(Priority, clusterModel, src)
Priority(1,src) = -100;
% disp('Priority')
% Priority
pind = 1;
Path(1,1)=clusterModel.clusterNode.no(src);
flag=0;
cur = src;
nalive = 0;
for i=1:clusterModel.clusterNode.countCHs
    if(clusterModel.nodeArch.dead(clusterModel.clusterNode.no(i)) ~= 1)
    nalive = nalive + 1;
    end
end
% disp('nalive')
% nalive
if(nalive==1)
    pind = pind+1;
    Path(1,pind)=clusterModel.clusterNode.no(clusterModel.clusterNode.countCHs);
    return
end
ndead = clusterModel.clusterNode.countCHs - nalive;
% disp('ndead')
while(cur ~= clusterModel.clusterNode.countCHs)
    %cur
   tdis = clusterModel.clusterNode.dista(cur,:);
%    disp('tdis')
%    tdis
   if(flag==0 && nalive-1 >= clusterModel.nodeArch.range)
      rng = clusterModel.nodeArch.range;
   else
       rng = clusterModel.clusterNode.countCHs-pind-1-ndead;
   end
%    disp('rng')
%    rng
   maxpri =0;
   maxprind = 0;
   if(nalive >= rng)
   maxpri =-100;
   maxprind = 0;
   if(rng ~= 0)
   while(rng ~= 0)
       %rng
      [temp , ind] = min(tdis);
      if(temp == inf)
          helllo000000ooooooo
      end
      tdis(1,ind) = inf;
      
      if(clusterModel.nodeArch.dead(clusterModel.clusterNode.no(ind)) ~=1 && Priority(ind) ~= -100)
         t = Priority(ind);
         if(maxpri < t)
            maxpri = t;
            maxprind = ind;
         end
         rng = rng-1;
      end
       
       
   end
   else
      maxprind = clusterModel.clusterNode.countCHs; 
   end
   else
       for i = 1:clusterModel.clusterNode.countCHs
           %hii
       if(clusterModel.nodeArch.dead(clusterModel.clusterNode.no(i))~=1 && Priority(i) ~= -100)
           t = Priority(i);
           
       if(maxpri < t)
          maxpri = t;
          maxprind = i;
         % maxprind
          
       end
       end
       end
   end
   pind = pind+1;
   if(pind >= clusterModel.clusterNode.countCHs-clusterModel.nodeArch.range-ndead)
      flag = 1; 
   end
   Path(1,pind) = clusterModel.clusterNode.no(maxprind);
   cur = maxprind;
   %cur
   Priority(cur) = -100;
%    Priority
%    tdis
    
    
end