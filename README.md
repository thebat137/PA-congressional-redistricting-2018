# Introduction
This repository collects all of the different Congressional redistricting plans proposed by parties and amicus filers in the Pennsylvania state court lawsuit _League of Women Voters of Pennsylvania et al. v. Commonwealth of Pennsylvania et al. (No. 159 MM 2017)_.  The original 2011 districting plan which was the subject of the lawsuit and the remedial plan ordered by the Pennsylvania Supreme Court are also included here.

The data provided for each plan has been converted into standardized block equivalency and ESRI shapefiles and combined with demographic and electoral data from the 2011 Pennsylvania legislative redistricting dataset.  Using this data, a few simple statistics are also computed for each plan.  This legislative redistricting dataset was used by the designers of the original (gerrymandered) 2011 plan, and was first made public during the _Agre et al. v. Wolf et al. (2:17-cv-04392)_ federal lawsuit.

The census block level data table from the redistricting dataset is included in this repository; the full dataset may be found in the companion repository https://github.com/thebat137/PA-redistricting-data-2011.  All scripts used to standardize the plans and combine them with the legislative redistricting data are also included in the present repository, and links are provided to the original sources for all publicly-available data and filings.


# Repository contents
The `map data` directory has subdirectories for all parties, each of which has the following contents:
 - `source files`: the supporting data files for the party's plan or plans, as provided by that party
 - `docs`: the briefs, reports, and other filings by that party directly related to analysis of its or another party's remedial plan
 - `corrections`: any auxiliary files generated during the process of standardizing the plan format
 - `block equivalency files`: the block equivalency file(s) for the party's plan(s), to be processed by the standardization script
 - `shapefiles`: the ESRI shapefile(s) for the party's plan(s), to be processed by the standardization script

The `scripts` directory has the various scripts used in processing the data.  All script output is also included in the repository; the scripts are included only for the sake of transparency.  The primary processing script is `stats.R`.  The others apply supporting corrections needed by some specific plans or produce translation tables to deal with the different sets of census blocks used by different parties.  These translation tables are stored in the `census block data` directory, along with the `cbLayer.csv` file which contains the actual 2011 legislative redistricting data.

There are two primary output directories.  The `standardized data` directory contains standardized block equivalency files and ESRI shapefiles for all the plans.  Aggregate plan statistics are output to the `map statistics` directory.  These statistics are a work in progress, with more to come.


# List of districting plans
A list of all districting plans gathered in this repository is below, together with links to PlanScore results for each plan.

|Map                    | Type                   | PlanScore URL
|-----------------------|------------------------|------------------------------------------------------------|
|2011                   | enacted by legislature | https://planscore.org/plan.html?20180218T024238.974318369Z|
|PA Supreme Court       | court ordered          | https://planscore.org/plan.html?20180219T202039.596761160Z|
|ACRU                   | amicus proposal        | https://planscore.org/plan.html?20180218T024328.570455314Z|
|Schneider/Wolf map A   | amicus proposal        | https://planscore.org/plan.html?20180218T024358.280589741Z|
|Schneider/Wolf map B   | amicus proposal        | https://planscore.org/plan.html?20180218T024434.295055622Z|
|CCFD                   | amicus proposal        | https://planscore.org/plan.html?20180218T023235.702533658Z|
|Fair Democracy map 1   | amicus proposal        | https://planscore.org/plan.html?20180218T024511.913516786Z|
|Fair Democracy map 2   | amicus proposal        | https://planscore.org/plan.html?20180218T024542.223110340Z|
|Petitioners map A      | petitioners' proposal  | https://planscore.org/plan.html?20180218T024758.056118526Z|
|Petitioners map B      | petitioners' proposal  | https://planscore.org/plan.html?20180218T024838.789911887Z|
|Governor               | respondents' proposal  | https://planscore.org/plan.html?20180218T024634.301586963Z|
|Lieutenant Governor    | respondents' proposal  | https://planscore.org/plan.html?20180218T024733.791373921Z|
|House Democrats        | respondents' proposal  | https://planscore.org/plan.html?20180218T024704.774498914Z|
|Senate Democrats       | respondents' proposal  | https://planscore.org/plan.html?20180218T025003.806567469Z|
|Scarnati/Turzai        | respondents' proposal  | https://planscore.org/plan.html?20180218T024936.922976451Z|
|Republican intervenors | respondents' proposal  | https://planscore.org/plan.html?20180218T024902.100874227Z|


# Data sources and useful references
This repository draws on a variety of data sources:
 - The Pennsylvania Supreme Court's case document website for _League of Women Voters of Pennsylvania et al. v. Commonwealth of Pennsylvania et al. (No. 159 MM 2017)_<br>
   http://www.pacourts.us/news-and-statistics/cases-of-public-interest/league-of-women-voters-et-al-v-the-commonwealth-of-pennsylvania-et-al-159-mm-2017
 - The Pennsylvania Legislative Reapportionment Commission website<br>
   http://www.redistricting.state.pa.us/index.cfm
 - The Census Bureau's Redistricting Data Program website<br>
   https://www.census.gov/programs-surveys/decennial-census/about/rdo/congressional-districts.115th_Congress.html

The following sites may offer additional useful information on the 2018 Congressional redistricting process and related legal cases.

 - The Public Interest Law Center, counsel for the petitioners in _League of Women Voters v. PA_ have posted case documents here:<br>
   https://www.pubintlaw.org/cases-and-projects/pennsylvania-redistricting-lawsuit-case-documents/
 - The Brennan Center also maintains archives of key documents for cases of interest.  Three different legal challenges were filed in 2017 to the 2011 PA Congressional map:
   - _League of Women Voters of Pennsylvania et al. v. Commonwealth of Pennsylvania et al. (No. 159 MM 2017)_, filed in the Pennsylvania state court system.  This suit was ultimately won by the plaintiffs in a PA Supreme Court decision handed down on January 22, 2018.  The Court ordered the legislature to attempt to design and pass an acceptable replacement map, and, failing that, offered the parties an opportunity to submit alternate proposals for consideration by the Court's expert, Nathaniel Persily.  11 different groups of parties and amicus filers submitted proposed maps by the Court's February 15 deadline.  Some submitted more than one map, for a total of 14 proposed maps.  On February 19, the Court released a map designed by Persily based on consideration of these proposals and orderd its use for the 2018 and subsequent Congressional elections.  The legislative repondents appealed the PA Supreme Court's order to the US Supreme Court, but, on March 19, SCOTUS denied their request for a stay of implementation of the new map.  Thus, the PA Supreme Court's map is currently (as of March 25, 2018) expected to be in effect for the 2018 elections.<br>
     https://www.brennancenter.org/legal-work/league-women-voters-v-pennslyvania
   - _Agre et al. v. Wolf et al. (2:17-cv-04392)_, filed in US federal court in the Eastern District of Pennsylvania.  Unlike the state-level case, which was bound by the legislative privilege provision of the PA state constitution, this case obtained discovery of the GIS data used by the legislature in designing the Congressional and legislative districts in 2011 (including large volumes of election results and partisan voter registration tallies), as well as communications by legislative leadership relating to the process.  A three-judge panel decided 2-1 against the plaintiffs and, as of March 25, 2018, the case is on appeal to the US Supreme Court.<br>
     https://www.brennancenter.org/legal-work/agre-v-wolf
   - _Diamond et al. v. Torres et al. (5:17-cv-05054)_, filed in US federal court in the Eastern District of Pennsylvania.  The _Diamond_ plaintiffs initially attempted to join _Agre v. Wolf_ as intervenor plaintiffs, and, when this was denied, filed a separate lawsuit with a distinct legal basis.  The case is currently (as of March 25, 2018) stayed indefinitely as a result of events in _LWV v. PA_.<br>
     https://www.brennancenter.org/legal-work/diamond-v-torres
   - _Corman et al. v. Torres et al. (1:18-cv-00443)_, filed in US federal court in the Middle District of Pennsylvania.  This case was brought by a group of incumbent Republican Congressmen and two state Senators to challenge the map ordered by the PA Supreme Court.  On March 19, 2018, the Court dismissed the case for lack of standing by the plaintiffs.<br>
     https://www.brennancenter.org/legal-work/corman-v-torres
