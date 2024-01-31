Deze Matlab-files schreef ik voor mijn bachelorproject aan de UvA. Mijn onderwerp was
afsprakenplanning in de gezondheidszorg. Het doel van mijn project was om de 
optimale tussenaankomsttijden van patienten in een huisartsenpraktijk te bepalen, 
zodanig dat er zo min mogelijk wachttijd van de patienten en inactieve tijd van 
de dokter ontstaat.

De optimale tussenaankomsttijden had ik exact berekend met het model uit de master's
thesis van Mendel (http://www.math.tau.ac.il/~hassin/sharon_thesis.pdf). De bijbehorende
Matlab-files zijn:
optimizeMendel
risk
p_mat 

De optimale tussenaankomsttijden had ik ook met simulatie en stochastische
benaderingsmethoden benaderd. De doelfunctie die ik hier gebruikte komt uit het
proefschrift van Kuiper (https://pure.uva.nl/ws/files/2776103/174963_AlexKuiper_Thesis_complete.pdf).
En de stochastische benaderingsmethoden die ik gebruikte komt uit het artikel van Spall
(10.1109/7.705889). De bijbehorende Matlab-files zijn:
optimizeSim
risk_sim
fminSPSA
fminFDSA

De doelfunctie had ik grafisch kunnen weergeven in de tweede en derde dimensie. De bijbehorende
Matlab-files zijn:
plot2DobjfMendel
plot3DobjfMendel
plot2DobjfSim
plot3DobjfSim

De resterende Matlab-files had ik geschreven om de invloed van een specifieke variabele
op de optimale tussenaankomsttijden te onderzoeken


~ Hamzah Nojosemito
