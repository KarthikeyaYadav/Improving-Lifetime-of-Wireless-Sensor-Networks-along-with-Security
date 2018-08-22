function nodeArch = newNodes2(netArch, numNode)
% Create the node model randomly
%   
%   Input:
%       netArch     Network architecture
%       numNode    Number of Nodes in the field
%   Output:
%       nodeArch    Nodes architecture
%       nodesLoc    Location of Nodes in the field
%   Example:
%       netArch  = createNetwork();
%       nodeArch = createNodes(netArch, 100)
%
% Hossein Dehghan, hd.dehghan@gmail.com
% Ver 1. 2/2013

    
    if ~exist('netArch','var')
        netArch = newNetwork();
    end
    
    if ~exist('numNode','var')
        numNode = 100;
    end
    for i = 1:numNode
        % x cordination of node
        nodeArch.node(i).x      =   rand * netArch.Yard.Length;
        nodeArch.nodesLoc(i, 1) =   nodeArch.node(i).x;
        % y cordination of node
        nodeArch.node(i).y      =   rand * netArch.Yard.Width;
        nodeArch.nodesLoc(i, 2) =   nodeArch.node(i).y;
        % the flag which determines the value of the indicator function? Ci(t)
        nodeArch.node(i).G      =   0; 
        % initially there are no cluster heads, only nodes
        nodeArch.node(i).type   =   'N'; % 'N' = node (nun-CH)
        nodeArch.node(i).energy =   netArch.Energy.init;
        
        nodeArch.node(i).CH     = -1; % number of its CH ?
        nodeArch.dead(i)        = 0; % the node is alive
    end
    nodeArch.numNode = numNode; % Number of Nodes in the field
    nodeArch.numDead = 0; % number of dead nodes
    dis = zeros(numNode+1,numNode+1);
    nodeArch.node(numNode+1).x=50;
      nodeArch.node(numNode+1).y=50;
      nodeArch.dead(numNode+1)        = 0;
      nodeArch.node(numNode+1).G      =   0;
      nodeArch.node(numNode+1).type   =   'N'; % 'N' = node (nun-CH)
        nodeArch.node(numNode+1).energy =   netArch.Energy.init;
        
        nodeArch.node(numNode+1).CH     = -1;
        nodeArch.numNode = nodeArch.numNode+1;
    for i = 1:numNode+1
        x1 = nodeArch.node(i).x;
        y1 = nodeArch.node(i).y;
       for j = i+1:numNode+1
           x2 = nodeArch.node(j).x;
           y2 = nodeArch.node(j).y;
           distance = sqrt(((x1-x2)^2)+(y1-y2)^2);
           dis(i,j) = distance;
           dis(j,i) = distance;
       end
    end
    for i = 1:numNode
       dis(i,i) = inf; 
    end
    xmin=0;
    xmax= 100;
    ymin=0;
    ymax= 100;
    nodeArch.xmin=xmin;
    nodeArch.xmax=xmax;
    nodeArch.ymin=ymin;
    nodeArch.ymax=ymax;
    nodeArch.dis=dis;  
    nodeArch.range=7;
    %nodeArch.PacketLength = 200;
    Tenergy = (nodeArch.numNode) * netArch.Energy.init;
    Tenergy
    nodeArch.Tenergy = Tenergy;
end