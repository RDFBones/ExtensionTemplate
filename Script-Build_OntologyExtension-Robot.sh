#! /bin/bash


## VARIABLES
## =========

cleanup=0
update=0
build=0


## USAGE FUNCTION
## ==============

function usage {
    echo " "
    echo "usage: $0 [-b][-c][-u]"
    echo " "
    echo "    -b          build owl file"
    echo "    -c          cleanup temporary files"
    echo "    -u          initialise/update submodules"
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


    ## TEMPLATES
    ## ---------


    ## Create value specifications

    robot template --template template-value_specifications.tsv \
	  --prefixes prefixes.json \
	  --input dependencies/RDFBones-O/robot/results/rdfbones.owl \
	  --output results/template_ValueSpecifications.owl

    robot merge --input dependencies/RDFBones-O/robot/results/rdfbones.owl \
	  --input results/template_ValueSpecifications.owl \
	  --output results/merged_Core-VS.owl


    ## Create data items

    robot template --template template-data_items.tsv \
	  --prefixes prefixes.json \
	  --input results/merged_Core-VS.owl \
	  --output results/template_DataItems.owl

    robot merge --input results/merged_Core-VS.owl \
	  --input results/template_DataItems.owl \
	  --output results/merged_Core_VS_DI.owl
    

    ## Create data sets

    robot template --template template-data_sets.tsv \
	  --prefixes prefixes.json \
	  --input results/merged_Core_VS_DI.owl \
	  --output results/template_DataSets.owl

    robot merge --input results/merged_Core_VS_DI.owl \
	  --input results/template_DataSets.owl \
	  --output results/merged_Core_VS_DI_DS.owl

    ## Create assays

    robot template --template template_assays.tsv \
	  --prefixes prefixes.json \
	  --input results/merged_Core_VS_DI_DS.owl \
	  --output results/template_assays.owl
	  


    ## MERGE TEMPLATE OUTPUTS
    ## ----------------------

    robot merge --input results/template_ValueSpecifications.owl \
	  --input results/template_DataItems.owl \
	  --input results/template_DataSets.owl \
	  --input results/template_assays.owl \
	  --output results/template.owl

    
    ## ANNOTATE OUTPUT
    ## ---------------

    robot annotate --input results/template.owl \
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
	  --output results/template.owl


    ## CONSISTENCY TEST
    ## ----------------

    robot reason --reasoner ELK \
	  --input results/template.owl \
	  -D results/debug.owl

fi


## CLEANUP
## =======


## CLEANUP TEMPORARY FILES IN DEPENDENCIES
## ---------------------------------------

FILE=dependencies/RDFBones-O/robot/results/
if [ -f "$FILE" ]; then
    rm -r dependencies/RDFBones-O/robot/results/
fi


## CLEANUP TEMPORARY FILES
## -----------------------


if [ $cleanup -eq 1 ]; then
    cd results
    find . -not -regex "./template.owl" -delete
    cd ..
fi
