Multi-Modal Correlated Centroid Space for Multi-lingual Cross-Modal Retrieval (CSquareSUR)

## Purpose 

Facilitate cross-modal retrieval using the multimodal correlated feature space obtained from different languages.

## Usage

1. Code is distributed into 3 different folders (Matlab, Java and Python)
2. First Run any of the .m files (polynomial kernel or RBF kernel) to generate .mat file containing cross-modal results for English, German and Spanish languages.
	* `$./matlab KMeansRBFRetrieval.m` or `$./matlab KMeansPolyRetrieval.m` 
	* Please NOTE that you can change any of the topics files (10,100 or 200) accordingly by editing Matlab File. (Please check the Matlab Code and see comments to change)			
3. Once you .mat file is generated inside Matlab Folder, Run the .java file inside Java Folder using the command line syntax provided below.
	* Compile--> `$javac -cp jmatio.jar:. GenerateEvaluationFiles.java`
	* Execute--> `$java -cp jmatio.jar:. GenerateEvaluationFiles ../Matlab/<.mat file>`
4. Results are generated inside Java/Results Folder, Now run the python code inside Python Folder to get the final MRR and MAP scores.
	* `$python evaluation.py`
5. To summarize:
	* First run the matlab code then the java code and further python code for the final results.	

## Dependencies (Already Included) :
* KCCA @Liang Sun (sun.liang@asu.edu)
* Java Matlab Conversion lib [http://sourceforge.net/projects/jmatio/]
* Test and Train files [http://www.svcl.ucsd.edu/projects/crossmodal/]

## Dependencies(Install):
* python-recsys [https://github.com/python-recsys/python-recsys]

6. NOTE: Toggle the train and test dataset and re-run the code to get cross-validation results. 

7. Please cite if you use this code.
	* Mogadala, A., and Rettinger, A. (2015). Multi-modal Correlated Centroid Space for Multi-lingual Cross-Modal Retrieval. In Advances in Information Retrieval (pp. 68-79). Springer International Publishing.

## Developed at
AIFB
Karlsruhe Institute of Technology
Karlsurhe
Germany.

For any queries or bug-reports Contact: aditya.mogadala [at] kit [dot] edu
