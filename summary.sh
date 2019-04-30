#!/bin/bash
# yyyu200@163.com
# run as:
# summary.sh scf.out

if [[ -z $1 ]];then
    pwoutfile=`ls -t|grep 'out'|head -1`
    if [[ -z $pwoutfile ]];then
        echo "PWscf output file not found, please specify it"
        exit 1
    fi
else
    pwoutfile=$1
fi
echo "reading $pwoutfile"

summaryfile="summary"

awk 'BEGIN{
        i=0;
        j=0;
        Etot=0;
        printf("      N         E                HF              dE        \n");
} 
/!/&&/total energy/{
        i=i+1;
        j=j+1;
        printf("%3d E= %17.8f",j,$5);
        tmp=$5;
        getline
        printf(" HF= %17.8f", $4);
        getline
        printf(" dE= %17.8e",$5);
        printf(" dEtot= %17.8e\n",tmp-Etot);
        Etot=tmp;
        i=0;
}
/total energy              =/ && (! /!/){
        i=i+1;
        printf("SCF%4d %17.8f",i,$4);
        getline
        printf("%17.8f", $4);
        getline
        printf("%17.8e\n",$5)
}' $pwoutfile > $summaryfile

if [ -z $2 ];then
    less $summaryfile
fi
