#include "fjcore.hh"
#include <iostream>
#include <fstream>
#include <sstream>

using namespace std;
using namespace fjcore;


// Notes for Jesse:
// Jesse should implement pT-scheme recombination
// Jesse should implement dynamic rescaling of pseudojets

int main(int argc, char *argv[]) {

   // Defining Scale Factors
   double scaleFactorX = 1.0;//50000.0; //larger than 255px*160nm/px (the largest expected value) 
   double scaleFactorIntensity = 1000000000.0;

   // Parsing Input Arguments

   char* inputFile = argv[1];
   char* outputFile = argv[2];

   //double ClusteringLengthScalePx = 0;
   //ClusteringLengthScalePx = strtod(argv[3],NULL);
   //double ClusteringLengthScale = ClusteringLengthScalePx/scaleFactorX;
   double ClusteringLengthScale = 3.1415;

   // file for read in (space separated)

   ifstream fin(inputFile);


   // getting ready to read in
   string line;
   vector<PseudoJet> event;

   int num = 0;

   while (getline(fin,line)) { // read in line by line
      num++;
      
      // convert to stringstream for easy parsing.
     
      stringstream stream(line);
      double label;
      double time;
      double x;
      double y;
      double intensity;
 
      stream >> label >> time >> x >> y >> intensity;
      
    
      // map onto FastJet objects

      double pt = 1.0 + intensity/scaleFactorIntensity;
      double eta = x ;// / scaleFactorX;
      double phi = y ;// / scaleFactorX;
      PseudoJet particle;
      particle.reset_PtYPhiM(pt,eta,phi);
	  particle.set_user_index(label);
      
      // add to event
      event.push_back(particle);
   }
   
   cout << event.size() << endl;
   
   
   // Run Fastjet algorithm 

   fjcore::JetDefinition jetDef(cambridge_algorithm, ClusteringLengthScale);
   ClusterSequence cs(event, jetDef);
   vector<ClusterSequence::history_element>  history=cs.history();
   
   ofstream fout_dendrogram(outputFile);

   for (int nLoop = 0; nLoop < history.size(); nLoop++) {
	   
	   double dij = history[nLoop].dij;
	   int parent1 = history[nLoop].parent1;
	   int parent2 = history[nLoop].parent2;
	   
	   //if (parent2 == -1) {
	   // 	break;
	  //		}
	   
	   fout_dendrogram  << parent1+1 << " " << parent2+1 << " " << dij << endl;
	
   		}

   
   return 0;
}
