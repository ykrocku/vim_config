#! /bin/bash
#File:	project.sh
#Usage:	Create/Update/Remove Vim project file
#Param:	create:	create project
#	update:	update project
#	remove:	remove project
#
#

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
	echo `basename $0` $CREATE: "create project"
	echo `basename $0` $UPDATE: "update project"
	echo `basename $0` $REMOVE: "remove project"
}
#
CreateProject()
{
	if [ -f $CTAG_FILE ]
	then
		echo $CTAG_FILE "exist, Skip!"
	else
		ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -f $CTAG_FILE
	fi

	if [ -f $CSCOPE_FILE ]
	then
		echo $CSCOPE_FILE "exist, Skip"
	else
		cscope -Rbq
	fi

	touch $PRJ_FILE
	echo -e $PRJ_FILE_CONTENT > $PRJ_FILE
	touch $VIM_SESSSION_FILE
	touch $VIM_INFO_FILE
}

#
RM_FLAG="-f"
RemoveProject()
{
	rm $RM_FLAG $PRJ_FILE
	rm $RM_FLAG $CTAG_FILE
	rm $RM_FLAG $CSCOPE_FILES
	rm $RM_FLAG $VIM_INFO_FILE
	rm $RM_FLAG $VIM_SESSSION_FILE
}
#
UpdateProject()
{
	rm $RM_FLAG $CTAG_FILE
	rm $RM_FLAG $CSCOPE_FILES
	CreateProject
}
if [ ! -n "$1" ]
then
	Usage
	exit
elif [ $1 == $CREATE ]
then
	#echo "Start Create Project..."
	CreateProject
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
