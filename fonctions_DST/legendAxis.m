function legendAxis(TextTable,fig,subfig,language,fontsize)
%% =========================================================================
%Usage: legendAxis(TextTable,fig,subfig,language,fontsize)  
%TextTable should be of the form:
%TextTable.fig(N°).subfig(N°).en={'title','yaxis','xaxis'}
%--------------------------------------------------------------------------
%Features: -Goal is to automatize the legending of the title and axes
%          -call just after refering to the subfigure
%          -languages 
%--------------------------------------------------------------------------
% Function created in nov 2009 - adrien chopin 
%--------------------------------------------------------------------------
%
%Exemple of a TextTable:
% TextTable.fig6.subfig1.en={'title',sprintf('Biased Moving Surface \n Seen in Front (%%)',a),'Stimulus Orientation (°)'}; %#ok<CTPCT>
% TextTable.fig7.subfig1.en={'',sprintf('Downward Moving Surface \n Seen in Front (%%)',a),'Stimulus Orientation (°)'}; %#ok<CTPCT>
% TextTable.fig8.subfig1.en={'PSE',sprintf('PSE Shift Relative to Block 1 (°)',a),'Block (#)'}; %#ok<CTPCT>
% TextTable.fig9.subfig1.en={'','Search Time (s)','Block (#)'};
%
if not(exist('fontsize','var'));fontsize=24;end
    figS=strcat('fig',num2str(fig));
    subfigS=strcat('subfig',num2str(subfig));
    axisTextes=TextTable.(figS).(subfigS).(language);
    ylabel(axisTextes{2},'fontsize',fontsize);xlabel(axisTextes{3},'fontsize',fontsize);title(axisTextes{1},'fontsize',fontsize);
    set(gca,'FontSize',fontsize);
end