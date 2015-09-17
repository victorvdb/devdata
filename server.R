library(shiny)
library(UsingR)
data(diamond)
plotWithInput <- function(data, i, s, n) {
        par(mfrow=c(1,2))
        if(n) {
                xlab="Mass - mean(Mass) (carats)"
                ylab="Price - mean(Price) (Sin $)"
        }
        else {
                xlab = "Mass (carats)"
                ylab = "Price (SIN $)"                
        }
        plot(data$carat, data$price,  
             xlab = xlab, 
             ylab = ylab, 
             main = "Fit for your plot",
             bg = "lightblue", 
             col = "black", cex = 1.1, pch = 21,frame = FALSE)
        abline(lm(price ~ carat, data = data), col=3, lty=2)
        abline(a=i, b=s, col=2)
        legend(x=min(data$carat), y=c(max(data$price)), col=c(3,2), lty=c(2,1), lwd=1, legend=c("Best fit", "Your fit"))
        
        data$resid <- data$price - (i + s * data$carat)   
        plot(data$carat, data$resid,  
             xlab = xlab, 
             ylab = "Residuals (SIN $)", 
             main="Residual plot for your fit",
             bg = "lightblue", 
             col = "black", cex = 1.1, pch = 21,frame = FALSE)
        abline(h = 0, lwd = 2)        
}

MSE <- function(data, i, s) {
        data$resid <- data$price - (i + s * data$carat)
        mse <- mean((data$resid)^2)
        mse
}

shinyServer(
        function(input, output) {
                dat <- reactive({
                        if(input$norm) {
                             dtnorm <- diamond
                             dtnorm$carat <- dtnorm$carat - mean(dtnorm$carat)
                             dtnorm$price <- dtnorm$price - mean(dtnorm$price)
                             dtnorm
                        }
                        else {
                                diamond
                        }
                })
                
                output$plot1 <- renderPlot({plotWithInput(dat(), input$intercept, input$slope, input$norm)})
                output$results <- renderTable({
                        fit <- lm(price ~ carat, dat())
                        int <- round(fit$coefficients[1])
                        slo <- round(fit$coefficients[2])
                        tab <- data.frame()
                        tab <- rbind(c(int, slo, MSE(dat(), int, slo)),
                                     c(input$intercept, input$slope, MSE(dat(), input$intercept, input$slope)))
                        colnames(tab) <- c("Intercept (beta0)", "Slope (beta1)", "Mean Squared Error")
                        rownames(tab) <- c("Best Fit", "Your Fit")
                        tab
                        
                })
        }
)