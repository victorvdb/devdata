library(shiny)
shinyUI(pageWithSidebar(
        headerPanel("Learn more about residual plots!"),
        sidebarPanel(
                h3('Change the values for the intercept and slope'),
                p("The diamonds dataset from UsingR is used for this interactive app. The dataset has two variables in it - diamond size in carats, and the diamond price in singapore dollars. 
                  You can play around with different values for a linear model fit to the data, and see what effects it has on the fit. 
                  It is especially good to look at the residual values, so you learn about patterns in residual data when your fit isn't appropriate. Also note that you won't find a lower mean square error than the one for the best fit."),
                p("The model fit will be Y=Beta0 + Beta1 * Carat"),
                p("You can use the slider below to change the intercept for your fitted line. By default it has the best fit in it."),
                sliderInput('intercept', "Intercept (Beta0)", -260, min=-400, max=100, step=1),
                p("You can use the slider below to change the slope for your fitted line. By default it has the best fit in it. Try putting it to 0 as well to see what the residual plot does."),
                sliderInput('slope', "Slope (Beta1) (SIN $ increase per carat)", 3721, min=0, max=5000, step=1),
                p("Tick this checkbox below to substract the mean values off the observations. Intercept will become 0 but slope won't change."),
                checkboxInput('norm', "Substract the mean?")
        ),
        mainPanel(
                h3('Model and residual information'),
                plotOutput('plot1'),
                p('Results of your values:'),
                tableOutput('results'),
                p('Thank you for trying out my shiny new app! I hope you enjoyed the exploration offered.')
        )
))