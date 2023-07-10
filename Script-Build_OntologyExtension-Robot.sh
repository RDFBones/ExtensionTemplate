#! /bin/bash


## VARIABLES
## =========

cleanup=0
update=0
build=0
full=0


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
fi


## BUILD ONTOLOGY EXTENSION
## ========================

if [ $build -eq 1 ]; then


    ## DEPENDENCIES
    ## ------------

    ## Build core ontology

    cd dependencies/RDFBones-O/robot/

    ./Script-Build_RDFBones-Robot.sh

    cd ../../../

    ## Add additional build instructions as exemplified for the core ontology above
    ## ****************************************************************************

    ## Merge dependencies

    robot merge --input dependencies/RDFBones-O/robot/results/rdfbones.owl \
	  --output results/dependencies.owl
    
    ## Add additional dependencies files as input
    ## ******************************************


    ## TEMPLATES
    ## ---------


    ## Create category labels

    robot template --template template-category_labels.tsv \
	  --prefixes prefixes.json \
	  --input results/dependencies.owl \
	  --output results/template_CategoryLabels.owl

    robot merge --input results/dependencies.owl \
	  --input results/template_CategoryLabels.owl \
	  --output results/merged.owl


    ## Create value specifications

    robot template --template template-value_specifications.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_ValueSpecifications.owl

    robot merge --input results/merged.owl \
	  --input results/template_ValueSpecifications.owl \
	  --output results/merged.owl

    robot merge --input results/template_CategoryLabels.owl \
	  --input results/template_ValueSpecifications.owl \
	  --output results/extension.owl


    ## Create data items

    robot template --template template-data_items.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_DataItems.owl

    robot merge --input results/merged.owl \
	  --input results/template_DataItems.owl \
	  --output results/merged.owl
    

    ## Create data sets

    robot template --template template-data_sets.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_DataSets.owl

    robot merge --input results/merged.owl \
	  --input results/template_DataSets.owl \
	  --output results/merged.owl

    robot merge --input results/extension.owl \
	  --input results/template_DataSets.owl \
	  --output results/extension.owl

    
    ## Create assays

    robot template --template template-assays.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_Assays.owl

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

    robot template --template template-conclusion_processes.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_ConclusionProcesses.owl

    robot merge --input results/merged.owl \
	  --input results/template_ConclusionProcesses.owl \
	  --output results/merged.owl

    robot merge --input results/extension.owl \
	  --input results/template_ConclusionProcesses.owl \
	  --output results/extension.owl


    ## Create Study Design Execution Processes

    robot template --template template-study_design_executions.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_StudyDesignExecutions.owl

    robot merge --input results/merged.owl \
	  --input results/template_StudyDesignExecutions.owl \
	  --output results/merged.owl

    robot merge --input results/extension.owl \
	  --input results/template_StudyDesignExecutions.owl \
	  --output results/extension.owl


    ## Create Protocols

    robot template --template template-protocols.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_Protocols.owl

    robot merge --input results/merged.owl \
	  --input results/template_Protocols.owl \
	  --output results/merged.owl

    robot merge --input results/extension.owl \
	  --input results/template_Protocols.owl \
	  --output results/extension.owl


    ## Create Study Designs

    robot template --template template-study_designs.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_StudyDesigns.owl

    robot merge --input results/merged.owl \
	  --input results/template_StudyDesigns.owl \
	  --output results/merged.owl

    robot merge --input results/extension.owl \
	  --input results/template_StudyDesigns.owl \
	  --output results/extension.owl


    ## Create Planning Processes

    robot template --template template-planning.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_Planning.owl

    robot merge --input results/merged.owl \
	  --input results/template_Planning.owl \
	  --output results/merged.owl

    robot merge --input results/extension.owl \
	  --input results/template_Planning.owl \
	  --output results/extension.owl


    ## Create Investigation Processes

    robot template --template template-investigations.tsv \
	  --prefixes prefixes.json \
	  --input results/merged.owl \
	  --output results/template_Investigations.owl

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
	find . -not -regex ./"$output" -delete
    fi


    ## CONSISTENCY TEST
    ## ----------------

    robot reason --reasoner ELK \
	  --input "$output" \
	  -D debug.owl

    
    ## ANNOTATE OUTPUT
    ## ---------------

    robot annotate --input "$output" \
	  --remove-annotations \
	  --ontology-iri "http://w3id.org/rdfbones/ext/template/latest/template.owl" \
	  --version-iri "http://w3id.org/rdfbones/ext/template/v0-1/template.owl" \
	  --annotation owl:versionInfo "0.1" \
	  --language-annotation rdfs:label "RDFBones ontology extension template" en \
	  --language-annotation rdfs:comment "This is a dummy for an ontology extending the RDFBones core ontology. It is not intended for productivity but to demonstrate how the template for RDFBones ontology extensions works." en \
	  --annotation dc:creator "Felix Engel" \
	  --annotation dc:contributor "Stefan Schlager" \
	  --annotation dc:contributor "Lukas Bender" \
	  --language-annotation dc:description "Extensions to the RDFBones core ontology are written to implement data structures representing osteological reseearch data in biological anthropology. The RDFBones ontology extension template provides a repository outline to help researchers embarking on the creation of an ontology extension. This output is dummy content proving that the template is operational and demonstrating how it is to be used. Authors of ontology extensions need to replace the dummy content with the information they intend to model in order to receive the desired outcome." en \
	  --language-annotation dc:title "RDFBones ontology extension template" en \
	  --output template.owl

    ## Change annotations to describe your extension and change file name in the final output statement.
    ## *************************************************************************************************

    
    ## CLEANUP TEMPORARY FILES
    ## -----------------------

    if [ $cleanup -eq 1 ]; then
	rm "$output"
    fi

    cd ..

fi


## CLEANUP
## =======


## CLEANUP TEMPORARY FILES IN DEPENDENCIES
## ---------------------------------------

## Remove temporary build files in RDFBones core ontology

FILE=dependencies/RDFBones-O/robot/results/
if [ -f "$FILE" ]; then
    rm -r dependencies/RDFBones-O/robot/results/
fi

## Add cleanup commands for additional dependencies as exemplified above for the RDFBones core ontology.
## *****************************************************************************************************
