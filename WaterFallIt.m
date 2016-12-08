function [ ] = WaterFallIt( PlotToGen, Wtrfl )
%Reads data from the 'Wtrfl' structure which containts fourier transformed
%versions of every signal, their respective frequency vectors, and the
%identifying cases.

%Creates a new figure & holds until all are plotted
figure
hold on

%Plots the four normal cases
for i = 1:4
    waterfall (i, Wtrfl.NoFault {2,i}, Wtrfl.NoFault {1,i})
end
%Plots the desired cases after the four normal cases
for i = 1:length(Wtrfl.(PlotToGen))
    waterfall (i+4, Wtrfl.(PlotToGen) {2,i}, Wtrfl.(PlotToGen) {1,i})
end
hold off

%Labels the graph and the individual cases from the Wtrfl structure
xlabel ('Case Number')
ylabel ('Frequency (Hz)')
zlabel ('Amplitude')
set(gca,'XTick',0:1:4+length(Wtrfl.(PlotToGen)))
set(gca,'XTickLabel',[' ', (Wtrfl.NoFault {3,1:length(Wtrfl.NoFault)}), (Wtrfl.(PlotToGen) {3,1:length(Wtrfl.(PlotToGen))})], 'fontsize',6)
end
