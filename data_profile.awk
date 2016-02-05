BEGIN{
    if (tolower(quote_enclosed)=="true") {
        null_length=2
    } else {
        null_length=0
    }
}
NR==1{
    for(n = 1; n <= NF; n++) {
        if (tolower(quote_enclosed)=="true") {
            colname[n]=substr($n,2,length($n)-2);
        } else {
            colname[n]=$n;
        }
        maxlen[n]=0;
        minlen[n]=999999999;
        nullable[n]="NOT NULL";
        datatype[n]="NUMBER";
    }
    fields=NF;
}
NR>1{
    for(n = 1; n <= NF; n++) {
        if (length($n)>maxlen[n]) {
            maxlen[n]=length($n)-null_length;
            maxval[n]=$n;
        };
        if (length($n)<minlen[n]) {
            minlen[n]=length($n)-null_length;
            minval[n]=$n;
        };
        if (minlen[n]==0) {
            nullable[n]="NULL";
        };
        if (datatype[n]=="NUMBER" && $n !~ /^"?[-+]?[0-9]*\.?[0-9]+"?$/ && length($n) > null_length) {
            datatype[n]="VARCHAR";
        };
    }
}
END {
    for (i=1; i<=fields; i++) {
        if (datatype[i] =="VARCHAR") {
            datatype[i] ="VARCHAR (" maxlen[i] ")"
        } else {
            if (datatype[i] == "NUMBER" && maxval[i] ~ /^"?[-+]?[0-9]+"?$/) {
                if (maxlen[i] <= 4) {
                    datatype[i] = "INT2"
                } else {
                    if (maxlen[i] <= 9) {
                        datatype[i] = "INT"
                    } else {
                        datatype[i] = "BIGINT"
                    }
                }
            } else {
                if (minlen[i] == 0 && maxlen[i] == 0) {
                    # field is all nulls, set to default
                    datatype[i] = "VARCHAR (255)"
                } else {
                    datatype[i] = "FLOAT"
                }
            }
        }
        printf ("%s %s %s\t\t-- (min,max) len=(%d,%d) values=(%s,%s)\n", colname[i], datatype[i], nullable[i], minlen[i]+0, maxlen[i]+0, minval[i] , maxval[i] );
    }
}
