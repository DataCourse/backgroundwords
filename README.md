## Analysis Script for the Pre-Course Survey ##

This repository contains the analysis script for the pre-course survey that was administered to students who signed up for the [Data Management for Clinical Research](https://www.coursera.org/course/datamanagement).

You can replicate this survey by uploading the data dictionary to an empty REDCap project. The data dictionary is saved in the main directory in the `REDCap_DataDictionary.csv` file.

To replicate the analysis, you will need to have the following:

1. The R open source statistical language (you will need to install the packages `cshapes`, `wordcloud` and `latticeExtra`

2. This analysis script and code. You can download it from this repository on GitHub as a zip file or by cloning the git repository on your local machine (if you have git installed) 

3. A data export of the survey results (which in the case of REDCap you can get by using the **Data Export Tool**.) Save the export file as `mysurveys.csv` in the `input` directory.

4. Make sure your working directory is the root directory of this code, then source the file `surveyanalysis.R`

The results will be saved in the `output` directory.

