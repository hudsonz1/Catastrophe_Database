# Spacecraft Debris Database
Version 1.0.0

Author: Marta Lopez Castro
Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.

The aim of this repository is to give the tools for the generation and analysis of debris database in Cislunar region due to explosions in different orbits.
A detailed explanation of the problem statement can be found on Ref. PAPER.

There are three main codes in the repository, that have to be launched sequentially to complete the proccess:

1. orbitdatabase.m: generate a set of initial conditions with parameters chosen by the user. Pre-computed orbit family data sets are required. It can be found in URL: https://data.mendeley.com/datasets/9j4hk7k9tb/1.

2. explosiondatabase.m: generate separate .mat containing the data from each propagated explosion.

3. debrisdatabase.m: compile selected explosion data for analysis and plotting.


IMPORTANT INFORMATION: 

All files and plots generated are automatically stored, therefore it is MANDATORY to respect the folder structure of the repository


FOLDER STRUCTURE:

matlab codes
 
 orbitdatabase.m
 explosiondatabase.m
 debrisdatabase.m
 -> 00 functions
	--> data_management
		createspecificorbitdatabase.m
		databasecreate.m
	--> dynamic_model
		cr3bp.m
		explosion.m
		JC_CR3BP.m
		lagrange.m
	--> explosion_model
		NASA_BM_EVOLVE4.m
	--> system_data
		somedata.m
	--> results_analysis
		classofdebris.m
		---> plotting
			danger_Lpoints_plotting.m
			evolutiondebrisplotting.m
			ICplotting.m
			twodplot.m
			ICplottingfromorbitdatabase.m
			----> Auxiliary
				circle.m	
				DrawEarthCR3BPnondim.m
				DrawMoonCR3BPnondim.m
				----->imagePlanets
					2k_earth.JPG
					2k_moon.jpg
					moonrev.png
			----> comparison
				danger_Lpoints_comparison.m
				debris_evolution_comparison.m			
 -> 01 orbits
	--> orbit_families
		!!(Store here orbit family data sets)!!
	--> specific_orbit_families
		!!(Store here folders with Lyapunov explosions included in url:bbb, i.e., sp_orbit_5_20_L1 and sp_orbit_5_20_L2)!!
		if generating new explosions, these are saved in this path
 -> 02 plots


