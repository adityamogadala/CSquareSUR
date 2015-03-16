Multi-Modal Correlated Centroid Space for Multi-lingual Cross-Modal Retrieval (CSquareSUR)
--------------------------------------------------------------------------------

Purpose: 

Facilitate cross-modal retrieval using the multimodal correlated feature space obtained from different languages.

Usage:

1. Code is distributed into 3 different folders (Matlab, Java and Python)

2. First Run any of the .m files (polynomial kernel or RBF kernel) to generate .mat file containing cross-modal results of English, German and Spanish files.

		 $./matlab KMeansRBFRetrieval.m 
				or 
		 $./matlab KMeansPolyRetrieval.m 

   Please not you can change the topics files according by editing Matlab File. (Please check the Matlab Code for comments)			

3. Once you see the .mat file in Matlab Folder, Now Run java file in Java Folder using the following command line syntax.

	Compile--> $javac -cp jmatio.jar:. GenerateEvaluationFiles.java
        Execute--> $java -cp jmatio.jar:. GenerateEvaluationFiles ../Matlab/<.mat file>

4. You can see some files generated inside Java/Results Folder, Now run the python code inside Python Folder to get the final MRR and MAP scores.

		$python evaluation.py

5. To summarize, first run the matlab code then java code and further the python code for the final results.	


Dependecies (Already Included) :
	KCCA @Liang Sun (sun.liang@asu.edu)
	Java Matlab Conversion lib (http://sourceforge.net/projects/jmatio/)


DEVELOPED AT:
-------------
AIFB
Karlsruhe Institute of Technology
Karlsurhe
Germany.

For any queries or bug-reports Contact: aditya.mogadala [at] kit [dot] edu
