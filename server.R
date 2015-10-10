library(shiny)
library(deSolve)
library(ggplot2)
library(gridExtra)
#library(Cairo) # For nicer ggplot2 output when deployed on Linux
#options(shiny.usecairo=TRUE)


shinyServer(function(input, output) {
  
  #Michaelis menten rate equations
  mm <- function(time,init,parms) {
    with(as.list(c(init, parms)), {
      dS <- -k1f * S * E + k1r * ES
      dE <- -k1f * S * E + (k1r + k2) * ES
      dES <- k1f * S * E - (k1r + k2) * ES
      dP <- k2 * ES
      
      vmax <- k2 * (E + ES)
      v <- vmax * S / (km + S)
      
      return(list(c(dS,dE,dES,dP),v=v))
    })
  }
  
  output$kinetics_plot <- renderPlot( {
    #model parameters
    parms = c(k1f=input$k1f, 
              k1r=input$k1r, 
              k2=input$k2, 
              km=((input$k1r + input$k2) / input$k1f)
              )
    
    #initial conditions
    init = c(S=input$S, 
             E=input$E, 
             ES=0, 
             P=0)
    
    #simulation time (with 100 steps to limit cpu load)
    sim.time = seq(0,input$tmax,input$tmax/100) 
    
    #run the integrator
    out <- as.data.frame(ode(y=init, times=sim.time, func = mm, parms=parms))
    
    #output plots
    p1 <- ggplot(data=out, aes(x=S, y=v)) +
      geom_line(colour="steelblue",size=1) +
      xlab("substrate concentration ([S]/t)") +
      ylab("rate of product formation ([P]/t)") +
      ggtitle("Reaction Rate (enzyme performance)")
    
    p2 <- ggplot(data=out, aes(x=time, y=S)) +
      geom_line(colour="steelblue",size=1) +
      xlab("time") +
      ylab("Substrate concentration [S]") +
      ggtitle("Substrate Utilization")
    
    p3 <- ggplot(data=out, aes(x=time, y=P)) +
      geom_line(colour="steelblue",size=1) +
      xlab("time") +
      ylab("Product concentration [P]") +
      ggtitle("Product Formation")
    
    p4 <- ggplot(data=out, aes(x=time, y=E, col="free enzyme")) +
      geom_line(size=1) +
      geom_line(aes(x=time, y=ES, col="ES complex")) +
      guides(col = guide_legend(title = "")) +
      xlab("time") +
      ylab("Enzyme concentration [E]") +
      ggtitle("Free & Bound Enzyme")
    
    #arrange the plots in a grid layout
    grid.arrange(p3,p2,p4,p1, ncol=2)
    
  })
})