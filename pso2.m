function GlobalBest=pso2(clusterModel)

%clusterModel.clusterNode.countCHs
%model=newNetwork1(100, 100, 50, 175);
%model.n=3;
nVar=clusterModel.clusterNode.countCHs;       % Number of Decision Variables

VarSize=[1 nVar]; 
VarMin=0;           % Lower Bound of Variables
VarMax=1;           % Upper Bound of Variables
        

%model.Yard
%% PSO Parameters

MaxIt=50;          % Maximum Number of Iterations
%r = 50;
nPop=50;           % Population Size (Swarm Size)

w=1;                % Inertia Weight
wdamp=0.98;         % Inertia Weight Damping Ratio
c1=1.5;             % Personal Learning Coefficient
c2=1.5;             % Global Learning Coefficient

alpha=0.1;
VelMax=alpha*(VarMax-VarMin);    % Maximum Velocity
VelMin=-VelMax;                    % Minimum Velocity
                    % Minimum Velocity

%% Initialization

% Create Empty Particle Structure
empty_particle.Priority=[];
empty_particle.Velocity=[];
empty_particle.Cost=[];
empty_particle.Best.Priority=[];
empty_particle.Best.Cost=[];
empty_particle.Best.Path=[];
empty_particle.Path=[];

ep.Priority=[];
ep.Cost=inf;
ep.Path=[];
% Initialize Global Best
 
% GlobalBest.Priority=zeros(model.numNode-1,model.numNode);
% %GlobalBest.Path=repmat([],model.numNode-1,1);
% for k = 1:model.numNode-1
%     GlobalBest.Path(k) = [];
% 
% end
particle=repmat(empty_particle,clusterModel.clusterNode.countCHs-1,1);
GlobalBest=repmat(ep,clusterModel.clusterNode.countCHs-1,1);
%GlobalBest.Cost=inf( model.numNode-1, 1);
%pause;


% p1.Priority = [];
% p1.Cost = [];
% p1.Path = [];
% GlobalBest.Best = repmat(p1, model.numNode-1,1);
% Create Particles Matrix



% Initialization Loop
for i=1:clusterModel.clusterNode.countCHs-1
   fflag=0; 
for j=1:2
    fflag=0;
particle(i).Priority = rand(1,clusterModel.clusterNode.countCHs);
    % Initialize Velocity
    particle(i).Velocity = zeros(VarSize);    
    % Evaluation
    particle(i).Path = gen1(particle(i).Priority, clusterModel, i);
%     particle(i).Path
    
    [particle(i).Cost]=CostFunction(particle(i).Path, clusterModel);
    
    % Update Personal Best
    if(j==1)
    particle(i).Best.Priority=particle(i).Priority;
    particle(i).Best.Cost=particle(i).Cost;
    particle(i).Best.Path=particle(i).Path;
    pr = particle(i).Priority;
    c = particle(i).Cost;
    p = particle(i).Path;
    else
        if(particle(i).Best.Cost>particle(i).Cost)
            particle(i).Best.Priority=particle(i).Priority;
    particle(i).Best.Cost=particle(i).Cost;
    particle(i).Best.Path=particle(i).Path;
    fflag=1;
        end
    end
    
    % Update Global Best
    if particle(i).Best.Cost<GlobalBest(i).Cost
%         length(GlobalBest.Priority(i,:))
%         length(particle(i).Best.Priority)
        GlobalBest(i).Priority=particle(i).Best.Priority;
        GlobalBest(i).Cost=particle(i).Best.Cost;
        GlobalBest(i).Path=particle(i).Best.Path;
        if(isempty(GlobalBest(i).Priority))
            
            
           i
          %pause;
        end
        
    end
end
% pause
if(fflag==1)
    particle(i).Priority=pr;
    particle(i).Cost=c;
    particle(i).Path=p;
end
end

% Array to Hold Best Cost Values at Each Iteration
BestCost=zeros(MaxIt,clusterModel.clusterNode.countCHs-1);
%pause;

for j=1:clusterModel.clusterNode.countCHs-1
    if (isempty(GlobalBest(j).Priority))
        j
        %pause;
    end
end

%% PSO Main Loop
% sop = 0;
% for iit = 1:r
for it=1:MaxIt
    
    for i=1:clusterModel.clusterNode.countCHs-1
        
        if(clusterModel.nodeArch.dead(clusterModel.clusterNode.no(i)) ~= 1)
%         it
%         
%         i
%         
%         particle(i).Velocity
%         particle(i).Best.Priority
%         particle(i).Priority
        if(it == 1 && isempty(GlobalBest(i).Priority))
        GlobalBest(i).Priority=particle(i).Best.Priority;
        GlobalBest(i).Cost=particle(i).Best.Cost;
        GlobalBest(i).Path=particle(i).Best.Path;
        end
       % pause;
%          if(i==1)
%             particle(i).Velocity
%             
%         end
        % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            + c1*rand(VarSize).*(particle(i).Best.Priority - particle(i).Priority) ...
            + c2*rand(VarSize).*(GlobalBest(i).Priority - particle(i).Priority);
%          if(i==1)
% %              c1*rand(VarSize).*(particle(i).Best.Priority - particle(i).Priority)
% %              c2*rand(VarSize).*(GlobalBest(i).Priority - particle(i).Priority)
%              
%             particle(i).Velocity
%             
%         end
        
        % Update Velocity Bounds
        particle(i).Velocity = max(particle(i).Velocity,VelMin);
        particle(i).Velocity = min(particle(i).Velocity,VelMax);
        
%         if(i==1)
%             particle(i).Velocity
%             pause;
%         end
        
        
%  if(i==1)
%   particle(i).Priority
% end       
        % Update Position
        particle(i).Priority = particle(i).Priority + particle(i).Velocity;
        
        % Velocity Mirroring
        OutOfTheRange=(particle(i).Priority<VarMin | particle(i).Priority>VarMax);
        particle(i).Velocity(OutOfTheRange)=-particle(i).Velocity(OutOfTheRange);
        
        % Update Position Bounds
        particle(i).Priority = max(particle(i).Priority,VarMin);
        particle(i).Priority = min(particle(i).Priority,VarMax);
%    if(i==1)
%   particle(i).Priority
% end     
%    if(i==1)
%   particle(i).Path
% end     
        particle(i).Path = gen2(particle(i).Priority, clusterModel, i);
%         particle(i).Path
%         it
%         i
%    if(i==1)
%   particle(i).Path
% end   
%         i
%         particle(i).Path
%        
% if(i==1)
%   particle(i).Cost
% end
        % Evaluation
        [particle(i).Cost]=CostFunction(particle(i).Path, clusterModel);
%    if(i==1)
%   particle(i).Cost
% end     
        % Update Personal Best
        if (particle(i).Cost<particle(i).Best.Cost)
            
            particle(i).Best.Priority=particle(i).Priority;
            particle(i).Best.Cost=particle(i).Cost;
            particle(i).Best.Path=particle(i).Path;
            
            % Update Global Best
            if (particle(i).Best.Cost<GlobalBest(i).Cost)
                
                GlobalBest(i).Priority=particle(i).Best.Priority;
        GlobalBest(i).Cost=particle(i).Best.Cost;
        GlobalBest(i).Path=particle(i).Best.Path;
                                %GlobalBest.Cost(i,:)=particle(i).Best.Cost;

                
            end
            
            
        end
        
%         if(i == 1)
%                 GlobalBest(i).Cost
%                 GlobalBest(i).Path
% %                 particle(i).Best.Cost
%                 end
        end
    BestCost(it,i) = GlobalBest(i).Cost;
    end
    
    % Update Best Cost Ever Found
  %  BestCost(it)=GlobalBest.Cost;
   % BestCost(it)
    % Inertia Weight Damping
    w=w*wdamp;

%     % Show Iteration Information
%     if GlobalBest.Sol.IsFeasible
%         Flag=' *';
%     else
%         Flag=[', Violation = ' num2str(GlobalBest.Sol.Violation)];
%     end
%     disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it)) Flag]);
    
    % Plot Solution
%     figure(1);
%     PlotSolution(GlobalBest.Sol,model);
   % pause(0.01);
  % pause; 
  %it

end

% for k = 1:model.numNode-1
%     GlobalBest(k).Cost
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model=dissEnergy(GlobalBest, model);
% nod = sum(model.dead);
% noda(iit) = nod;
% disp('Dead Nodes:')
% disp(nod)
% sop = sop + (model.numNode-1-nod);
% sopa(iit) = sop;
% disp('Total Packets:')
% disp(sop)
% disp('Total Energy:')
% model.Tenergy
% enea(iit) = model.Tenergy;
% %model.dead
% iit
% %pause;
% 
% createfigure(1:iit, enea, sopa, noda);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





end





