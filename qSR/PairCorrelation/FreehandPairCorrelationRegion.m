function [r,g,included_points]=FreehandPairCorrelationRegion(Times,Xpos,Ypos,binsize,rmax,sigma,px_size)
%[r,g,r_cell,g_cell]=FreehandPairCorrelationRegion(Times,Xpos,Ypos,binsize,rmax,sigma)

    % Takes in a list of X coordinates, and Y coordinates, and performs
    % pair correlation analysis on a user deifned region within the data
    % set. I should split this into multiple functions to allow easier
    % calling within gui. One function to freehand collect the data, which
    % will be modified in the gui to work with in gui axes, and one that
    % performs the computation on the user defined region. 
        
    FreehandROICoordinateList = DrawFreehandRegion; %Returns an ordered list of the x and y coordinates that defines the boundary.
    px_ROI_coordinates = FreehandROICoordinateList*1000/px_size; %1000/px_size converts from microns to pixels. 
    
    included_points = inpolygon(Xpos,Ypos,px_ROI_coordinates(:,1),px_ROI_coordinates(:,2)); %Returns a logical defining which points lie within the ROI. 

    XposIN = Xpos(included_points);
    YposIN = Ypos(included_points);
    
    [merged_data]=precluster_pc_data(Times,Xpos,Ypos,sigma);
    
    Xpos_merged = merged_data(1,:);
    Ypos_merged = merged_data(2,:);
    
    [image,mask,avg_density,Npoints]=create_pc_image(Xpos_merged,Ypos_merged,binsize,px_ROI_coordinates);
    
    avg_density

    [~,r,g,~] = pair_corr(image,mask,binsize,rmax);
    
%     [rho_null,sigma_null,rho_exp,sigma_exp,A,xi]=FitPairCorrelations(r,g)
%     
% 
%     
%     g_theo = 1+1/4/pi/sigma_null^2/rho_null*exp(-r.^2/4/sigma_null^2);
%     
%     g_theo_exp = 1+1/4/pi/sigma_exp^2/rho_exp*exp(-r.^2/4/sigma_exp^2)+A*exp(-r/xi).*(erf(r/2/sigma_exp-sigma_exp/xi)+erf(sigma_exp/xi));

    figure
    plot(r*px_size,g,'.k')
%     hold on
%     plot(r,g_theo,'r')
%     plot(r,g_theo-1,'.b')
%     plot(r,g-g_theo+1,'.g')
    xlabel('r (nm)')
    ylabel('g(r)')
    title('Spatial Pair Correlation Function')
%    legend('g(r)^{peaks}','Fit to Null Model','g(r)^{stoch}','g(r)^{protein}')
%     title('Spatial Correlation Fit to Null Model')
%     
%     figure
%     plot(r,g,'.k')
%     hold on
%     plot(r,g_theo_exp,'r')
%     plot(r,g_theo_exp-1-A*exp(-r/xi).*(erf(r/2/sigma_exp-sigma_exp/xi)+erf(sigma_exp/xi)),'.b')
%     plot(r,g-g_theo_exp+1+A*exp(-r/xi).*(erf(r/2/sigma_exp-sigma_exp/xi)+erf(sigma_exp/xi)),'.g')
%     xlabel('r (px)')
%     ylabel('g(r)')
%     legend('g(r)^{peaks}','Fit to Exponential Model','g(r)^{stoch}','g(r)^{protein}')
%     title('Spatial Correlation Fit to Exponential Model')

        
%     Locs_per_protein_null = avg_density/rho_null; %Rho null is the estimate protein density from pcPALM and avg_density is the density of localizations
%     Locs_per_protein_exp = avg_density/rho_exp;
%     
%     Nsim = 29;

    
%     [r_cell,g_cell]=simulate_pc_envelope(sigma_null,Locs_per_protein_null,Npoints,Nsim,binsize,FreehandROICoordinateList,rmax);
%     
%     g_mat=[];
%     for i = 1:length(g_cell); g_mat=[g_mat;g_cell{i}]; end   
    
%     delta_g = [];
%     for i = 1:length(g_cell); delta_g=[delta_g;abs(g_theo-g_mat(i,:))]; end
%     
%     max_delta_g=max(delta_g);
%     
%     envelope_half_width = max(max_delta_g);
    
    
%     plot(r,g_theo+max_delta_g,'g')
%     plot(r,g_theo-max_delta_g,'g')
%     plot(r,g_theo+envelope_half_width,'r')
%     plot(r,g_theo-envelope_half_width,'r')
%     %[rho_null_sim,sigma_null_sim,rho_exp_sim,sigma_exp_sim,A_sim,xi_sim]=FitPairCorrelations(r_cell{1},g_cell{1})
%     QuantileSimulationEnvelopes(r,g,g_cell,rho_null,sigma_null)
end