#shinyapps::deployApp("/media/stephen/2AB4135CB4132A39/Users/schec/My Documents/coursera/data products/enzyme_kinetics/shiny_mm")
library(shiny)

#define the user interface
shinyUI(fluidPage(
  #App title
  headerPanel("Michaelis Menten enzyme kinetics"),
  
  #Sidebar with slider controls
  sidebarPanel(
    numericInput("tmax", "simulation time:", 20, min=1, max=1000, step=NA),
    sliderInput("k1f","k1 forward:", min=0, max=10, value=1, step = 0.1),
    sliderInput("k1r","k1 reverse:", min=0, max=10, value=1, step = 0.1),
    sliderInput("k2", "k2:", min=0, max=10, value = 1, step = 0.1),
    sliderInput("S", "Initial [S]ubtrate conc.", min=0, max=100, value=100, step = 10),
    sliderInput("E", "Initial [E]nzyme conc.", min=0, max=100, value=10, step = 10)
  ),
  
  #Show the plot
  mainPanel(
    tabsetPanel(
      tabPanel("Model",
      img(src="mechanism.png"),
      plotOutput("kinetics_plot")
      ),
    
      tabPanel("Description",
      h3("Summary of an enzyme catalysed reaction"),
      img(src="enzyme_action.png"),
      br(),
      br(),
      h3("Introduction"),
      p("So, if you're not a biochemist you won't know what an enzyme is.",
        "For the uninitiated, chemical reactions happen by random chance and this can take a while to happen. Enzymes are biological entities which have",
        "evolved to help chemical reactions occur by increasing the chance of them happening. Enzymes facilitate all kinds of reactions while not being an",
        "active participant themselves (they change stuff but don't get changed themselves)."),
      
      p("Enzymes are of great interest to biologists because they can drive all kinds of reactions that wouldn't ordinarily occur (at least not within the lifetime of the researcher!).", 
        "Biologists can adjust the properties of enzymes by modifying",
        "their attributes (like how efficiently they bind to reactants and how quickly they can convert them into product), usually to get them to drive faster reactions under",
        "particular conditions (like breaking down dirt on your clothes whilst being spun at 1200rpm at 30oC in your washing machine - not a naturally occuring environment!)"),
      
      p("This app simulates the process of an enzyme binding to a substrate and converting it to product. In a regular chemical reaction, this would be a 1:1 relationship and the",
        "concentration of product would increase linearly with concentration of substrate as one converts to the other. For enzyme driven reactions however, the enzyme is an intermediary and therefore",
        "the rate of the reaction is non-linear as it is governed by the performance of the enzyme, like the speed of a car is governed by the performance of the engine,", 
        "but like an engine, an enzyme can be tuned. Welcome to the world of the enzyme kineticist!"),
      
      h3("App Instructions"),
      p("This app simulates the modifications a scientist can make to the attributes of an enzyme and reports the rate of product formation ([P]), substrate utilization [S]",
        "and information about the amount of free enzyle [E] complexed with substrate [ES]. You can also adjust the starting amount of enzyme and substrate",
        "The calculations are the same as those performed daily by enzyme kineticists the world over, and apps such as this are useful experimental tools."),
      
      strong("The parameters for the simulation are as follows:"),
      br(),
      img(src="mechanism.png"),
      
      p("k1 forward = forward rate for substrate [S] binding to enzyme[E], forming an enzyme-substrate complex [ES]."),
      p("k1 reverse = the reverse rate for substrate [S] unbinding from the enzyme-substrate complex [ES] before it gets chance to process it."),
      p("k2 = rate of conversion of the bound substrate [ES] to product [P] (releasing [E] to bind another free [S]). This is also known as the catalytic rate of the enzyme, or kcat."),
      p("S = the initial starting concentration of substrate, you can adjust this from 0 to lots."),
      p("E = the initial starting concentration of enzyme, you can adjust this from 0 to lots too. The maximum value matches the substrate because",
        "michaelis menten kinetics only hold for conditions where [S] >> [E], or you get all kinds of things happening with crowding of the enzyme.",
        "Inside cells, enzymes are usually present at much lower concentrations than their substrate and generally, michaelis-menten kinetics hold up as a reasonable approximation."),
      p("The length of the simulation time can also be set, which is useful for the plots. Simulation starts at time 0, so minimum time must be >0 (or the integrator will break; TARDIS not included!).",
        "1 to 100 are recommended simulation times."),
      
      h3("epilogue"),
      p("Enzyme kinetics is a huge field. For a much better description take a look at the", a("Wikipedia page",href="https://www.wikiwand.com/en/Enzyme_kinetics"), 
        ", or a nice commemorative article on the", a("classic 1913 manuscript by Michaelis and Menten.", href="http://onlinelibrary.wiley.com/doi/10.1111/febs.12598/pdf"))
      )
    )
  )
))