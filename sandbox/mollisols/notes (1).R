library(latticeExtra)
library(rms)
library(hexbin)
library(RColorBrewer)
library(viridis)
library(tactile)


# CREATE TEMP TABLE zzz AS 
# SELECT pedon_key, labsampnum, hzn_top, hzn_bot, hzn_desgn, bs7, estimated_ph_h2o FROM kssl.horizon
# WHERE hzn_bot <= 25;
# 
# \copy zzz TO 'top-25cm-data.csv' CSV HEADER

# bottom depth <= 25cm
x <- read.csv('top-25cm-data.csv.gz', stringsAsFactors = FALSE)

# missing data
x <- na.omit(x)

# only A horizons
idx <- grep('A', x$hzn_desgn)
x <- x[idx, ]

# bad data
x <- subset(x, subset=bs7 > 0 & bs7 < 100)
x <- subset(x, subset=estimated_ph_h2o > 2 & estimated_ph_h2o < 8)

# 'k' suffixes
idx <- grep('k', x$hzn_desgn, invert=TRUE)
x <- x[idx, ]

# 50% threshold
x$mollic <- x$bs7 > 50
prop.table(table(x$mollic))

# pH 6.5 threshold
prop.table(table(x$estimated_ph_h2o > 6.5))

# joint tabulation of thresholds
tab <- table(BS_threshold=x$mollic, pH_threshold=x$estimated_ph_h2o > 6.5)
round(prop.table(tab), 2)

# this is truly a blunt intstrument.
e1071::classAgreement(tab)



densityplot( ~ bs7, data=x, pch=NA)
densityplot( ~ estimated_ph_h2o, data=x, pch=NA)

png(file='bs7-threshold-vs-pH.png', width=800, height=400, type='cairo', antialias = 'subpixel')

bwplot(mollic ~ estimated_ph_h2o, data=x, main='A Horizons\n0-25cm Depth', xlab='pH 1:1 H2O', ylab='Base Saturation > 50% (NH4-Ac, pH 7)', par.settings=tactile.theme(), varwidth=TRUE, scales=list(x=list(tick.number=10)), panel=function(...) {
  panel.grid(v=-1)
  panel.bwplot(...)
  panel.abline(v=6.5, lty=2, lwd=2, col='firebrick')
})

dev.off()

png(file='bs7-vs-pH-scatter-plot.png', width=900, height=900, type='cairo', antialias = 'subpixel')
xyplot(bs7 ~ estimated_ph_h2o, data=x, asp=1, panel=function(x, y, ...) {
  panel.rug(x=x, col=rgb(0.25, 0.25, 0.25, alpha = 0.25), ...)
  panel.rug(y=y, col=rgb(0.25, 0.25, 0.25, alpha = 0.25), ...)
  panel.xyplot(x, y, col=rgb(0.25, 0.25, 0.25, alpha = 0.25), ...)
})
dev.off()

png(file='bs7-vs-pH.png', width=800, height=800, type='cairo', antialias = 'subpixel')
hexbinplot(bs7 ~ estimated_ph_h2o, data=x, xbins=50, main='A Horizons\n0-25cm Depth', xlab='pH 1:1 H2O', ylab='Base Saturation (NH4-Ac, pH 7)', trans=log, inv=exp, asp=1, colramp=viridis, type='g', colorkey=FALSE, scales=list(tick.number=10), panel=function(...) {
  panel.hexbinplot(...)
  panel.abline(v=6.5, h=50, lty=2, lwd=2, col='firebrick')
})
dev.off()


## logistic regression

options(datadist=NULL)
dd <- datadist(x)
options(datadist="dd")


(m <- lrm(mollic ~ estimated_ph_h2o, data=x))
anova(m)

# inflection point
ip <- (log(0.5/(1-0.5)) - coef(m)[1]) / coef(m)[2]

p <- plot(Predict(m, estimated_ph_h2o=NA, fun=plogis))

p <- update(p, main='A Horizons\n0-25cm Depth', xlab='pH 1:1 H2O', ylab='Base Saturation > 50% (NH4-Ac, pH 7)', par.settings=tactile.theme(), scales=list(x=list(tick.number=10), y=list(tick.number=10)), ylim=c(-0.05, 1.05), panel=function(...) {
  panel.grid(h=-1, v=-1)
  # panel.xyplot(x$estimated_ph_h2o, x$mollic, cex=0.1, pch='|')
  panel.xYplot(...)
  panel.abline(v=6.5, lty=2, lwd=2, col='royalblue')
  panel.abline(v=ip, lty=2, lwd=2, col='firebrick')
})


png(file='logistic-via-pH.png', width=800, height=600, type='cairo', antialias = 'subpixel')
print(p)
dev.off()



(m2 <- ols(bs7 ~ rcs(estimated_ph_h2o, 5), data=x))
anova(m2)

p <- plot(Predict(m2, estimated_ph_h2o=NA))

p <- update(p, main='A Horizons\n0-25cm Depth', xlab='pH 1:1 H2O', ylab='Base Saturation (NH4-Ac, pH 7)', par.settings=tactile.theme(), scales=list(x=list(tick.number=10), y=list(tick.number=10)), ylim=c(0, 100), panel=function(...) {
  panel.grid(h=-1, v=-1)
  panel.xYplot(...)
  panel.abline(v=6.5, lty=2, lwd=2, col='royalblue')
  panel.abline(v=ip, lty=2, lwd=2, col='firebrick')
})

png(file='linear-RCS-via-pH.png', width=800, height=600, type='cairo', antialias = 'subpixel')
print(p)
dev.off()
