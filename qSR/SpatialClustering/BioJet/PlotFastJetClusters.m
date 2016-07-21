function clusters=PlotFastJetClusters(Data,tree,cut_height,varargin)

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
        clusters_small = CutTree(tree,cut_height/1.5);
        clusters_large = CutTree(tree,cut_height*1.5);
        
    %% Determine Clusters to Plot
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
            if colored
                figure
                
                subplot(1,3,1)
                plot(Data(:,2),Data(:,3),'.k')
                hold on
                colormat = [1-Data(clusters_small>0,1)/max(Data(clusters_small>0,1)),zeros(sum(clusters_small>0),1),Data(clusters_small>0,1)/max(Data(clusters_small>0,1))];
                scatter(Data(clusters_small>0,2),Data(clusters_small>0,3),4,colormat)
                title(['Length Scale:',num2str(cut_height/2)])
                
                subplot(1,3,2)
                plot(Data(:,2),Data(:,3),'.k')
                hold on
                colormat = [1-Data(clusters>0,1)/max(Data(clusters>0,1)),zeros(sum(clusters>0),1),Data(clusters>0,1)/max(Data(clusters>0,1))];
                scatter(Data(clusters>0,2),Data(clusters>0,3),4,colormat)
                title(['Length Scale:',num2str(cut_height)])
                
                subplot(1,3,3)
                plot(Data(:,2),Data(:,3),'.k')
                hold on
                colormat = [1-Data(clusters_large>0,1)/max(Data(clusters_large>0,1)),zeros(sum(clusters_large>0),1),Data(clusters_large>0,1)/max(Data(clusters_large>0,1))];
                scatter(Data(clusters_large>0,2),Data(clusters_large>0,3),4,colormat)
                title(['Length Scale:',num2str(cut_height*2)])
            else
                figure
                subplot(1,3,1)
                plot(Data(:,2),Data(:,3),'.k')
                hold on
                plot(Data(clusters_small>0,2),Data(clusters_small>0,3),'.r')
                title(['Length Scale:',num2str(cut_height/2)])
                
                subplot(1,3,2)
                plot(Data(:,2),Data(:,3),'.k')
                hold on
                plot(Data(clusters>0,2),Data(clusters>0,3),'.r')
                title(['Length Scale:',num2str(cut_height)])
                
                subplot(1,3,3)
                plot(Data(:,2),Data(:,3),'.k')
                hold on
                plot(Data(clusters_large>0,2),Data(clusters_large>0,3),'.r')
                title(['Length Scale:',num2str(cut_height*2)])
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
            
            plot_indices=false(size(clusters));
            plot_indices_small=false(size(clusters_small));
            plot_indices_large=false(size(clusters_large));

            for i = 1:num_clusters
                plot_indices = or(plot_indices,clusters==s_index(i));
                plot_indices_small = or(plot_indices_small,clusters==s_index_small(i));
                plot_indices_large = or(plot_indices_large,clusters==s_index_large(i));
            end
            
            if colored
                
                figure
                
                subplot(1,3,1)
                plot(Data(:,2),Data(:,3),'.k')
                hold on
                colormat = [1-Data(plot_indices_small,1)/max(Data(plot_indices_small,1)),zeros(sum(plot_indices_small),1),Data(plot_indices_small,1)/max(Data(plot_indices_small,1))];
                scatter(Data(plot_indices_small,2),Data(plot_indices_small,3),4,colormat)
                title(['Length Scale:',num2str(cut_height/2)])
                
                subplot(1,3,2)
                plot(Data(:,2),Data(:,3),'.k')
                hold on
                colormat = [1-Data(plot_indices,1)/max(Data(plot_indices,1)),zeros(sum(plot_indices),1),Data(plot_indices,1)/max(Data(plot_indices,1))];
                scatter(Data(plot_indices,2),Data(plot_indices,3),4,colormat)
                title(['Length Scale:',num2str(cut_height)])
                
                subplot(1,3,3)
                plot(Data(:,2),Data(:,3),'.k')
                hold on
                colormat = [1-Data(plot_indices_large,1)/max(Data(plot_indices_large,1)),zeros(sum(plot_indices_large),1),Data(plot_indices_large,1)/max(Data(plot_indices_large,1))];
                scatter(Data(plot_indices_large,2),Data(plot_indices_large,3),4,colormat)
                title(['Length Scale:',num2str(cut_height*2)])
                
                
            else
               
                
                figure
                subplot(1,3,1)
                plot(Data(:,2),Data(:,3),'.k')
                hold on
                plot(Data(plot_indices_small,2),Data(plot_indices_small,3),'.r')
                title(['Length Scale:',num2str(cut_height/2)])
                
                subplot(1,3,2)
                plot(Data(:,2),Data(:,3),'.k')
                hold on
                plot(Data(plot_indices,2),Data(plot_indices,3),'.r')
                title(['Length Scale:',num2str(cut_height)])
                
                subplot(1,3,3)
                plot(Data(:,2),Data(:,3),'.k')
                hold on
                plot(Data(plot_indices_large,2),Data(plot_indices_large,3),'.r')
                title(['Length Scale:',num2str(cut_height*2)])
            end
    end
    
    %% Plot Data
    
    
    
    