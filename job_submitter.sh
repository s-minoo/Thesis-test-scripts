#!/usr/bin/env bash

__ScriptVersion="0.0.1"

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
function usage ()
{
    echo "Usage :  $0 [options] [--]

    Options:
    -h|help       Display this message
    -v|version    Display script version"

}    # ----------  end of function usage  ----------

#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hvm:o:" opt
do
  case $opt in
    m|mapping-file ) 
        MAPPING_FILE_CONAINER_PATH=$OPTARG ;; 
    o|output-path ) 
        OUTPUT_PATH=$OPTARG ;; 

    h|help     )  usage; exit 0   ;;

    v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

    \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;

    :  ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;

    * )  echo -e "\n  Option does not exist : $OPTARG\n"
          usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))


JOB_CLASS_NAME="io.rml.framework.Main"
JM_CONTAINER=$(docker ps --filter name=jobmanager --format={{.ID}})

docker cp resources/RMLStreamer-2.0.1-SNAPSHOT.jar  "${JM_CONTAINER}":/job.jar
docker exec -t -i "${JM_CONTAINER}" flink run -d -c ${JOB_CLASS_NAME} /job.jar toFile --mapping-file $MAPPING_FILE_CONAINER_PATH --output-path $OUTPUT_PATH  
