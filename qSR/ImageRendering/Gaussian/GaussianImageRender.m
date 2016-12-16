function Im2=GaussianImageRender(Xpos,Ypos,px_size,resolution,render_precision)

    Xmin = min(Xpos);Xmax=max(Xpos);Ymin=min(Ypos);Ymax=max(Ypos);
    
    sigma_render = render_precision/px_size;
    
    dx=(Xmax-Xmin)/resolution;
    dy=(Ymax-Ymin)/resolution;
    Edges{1}=Xmin:dx:Xmax;
    Edges{2}=Ymin:dy:Ymax;

    Im = hist3([Xpos',Ypos'],'Edges',Edges);
    TempX=-1:dx:1;
    TempY=-1:dy:1;
    ConVecX = exp(-0.5*(TempX/sigma_render).^2); 
    ConVecY = exp(-0.5*(TempY/sigma_render).^2);
    Im2 = conv2(ConVecX,ConVecY,Im);
    Im2=Im2/max(max(Im2));
    Im2=Im2(:,end:-1:1)';

    figure
    imshow(Im2,hot);
    colormap(hot)
    imcontrast(gca)