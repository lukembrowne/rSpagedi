### Make a spatial autocorrelation plot with spagedi output

plotAutoCor <- function(spagediList, overlay = FALSE, color = "black",
                        max_dist){

  
  perm <- spagediList$perm
  dist <- spagediList$dist
  
  perm <- perm[, c(2:(ncol(perm) - 4))] # chop off last 3 columns and 1st col
  
  obs <- as.numeric(perm["Obs val", ])
  conf_hi <- as.numeric(perm["95%CI-sup", ])
  conf_low <- as.numeric(perm["95%CI-inf", ])
  dist <- as.numeric(dist["Max distance", ])
  
    # Closed symbol if permutation was significant
  sig <- apply(perm[c(8,9,10), ], 2, FUN = function(x) {any(x < 0.05)})
  symbols <- rep(1, ncol(perm))
  symbols[sig] <- 19
  
  if(overlay){
    par(new = TRUE)
    points(dist, obs, type = "b", pch = symbols, xlab = "", ylab = "",
           yaxt = "n", xaxt = "n", col = color, lwd = 2, lty = 1)
    lines(dist, conf_hi, lty = 4, col = color)
    lines(dist, conf_low, lty = 4, col = color)
    
  } else{
  
  plot(dist, obs, type = "b", pch = symbols, las = 1, 
       ylab = "Kinship", xlab = "Distance (m)", lwd = 2,
       ylim = c(min(obs, conf_low, na.rm = TRUE) * 1.1, 
                max(obs, conf_hi, na.rm = TRUE) * 1.1),
       xlim = c(0, max_dist), col = color)
  abline(h = 0, lty = 1, col = "grey50")
  lines(dist, conf_hi, lty = 4, col = color)
  lines(dist, conf_low, lty = 4, col = color)
  }
  
}

