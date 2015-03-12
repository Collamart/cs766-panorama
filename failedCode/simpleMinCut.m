%% Simple min cut
% reference: http://www.cs.dartmouth.edu/~ac/Teach/CS105-Winter05/Handouts/stoerwagner-mincut.pdf

%%% CODE NEVER GET TO RUN! FAILS WHEN USED ON GRAH CUT BLENDING PROBLEM


function [mCut] = simpleMinCut(graph, force)

if nargin == 1
    force = 1;
end
graph = double(graph);
numNodes = length(graph);
graph(1:numNodes+1:end) = 0;
graph(isinf(graph)) = 0;
mCut = (1:numNodes)';
mWeight = inf;

force = sort(force);
i = 1:numNodes;
for n = length(force):-1:2
    [graph, i] = mergeNodes(graph, force(1), force(n), i);
end

mCut(force) = force(1);
    
while length(i)>1
    % minimum cut phase
    [vs, vt] = mincutphase( graph );
    st = sum(graph(vt, setdiff(1:length(graph),vt)));

    if st<mWeight,   % record
        mWeight = st;
        end_mv = mCut; 
        end_mv(mCut==mCut(i(vt))) = 0;
%         end_mv(mCut(i(vt))) = 0;
    end

    % update belonging vector
    mCut(mCut == mCut(i(vt))) = mCut(i(vs));
%     mCut(mCut(i(vt))) = mCut(i(vs));

    % merge t to s
    [graph, i] = mergeNodes(graph, vs, vt, i);
end

mCut = end_mv;
mCut(mCut > 0) = 1;

end

% merge 2 nodes
function [updateGraph, updateIndex] = mergeNodes(graph, n1, n2, nIndex)
% weight changed
graph(n1,:) = graph(n1,:) + graph(n2,:);
graph(:,n1) = graph(n1,:);
graph(n1,n1)= 0;    % self-edge

selectN = true(1, size(graph,2));
selectN(n2) = false;
updateGraph  = graph(selectN, selectN);
updateIndex = nIndex(selectN);
    
end
    
% maximum adjacency search or maximum cardinality search
function [vertS, vertT] = mincutphase( graph )

N  = length(graph);

if N == 2,                  % only two nodes 
    vertS = 1;
    vertT = 2;     
    return;     
end

s  = randi(N); % start node by random selection
cs = s; % index of start node in current graph
ni = 1:N;
for n = 1:N-3
    [nul, t] = max(graph(cs,:));
    [graph, ni]  = mergeNodes(graph, cs, t, ni);
    cs = find(ni==s);
end

[nul, vertS] = max(graph(cs,:));
vertS = ni(vertS);
vertT = setdiff(ni,[vertS, ni(cs)]);  
end