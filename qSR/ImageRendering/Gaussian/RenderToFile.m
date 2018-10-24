function RenderToFile(Xpos,Ypos,num_pix,sigma_render,o_filename,max_intensity)

    show_figure = false;
    ImOut = Render(Xpos,Ypos,num_pix,sigma_render,show_figure);
    
    
    h1 = figure('visible','off');
    imshow(ImOut,'colormap',hot)
    h2 = colorbar;
    xlabel(h2,'Localizations/um^2','FontSize',14)
    
    ax = gca;
    ax.CLim = [0,max_intensity];
    
    saveas(h1,o_filename,'tif')
    close(h1)