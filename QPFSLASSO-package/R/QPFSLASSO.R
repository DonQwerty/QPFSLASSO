QPFSLASSO <-
function(x,lab,cont,lambda=0.01,object=TRUE,class=NULL,lengths=NULL,threshold=NULL){
    print("Normalizing...")
    x<-as.data.frame(x)
    genes<-names(x)[1:(ncol(x)-2)]
    
    if(!is.null(lengths))
      x[1:nrow(x),1:(ncol(x)-2)]<-t(rpkm(t(x[1:nrow(x),1:(ncol(x)-2)]),lengths[as.character(genes)]))
    
    
    genes_int<-paste("G",seq(1:length(genes)),sep="_")
    names(genes)<-genes_int
    names(x)[1:(ncol(x)-2)]<-genes_int
    condition<-x[,lab]
    names(x)[which(names(x)==lab)]<-"condition"
    control<-x[,cont]
    names(x)[which(names(x)==cont)]<-"control"
    print("Calculating medians...")
    x<-data.table(x)
    summary<-.getSummary(x)
    
    print("Obtaining the alpha...")
    alpha<-.getAlpha(summary,condition,genes_int)
    print("Calculating weights...")
    no_cores <- detectCores() - 1
    cl <- makeCluster(no_cores)
    if(length(lambda)==1){
    pesos<-unlist(pblapply(genes_int,FUN=.get_weight,summary=summary,conditions=as.character(unique(condition)),
                    genes=genes,f1=.fill_mat,f2=.fill_vector,f3=solve.QP,entropy=entropy,alpha=alpha,lambda=lambda,cl = cl))
    pesos[pesos<0]<-0
    } else{
      pesos<-list()
      for(i in lambda){
        p<-unlist(pblapply(genes_int,FUN=.get_weight,summary=summary,conditions=as.character(unique(condition)),
                               genes=genes,f1=.fill_mat,f2=.fill_vector,f3=solve.QP,entropy=entropy,alpha=alpha,lambda=i,cl = cl))
        p[p<0]<-0
        pesos[[as.character(i)]]<-p
      }
    }
    #a<-pbsapply(genes_int,FUN=.obtein_weight,ruta=ruta,alpha=alpha,cl=cl)
    stopCluster(cl)
    

    # pesos<-c()
    # for( gen in genes_int){
    #   pesos<-c(pesos,scan(paste0(ruta,"auxiliares/",gen),quiet = T))
    # }
    # names(pesos)<-paste(rep(genes,each=length(unique(condition))),rep(unique(condition),length(genes)),sep="_")
    # if(!is.null(threshold)){
    #   pesos<-pesos[pesos>threshold]
    # }
    if(object & length(lambda)==1)
      return(.sort_conditions(pesos))
    return(pesos)
  }
