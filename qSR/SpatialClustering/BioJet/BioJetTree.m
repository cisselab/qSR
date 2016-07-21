function tree=BioJetTree(Frames,Xpos,Ypos,Intensity,writefilename,fastjetoutfilename)
    
    %Define where the BioJetsTree compiled function is stored on computer
    FastJetPath = '/Users/Owen/Documents/MATLAB/qSR/qSR/SpatialClustering/BioJet/FJCore/fjcore-3.2.0/';

    %Rescale Position Data. Note: One dimension in fastjet is periodic with period 2pi, so
    %restricting it to the region [0,1] will prevent forming "wraparound"
    %clusters.
    largest_value=max([Xpos,Ypos]); 
    XposScaled=Xpos/largest_value;
    YposScaled=Ypos/largest_value;
    
    %Write data into a text document that BioJetsTree can read
    write_data=[1:length(Frames);Frames;XposScaled;YposScaled;Intensity]';
    dlmwrite(writefilename,write_data,'delimiter',' ','precision',16)
    
    %Change to the BioJetsTree directory, execute the program and return to
    %the present directory. 
    currentDir=cd;
    cd(FastJetPath);
    BioJetsCallFunction = ['./BioJetsTree ',writefilename,' ',fastjetoutfilename];
    status = system(BioJetsCallFunction)
    cd(currentDir);
    
    tree = dlmread(fastjetoutfilename,' ');
    
    tree(:,3)=tree(:,3).*largest_value;
    
    