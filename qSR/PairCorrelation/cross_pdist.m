function mat=cross_pdist(points1,points2)

% cross_pdist(points1,points2) takes in an N1xD matrix (points1) and an
% N2xD matrix (points2) of positions where each row corresponds to a single
% data point in a D-dimensional vector space, and returns an N1xN2 matrix (mat)
% whose (n1,n2)th element corresponds to the euclidean distance between
% the n1-th point in points1 and the n2-th point in points2. 

    [N1,D1]=size(points1);
    [N2,D2]=size(points2);
    if D1~=D2
        error('The sets do not have the same dimension')
    end
    
    mat=zeros(N1,N2);
    
    for i = 1:N1     
        delta=zeros(N2,D2);
        for d = 1:D1
            delta(:,d)=points2(:,d)-points1(i,d);
        end
        dists=sqrt(sum(delta.^2,2));
        mat(i,:)=dists;
    end
end