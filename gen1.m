function [Path] = gen1(Priority, clusterModel, src)
Priority(1,src) = -100;
pind = 1;
Path(1,1)=clusterModel.clusterNode.no(src);
flag=0;
cur = src;
%see from here ...............
while(cur ~= clusterModel.clusterNode.countCHs)
   tdis = clusterModel.clusterNode.dista(cur,:);
   if(flag==0 && clusterModel.nodeArch.range <= clusterModel.clusterNode.countCHs-pind)
      rng = clusterModel.nodeArch.range;
   else
       rng =clusterModel.clusterNode.countCHs-pind-1;
   end
   
   maxpri =0;
   maxprind = 0;
        if(rng ~= 0)
           while(rng ~= 0)
              [temp , ind] = min(tdis);
              tdis(1,ind) = inf;
%disp('inf loop')
              if(Priority(ind) ~= -100)
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
   
   pind = pind+1;
   if(pind >= clusterModel.clusterNode.countCHs-clusterModel.nodeArch.range)
      flag = 1; 
   end
   %maxprind
   Path(1,pind) = clusterModel.clusterNode.no(maxprind);
   cur = maxprind;
   %cur
   Priority(cur) = -100;
%    Priority
%    tdis
    
    
end