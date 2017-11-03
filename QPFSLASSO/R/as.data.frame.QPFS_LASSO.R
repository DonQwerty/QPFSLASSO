as.data.frame.QPFS_LASSO <-
function(x){
    df<-data.frame(w=x$w,condition=x$condition,gen=x$gen)
    return(df)
  }
