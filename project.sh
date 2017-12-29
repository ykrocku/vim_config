#! /bin/bash
#File:	project.sh
#Usage:	Create/Update/Remove Vim project file
#Param:	create:	create project
#	update:	update project
#	remove:	remove project
#
#

PRJ_ROOT_FOLDER="prj__"
PRJ_FILE="0_0_project"
PRJ_FILE_CONTENT="This is help file\nExecute 'vim project' to enter project\nCreate project files done!"
CREATE="create"
UPDATE="update"
REMOVE="remove"
CTAG_FILE="tags"
CSCOPE_FILE="cscope.out"
CSCOPE_FILES="cscope.out cscope.in.out cscope.po.out"
VIM_SESSSION_FILE="session.vim"
VIM_INFO_FILE="viminfo.vim"
#
Usage()
{
	echo "Usage:"
	echo `basename $0` $CREATE: "create project NAME folder1 folder2 ... foldern"
	echo `basename $0` $UPDATE: "update project"
	echo `basename $0` $REMOVE: "remove project"
}
#
CreateProject() 
{
#project.sh create NAME f1 f2 f3 ... fn
    PRJ_FOLDER=$PRJ_ROOT_FOLDER/$2
    echo "Project folder:" $PRJ_FOLDER

    SRC_FOLDER_LIST=""
    ARGV=($@)
    for (( j=2; j<$#; j++))
    do
	SRC_FOLDER_LIST+=`readlink -f ${ARGV[j]}`" "
    done


    mkdir -p $PRJ_FOLDER 
    pushd $PRJ_FOLDER  1>/dev/null
    if [[ -f $CTAG_FILE || -f $CSCOPE_FILES ]]
    then
	    echo $CTAG_FILE "or" $CSCOPE_FILES "already exist!"
	    return
    fi

    for SRC_FOLDER in $SRC_FOLDER_LIST
    do
    	echo "Indexing " $SRC_FOLDER "..."
	ctags -aR $SRC_FOLDER --c++-kinds=+p --fields=+iaS --extra=+q -f $CTAG_FILE
	find $SRC_FOLDER -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' >> cscope.files
    done
    cscope -bq


    touch $PRJ_FILE
    echo -e $PRJ_FILE_CONTENT > $PRJ_FILE
    echo  $@ >> $PRJ_FILE
    touch $VIM_SESSSION_FILE
    touch $VIM_INFO_FILE
    popd 1>/dev/null
}

#
RM_FLAG="-f"
RemoveProject()
{
    echo "TODO"
}

#
UpdateProject()
{
    echo "TODO"
}
if [ ! -n "$1" ]
then
	Usage
	exit
elif [ $1 == $CREATE ]
then
	if [ ! -n "$2" ]
	then
	    Usage
	    exit
	fi
	CreateProject $@
elif [ $1 == $UPDATE ]
then
	#echo "Start Update Project..."
	UpdateProject
elif [ $1 == $REMOVE ]
then
	#echo "Start Remove Project..."
	RemoveProject
else
	Usage
fi
