Version 2.0.0

Author: Marta Lopez Castro
Copyright 2023 - 2025 David Canales Garcia; All Rights Reserved.

The aim of this repository is to give the tools for the generation and analysis of debris database in Cislunar region due to explosions in different orbits.
A detailed explanation of the problem statement can be found on Ref. PAPER.

There are three main codes in the repository, that have to be launched sequentially to complete the proccess:

1. orbitdatabase.m: generate a set of initial conditions with parameters chosen by the user. Pre-computed orbit family data sets are required. It can be found in URL: https://data.mendeley.com/datasets/9j4hk7k9tb/1

2. explosiondatabase.m: generate separate .mat containing the data from each propagated explosion.

3. debrisdatabase.m: compile selected explosion data for analysis and plotting.


IMPORTANT INFORMATION: 

All files and plots generated are automatically stored, therefore it is MANDATORY to respect the folder structure of the repository shown below:


FOLDER STRUCTURE:

matlab codes
 
 orbitdatabase.m
 explosiondatabase.m
 debrisdatabase.m
 othersatellitestudy.m
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
	--> other_satellite
		danger_othersat_plotting.m
		IC_other_sat.m
	--> results_analysis
		classofdebris.m
		---> plotting
			danger_Lpoints_plotting.m
			evolutiondebrisplotting.m
			ICplotting.m
			twodplot.m
			ICplottingfromorbitdatabase.m
			density_map_plotting.m
			trajectory_plotting.m
			twodplot_moon_explosion.m
			----> Auxiliary
				circle.m	
				DrawEarthCR3BPnondim.m
				DrawMoonCR3BPnondim.m
				ZVC_plot_xy.m
				----->imagePlanets
					2k_earth.JPG
					2k_moon.jpg
					moonrev.png
			----> comparison
				danger_Lpoints_comparison.m
				debris_evolution_comparison.m			
 -> 01 orbits (This folder needs to be created, as well as the next subfolders)
	--> orbit_families
		!!(Store here orbit family data sets)!!
	--> specific_orbit_families
		!!(Store here folders with Lyapunov explosions included in url: https://datacommons.erau.edu/datasets/x4g4f3t98p/1, i.e., sp_orbit_5_20_L1 and sp_orbit_5_20_L2)!!
		if generating new explosions, these are saved in this path
 -> 02 plots (This folder needs to be created)

OTHER EXPLOSIONS DATASET:

40 explosions along 5 orbits of each different family are also simulated and included in the following urls. The datasets structure is the same aforementioned. It is also included a single JSON file that contains all the explosions computed in that family.

Axial_L1: https://data.mendeley.com/datasets/8mwb28h4g6/1
Axial_L2: https://data.mendeley.com/datasets/4g28tkstj8/1
Axial_L4L5: https://data.mendeley.com/datasets/nn225wtdfd/1
Distant_Retrograde_2D: https://data.mendeley.com/datasets/s5y3bwsjz9/1
Distant_Retrograde_3D: https://data.mendeley.com/datasets/bjsw4m983g/1
Halo_L1: https://data.mendeley.com/datasets/g47z49pk76/1
Halo_L2: https://data.mendeley.com/datasets/sfdvcrndm5/1
Lyapunov_L1: https://data.mendeley.com/datasets/vhcytfzd94/1
Lyapunov_L2: https://data.mendeley.com/datasets/8r4dsrnzz6/1


