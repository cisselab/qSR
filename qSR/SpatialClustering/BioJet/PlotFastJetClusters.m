function clusters= PlotFastJetClusters(Data,tree,cut_height,varargin)

    % Modes of operation:
    %       Single Color vs. time colored
    %       Min_points vs top clusters
    
    
    %% Parse Inputs
    if nargin == 3
        plot_mode = 'min_points';
        min_points = 20;
        colored=false;
    elseif nargin == 4
        plot_mode = 'min_points';
        min_points = varargin{1};
        colored=false;
    elseif nargin == 5
        plot_mode = varargin{1};
        switch plot_mode
            case 'min_points'
                min_points = varargin{2};
            case 'top_clusters'
                num_clusters = varargin{2};
            otherwise
        end
        colored=false;
    elseif nargin == 6
        plot_mode = varargin{1};
        switch plot_mode
            case 'min_points'
                min_points = varargin{2};
            case 'top_clusters'
                num_clusters = varargin{2};
            otherwise
        end
        switch varargin{3}
            case 'time_colored'
                colored=true;
            case 'single_color'
                colored=false;
            otherwise
        end
    end
    
     %% Cut Tree
    
        clusters = CutTree(tree,cut_height);
        scaling_ratio=1.5;
        clusters_small = CutTree(tree,cut_height/scaling_ratio);
        clusters_large = CutTree(tree,cut_height*scaling_ratio);
        
    %% Trim Clusters
        switch plot_mode
            case 'min_points'
                for i = 1:max([clusters,clusters_small,clusters_large])
                    if sum(clusters==i)<min_points
                        clusters(clusters==i)=0;
                    end

                    if sum(clusters_small==i)<min_points
                        clusters_small(clusters_small==i)=0;
                    end

                    if sum(clusters_large==i)<min_points
                        clusters_large(clusters_large==i)=0;
                    end
                end
            case 'top_clusters'
                size_dist=zeros(1,max([clusters,clusters_small,clusters_large]));
                size_dist_small=zeros(1,max([clusters,clusters_small,clusters_large]));
                size_dist_large=zeros(1,max([clusters,clusters_small,clusters_large]));

                for i = 1:max([clusters,clusters_small,clusters_large])
                    size_dist(i)=sum(clusters==i);
                    size_dist_small(i)=sum(clusters_small==i);
                    size_dist_large(i)=sum(clusters_large==i);
                end

                [~,s_index]=sort(size_dist,'descend');
                [~,s_index_small]=sort(size_dist_small,'descend');
                [~,s_index_large]=sort(size_dist_large,'descend');

                new_clusters=zeros(size(clusters));
                new_clusters_small=zeros(size(clusters));
                new_clusters_large=zeros(size(clusters));
                
                for i = 1:num_clusters
                   new_clusters(clusters==s_index(i))=i;
                   new_clusters_small(clusters_small==s_index_small(i))=i;
                   new_clusters_large(clusters_large==s_index_large(i))=i;
                end
                
                clusters=new_clusters;
                clusters_small=new_clusters_small;
                clusters_large=new_clusters_large;
        end
        
        %% Plot Results
        if colored
            figure
            
            colormat = [1-Data(clusters>0,1)/max(Data(clusters>0,1)),zeros(sum(clusters>0),1),Data(clusters>0,1)/max(Data(clusters>0,1))];
            scatter(Data(clusters>0,2),Data(clusters>0,3),49,colormat,'filled')
            hold on
            plot(Data(:,2),Data(:,3),'.','markersize',4,'color',[0.6,0.6,0.6])
            
            title(['Length Scale (nm):',num2str(cut_height)])
            axis equal square
            
            figure

            subplot(1,3,1)
            
            colormat = [1-Data(clusters_small>0,1)/max(Data(clusters_small>0,1)),zeros(sum(clusters_small>0),1),Data(clusters_small>0,1)/max(Data(clusters_small>0,1))];
            scatter(Data(clusters_small>0,2),Data(clusters_small>0,3),49,colormat,'filled')
            hold on
            plot(Data(:,2),Data(:,3),'.','markersize',4,'color',[0.6,0.6,0.6])
            title(['Length Scale (nm):',num2str(cut_height/scaling_ratio)])
            axis equal square

            subplot(1,3,2)
            
            colormat = [1-Data(clusters>0,1)/max(Data(clusters>0,1)),zeros(sum(clusters>0),1),Data(clusters>0,1)/max(Data(clusters>0,1))];
            scatter(Data(clusters>0,2),Data(clusters>0,3),49,colormat,'filled')
            hold on
            plot(Data(:,2),Data(:,3),'.','markersize',4,'color',[0.6,0.6,0.6])
            title(['Length Scale (nm):',num2str(cut_height)])
            axis equal square

            subplot(1,3,3)
            
            colormat = [1-Data(clusters_large>0,1)/max(Data(clusters_large>0,1)),zeros(sum(clusters_large>0),1),Data(clusters_large>0,1)/max(Data(clusters_large>0,1))];
            scatter(Data(clusters_large>0,2),Data(clusters_large>0,3),49,colormat,'filled')
            hold on
            plot(Data(:,2),Data(:,3),'.','markersize',4,'color',[0.6,0.6,0.6])
            title(['Length Scale (nm):',num2str(cut_height*scaling_ratio)])
            axis equal square
            
        else
            figure
            
            PlotClusterBackground(Data,clusters,1)
            title(['Length Scale (nm):',num2str(cut_height)])
            axis equal square
            
            figure
            subplot(1,3,1)
            PlotClusterBackground(Data,clusters_small,1)
            title(['Length Scale (nm):',num2str(cut_height/scaling_ratio)])
            axis equal square

            subplot(1,3,2)
            PlotClusterBackground(Data,clusters,1)
            title(['Length Scale (nm):',num2str(cut_height)])
            axis equal square

            subplot(1,3,3)
            PlotClusterBackground(Data,clusters_large,1)
            title(['Length Scale (nm):',num2str(cut_height*scaling_ratio)])
            axis equal square
        end