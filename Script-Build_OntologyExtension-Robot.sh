#! /bin/bash

## META DATA
## =========

export title="RDFBones ontology extension template"
export shortname="template"
export version="0.1"
export ontology_iri="http://w3id.org/rdfbones/ext/template/latest/template.owl"
export version_iri="http://w3id.org/rdfbones/ext/template/v0-1/template.owl"
export creator="Felix Engel"
export contributors="Stefan Schlager, Lukas Bender"
export description="Extensions to the RDFBones core ontology are written to implement data structures representing osteological reseearch data in biological anthropology. The RDFBones ontology extension template provides a repository outline to help researchers embarking on the creation of an ontology extension. This output is dummy content proving that the template is operational and demonstrating how it is to be used. Authors of ontology extensions need to replace the dummy content with the information they intend to model in order to receive the desired outcome."
export comment="This is a dummy for an ontology extending the RDFBones core ontology. It is not intended for productivity but to demonstrate how the template for RDFBones ontology extensions works."



## VARIABLES
## =========

export cleanup=0
export update=0
export build=0
export full=0


## USAGE FUNCTION
## ==============

function usage {
    echo " "
    echo "usage: $0 [-b][-c][-u]"
    echo " "
    echo "    -b          build owl file"
    echo "    -c          cleanup temporary files"
    echo "    -u          initialise/update submodules"
    echo "    -f          merge extension with the core ontology and all dependencies and output as one owl file"
    echo "    -h -?       print this help"

    exit

}

while getopts "bcuh?" opt; do
    case "$opt" in
	c)
	    cleanup=1
	    ;;
	u)
	    update=1
	    ;;
	b)
	    build=1
	    ;;
	f)
	    full=1
	    ;;
	?)
	    usage
	    ;;
	h)
	    usage
	    ;;
    esac
done

if [ -z "$1" ]; then
    usage
fi


## SUBMODULES
## ==========

## Check if submodules are initialised

gitchk=$(git submodule foreach 'echo $sm_path `git rev-parse HEAD`')
if [ -z "$gitchk" ]; then
    update=1
    echo "Initialising git submodules"
fi

## Initialise and update git submodules

if [ $update -eq 1 ]; then
    git submodule init
    git submodule update
    echo "Updating git submodules"
fi


## BUILD ONTOLOGY EXTENSION
## ========================

if [ $build -eq 1 ]; then


    ## DEPENDENCIES
    ## ------------

    echo "Building dependencies"

    ## Build core ontology

    cd dependencies/RDFBones-O/robot/

    ./Script-Build_RDFBones-Robot.sh

    cd ../../../

    ## Add additional build instructions as exemplified for the core ontology above
    ## ****************************************************************************

    ## Merge dependencies

    echo "Merging dependencies"

    robot merge --input dependencies/RDFBones-O/robot/results/rdfbones.owl \
	  --output results/dependencies.owl
    
    ## Add additional dependencies files as input
    ## ******************************************


    ## TEMPLATES
    ## ---------

    
    echo "Processing category labels template"

    ## Create category labels

    robot template --template template-category_labels.tsv \
	  --prefixes prefixes.json \
	  --input results/dependencies.owl \
	  --output results/template_CategoryLabels.owl

    echo "Merging category labels"

    robot merge --input results/dependencies.owl \
	  --input results/template_CategoryLabels.owl \
	  --output results/merged.owl


    ## Create value specifications

    echo "Processing value specifications template"

    robot template --template template-value_specifications.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_ValueSpecifications.owl

    echo "Merging value specifications"

    robot merge --input results/merged.owl \
	  --input results/template_ValueSpecifications.owl \
	  --output results/merged.owl

    robot merge --input results/template_CategoryLabels.owl \
	  --input results/template_ValueSpecifications.owl \
	  --output results/extension.owl


    ## Create data items

    echo "Processing data items template"

    robot template --template template-data_items.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_DataItems.owl

    echo "Merging data items"

    robot merge --input results/merged.owl \
	  --input results/template_DataItems.owl \
	  --output results/merged.owl
    

    ## Create data sets

    echo "Processing data sets template"

    robot template --template template-data_sets.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_DataSets.owl

    echo "Merging data sets"

    robot merge --input results/merged.owl \
	  --input results/template_DataSets.owl \
	  --output results/merged.owl

    robot merge --input results/extension.owl \
	  --input results/template_DataSets.owl \
	  --output results/extension.owl

    
    ## Create assays

    echo "Processing assays template"

    robot template --template template-assays.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_Assays.owl

    echo "Merging assays"

    robot merge --input results/merged.owl \
	  --input results/template_Assays.owl \
	  --output results/merged.owl

    robot merge --input results/extension.owl \
	  --input results/template_Assays.owl \
	  --output results/extension.owl


    ## Create data transformations

    robot template --template template-data_transformations.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_DataTransformations.owl

    robot merge --input results/merged.owl \
	  --input results/template_DataTransformations.owl \
	  --output results/merged.owl

    robot merge --input results/extension.owl \
	  --input results/template_DataTransformations.owl \
	  --output results/extension.owl


    ## Create Conclusion Processes

    echo "Processing conlusion processes template"

    robot template --template template-conclusion_processes.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_ConclusionProcesses.owl

    echo "Merging conclusion processes"

    robot merge --input results/merged.owl \
	  --input results/template_ConclusionProcesses.owl \
	  --output results/merged.owl

    robot merge --input results/extension.owl \
	  --input results/template_ConclusionProcesses.owl \
	  --output results/extension.owl


    ## Create Study Design Execution Processes

    echo "Processing study design execution processes template"

    robot template --template template-study_design_executions.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_StudyDesignExecutions.owl

    echo "Merging study design execution processes"

    robot merge --input results/merged.owl \
	  --input results/template_StudyDesignExecutions.owl \
	  --output results/merged.owl

    robot merge --input results/extension.owl \
	  --input results/template_StudyDesignExecutions.owl \
	  --output results/extension.owl


    ## Create Protocols

    echo "Processing protocols template"

    robot template --template template-protocols.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_Protocols.owl

    echo "Merging protocols"

    robot merge --input results/merged.owl \
	  --input results/template_Protocols.owl \
	  --output results/merged.owl

    robot merge --input results/extension.owl \
	  --input results/template_Protocols.owl \
	  --output results/extension.owl


    ## Create Study Designs

    echo "Processing study designs template"

    robot template --template template-study_designs.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_StudyDesigns.owl

    echo "Merging study designs"

    robot merge --input results/merged.owl \
	  --input results/template_StudyDesigns.owl \
	  --output results/merged.owl

    robot merge --input results/extension.owl \
	  --input results/template_StudyDesigns.owl \
	  --output results/extension.owl


    ## Create Planning Processes

    echo "Processing planning processes template"

    robot template --template template-planning.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_Planning.owl

    echo "Merging planning processes"

    robot merge --input results/merged.owl \
	  --input results/template_Planning.owl \
	  --output results/merged.owl

    robot merge --input results/extension.owl \
	  --input results/template_Planning.owl \
	  --output results/extension.owl


    ## Create Investigation Processes

    echo "Processing investigation processes template"

    robot template --template template-investigations.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_Investigations.owl

    echo "Merging investigation processes"

    robot merge --input results/merged.owl \
	  --input results/template_Investigations.owl \
	  --output results/merged.owl

    robot merge --input results/extension.owl \
	  --input results/template_Investigations.owl \
	  --output results/extension.owl


    ## DEFINE OUTPUT FILE
    ## ------------------

    cd results
    
    if [ $full -eq 1 ]; then
	output="merged.owl"
    else
	output="extension.owl"
    fi
    

    ## CLEANUP TEMPORARY FILES
    ## -----------------------

    if [ $cleanup -eq 1 ]; then
	echo "Cleaning up temporary files"
	find . -not -regex ./"$output" -delete
    fi


    ## CONSISTENCY TEST
    ## ----------------

    echo "Testing consistency of output"

    robot reason --reasoner ELK \
	  --input "$output" \
	  -D debug.owl

    
    ## ANNOTATE OUTPUT
    ## ---------------

    echo "Annotating output"

    robot annotate --input "$output" \
	  --remove-annotations \
	  --ontology-iri "${ontology_iri}" \
	  --version-iri "${version_iri}" \
	  --annotation owl:versionInfo "${version}" \
	  --language-annotation rdfs:label "${title}" en \
	  --language-annotation rdfs:comment "${comment}" en \
	  --annotation dc:creator "${creator}" \
	  --annotation dc:contributor "${contributors}" \
	  --language-annotation dc:description "${description}" en \
	  --language-annotation dc:title "${title}" en \
	  --output $shortname.owl

    ## Change annotations to describe your extension and change file name in the final output statement.
    ## *************************************************************************************************

    
    ## CLEANUP TEMPORARY FILES
    ## -----------------------

    if [ $cleanup -eq 1 ]; then
	echo "Cleaning up temposrary files"
	rm "$output"
    fi

    cd ..

fi


## CLEANUP
## =======


## CLEANUP TEMPORARY FILES IN DEPENDENCIES
## ---------------------------------------

echo "Cleaning up temporary files in dependencies directories"

## Remove temporary build files in RDFBones core ontology

FILE=dependencies/RDFBones-O/robot/results/
if [ -f "$FILE" ]; then
    rm -r dependencies/RDFBones-O/robot/results/
fi

## Add cleanup commands for additional dependencies as exemplified above for the RDFBones core ontology.
## *****************************************************************************************************
