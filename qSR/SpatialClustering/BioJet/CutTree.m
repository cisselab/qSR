function cluster_ids=CutTree(tree,height)

%     idx=1;
%     clusters=struct(1);
%     while tree(idx,3)<=height
%         
%         
%         idx=idx+1;
%     end    

%start at the top of the tree and move down. Instantiate a new cluster for
%the largest consistent merger, and recursively add points to the tree from
%the children

cut_idx=find(tree(:,3)>height,1);
N=find(tree(:,1)>-1,1)-1;

current_index=cut_idx-1;

cluster_idx=1;
cluster_ids=zeros(1,N);
visited_indicator=false(1,length(tree));
visited_indicator(cut_idx:end)=true;
while current_index > N
    [clusters,visited_nodes] = RecursiveTree(tree,current_index);
    cluster_ids(clusters)=cluster_idx;
    cluster_idx=cluster_idx+1;
    visited_indicator(visited_nodes)=true;
    current_index=find(~visited_indicator,1,'last');
    if isempty(current_index)
        break
    end
end



% while current_index>1 %This logic won't work btws because I will be traveling up and down the tree many times. 
%     [child1,child2]=tree(1:2,current_index);
%     tree
% end

end

function [cluster_members,visited_nodes]=RecursiveTree(tree,root_idx)

    
    children = tree(root_idx,1:2);
    child1=children(1);
    child2=children(2);
    
    if IsLeaf(child1,tree)
        new_members1=child1;
        visited_nodes1=child1;
    else
        [new_members1,visited_nodes1]=RecursiveTree(tree,child1);
    end
    
    if IsLeaf(child2,tree)
        new_members2=child2;
        visited_nodes2=child2;
    else
        [new_members2,visited_nodes2]=RecursiveTree(tree,child2);
    end
    cluster_members=[new_members1,new_members2];
    visited_nodes=[visited_nodes1,visited_nodes2,root_idx];
    
end

function isleaf=IsLeaf(node,tree)
    %The FastJet Data structure outputs a -1 for the children of a node if
    %it is a leaf node. 
    children = tree(node,1:2);
    isleaf = (children(1)==-1);
end