# QPFSLASSO
QPFSLASSO: a specific gene selector for multiple conditions

### INSTALL

For install, first download the git repository:

```shell
git clone https://github.com/DonQwerty/QPFSLASSO.git
```

After that, you only need to install the package:

```shell
R CMD INSTALL QPFSLASSO/QPFSLASSO-package
```


### Dependencies
The follow packeges are needed for executing QPFSLASSO:

* dplyr
* doMC
* stringr
* data.table
* pbapply
* entropy
* edgeR
* TCC
* ggplot2
* ballgown
* quadprog

### Example
```R
library(QPFSLASSO)
data(genes)
weights<-QPFSLASSO(genes,"type","control")
plot(weights)
```
