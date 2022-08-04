library(optparse)
library(data.table)
library(ggplot2)

printStdout <- function(X) {
  write(X, stdout())
}

printHeader <- function(X) {
  printStdout(paste0("\n*** ", X, " ***\n"))
}

printDim <- function(X) {
  printStdout(paste("Dim:", paste(dim(X), collapse=" * ")))
}

readInput <- function(fname) {
  printHeader("Read input")
  printStdout(fname)
  DT = fread(fname)
  printDim(DT)
  return(DT)
}

setcolnames <- function(DT, phenocol, rsidcol, eacol, descrcol, catcol, pvcol, samedircol) {
  # set Phenotype column
  if (phenocol!="" & phenocol != "Phenotype") setnames(DT, phenocol, "Phenotype")
  # set RsID column
  if (rsidcol!="" & rsidcol != "RsID") setnames(DT, rsidcol, "RsID")
  # set effect allele column
  if (eacol!="" & eacol != "EA") setnames(DT, eacol, "EA")
  # set description column
  if (descrcol!="" & descrcol != "Description") setnames(DT, descrcol, "Description")
  # set category column
  if (catcol!="" & catcol != "Category") setnames(DT, catcol, "Category")
  # set category column
  if (pvcol!="" & pvcol != "Pvalue") setnames(DT, pvcol, "Pvalue")
  # set same direction column
  if (samedircol!="" & samedircol != "Same_direction") setnames(DT, samedircol, "Same_direction")
  return(DT)
}

prepare_data <- function(DT) {
  printHeader("Prepare data")
  # set variant name to plot on x-axis
  DT[, RsidEa := paste(RsID,EA,sep="_")]
  # set phewas name to plot on y-axis
  DescrOrder = sort(unique(DT$Description), decreasing=T)
  DT[, fDescription := factor(Description, levels=DescrOrder)]
  # set zero pvalues to machine min value.
  printStdout(paste("Zero pvalues:", nrow(DT[Pvalue == 0])))
  DT[Pvalue == 0, Pvalue := .Machine$double.xmin]
  # convert pvalues to -log10 scale
  DT[, log10P := -log10(Pvalue)]
  # set log10 pvalue category (<20, 20-40, >40)
  DT[, log10Pcat := ifelse(log10P<20, 3, ifelse(log10P<40, 4, 5))]
  printStdout("\nlog10P categories:")
  print(table(DT$log10Pcat))
  # set beta direction symbol (triangle up or down)
  DT[, Direction := ifelse(Same_direction==1, 24, 25)]
  printStdout("\nBeta direction:")
  print(table(DT$Direction))
  return(DT)
}

plot_data <- function(DT, pdfheight, pdfwidth, pdfname) {
  printHeader("Plot phewas")
  pdf(pdfname, height=pdfheight, width=pdfwidth)
  printStdout(paste("X axis:",length(unique(DT$RsidEa))))
  printStdout(paste("Y axis:",length(unique(DT$fDescription))))
  printStdout(paste("Category:",length(unique(DT$Category))))
  g = ggplot(DT)
  if ("Phenotype" %in% colnames(DT)) {
    g = g + facet_grid(rows=vars(Category), cols=vars(Phenotype), scales="free", space="free")
    printStdout(paste("Phenotype:",length(unique(DT$Phenotype))))
  } else {
    g = g + facet_grid(rows=vars(Category), scales="free", space="free")
  }
  g = g + geom_point(aes(x=RsidEa, y=fDescription, col=Category, fill=Category), size=DT$log10Pcat, shape=DT$Direction) +
    theme(strip.text.y = element_text(angle = 0),
        axis.text.x=element_text(angle=45, hjust=1),
        axis.text.y=element_text(angle=0, hjust=1),
        panel.background = element_rect(fill = "white", colour = "white", size = 0.5, linetype = "solid"),
        panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "grey"),
	legend.position="none") +
    ylab("") +
    xlab("")
  plot(g)
  dev.off()
  printStdout(pdfname)
}

run <- function(inputname, outputname, pdfwidth, pdfheight, phenocol, rsidcol, eacol, descrcol, catcol, pvcol, samedircol, dolog) {
  logname = sub(".pdf$",".log", outputname)
  if (dolog) sink(logname, split=T)
    
  DT = readInput(inputname)
  DT = setcolnames(DT, phenocol, rsidcol, eacol, descrcol, catcol, pvcol, samedircol)
  DT = prepare_data(DT)
  plot_data(DT, pdfheight, pdfwidth, outputname)
  
  if (dolog) printStdout(logname)    
  return()
}

option_list <- list(
  make_option("--input", type="character", default="",
    help="csv file to plot."),
  make_option("--output", type="character", default="output.pdf",
    help="pdf output file. Default [output.pdf]"),
  make_option("--pdfwidth", type="numeric", default=8,
    help="pdf width. Default [8]"),
  make_option("--pdfheight", type="numeric", default=7,
    help="pdf height. Default [7]"),
  make_option("--phenoCol", type="character", default="",
    help="phenotype column name to group x-axis variants by phenotype. Default []"),
  make_option("--rsidCol", type="character", default="RsID",
    help="RsID column name. Default [RsID]"),
  make_option("--eaCol", type="character", default="EA",
    help="Effect allele column name. Default [EA]"),
  make_option("--descrCol", type="character", default="Description",
    help="phewas description column name to plot on y-axis. Default [Description]"),
  make_option("--catCol", type="character", default="Category",
    help="phewas category column name to colour and group by phewas category. Default [Category]"),
  make_option("--pvCol", type="character", default="Pvalue",
    help="P-value column name. Default [Pvalue]"),
  make_option("--sameDirCol", type="character", default="Same_direction",
    help="Same direction column name. Default [Same_direction]"),
  make_option("--log", type="logical", default=TRUE,
    help="Write log file")
)

parser <- OptionParser(usage="%prog [options]", option_list=option_list)

args <- parse_args(parser, positional_arguments = 0)
opt <- args$options

print(opt)

run(opt$input,
opt$output,
opt$pdfwidth,
opt$pdfheight,
opt$phenoCol,
opt$rsidCol,
opt$eaCol,
opt$descrCol,
opt$catCol,
opt$pvCol,
opt$sameDirCol,
opt$log
)
