library(hexSticker)
library(teamcolors)

png("./teamcolors_hex2.png", res = 300, units = "in", h = 10, w = 10*sqrt(3)/2, bg = "transparent")
test <- expression(
  par(mar = c(0,0,0,0)),
plot(0,0,xlim = c(-10*sqrt(3)/2,10*sqrt(3)/2), ylim = c(-10,10),col = rgb(1,1,1,0), xlab = "", ylab = "", yaxt= 'n', xaxt = 'n', frame.plot = FALSE, asp = 1),
teamcolors2 <- teamcolors[order(teamcolors$league),],
cols1 <- (teamcolors2$primary),
cols2 <- (teamcolors2$secondary),
r <- 10,
sss <- seq(-r*sqrt(3)/2, r*sqrt(3)/2, length = 165),
for (i in 1:164){
  
  if (sss[i] < 0) {
    h1 <- .7*sss[i] + r
    h2 <- .7*sss[i+1] + r
    polygon(c(sss[i],sss[i+1],sss[i+1],sss[i]), c(-h1,-h2,h2,h1), col = cols1[i], bor = cols1[i], lwd = 0.0000001)
  }
  
  
  if (sss[i] >= 0) {
    h1 <- -.7*sss[i] + r
    h2 <- -.7*sss[i+1] + r
    polygon(c(sss[i],sss[i+1],sss[i+1],sss[i]), c(-h1,-h2,h2,h1), col = cols1[i], bor = cols1[i], lwd = 0.0000001)
  }
  
}
)

dev.off()


sticker(test, package="teamcolors", p_size=8, s_x=.8, s_y=.8, s_width=3, s_height = 2.6,
        h_color = "black", h_fill = "white", p_color = rgb(0.85,.85,0.85), spotlight = FALSE,
        u_y = 1, u_x = 1,
        filename="./teamcolors_sticker.png")

