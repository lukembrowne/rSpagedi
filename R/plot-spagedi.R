### Make a spatial autocorrelation plot with spagedi output

plotAutoCor <- function(spagediList){
  
  perm <- spagediList$perm
  dist <- spagediList$dist
  
  perm <- perm[, c(2:(ncol(perm) - 4))] # chop off last 3 columns and 1st col
  
  obs <- as.numeric(perm["Obs val", ])
  conf_hi <- as.numeric(perm["95%CI-sup", ])
  conf_low <- as.numeric(perm["95%CI-inf", ])
  max_dist <- as.numeric(dist["Max distance", ])
  
  plot(max_dist, obs, type = "b", pch = 19, las = 1, 
       ylab = "Kinship", xlab = "Distance (m)", lwd = 2,
       ylim = c(min(obs, conf_low) * 1.1, max(obs, conf_hi) * 1.1))
  abline(h = 0, lty = 1, col = "grey50")
  lines(max_dist, conf_hi, lty = 4)
  lines(max_dist, conf_low, lty = 4)
  
  
}
