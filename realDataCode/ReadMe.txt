% ----------------------------------------------------------------------------------
%   Title:  A Statistical Framework for Visualization of Positional Uncertainty in Deep Brain Stimulation Electrodes
%   Authors: Tushar M. Athawale (tushar.athawale@gmail.com), Kara A. Johnson, Chris. R. Butson, and Chris R. Johnson	
%   Date: 06/26/2019
% ---------------------------------------------------------------------------------------

Visualization of real data(Fig. 9 and Fig. 10 in the paper)-

NOTE: The provided MATLAB code in will ERROR OUT, since we can not make a few data, such as high-resolution image of DBS lead electrodes and patient data, publicly available. 
If you would like access to these data, please reach out to one of the authors of the paper.

Required software to produce visualizations:

MATLAB (v.2018a), SCIRun (v.5), ParaView (v.5.4.1). MATLAB is used for computation and generation of visualization files. SCIRun is used for visual analysis of patient image and setting a few parameters 
values in the MATLAB scripts. Paraview is to visualize files generated using MATLAB.

Directories info:
data: contains a high-resolution veritically oriented (+ve Z axis) DBS lead image (We can not make this data publicly available! Please contact the authors if you would like access to this data)
realData: contains a post-operative CT scan of a patient implanted with DBS electrodes (We can not make this data publicly available! Please contact the authors if you would like access to this data)
electordeFunctions, helperFunctions: Matlab scripts frequently used by main Matlab files
SCIRunNetworks: network used in the SCIRun software to visually analyze DBS electrodes isosurface
paraviewStateFiles: The state files to be used in the Paraview software to produce visualizations in the paper
results: contain visualization files produced using MATLAB scripts, which are fed as input to the ParaView software (You may use these pre-generated files to for generating visualizations in ParaView)

Workflow:

- quantifyCenterUncertainty.m:

Navigate to a directory your_working_directory/dbsElectrodesPositionalUncertainty/realDataCode/ and run quantifyCenterUncertainty.m. The quantifyCenterUncertainty.m consists of three steps.

Step 1:  caluculateSolidAngle.m : Qantify the longitudinal (directional) uncertainty in the DBS lead for input test image (Section 3.2 in the paper)

     *** This is a semi-automatic step and needs to be provided with approximate outer and inner bounding box plane numbers for electrode isosurface.
         We used the SCIRun software to gain the sense of outer and inner bounding boxes. 

     a) How to use the SCIRun software for this specific project to determine the inner and outer bounding boxes for DBS electrode isosurfaces (Fig. 5 in paper)?
     
     1) Download and install SCIRun5 from: http://www.sci.utah.edu/cibc-software/scirun.html
     2) Navigate to a directory which contains the SCIRun executable, e.g, your_software_directory/SCIRun5/bin/SCIRun/ and hit ./SCIRun in the terminal
     You will see the SCIRun Gui.
     3) Now load a provided SCIRun network (directory: SCIRunNetworks) for this project. For that, click File->Load in SCIRun, and load the network (SRN extension) located in the SCIRun Networks directory.
     The network name is identifyTerminalContactRegionThroughVis.srn5.
     4) Hover on ReadField block of the network, and click on three horizontal lines. Load the path where test image (directory: realData, Crop_NYU002_PostCT_T1space.nrrd) is located. 
     5) Now, run the network by clicking on a green arrow on the top left of the SCIRun Gui, and double-click on the viewScene block. You should see a DBS elctrodes-like isosurface 
     (Fig. 5 in the paper) with test image planes along X, Y, and Z directions.
     6) If you see a very thin or no isosurface in step 5, hover mouse on the ExtractSimpleIsosurface block and play with isovalues to get an isosurface with reasonable thickness.
     7) The bounding box estimates in SCIRun environment can be, thus, obtained by playing around with the electrode isovalues, and moving planes using GetSliceFromStructuredFieldByIndices 
     (three blocks for X, Y, and Z directions, respectively.)

     Set the values of the outer bounding box found in step 7 into a MATLAB script calculateSolidAngle.m on lines 80 to 85 (variables x1,x2,y1,y2,z1,z2). Note that the one 
     needs to be added to the bounding box limits found in the SCIRun, since 0 in SCIRun corresponds to 1 in matlab.

     Set the uncertainty (in terms of the number of imaging planes, thus, only integers and no fractions) for the outer bounding box by setting variables nlmX, nlmY, and nlmZ. 
     Usually these numbers are 1, 2, or 3 with 1 being lower uncertainty and 3 being high uncertainty in electrode positions.     
         
     b) Having set the outer and inner bounding box limits, the execution of the calculateSolidAngle.m script will dump following four result files into the directory 
     your_working_directory/dbsElectrodesPositionalUncertainty/realDataCode/results/patient1/:
     
     cropLimits.txt: Contains limits of visually estimated outer bounding box for electrodes isosurface (using SCIRun) in format x1 x2 y1 y2 z1 z2
     phiThetaArray: Contains array of phi (elevation) and theta (azimuth) for eight bounding boxes in format phi1,.., phi8 (in row 1) and theta1,.., theta8 (in row 2)
     minPhiMinThetaMaxPhiMaxThetaTruePhiTrueTheta.txt: Contains an array representing longitudinal uncertainty (order self explanatory from the file name) 
     reverseMinPhiMinThetaMaxPhiMaxThetaTruePhiTrueTheta.txt: again, contains an array representing longitudinal uncertainty
     meanPhiMeanTheta.vtk: a 3D line representing the mean DBS lead trajectory

	The visualization of longitudinal uncertainty for the DBS lead:
	1) Start Paraview and go to File->Load State
	2) a) open the provided Paraview state file your_working_directory/dbsElectrodesPositionalUncertainty/realDataCode/paraviewStateFiles/visLongitudinalUncertainty.pvsm
   	   b) Select "search files under specified directory" for the "Load State Data File Options"
   	   c) Navigate to a directory containing visualization files for longitudinal uncertainty, specifically, codePublicRepo/syntheticDataCode/syntheticDatasetCode/syntheticData/noisyData/smoothing1/1_1_0.55_1.3/
	3) You should now see longitudinal uncertainty visualization and interact with it. Make sure that you set the parameters of both speheres as follows:
     	   - Set the phi and theta range for the sphere 1 as generated in the file minPhiMinTheataMaxPhiMaxThetaTruePhiTrueTheta.txt.
      	   - Set the phi and theta range for the sphere 2 as generated in the file reverseMinPhiMinThetaMaxPhiMaxThetaTruePhiTrueTheta.txt

- Step 2: computeLikelihood.m: Quantification of existential likelihood of DBS contact centers in space at subvoxel levels for the test image (Section 3.3 in the paper)

Draw Monte Carlo samples from filtered high-resolution image of DBS lead rotated along the mean of uncertain longitudinal directions, and compare each sample with the post-operative CT scan of patient.

- Step 3: visualizeRealData.m: Generate visualization files (Fig. 9/10 in the paper)

The following files will be generated in the directory your_working_directory/dbsElectrodesPositionalUncertainty/realDataCode/results/patient1/vis/ssim/ corresponding to Fig. 9 in the paper:

meanDirection.vtk: stores the mean DBS lead direction
likelihood.vtk: Writes a likelihood volume
mostProbableCenters.vtk: The most probable DBS contact-center positions
testImage.nrrd: post-operative scan of patient implanted with DBS electrodes
contact0, contact1, contact2, contact3: Contact spatial likelihood resampled at higher resolution using linear interpolation

Visualization of files generated in the Step 3:

1) Start Paraview and go to File->Load State
2) a) open the provided Paraview state file your_working_directory/dbsElectrodesPositionalUncertainty/realDataCode/paraviewStateFiles/realDataVis.pvsm
   b) Select "search files under specified directory" for the "Load State Data File Options"
   c) Navigate to a directory containing visualization files for subvoxel level uncertainty, specifically, your_working_directory/dbsElectrodesPositionalUncertainty/realDataCode/results/patient1/vis/ssim/, and hit ok.
3) You should now interactively be able to visualize positional likelihood for DBS contact centers

Note: If you want to visualize images reported in Fig. 10 of the paper, please change the kSize parameter in quantifyCenterUncertainty.m on line 66 and reexecute quantifyCenterUncertainty.m

     



 