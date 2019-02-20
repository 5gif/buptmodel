%% IMT-2020 Channel Model Software
%% Copyright:Zhang Jianhua Lab, Beijing University of Posts and Telecommunications (BUPT)
%% Editor:Zhang Jianhua (ZJH), Tian Lei (TL)
%% Version: 1.0   Date: Dec.15, 2017

clc;  
clear ;
%% Channel coefficient generation for 1 UT-BS link with default settings. 
%Create folder to store data
if ~exist('SSP') 
    mkdir('SSP')         % if SSP does not exist, create it.
end
cd ./SSP;
delete *.mat;
cd ../;
if ~exist('H') 
    mkdir('H')         % if SSP does not exist, create it.
end
cd ./H;
delete *.mat;
cd ../;
if ~exist('LSP') 
    mkdir('LSP')         % if SSP does not exist, create it.
end
cd ./LSP;
delete *.mat;
cd ../
if ~exist('LayoutParameters') 
    mkdir('LayoutParameters')         % if SSP does not exist, create it.
end
cd ./LayoutParameters;
delete *.mat;
cd ../
if ~exist('ScenarioParameters') 
    mkdir('ScenarioParameters')         % if SSP does not exist, create it.
end
cd ./ScenarioParameters;
delete *.mat;
cd ../
Input=struct('Sce','UMi_B',... %Set the scenario (InH_x, UMi_x, UMa_x, RMa_x)
    'C',7,...           %Set the number of Bs
    'N_user',7,...    %Set the number of subscribers per Bs
    'fc',6,...          %Set the center frequency (GHz)
    'AA',[1,1,10,1,1,2.5,2.5,0.5,0.5,102],... %AA=(Mg,Ng,M,N,P,dgH,dgV,dH,dV,downtilt)  BS antenna panel configuration,unit of d and dg is wave length.
    'sim',1,...         %Set the number of simulations
    'BW',200,...        %Set the bandwidth of the simulation(MHz)
     'T',10 );            %Set the number of sampling points of CIR in time domain

layoutpar=Layout(Input.Sce,Input.C,Input.N_user,Input.fc,Input.AA);
[Pathloss,SF_sigma]=GeneratePathloss(layoutpar);%Generate path loss and shadow fading.
fixpar=Scenario(Input.fc,layoutpar);%Generate scenario information. 
sigmas= GenerateLSP(layoutpar,fixpar);
GenerateSSP(layoutpar,fixpar,Input.sim,sigmas);%Generate small-scale parameters.
GenerateCIR(fixpar,layoutpar,Input.sim,Input.BW,Input.T);%Generate the channel coefficient.

