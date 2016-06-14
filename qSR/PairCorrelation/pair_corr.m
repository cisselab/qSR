function [G,r,g,dg] = pair_corr(image,mask,binsize,rmax)
    
    rmaxLattice = ceil(rmax/binsize);
    [G, r_temp, g_temp, dg_temp]=get_autocorr(image,mask,rmaxLattice);
    r=r_temp(2:end)*binsize;
    g=g_temp(2:end);
    dg=dg_temp(2:end);
end