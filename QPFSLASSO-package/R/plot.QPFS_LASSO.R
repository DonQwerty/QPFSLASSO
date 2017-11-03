plot.QPFS_LASSO <-
function(x){
    a<-as.data.frame(x)
    a$t<-seq(1:nrow(a))
    ggplot(a)+geom_point(aes(a$t,a$w,color=a$condition))+xlab("Gen-Condition")+ylab("Weight")+guides(color=guide_legend(title="Conditions"))
  }
